Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDB219FA99;
	Thu, 15 Aug 2024 13:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729222; cv=none; b=T2rwC/8LKx2/woa/LYyW/q9F2Kfn7Iuiz3ZlzWYCB8bfArWsckTLDzBwhh7gyWzieXkC4Gpy60WU0Y72FnEm7vSBiRzKe1EvNrkeZp3A/+0TZMw1ExaJMUWpSaO7RypNyqOA8j4PLv6cDhLLr5/rmDM40cIMOB7I/QsMbBxoi6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729222; c=relaxed/simple;
	bh=hI/HT4JXb10bJSc6Ja3Yp8S0uIO6WTTjA3tNxWeXGro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hM31zeaD7bO+nqXJKYqdI9tyHXiYBcLDJ87YcXvzxkjwBd8y5usoKNJTUr9pgKfgwsAKYSUkKgqVwvlvB2gWqRzNx0WgTZRREIVgp5pT/ElPdHKW1xNqQY9VcAe/dXLDsL3A23lmazPxnFRSalMCVAcS0k4YSV6nvld0tomSVe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ug/ppoFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ug/ppoFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DE8C4AF0C;
	Thu, 15 Aug 2024 13:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729222;
	bh=hI/HT4JXb10bJSc6Ja3Yp8S0uIO6WTTjA3tNxWeXGro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ug/ppoFzj9/0WOjQ+6inFHB9sXolG1c34+gLrP/C3giDa4qxckxoy02wiRL1fhdbL
	 p8flroRFdaVqdrElNx+OBsjfgEfyywmJd7vSq6I1MFyP1AKsX+F+6jWyARg4i2B6Q0
	 ZY0AJQk3jmDsUnhzPSexN0k1aVMaN22YyRO7f3dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jinyoung Choi <j-young.choi@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/484] block: cleanup bio_integrity_prep
Date: Thu, 15 Aug 2024 15:17:44 +0200
Message-ID: <20240815131941.509242812@linuxfoundation.org>
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

From: Jinyoung Choi <j-young.choi@samsung.com>

[ Upstream commit 51d74ec9b62f5813767a60226acaf943e26e7d7a ]

If a problem occurs in the process of creating an integrity payload, the
status of bio is always BLK_STS_RESOURCE.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jinyoung Choi <j-young.choi@samsung.com>
Reviewed-by: "Martin K. Petersen" <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20230725051839epcms2p8e4d20ad6c51326ad032e8406f59d0aaa@epcms2p8
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 899ee2c3829c ("block: initialize integrity buffer to zero before writing it to media")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index a11c4cac269f1..3693daa1c894e 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -203,7 +203,6 @@ bool bio_integrity_prep(struct bio *bio)
 	unsigned long start, end;
 	unsigned int len, nr_pages;
 	unsigned int bytes, offset, i;
-	blk_status_t status;
 
 	if (!bi)
 		return true;
@@ -231,7 +230,6 @@ bool bio_integrity_prep(struct bio *bio)
 	/* Allocate kernel buffer for protection data */
 	len = bio_integrity_bytes(bi, bio_sectors(bio));
 	buf = kmalloc(len, GFP_NOIO);
-	status = BLK_STS_RESOURCE;
 	if (unlikely(buf == NULL)) {
 		printk(KERN_ERR "could not allocate integrity buffer\n");
 		goto err_end_io;
@@ -246,7 +244,6 @@ bool bio_integrity_prep(struct bio *bio)
 	if (IS_ERR(bip)) {
 		printk(KERN_ERR "could not allocate data integrity bioset\n");
 		kfree(buf);
-		status = BLK_STS_RESOURCE;
 		goto err_end_io;
 	}
 
@@ -274,7 +271,6 @@ bool bio_integrity_prep(struct bio *bio)
 
 		if (ret == 0) {
 			printk(KERN_ERR "could not attach integrity payload\n");
-			status = BLK_STS_RESOURCE;
 			goto err_end_io;
 		}
 
@@ -296,7 +292,7 @@ bool bio_integrity_prep(struct bio *bio)
 	return true;
 
 err_end_io:
-	bio->bi_status = status;
+	bio->bi_status = BLK_STS_RESOURCE;
 	bio_endio(bio);
 	return false;
 
-- 
2.43.0



