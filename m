Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CEC343893;
	Sat, 12 Sep 2026 07:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198400; cv=none; b=FgWPfA/5q++ZEskJTjPE4aIuhgXUW6FjUIhOMYCSzWKB1R+2vtzY79WSnE5VyObM3BlUgVplujLo2GEoVL66QDoP8bGuLEw4Z6jB794o6IANX+dlDwLEdr+eapYN0LIGXs0TtrvwpA9RNBwmJmdlOTRYTeU0gsrkA7kVLUGAi6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198400; c=relaxed/simple;
	bh=NWNWgGw6hjm6xrIqAqp/HiBUE7vuNQNxIBWdU+hZRqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZNHHMVX9caC7jaI9FDguq3oAEfA4MAfXg6EcL1ZBTDPjk5ymDrsbsWASUc0jTgUwCKJEWyraMrbKJ4se/hQ9gJ15+jzal1lvVkv9/s/s06xrjztE4VInBgE0ZBunDqs8GrU8YORIuWavpAKHAsBrEU3dy9Lz3G0swPjQoCa+0xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmnDwrBs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmnDwrBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01071F000FF;
	Sat, 12 Sep 2026 07:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198399;
	bh=YSM8GIP/lZcINixHfTks0ZSG6Sb/KCRgbVFZbPGRlb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zmnDwrBsE4mrAW4p6JPcwtRh0u6YFQ+xEXZI6XphqMhTn8Vs0MX/ZBRBPzHCFb66I
	 rgagDBkoie4yyyaGTqZdYxfRfi1ikMRyq0UxvcofArK2v0/hpcbFRgAkefmO1G15jx
	 i1Rzx2pFcBn8sc3SIwwODnye2Kf0Auvf4+V0WVY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0373/1815] perf record: Return the written size from process_comp_header()
Date: Sat, 12 Sep 2026 08:35:23 +0200
Message-ID: <20260912065657.660569064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Ilvokhin <d@ilvokhin.com>

[ Upstream commit 757155c142f2bc9793e888ab101a5eea2d53f8f8 ]

process_comp_header() is called from zstd_compress_stream_to_records()
twice per record: once with data_size == 0 to write the record header,
and once with the payload size to finalize it. It returns the increment
it was passed, and the loop separately decides whether a record still
fits by comparing the remaining 'dst_size' against the header size.

With the fit check split from the code that writes the record,
process_comp_header() cannot reject a record on its own, so any bytes it
writes into 'dst' have to be bounds-checked by the caller instead of
where they are produced.

Pass the space left in 'dst' to process_comp_header(), let it return the
number of bytes written or -1 when the header does not fit, and account
the compressed payload in the loop.

No functional change intended.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: ad40a000ea59 ("perf record: Fix multiple PERF_RECORD_COMPRESSED2 records per push")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c | 17 +++++++++++++----
 tools/perf/util/compress.h  |  6 ++++--
 tools/perf/util/zstd.c      | 25 ++++++++++++++-----------
 3 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d1276382b77a2..294bdd4b8d004 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1592,16 +1592,25 @@ static void record__adjust_affinity(struct record *rec, struct mmap *map)
 	}
 }
 
-static size_t process_comp_header(void *record, size_t increment)
+/*
+ * Called once with data_size == 0 to start a record, then once with
+ * data_size == compressed payload size to finalize.
+ * Returns the bytes written, or -1 if it won't fit.
+ */
+static ssize_t process_comp_header(void *record, size_t dst_size,
+				   size_t data_size)
 {
 	struct perf_record_compressed2 *event = record;
 	size_t size = sizeof(*event);
 
-	if (increment) {
-		event->header.size += increment;
-		return increment;
+	if (data_size) {
+		event->header.size += data_size;
+		return 0;
 	}
 
+	if (size > dst_size)
+		return -1;
+
 	event->header.type = PERF_RECORD_COMPRESSED2;
 	event->header.size = size;
 
diff --git a/tools/perf/util/compress.h b/tools/perf/util/compress.h
index 6cfecfca16f24..ec6c38129e248 100644
--- a/tools/perf/util/compress.h
+++ b/tools/perf/util/compress.h
@@ -54,7 +54,8 @@ int zstd_fini(struct zstd_data *data);
 
 ssize_t zstd_compress_stream_to_records(struct zstd_data *data, void *dst, size_t dst_size,
 				       void *src, size_t src_size, size_t max_record_size,
-				       size_t process_header(void *record, size_t increment));
+				       ssize_t process_header(void *record, size_t dst_size,
+							      size_t data_size));
 
 size_t zstd_decompress_stream(struct zstd_data *data, void *src, size_t src_size,
 			      void *dst, size_t dst_size);
@@ -75,7 +76,8 @@ ssize_t zstd_compress_stream_to_records(struct zstd_data *data __maybe_unused,
 				       void *dst __maybe_unused, size_t dst_size __maybe_unused,
 				       void *src __maybe_unused, size_t src_size __maybe_unused,
 				       size_t max_record_size __maybe_unused,
-				       size_t process_header(void *record, size_t increment) __maybe_unused)
+				       ssize_t process_header(void *record, size_t dst_size,
+							      size_t data_size) __maybe_unused)
 {
 	return 0;
 }
diff --git a/tools/perf/util/zstd.c b/tools/perf/util/zstd.c
index 21a0eb58597c2..d98014902f012 100644
--- a/tools/perf/util/zstd.c
+++ b/tools/perf/util/zstd.c
@@ -31,9 +31,11 @@ int zstd_fini(struct zstd_data *data)
 
 ssize_t zstd_compress_stream_to_records(struct zstd_data *data, void *dst, size_t dst_size,
 				       void *src, size_t src_size, size_t max_record_size,
-				       size_t process_header(void *record, size_t increment))
+				       ssize_t process_header(void *record, size_t dst_size,
+							      size_t data_size))
 {
-	size_t ret, size, compressed = 0;
+	size_t ret, compressed = 0;
+	ssize_t size;
 	ZSTD_inBuffer input = { src, src_size, 0 };
 	ZSTD_outBuffer output;
 	void *record;
@@ -55,12 +57,9 @@ ssize_t zstd_compress_stream_to_records(struct zstd_data *data, void *dst, size_
 
 	while (input.pos < input.size) {
 		record = dst;
-		/* process_header writes the event header into record */
-		if (dst_size < sizeof(struct perf_event_header))
-			goto reset;
-		size = process_header(record, 0);
+		size = process_header(record, dst_size, 0);
 		/* Output buffer full — cannot fit even the record header */
-		if (size > dst_size)
+		if (size < 0)
 			goto reset;
 		compressed += size;
 		dst += size;
@@ -74,17 +73,21 @@ ssize_t zstd_compress_stream_to_records(struct zstd_data *data, void *dst, size_
 				(long)src_size, ZSTD_getErrorName(ret));
 			goto reset;
 		}
-		size = output.pos;
+		compressed += output.pos;
+		dst += output.pos;
+		dst_size -= output.pos;
 		/*
 		 * No progress: ZSTD couldn't emit any bytes into the
 		 * remaining output buffer.  Calling process_header
-		 * with size=0 would re-trigger header initialization,
+		 * with output.pos=0 would re-trigger header initialization,
 		 * double-subtracting the header size from dst_size and
 		 * underflowing the unsigned counter.
 		 */
-		if (size == 0)
+		if (output.pos == 0)
+			goto reset;
+		size = process_header(record, dst_size, output.pos);
+		if (size < 0)
 			goto reset;
-		size = process_header(record, size);
 		compressed += size;
 		dst += size;
 		dst_size -= size;
-- 
2.53.0



