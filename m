Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4313A7F43;
	Thu, 15 Jan 2026 16:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496335; cv=none; b=k6mFEnwkTODA0pkyX/nAXifjpWEk6bPr8IXBeDdRZW6ifRd9rok7uiYqCzZ0Y3bRp+Fptg+DHOjSd51OGZeyiBfhMJUk0FMUCSn9KNr5bRxxTSAxxtQ5KwY60gQl1AA/KWVDLxMpsLw/z2yhQXAcq4Y61hPRq7g8q3OBJkI229w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496335; c=relaxed/simple;
	bh=djg91dr9efbB521/CyMd531aSiw1cF6nvcysNLSktoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZy2TjKbj9aaIAyGhuF/aQMue8l11iv6fwUW19ZcoiaB54Z0VPHtpy0QcQPR3Oh8779HiinD4BbpNsrajNmtZkVZs8B4544Shaqxf8cmkjRmQd3oxlhI6FJzKIq2KoFht5Vq5VKW2kywsliSagllCZahG6+jdW5+p0x+Iywe/Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXdGAOnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXdGAOnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CADC116D0;
	Thu, 15 Jan 2026 16:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496335;
	bh=djg91dr9efbB521/CyMd531aSiw1cF6nvcysNLSktoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXdGAOnQ7LIwVneZE5ikcYDGUV9PuOuKnwz1An9MfOynLGE2fLd7QdrhQzKIxlIzE
	 Ja0wyqBvwrUKhdhIJRu/QFUqAfSSJwcjMYd0ily8jenGddSV2mZN4DMgMDHKZmmlNM
	 EoP8tHlS6ltV98YfC+QzwDOHeiVXDXDaUlzrklaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 143/181] block: dont merge bios with different app_tags
Date: Thu, 15 Jan 2026 17:48:00 +0100
Message-ID: <20260115164207.478696117@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 6acd4ac5f8f0ec9b946875553e52907700bcfc77 ]

nvme_set_app_tag() uses the app_tag value from the bio_integrity_payload
of the struct request's first bio. This assumes all the request's bios
have the same app_tag. However, it is possible for bios with different
app_tag values to be merged into a single request.
Add a check in blk_integrity_merge_{bio,rq}() to prevent the merging of
bios/requests with different app_tag values if BIP_CHECK_APPTAG is set.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 3d8b5a22d404 ("block: add support to pass user meta buffer")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-integrity.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 9b27963680dc3..964eebbee14d0 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -140,14 +140,21 @@ EXPORT_SYMBOL_GPL(blk_rq_integrity_map_user);
 bool blk_integrity_merge_rq(struct request_queue *q, struct request *req,
 			    struct request *next)
 {
+	struct bio_integrity_payload *bip, *bip_next;
+
 	if (blk_integrity_rq(req) == 0 && blk_integrity_rq(next) == 0)
 		return true;
 
 	if (blk_integrity_rq(req) == 0 || blk_integrity_rq(next) == 0)
 		return false;
 
-	if (bio_integrity(req->bio)->bip_flags !=
-	    bio_integrity(next->bio)->bip_flags)
+	bip = bio_integrity(req->bio);
+	bip_next = bio_integrity(next->bio);
+	if (bip->bip_flags != bip_next->bip_flags)
+		return false;
+
+	if (bip->bip_flags & BIP_CHECK_APPTAG &&
+	    bip->app_tag != bip_next->app_tag)
 		return false;
 
 	if (req->nr_integrity_segments + next->nr_integrity_segments >
@@ -163,15 +170,21 @@ bool blk_integrity_merge_rq(struct request_queue *q, struct request *req,
 bool blk_integrity_merge_bio(struct request_queue *q, struct request *req,
 			     struct bio *bio)
 {
+	struct bio_integrity_payload *bip, *bip_bio = bio_integrity(bio);
 	int nr_integrity_segs;
 
-	if (blk_integrity_rq(req) == 0 && bio_integrity(bio) == NULL)
+	if (blk_integrity_rq(req) == 0 && bip_bio == NULL)
 		return true;
 
-	if (blk_integrity_rq(req) == 0 || bio_integrity(bio) == NULL)
+	if (blk_integrity_rq(req) == 0 || bip_bio == NULL)
+		return false;
+
+	bip = bio_integrity(req->bio);
+	if (bip->bip_flags != bip_bio->bip_flags)
 		return false;
 
-	if (bio_integrity(req->bio)->bip_flags != bio_integrity(bio)->bip_flags)
+	if (bip->bip_flags & BIP_CHECK_APPTAG &&
+	    bip->app_tag != bip_bio->app_tag)
 		return false;
 
 	nr_integrity_segs = blk_rq_count_integrity_sg(q, bio);
-- 
2.51.0



