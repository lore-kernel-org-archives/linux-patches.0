Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6549E35201F;
	Sat, 12 Sep 2026 10:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207211; cv=none; b=N7E8q3Fnh1KHXhQVzaZVJiRWmIvr3IriIxf2ik2M3Ym6UFimmvQhVZa5GlUpreNHTcuDnbmArZSR7hCTHu50R55D1pOoPzYS/txaajpxf3XV4/BPBiawK8YqPu2HqQwCKf6BmtDMByDlIy2KNZtcmtE1/Zg6ExwJp+ww5dHVtaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207211; c=relaxed/simple;
	bh=85sYo1fhiaN1ZRcvJSNP5QNRspZ9Cb2vuPEFhqHJe0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uIEcnaWOPeHXSjdKdwyjIf6I29sLHxU3IdsTAur3BvFPnO3CtL2JjZYNsmPV7EEMmfJeHE7NWAC+mwn1qF7VylwrBwrpm+f4V7HNWAw9DyAXr5xAGHpXpuKx7M7ltQoDhQ6Gv8YfnxMWDJGK6W3lAtbTwltsCsPKj6peer4l+6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7Y0ffeZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7Y0ffeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4811F1F000FF;
	Sat, 12 Sep 2026 10:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207210;
	bh=DXUlteG2myDI+uqA9BNMJnke4d/TuHmUkQOALyBGM9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7Y0ffeZlY7LOonpBF068ZlgwT7qO1RRexz6aM5K2YlQjBVUg/yz2u6r6tOUQY/Nx
	 dS9prOjZ3OPFXSUKnhtk7Nhg9kGAL4c66OMhqoyda3CJ0SMFTrKLRP1R05b8G6S7aZ
	 taDul0oaPQ69bM0TkaK2S8R/h4H9eKXgrGSh8sHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	sashiko-bot@kernel.org
Subject: [PATCH 6.18 0364/1518] perf zstd: Fix compression error path in zstd_compress_stream_to_records()
Date: Sat, 12 Sep 2026 08:42:13 +0200
Message-ID: <20260912065631.705131563@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit a18908b5056b8fdb2c44505f0c57ff05865740a3 ]

The error fallback does memcpy(dst, src, src_size) intending to store
uncompressed data when compression fails, but this has three bugs:

1. dst has been advanced past the record header (and potentially
   past earlier compressed records), so the copy writes to the
   wrong offset in the output buffer.

2. src still points to the start of the input, not to the
   remaining uncompressed data at src + input.pos.  On a second
   or later iteration, previously compressed data would be
   duplicated.

3. No check that dst_size >= src_size — if the remaining output
   space is smaller, this is an out-of-bounds write.

Replace with return -1 after resetting the ZSTD compression
context via ZSTD_initCStream().  The -1 propagates through
zstd_compress() -> record__pushfn() -> perf_mmap__push() to the
recording loop, which breaks out and terminates recording.

Add an out_child_no_flush label in __cmd_record() so the
mmap-read failure path skips the final record__mmap_read_all()
flush — retrying the same read that just failed would just fail
again, and the flush is only useful when the mmap data is intact
but the control path (auxtrace, switch_output) had an error.

Consolidate all error paths through a single 'reset' label to
ensure the compression context is always reset on failure —
including the output-buffer-full path, where a bare return
without resetting would leave stale stream state that corrupts
output if the caller retries.

Also guard against process_header() writing the event header
before the buffer-full check: add a sizeof(perf_event_header)
pre-check so the callback never writes past the output buffer.

Guard against ZSTD making no progress: if output.pos is zero
after ZSTD_compressStream(), calling process_header(record, 0)
would re-trigger header initialization, double-subtracting the
header size from dst_size and underflowing the unsigned counter.

Also fix two pre-existing issues in the same function:

- Add a dst_size guard before subtracting the record header
  size: if the output buffer is nearly full, the unsigned
  dst_size -= size underflows to a huge value, causing
  ZSTD_compressStream to write past the buffer boundary.

- Check the ZSTD_initCStream() return value and log an error
  if the context reset itself fails.

Reported-by: sashiko-bot@kernel.org # Running on a local machine
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6-1m
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: ad40a000ea59 ("perf record: Fix multiple PERF_RECORD_COMPRESSED2 records per push")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c |  6 +++++-
 tools/perf/util/zstd.c      | 27 +++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c82b9720c9296..79603329b8897 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -2702,7 +2702,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 			trigger_error(&auxtrace_snapshot_trigger);
 			trigger_error(&switch_output_trigger);
 			err = -1;
-			goto out_child;
+			goto out_child_no_flush;
 		}
 
 		if (auxtrace_record__snapshot_started) {
@@ -2849,6 +2849,10 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 out_child:
 	record__stop_threads(rec);
 	record__mmap_read_all(rec, true);
+	goto out_free_threads;
+out_child_no_flush:
+	/* mmap read already failed — retrying would just fail again */
+	record__stop_threads(rec);
 out_free_threads:
 	record__free_thread_data(rec);
 	evlist__finalize_ctlfd(rec->evlist);
diff --git a/tools/perf/util/zstd.c b/tools/perf/util/zstd.c
index 57027e0ac7b65..ecda9deb53b73 100644
--- a/tools/perf/util/zstd.c
+++ b/tools/perf/util/zstd.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <string.h>
+#include <linux/perf_event.h>
 
 #include "util/compress.h"
 #include "util/debug.h"
@@ -54,7 +55,13 @@ ssize_t zstd_compress_stream_to_records(struct zstd_data *data, void *dst, size_
 
 	while (input.pos < input.size) {
 		record = dst;
+		/* process_header writes the event header into record */
+		if (dst_size < sizeof(struct perf_event_header))
+			goto reset;
 		size = process_header(record, 0);
+		/* Output buffer full — cannot fit even the record header */
+		if (size > dst_size)
+			goto reset;
 		compressed += size;
 		dst += size;
 		dst_size -= size;
@@ -65,10 +72,18 @@ ssize_t zstd_compress_stream_to_records(struct zstd_data *data, void *dst, size_
 		if (ZSTD_isError(ret)) {
 			pr_err("failed to compress %ld bytes: %s\n",
 				(long)src_size, ZSTD_getErrorName(ret));
-			memcpy(dst, src, src_size);
-			return src_size;
+			goto reset;
 		}
 		size = output.pos;
+		/*
+		 * No progress: ZSTD couldn't emit any bytes into the
+		 * remaining output buffer.  Calling process_header
+		 * with size=0 would re-trigger header initialization,
+		 * double-subtracting the header size from dst_size and
+		 * underflowing the unsigned counter.
+		 */
+		if (size == 0)
+			goto reset;
 		size = process_header(record, size);
 		compressed += size;
 		dst += size;
@@ -76,6 +91,14 @@ ssize_t zstd_compress_stream_to_records(struct zstd_data *data, void *dst, size_
 	}
 
 	return compressed;
+
+reset:
+	/* Reset so the context is usable if the caller retries */
+	ret = ZSTD_initCStream(data->cstream, data->comp_level);
+	if (ZSTD_isError(ret))
+		pr_err("failed to reset compression context: %s\n",
+			ZSTD_getErrorName(ret));
+	return -1;
 }
 
 size_t zstd_decompress_stream(struct zstd_data *data, void *src, size_t src_size,
-- 
2.53.0



