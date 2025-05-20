Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5012451C8;
	Tue, 20 May 2025 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749545; cv=none; b=T15ZI6XojzBEDWZO7a/B5X0Cnc6gHBm1q5y3aEg31ypkuoymX4fG/GKlKe26FQZEWGIqVyA6adZlGTt+Tk7mbDdzkh2zv0V6Bu9e4INdQIWyROUCB1vIzdNG3AkjxRru8zkl/RoiOSQQpju8eHJzl2tXUJPgNalJUkLDMDpM6kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749545; c=relaxed/simple;
	bh=jn7zWoOvxxhrgVQdXVMHtGCQLru/X9JLRBMbF2NsvYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHTiuG0uPebcBnN9oSLNpgtGK424otgy5S35A1iG+FcWjYa8t8hTrtQIDJjvUoAAxR0lfUiiLnP4RXM8FQUDQqfOKwsBC3kzCAWBpQdTlsvTgsyvbE00Xkgc6oRrEOZH8lo+L6Qjpny+QOxKjO9Wlfw4Rway8anAOw9L8NjSk30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIKfeuWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIKfeuWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39091C4CEEA;
	Tue, 20 May 2025 13:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749544;
	bh=jn7zWoOvxxhrgVQdXVMHtGCQLru/X9JLRBMbF2NsvYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIKfeuWVHyta+l2zfIrf6id21U31lHoZhA0pVPu+QiscShQstxMZ6kHZegklUJR3X
	 z5LerAHyNLFWUGCZHRWms3jcwJqnRnZXBiBGV/UgwqY6IAso3X4zrstwW0kq8j23wT
	 k6QGjw8MRP1t/MWzMjzCg7Yqn9xuzvC37a9tN1ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Siwinski <ssiwinski@atto.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 61/97] scsi: sd_zbc: block: Respect bio vector limits for REPORT ZONES buffer
Date: Tue, 20 May 2025 15:50:26 +0200
Message-ID: <20250520125803.044227392@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Siwinski <ssiwinski@atto.com>

commit e8007fad5457ea547ca63bb011fdb03213571c7e upstream.

The REPORT ZONES buffer size is currently limited by the HBA's maximum
segment count to ensure the buffer can be mapped. However, the block
layer further limits the number of iovec entries to 1024 when allocating
a bio.

To avoid allocation of buffers too large to be mapped, further restrict
the maximum buffer size to BIO_MAX_INLINE_VECS.

Replace the UIO_MAXIOV symbolic name with the more contextually
appropriate BIO_MAX_INLINE_VECS.

Fixes: b091ac616846 ("sd_zbc: Fix report zones buffer allocation")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Siwinski <ssiwinski@atto.com>
Link: https://lore.kernel.org/r/20250508200122.243129-1-ssiwinski@atto.com
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c           |    2 +-
 drivers/scsi/sd_zbc.c |    6 +++++-
 include/linux/bio.h   |    1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -576,7 +576,7 @@ struct bio *bio_kmalloc(unsigned short n
 {
 	struct bio *bio;
 
-	if (nr_vecs > UIO_MAXIOV)
+	if (nr_vecs > BIO_MAX_INLINE_VECS)
 		return NULL;
 	return kmalloc(struct_size(bio, bi_inline_vecs, nr_vecs), gfp_mask);
 }
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -197,6 +197,7 @@ static void *sd_zbc_alloc_report_buffer(
 					unsigned int nr_zones, size_t *buflen)
 {
 	struct request_queue *q = sdkp->disk->queue;
+	unsigned int max_segments;
 	size_t bufsize;
 	void *buf;
 
@@ -208,12 +209,15 @@ static void *sd_zbc_alloc_report_buffer(
 	 * Furthermore, since the report zone command cannot be split, make
 	 * sure that the allocated buffer can always be mapped by limiting the
 	 * number of pages allocated to the HBA max segments limit.
+	 * Since max segments can be larger than the max inline bio vectors,
+	 * further limit the allocated buffer to BIO_MAX_INLINE_VECS.
 	 */
 	nr_zones = min(nr_zones, sdkp->zone_info.nr_zones);
 	bufsize = roundup((nr_zones + 1) * 64, SECTOR_SIZE);
 	bufsize = min_t(size_t, bufsize,
 			queue_max_hw_sectors(q) << SECTOR_SHIFT);
-	bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
+	max_segments = min(BIO_MAX_INLINE_VECS, queue_max_segments(q));
+	bufsize = min_t(size_t, bufsize, max_segments << PAGE_SHIFT);
 
 	while (bufsize >= SECTOR_SIZE) {
 		buf = kvzalloc(bufsize, GFP_KERNEL | __GFP_NORETRY);
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -11,6 +11,7 @@
 #include <linux/uio.h>
 
 #define BIO_MAX_VECS		256U
+#define BIO_MAX_INLINE_VECS	UIO_MAXIOV
 
 static inline unsigned int bio_max_segs(unsigned int nr_segs)
 {


