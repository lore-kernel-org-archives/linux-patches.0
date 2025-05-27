Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38E71FB3;
	Tue, 27 May 2025 17:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368067; cv=none; b=nM8jTfQqq86I7HxbzOr9A/mx9S7Scqe9jgwQI022uKC4kP+Su8R4hibcGFkzRxBHMJy8fBGc/j5ByDgcCdYwoEReFks4SAHlgtvDP1R/j19RV+Z8+Uoc5owJGycZb4E85W3MM51+VSy5rXX3Pb/cnU9LPhPCz0Wyid6sL/lAi0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368067; c=relaxed/simple;
	bh=tf5XIr/03iXTNcxz3nSNO2uVLh/UymJCOW53oAqCkdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRDoBjzTISFfeK5jOHqqCpi5TFQfzGrF+DQyg7+UONVVK4N753s3AxQ4gtkm6z8Gb0nZj5i+Q/15F9I4es8BhAacQKp48XiF1eq5jA56OcgMuo63EqNQYsQqAXgQNPLaV3RzPNajd0SY6/lX3GrSYDiytJPhbPVZFZI/XdVfiYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhFqxN2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhFqxN2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0BBC4CEE9;
	Tue, 27 May 2025 17:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368065;
	bh=tf5XIr/03iXTNcxz3nSNO2uVLh/UymJCOW53oAqCkdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhFqxN2YoZX5ePxCjageNw55Asu8DpdeHD3tGVWuuvictvPJtCb9UV9yDo4gTBiMb
	 bt3w2j7EvJG6d6lF60LbiIOCFPeBC0QdaI0Qjb5ZCzrJA1mCo6EqAeLF+TJ/JJ5C1R
	 JuUwN5n4EMFekBFFlX8ZJsb+b2beabOuyCwwe/nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 588/783] dm vdo vio-pool: allow variable-sized metadata vios
Date: Tue, 27 May 2025 18:26:25 +0200
Message-ID: <20250527162537.082726404@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ken Raeburn <raeburn@redhat.com>

[ Upstream commit f979da512553a41a657f2c1198277e84d66f8ce3 ]

With larger-sized metadata vio pools, vdo will sometimes need to
issue I/O with a smaller size than the allocated size. Since
vio_reset_bio is where the bvec array and I/O size are initialized,
this reset interface must now specify what I/O size to use.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-vdo/io-submitter.c |  6 ++++--
 drivers/md/dm-vdo/io-submitter.h | 18 +++++++++++++---
 drivers/md/dm-vdo/types.h        |  3 +++
 drivers/md/dm-vdo/vio.c          | 36 +++++++++++++++++++-------------
 drivers/md/dm-vdo/vio.h          |  2 ++
 5 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 421e5436c32c9..11d47770b54d2 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -327,6 +327,7 @@ void vdo_submit_data_vio(struct data_vio *data_vio)
  * @error_handler: the handler for submission or I/O errors (may be NULL)
  * @operation: the type of I/O to perform
  * @data: the buffer to read or write (may be NULL)
+ * @size: the I/O amount in bytes
  *
  * The vio is enqueued on a vdo bio queue so that bio submission (which may block) does not block
  * other vdo threads.
@@ -338,7 +339,7 @@ void vdo_submit_data_vio(struct data_vio *data_vio)
  */
 void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 			   bio_end_io_t callback, vdo_action_fn error_handler,
-			   blk_opf_t operation, char *data)
+			   blk_opf_t operation, char *data, int size)
 {
 	int result;
 	struct vdo_completion *completion = &vio->completion;
@@ -349,7 +350,8 @@ void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 
 	vdo_reset_completion(completion);
 	completion->error_handler = error_handler;
-	result = vio_reset_bio(vio, data, callback, operation | REQ_META, physical);
+	result = vio_reset_bio_with_size(vio, data, size, callback, operation | REQ_META,
+					 physical);
 	if (result != VDO_SUCCESS) {
 		continue_vio(vio, result);
 		return;
diff --git a/drivers/md/dm-vdo/io-submitter.h b/drivers/md/dm-vdo/io-submitter.h
index 80748699496f2..3088f11055fdd 100644
--- a/drivers/md/dm-vdo/io-submitter.h
+++ b/drivers/md/dm-vdo/io-submitter.h
@@ -8,6 +8,7 @@
 
 #include <linux/bio.h>
 
+#include "constants.h"
 #include "types.h"
 
 struct io_submitter;
@@ -26,14 +27,25 @@ void vdo_submit_data_vio(struct data_vio *data_vio);
 
 void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 			   bio_end_io_t callback, vdo_action_fn error_handler,
-			   blk_opf_t operation, char *data);
+			   blk_opf_t operation, char *data, int size);
 
 static inline void vdo_submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 					   bio_end_io_t callback, vdo_action_fn error_handler,
 					   blk_opf_t operation)
 {
 	__submit_metadata_vio(vio, physical, callback, error_handler,
-			      operation, vio->data);
+			      operation, vio->data, vio->block_count * VDO_BLOCK_SIZE);
+}
+
+static inline void vdo_submit_metadata_vio_with_size(struct vio *vio,
+						     physical_block_number_t physical,
+						     bio_end_io_t callback,
+						     vdo_action_fn error_handler,
+						     blk_opf_t operation,
+						     int size)
+{
+	__submit_metadata_vio(vio, physical, callback, error_handler,
+			      operation, vio->data, size);
 }
 
 static inline void vdo_submit_flush_vio(struct vio *vio, bio_end_io_t callback,
@@ -41,7 +53,7 @@ static inline void vdo_submit_flush_vio(struct vio *vio, bio_end_io_t callback,
 {
 	/* FIXME: Can we just use REQ_OP_FLUSH? */
 	__submit_metadata_vio(vio, 0, callback, error_handler,
-			      REQ_OP_WRITE | REQ_PREFLUSH, NULL);
+			      REQ_OP_WRITE | REQ_PREFLUSH, NULL, 0);
 }
 
 #endif /* VDO_IO_SUBMITTER_H */
diff --git a/drivers/md/dm-vdo/types.h b/drivers/md/dm-vdo/types.h
index dbe892b10f265..cdf36e7d77021 100644
--- a/drivers/md/dm-vdo/types.h
+++ b/drivers/md/dm-vdo/types.h
@@ -376,6 +376,9 @@ struct vio {
 	/* The size of this vio in blocks */
 	unsigned int block_count;
 
+	/* The amount of data to be read or written, in bytes */
+	unsigned int io_size;
+
 	/* The data being read or written. */
 	char *data;
 
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index e710f3c5a972d..725d87ecf2150 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -188,14 +188,23 @@ void vdo_set_bio_properties(struct bio *bio, struct vio *vio, bio_end_io_t callb
 
 /*
  * Prepares the bio to perform IO with the specified buffer. May only be used on a VDO-allocated
- * bio, as it assumes the bio wraps a 4k buffer that is 4k aligned, but there does not have to be a
- * vio associated with the bio.
+ * bio, as it assumes the bio wraps a 4k-multiple buffer that is 4k aligned, but there does not
+ * have to be a vio associated with the bio.
  */
 int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
 		  blk_opf_t bi_opf, physical_block_number_t pbn)
 {
-	int bvec_count, offset, len, i;
+	return vio_reset_bio_with_size(vio, data, vio->block_count * VDO_BLOCK_SIZE,
+				       callback, bi_opf, pbn);
+}
+
+int vio_reset_bio_with_size(struct vio *vio, char *data, int size, bio_end_io_t callback,
+			    blk_opf_t bi_opf, physical_block_number_t pbn)
+{
+	int bvec_count, offset, i;
 	struct bio *bio = vio->bio;
+	int vio_size = vio->block_count * VDO_BLOCK_SIZE;
+	int remaining;
 
 	bio_reset(bio, bio->bi_bdev, bi_opf);
 	vdo_set_bio_properties(bio, vio, callback, bi_opf, pbn);
@@ -205,22 +214,21 @@ int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
 	bio->bi_ioprio = 0;
 	bio->bi_io_vec = bio->bi_inline_vecs;
 	bio->bi_max_vecs = vio->block_count + 1;
-	len = VDO_BLOCK_SIZE * vio->block_count;
+	if (VDO_ASSERT(size <= vio_size, "specified size %d is not greater than allocated %d",
+		       size, vio_size) != VDO_SUCCESS)
+		size = vio_size;
+	vio->io_size = size;
 	offset = offset_in_page(data);
-	bvec_count = DIV_ROUND_UP(offset + len, PAGE_SIZE);
+	bvec_count = DIV_ROUND_UP(offset + size, PAGE_SIZE);
+	remaining = size;
 
-	/*
-	 * If we knew that data was always on one page, or contiguous pages, we wouldn't need the
-	 * loop. But if we're using vmalloc, it's not impossible that the data is in different
-	 * pages that can't be merged in bio_add_page...
-	 */
-	for (i = 0; (i < bvec_count) && (len > 0); i++) {
+	for (i = 0; (i < bvec_count) && (remaining > 0); i++) {
 		struct page *page;
 		int bytes_added;
 		int bytes = PAGE_SIZE - offset;
 
-		if (bytes > len)
-			bytes = len;
+		if (bytes > remaining)
+			bytes = remaining;
 
 		page = is_vmalloc_addr(data) ? vmalloc_to_page(data) : virt_to_page(data);
 		bytes_added = bio_add_page(bio, page, bytes, offset);
@@ -232,7 +240,7 @@ int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
 		}
 
 		data += bytes;
-		len -= bytes;
+		remaining -= bytes;
 		offset = 0;
 	}
 
diff --git a/drivers/md/dm-vdo/vio.h b/drivers/md/dm-vdo/vio.h
index 3490e9f59b04a..74e8fd7c8c029 100644
--- a/drivers/md/dm-vdo/vio.h
+++ b/drivers/md/dm-vdo/vio.h
@@ -123,6 +123,8 @@ void vdo_set_bio_properties(struct bio *bio, struct vio *vio, bio_end_io_t callb
 
 int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
 		  blk_opf_t bi_opf, physical_block_number_t pbn);
+int vio_reset_bio_with_size(struct vio *vio, char *data, int size, bio_end_io_t callback,
+			    blk_opf_t bi_opf, physical_block_number_t pbn);
 
 void update_vio_error_stats(struct vio *vio, const char *format, ...)
 	__printf(2, 3);
-- 
2.39.5



