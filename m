Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365FA7DA9E;
	Thu, 15 Aug 2024 13:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729219; cv=none; b=OMKklrjOpkbvG/qVBid4hJ29sJTGJmuENkq0dCmQG0EkQSukCvnoB/adjU2kJ6JZ7pbQGJPC9USLC1U0WJkKCJQsWjKKT3s5COYwY1OMDI+eKlsJcTw9Q20HFiGIWJLm9+/0NHFDQ1+tmFg3GmnDu7Ml0V01jQQST1pmlQSWpk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729219; c=relaxed/simple;
	bh=+lkgELnGgAswoFj/MndNZq2Ps4Y91ktLxufGGIc7ODE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8nOmgzEN+lb8tZzt9PLiBDeFaAmXnbFjQuBag8CJej1Sd+JSVd9+Mzr9Mt5HDMf0PyA+dlenVb/YfLLLDPgZKUmWaLB0tgE3rAUKeSvkzxWhZQRyBEz9YaUmL5BZbb5/nmsCcdVOCTshmV9OmB7Ma6jcK3/h9yU7J67ZcCak1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHMboS82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHMboS82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9976FC32786;
	Thu, 15 Aug 2024 13:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729219;
	bh=+lkgELnGgAswoFj/MndNZq2Ps4Y91ktLxufGGIc7ODE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHMboS82TBRk8LiNcU7FYuIhoR25GkSm3b/waZB0aKFAXdNtM3sbTmGpBdSJh/Qy+
	 A5enqBSeU90C+s4Nb642nwEiGljlnGRl88JmeZd62GfFGRdyS7em/NvRXg5RIxpdDL
	 xN7fFMfBU2IOKNdepOmnzjEedF4kMluTnfNdsZNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/484] block: refactor to use helper
Date: Thu, 15 Aug 2024 15:17:43 +0200
Message-ID: <20240815131941.472296317@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitesh Shetty <nj.shetty@samsung.com>

[ Upstream commit 8f63fef5867fb5e8c29d9c14b6d739bfc1869d32 ]

Reduce some code by making use of bio_integrity_bytes().

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Reviewed-by: "Martin K. Petersen" <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20230719121608.32105-1-nj.shetty@samsung.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 899ee2c3829c ("block: initialize integrity buffer to zero before writing it to media")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 4f34ac27c47dd..a11c4cac269f1 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -203,7 +203,6 @@ bool bio_integrity_prep(struct bio *bio)
 	unsigned long start, end;
 	unsigned int len, nr_pages;
 	unsigned int bytes, offset, i;
-	unsigned int intervals;
 	blk_status_t status;
 
 	if (!bi)
@@ -228,10 +227,9 @@ bool bio_integrity_prep(struct bio *bio)
 		    !(bi->flags & BLK_INTEGRITY_GENERATE))
 			return true;
 	}
-	intervals = bio_integrity_intervals(bi, bio_sectors(bio));
 
 	/* Allocate kernel buffer for protection data */
-	len = intervals * bi->tuple_size;
+	len = bio_integrity_bytes(bi, bio_sectors(bio));
 	buf = kmalloc(len, GFP_NOIO);
 	status = BLK_STS_RESOURCE;
 	if (unlikely(buf == NULL)) {
-- 
2.43.0



