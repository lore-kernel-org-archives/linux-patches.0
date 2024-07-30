Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEDE145A18;
	Tue, 30 Jul 2024 15:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354834; cv=none; b=Zo0a3e9X5gAQrWcmoQDGfCd6zZWvn+xPDh8Wtxi7FcaC9CpjKMqCy1z0RiG1GCMmXPozf2kTGw6+G0gMvDwkwcd0VUv2rvh+1RtPftVx0q+JN5AHIBYsz+xHXEq218m+UBivT8YJzAQkrfFs3x5gqmntDkD+bKXCtfXUExiwbVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354834; c=relaxed/simple;
	bh=XQvfqYttIqerH0RkVKTHeD3w5s3G4JwUfpBttNwF5YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2lZj34KlZX8EfPVnRIxTD/1gLXtTaX/WNlDruc8Dfx8jHtLAb5wPXP7xN1l1FJk/5ZxUhrS7mgCap8cxvQCMMj/n15ejDdn0cY41rWPJant5rdXTNPbTPKAAKZok13v5ugHoYzThoahzsF/SJCZreGX/wqe5eu4M8U12d3Qfi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzErfKiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzErfKiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD936C32782;
	Tue, 30 Jul 2024 15:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354834;
	bh=XQvfqYttIqerH0RkVKTHeD3w5s3G4JwUfpBttNwF5YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzErfKiVuXqwEoe+KA+9IuQRSgTW5nPe5hl1wD/w1fWcpib0mymhWVBykQ3imTzTl
	 xpvtfxFAEyR+vX/uNDIvAiRAETLftfcpvaoxp611NnAvGiX12oux/HP9/gHjqQ+OEw
	 aUnyGcVchnJCpft3PnPoVauq65TvfEs6w21qxP0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/440] block: refactor to use helper
Date: Tue, 30 Jul 2024 17:44:02 +0200
Message-ID: <20240730151616.124704213@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4533eb4916610..8f0af7ac8573b 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -199,7 +199,6 @@ bool bio_integrity_prep(struct bio *bio)
 	unsigned long start, end;
 	unsigned int len, nr_pages;
 	unsigned int bytes, offset, i;
-	unsigned int intervals;
 	blk_status_t status;
 
 	if (!bi)
@@ -224,10 +223,9 @@ bool bio_integrity_prep(struct bio *bio)
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



