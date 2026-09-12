Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0670370ACA;
	Sat, 12 Sep 2026 10:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207472; cv=none; b=eWfJ1QK1kczJdc4QV5B74vUpg8h3fSRKqEb9OWabQO0HSsJOCFFJd4YVWX8eNWVkGVoO6UchMYeMQjNuxj4vS3WNXfmCpjR1sEPtgKYHQzQ3pKgD9B++zq6BtNwKx+VWD+nM6QBfIS+8qtQ1Oxt9fp2Sycux1lyz5SOsIwwZYgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207472; c=relaxed/simple;
	bh=HpMqwMky9Is6GnI1bZO+JXNUlydmnxQTah4k81Ix+Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUUZ0MayF5hl/4fUqa5nZuUHon0SuETK4LER/hGE0NHKqhyA9uj7vx3PDgTd6K5TmrJDWjhK2ozq98B0QIM245Y0cu+D8jgEhosH5uZm+aiZ6l2/UecfuiRsq6iQF+gSxKinr0yQtKGmEclXAW+9t+8A6RLwSp+gM6HvuvXOsqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R06ld4KB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R06ld4KB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED691F00893;
	Sat, 12 Sep 2026 10:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207470;
	bh=B6n6pFKMs01MPGy6tQHH+0C0NhuuSUmJ+P61ht1NLHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R06ld4KBhc9ZO0OVaHhGXYwU4fwa1plPUqg7UtSFBPGwg9gs5Fa0HUM2OqcvajY1E
	 y7W8+Okbg0oAO67Gw0GcCUJcR8wIpLpERpMvGoNAhy7kG7vv+nHMb7fnlbANvNoXGS
	 Reyse1SCBsCmoI5U2V7iueyRxmVn7X/ejQ9tTNck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farid Zakaria <fmzakari@meta.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0366/1518] perf record: Fix multiple PERF_RECORD_COMPRESSED2 records per push
Date: Sat, 12 Sep 2026 08:42:15 +0200
Message-ID: <20260912065631.751339130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Ilvokhin <d@ilvokhin.com>

[ Upstream commit ad40a000ea598f316ddc0e81e5acc77cc3b1fae0 ]

With Zstd compression enabled ('perf record -z'), a single mmap push
whose compressed output exceeds the maximum record size makes
zstd_compress_stream_to_records() emit several PERF_RECORD_COMPRESSED2
records back to back. record__pushfn() however rewrote only the first
record's header to describe the whole blob as one record:

  event->data_size   = compressed - sizeof(struct perf_record_compressed2);
  event->header.size = PERF_ALIGN(compressed, sizeof(u64));
  padding            = event->header.size - compressed;
  ...
  record__write(rec, map, &pad, padding);

perf_event_header::size is a __u16, so once the compressed blob no
longer fits in it the header.size assignment truncates and 'padding'
(size_t) underflows. write() is then handed that bogus length and fails
with EFAULT, aborting the recording:

  failed to write perf data, error: Bad address

The bytes that did reach the file are mis-framed, so reading it back
cannot be decompressed.

This is easy to hit with a high event rate and a large buffer, e.g.:

  perf record -z -F max -m 32M --per-thread -- perf test -w thloop 5 1

The single-record fixup is wrong by construction: because header.size is
16 bits a compressed record cannot exceed 64KB, so the compressor must
split a push into a chain of records, and the session reader already
consumes them as such.

Frame each record where it is produced instead: make
process_comp_header() set the per-record data_size, 8-byte-align
header.size and zero the trailing padding, and let record__pushfn()
write the resulting blob, as the AIO path already does. Reduce
max_record_size by sizeof(u64) so the per-record alignment padding
cannot push header.size past its u16 field. process_comp_header()
returns -1 when that padding would not fit the space left in 'dst', so
the compressor stops instead of overrunning the output buffer.

There is no on-disk format change; a perf.data written by the fixed tool
is still read by existing perf.

Fixes: 208c0e168344 ("perf record: Add 8-byte aligned event type PERF_RECORD_COMPRESSED2")
Reported-by: Farid Zakaria <fmzakari@meta.com>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c                   | 38 +++++------
 .../record+zstd_comp_decomp_multi_record.sh   | 63 +++++++++++++++++++
 2 files changed, 83 insertions(+), 18 deletions(-)
 create mode 100755 tools/perf/tests/shell/record+zstd_comp_decomp_multi_record.sh

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6c558b60aa9a1..87cff5f5a99c1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -63,6 +63,7 @@
 #include <poll.h>
 #include <pthread.h>
 #include <unistd.h>
+#include <string.h>
 #ifndef HAVE_GETTID
 #include <syscall.h>
 #endif
@@ -652,27 +653,14 @@ static int record__pushfn(struct mmap *map, void *to, void *bf, size_t size)
 	struct record *rec = to;
 
 	if (record__comp_enabled(rec)) {
-		struct perf_record_compressed2 *event = map->data;
-		size_t padding = 0;
-		u8 pad[8] = {0};
 		ssize_t compressed = zstd_compress(rec->session, map, map->data,
 						   mmap__mmap_len(map), bf, size);
 
 		if (compressed < 0)
 			return (int)compressed;
 
-		bf = event;
 		thread->samples++;
-
-		/*
-		 * The record from `zstd_compress` is not 8 bytes aligned, which would cause asan
-		 * error. We make it aligned here.
-		 */
-		event->data_size = compressed - sizeof(struct perf_record_compressed2);
-		event->header.size = PERF_ALIGN(compressed, sizeof(u64));
-		padding = event->header.size - compressed;
-		return record__write(rec, map, bf, compressed) ||
-		       record__write(rec, map, &pad, padding);
+		return record__write(rec, map, map->data, compressed);
 	}
 
 	thread->samples++;
@@ -1552,7 +1540,8 @@ static void record__adjust_affinity(struct record *rec, struct mmap *map)
 
 /*
  * Called once with data_size == 0 to start a record, then once with
- * data_size == compressed payload size to finalize.
+ * data_size == compressed payload size to finalize and 8-byte-pad it
+ * (unaligned records trip ASan in the reader).
  * Returns the bytes written, or -1 if it won't fit.
  */
 static ssize_t process_comp_header(void *record, size_t dst_size,
@@ -1562,8 +1551,15 @@ static ssize_t process_comp_header(void *record, size_t dst_size,
 	size_t size = sizeof(*event);
 
 	if (data_size) {
-		event->header.size += data_size;
-		return 0;
+		size_t padding;
+
+		event->data_size = data_size;
+		event->header.size = PERF_ALIGN(size + data_size, sizeof(u64));
+		padding = event->header.size - size - data_size;
+		if (padding > dst_size)
+			return -1;
+		memset(record + size + data_size, 0, padding);
+		return padding;
 	}
 
 	if (size > dst_size)
@@ -1571,6 +1567,7 @@ static ssize_t process_comp_header(void *record, size_t dst_size,
 
 	event->header.type = PERF_RECORD_COMPRESSED2;
 	event->header.size = size;
+	event->data_size = 0;
 
 	return size;
 }
@@ -1579,7 +1576,12 @@ static ssize_t zstd_compress(struct perf_session *session, struct mmap *map,
 			    void *dst, size_t dst_size, void *src, size_t src_size)
 {
 	ssize_t compressed;
-	size_t max_record_size = PERF_SAMPLE_MAX_SIZE - sizeof(struct perf_record_compressed2) - 1;
+	/*
+	 * Reserve space so per-record PERF_ALIGN() padding keeps header.size
+	 * within u16.
+	 */
+	size_t max_record_size = PERF_SAMPLE_MAX_SIZE
+		- sizeof(struct perf_record_compressed2) - sizeof(u64);
 	struct zstd_data *zstd_data = &session->zstd_data;
 
 	if (map && map->file)
diff --git a/tools/perf/tests/shell/record+zstd_comp_decomp_multi_record.sh b/tools/perf/tests/shell/record+zstd_comp_decomp_multi_record.sh
new file mode 100755
index 0000000000000..c05ace8214ca3
--- /dev/null
+++ b/tools/perf/tests/shell/record+zstd_comp_decomp_multi_record.sh
@@ -0,0 +1,63 @@
+#!/bin/bash
+# Zstd perf.data compression/decompression of multi-record data
+# SPDX-License-Identifier: GPL-2.0
+
+perfdata=$(mktemp /tmp/__perf_test.perf.data.XXXXX)
+recout=$(mktemp /tmp/__perf_test.zstd.rec.XXXXX)
+injout=$(mktemp /tmp/__perf_test.zstd.inj.XXXXX)
+perf_tool=perf
+
+cleanup() {
+	rm -f "${perfdata}" "${perfdata}".old "${perfdata}".decomp "${recout}" "${injout}"
+}
+trap cleanup EXIT TERM INT
+
+skip_if_no_z_record() {
+	$perf_tool record -h 2>&1 | grep -q -- '-z, --compression-level'
+}
+
+collect_z_record() {
+	echo "Collecting compressed record file:"
+	[ "$(uname -m)" != s390x ] && gflag='-g'
+	$perf_tool record -o "${perfdata}" $gflag -z -F max -m 32M --per-thread -- \
+		$perf_tool test -w thloop 5 1 \
+		>/dev/null 2>"${recout}"
+}
+
+check_record() {
+	echo "Checking record did not fail to write data:"
+	if grep -q "failed to write perf data" "${recout}"; then
+		cat "${recout}"
+		return 1
+	fi
+}
+
+check_decompress() {
+	echo "Checking compressed file decompresses cleanly:"
+	if ! $perf_tool inject -i "${perfdata}" -o "${perfdata}".decomp 2>"${injout}"; then
+		cat "${injout}"
+		return 1
+	fi
+	if grep -Eqi "decompress|corrupt|failed to process type" "${injout}"; then
+		cat "${injout}"
+		return 1
+	fi
+}
+
+skip_if_no_z_record || exit 2
+collect_z_record
+check_record || exit 1
+
+# Need >1 record, else the multi-record path wasn't exercised.
+# Skip rather than pass/fail spuriously.
+nr=$($perf_tool report -i "${perfdata}" --stats 2>/dev/null |
+	awk '/COMPRESSED2 events:/ { print $3 }')
+if [ -z "${nr}" ] || [ "${nr}" -lt 2 ]; then
+	echo "less than two compressed records (${nr:-0}), skipping"
+	exit 2
+fi
+echo "Produced ${nr} compressed records"
+
+check_decompress
+err=$?
+exit $err
-- 
2.53.0



