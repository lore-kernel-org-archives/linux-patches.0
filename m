Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A6F29A2;
	Tue, 30 Jul 2024 15:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354908; cv=none; b=iO6RiItjU3pcX7B9DMcuauGk763xpXLOxZHudLsB1Lv9B0/9QaEw3v4GJCxVoiBywGPeSCQrWnCPI9OHOUAEcEufXnDZ3BbnnnA/3s1d2IH0Vj6NAFpCHH9Qc8RKjor+clfy5LWZOzvTXL3DuJg1+wDshpC+BcS+6dwI0gXPup4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354908; c=relaxed/simple;
	bh=CavXqUAO0mF2bx6rvs0qenlui9+5id8kVPrtvdni+DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBTdLkCC/4b+PfYUrvWoYVAclNJZpMK9UF5zpSRIL9ZM8+atnRJR1W5BiS7sUgrKN09gqQ7DMeivH0riJWNYvaZxvYdqsrk+SYBHxoI9YRClUUKIU5ZNB+UrA52bXYf1SF2fyaYOpwO6BWTPGArYO5lmPBBL1B0lRURU/9lhC/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOeAjNwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOeAjNwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4B8C32782;
	Tue, 30 Jul 2024 15:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354908;
	bh=CavXqUAO0mF2bx6rvs0qenlui9+5id8kVPrtvdni+DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOeAjNwDkCSZNBTm3yh1JV1Cm0KZHGS1lB/Wn7GTEwnjsNczM+13GJ9Gsnn/xRWxc
	 7iiel6XwKlKMmq5imBOQ3cHaLguFeQxtp/4sWgIqZhmw/SQAokw9Uc40XnwFzvTGzf
	 FFwDzZO0e2H0mIxlpmAx0TA2jSy2ytUSQ8Di15xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/568] block: initialize integrity buffer to zero before writing it to media
Date: Tue, 30 Jul 2024 17:41:56 +0200
Message-ID: <20240730151640.181680931@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 899ee2c3829c5ac14bfc7d3c4a5846c0b709b78f ]

Metadata added by bio_integrity_prep is using plain kmalloc, which leads
to random kernel memory being written media.  For PI metadata this is
limited to the app tag that isn't used by kernel generated metadata,
but for non-PI metadata the entire buffer leaks kernel memory.

Fix this by adding the __GFP_ZERO flag to allocations for writes.

Fixes: 7ba1ba12eeef ("block: Block layer data integrity support")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20240613084839.1044015-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index ec8ac8cf6e1b9..15e444b2fcc12 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -217,6 +217,7 @@ bool bio_integrity_prep(struct bio *bio)
 	unsigned long start, end;
 	unsigned int len, nr_pages;
 	unsigned int bytes, offset, i;
+	gfp_t gfp = GFP_NOIO;
 
 	if (!bi)
 		return true;
@@ -239,11 +240,19 @@ bool bio_integrity_prep(struct bio *bio)
 		if (!bi->profile->generate_fn ||
 		    !(bi->flags & BLK_INTEGRITY_GENERATE))
 			return true;
+
+		/*
+		 * Zero the memory allocated to not leak uninitialized kernel
+		 * memory to disk.  For PI this only affects the app tag, but
+		 * for non-integrity metadata it affects the entire metadata
+		 * buffer.
+		 */
+		gfp |= __GFP_ZERO;
 	}
 
 	/* Allocate kernel buffer for protection data */
 	len = bio_integrity_bytes(bi, bio_sectors(bio));
-	buf = kmalloc(len, GFP_NOIO);
+	buf = kmalloc(len, gfp);
 	if (unlikely(buf == NULL)) {
 		printk(KERN_ERR "could not allocate integrity buffer\n");
 		goto err_end_io;
-- 
2.43.0



