Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3447E7BAF8;
	Wed, 21 Feb 2024 14:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524168; cv=none; b=I3Fn3TJcpdMO2/f603njxI63fj3Exq86YAWKa0HfozW4CQtW2AkgacMUK0BP3IaMYJTZDDzAtBnTJWeZNM8u86nCeEgCDRtgm1dxeeJWHvUPxxLqlWzLw76GrAGdcte+ldFgs51SufEHZ4oCKle+xiQ3Fe59ONYWPQv2IRftQTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524168; c=relaxed/simple;
	bh=RmppxLtmjNemNwoXYaFvnmG3rUMHsM+2pN+v6BK9LF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XC70efzf81FOLx5jzHD33mJMn96i/va3QtK4SA6leg1yXNQuBnSh48Dleo4IpKX/fF3XMTikN4jr5uvWA3aRDN4oZbP9xm0VFVkN4FpeR4+jjVwHVqy7mBBXltOFZHR7slJCkijyPPBV1Krj7GW/cysgeJ07DajXYo+2k1jSQyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=le4Lu0WK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="le4Lu0WK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA87AC433C7;
	Wed, 21 Feb 2024 14:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524168;
	bh=RmppxLtmjNemNwoXYaFvnmG3rUMHsM+2pN+v6BK9LF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=le4Lu0WK1a+OkZrYCi78CJCQwYZSgwX7HJwWMXcpaUMVBO9iep/ijhJdxQW6BYkyK
	 ke9SgFUR77v0NKZfi4E2/ScUc8sxAAmDojyBfg8T0QKJRG5vj/4qUtPDHDhA4xUpnc
	 MgvE6mx5uAML8TIT5tvtlFbZBRERDrGl363uMM8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/379] block: prevent an integer overflow in bvec_try_merge_hw_page
Date: Wed, 21 Feb 2024 14:05:44 +0100
Message-ID: <20240221125959.796825081@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b729f0240082..6f7a1aa9ea22 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -770,7 +770,7 @@ static bool bio_try_merge_hw_seg(struct request_queue *q, struct bio *bio,
 
 	if ((addr1 | mask) != (addr2 | mask))
 		return false;
-	if (bv->bv_len + len > queue_max_segment_size(q))
+	if (len > queue_max_segment_size(q) - bv->bv_len)
 		return false;
 	return __bio_try_merge_page(bio, page, len, offset, same_page);
 }
-- 
2.43.0



