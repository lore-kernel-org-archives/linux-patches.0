Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01226A8D6;
	Wed, 21 Feb 2024 13:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522549; cv=none; b=YSg0XeI2AoyFAAD2azMycBpfcfxI49WDMWmFDrrSjWYFBMMZU8AkzjXdl2boU78ogXXAFTm6V9fBpKbcojUEvKhTkq+WAq1nqIMHn/PY1EGX14c+qIPiBvVFESrVkUjcbmEMUg5I2eVDz0AijMpM9DlPU8PyceYmMGN+VWF0bYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522549; c=relaxed/simple;
	bh=+T9YlT2wQ0YO/g1EvI/eTJgIjupXm7IwdiPHj8/eEjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBy24syyufUZ8El1aYE0/EyQ5STxOwyCccdyd2ZsrhiGcdx/Gf8MLAa6tK6VjfU2DRNiQSdkF060w0Ugkd5b1p7ZglKWOqYGXh2+zknkw+xyqnA36I6uFOl3fL1UhlkcTXc+6nfr8uyprZ8EIzNug/jh4vZEBaGeUMHGQJ4SRao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZF3uIt2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZF3uIt2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE1CC433F1;
	Wed, 21 Feb 2024 13:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522549;
	bh=+T9YlT2wQ0YO/g1EvI/eTJgIjupXm7IwdiPHj8/eEjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZF3uIt2no//C2ghJr1tU7sAykemrsV2zrByX59ZS4y6wQk8wzMsaVsk7VEUtJ6nCf
	 rpS+tVTd8i0MSNByU/+sQNpEJxLaAJuX1qZAbAt93JNGMnKnQQRd/aRaxvscgJ5fbc
	 4sLnIo/t5vJFDcm9jUmImdCgQOtQ+29Zr58DDcXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/476] block: prevent an integer overflow in bvec_try_merge_hw_page
Date: Wed, 21 Feb 2024 14:04:05 +0100
Message-ID: <20240221130015.093318771@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3f034c374ad55773c12dd8f3c1607328e17c0072 ]

Reordered a check to avoid a possible overflow when adding len to bv_len.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20231204173419.782378-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index a0080dc55c95..92399883bc5e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -809,7 +809,7 @@ static bool bio_try_merge_hw_seg(struct request_queue *q, struct bio *bio,
 
 	if ((addr1 | mask) != (addr2 | mask))
 		return false;
-	if (bv->bv_len + len > queue_max_segment_size(q))
+	if (len > queue_max_segment_size(q) - bv->bv_len)
 		return false;
 	return __bio_try_merge_page(bio, page, len, offset, same_page);
 }
-- 
2.43.0



