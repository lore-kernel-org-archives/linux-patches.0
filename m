Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E0D69D29;
	Wed, 21 Feb 2024 14:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525294; cv=none; b=jiz5j1O7CFT9ggd7zj54tbEAM+fkJIZMNL86QnwCWCz9qOM/FgoniqpxrgosEd1M3L6cnxmtnc/YU+Z6Ruqo7CpB0XlOmCTb7hQhcq9TPWvYirP3ie+coclqNZaevKIfgGemHTinYujNqfXdapGPZAkOcWDgr6u2sa8XPsWQAWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525294; c=relaxed/simple;
	bh=8hnQW2Nf32AOyO+BL/tn9ey3JKmFTugdWbi3vi/MFLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sgw0nx3MKAPMZKJ2qaOB8rahuUwy1HFsUGM+i4fkXzD0zl9Vaj2ulxNxGgenaOoiWqf6Ose+CzfEoPMvpOQz+fDHUzsZdDo5DemIwz1fON2D4s2gq5qWWbdCTs4m4hothB+76VigTRUbJbKiKVRQNB5ChMklRxz8JLwG1GC22Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XeK3OQeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XeK3OQeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3B4C433C7;
	Wed, 21 Feb 2024 14:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525294;
	bh=8hnQW2Nf32AOyO+BL/tn9ey3JKmFTugdWbi3vi/MFLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeK3OQeujrvG+asyKm8+SUBSVTzLHhIqDVBMeW43KhGjQeohfU2JQk3ozG6T85p3M
	 X5d5hMnaXGH/H4oYn+aXyhFUetTjYv0myUV6kvBqcP3KrIZcV84rzzxn45Tbxhbwa2
	 tSdVuNfZjq6ssmY71Y44e1dEt/6w8cSaH+GafXnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/267] block: prevent an integer overflow in bvec_try_merge_hw_page
Date: Wed, 21 Feb 2024 14:07:34 +0100
Message-ID: <20240221125943.511519908@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6bdb95174adc..e3d3e75c97e0 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -710,7 +710,7 @@ static bool bio_try_merge_pc_page(struct request_queue *q, struct bio *bio,
 
 	if ((addr1 | mask) != (addr2 | mask))
 		return false;
-	if (bv->bv_len + len > queue_max_segment_size(q))
+	if (len > queue_max_segment_size(q) - bv->bv_len)
 		return false;
 	return __bio_try_merge_page(bio, page, len, offset, same_page);
 }
-- 
2.43.0



