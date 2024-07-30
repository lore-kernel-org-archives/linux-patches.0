Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA2B8BE8;
	Tue, 30 Jul 2024 16:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357246; cv=none; b=fxoVeDVZQU0uDNn83R4ff6f2OgSSUg7rY5caSYekU3VPvc52zhsD0NJwFWTWzwNRQUr+1hchyDkgsn8Q6rr54n+PTKKobMA1eFBE6ycBeVIQIQuXCK6T81Cqdhh5nmiLdnqroix95V/0a/MprD66Gu0XpSrBP6Q/t+f2uuho6nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357246; c=relaxed/simple;
	bh=hjOECVx8Ru6UtK8BqLhVqZsr7gl7XnLhf/YvMtCnjEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOtMN/XVdpwM+Q9SDTwdQ9yQDgWZIFXzd5Vjt4PjkQ4XR3TjuIV5kmaM52gisSCCTdhzUhMwRB1Tq6LODJsLWeWasqJVWp4lfPLBTkXySGcGCuvbG7HEwUrDMzNtxIfnFdZayzUbkHeITfPEGZqJUac1ZO2Pnzw44skE5U4X6EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpFppoRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpFppoRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C3CC32782;
	Tue, 30 Jul 2024 16:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357246;
	bh=hjOECVx8Ru6UtK8BqLhVqZsr7gl7XnLhf/YvMtCnjEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpFppoRLlzcubLgw/6qt6LSrqHmGq311lgaXG3Xs9w11YwlxtLVBlxPhMM+Pf2o9T
	 olistkPMmH2F6UTsGS66ixGa0HUUf+e5x9C0Kr/xH75Rg0PrWExzN0jGdpW6/5arnn
	 rV0Y55mQ2JJYy7F7hVLma2k6szCl8gOi3b2tHO4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 236/809] net: page_pool: fix warning code
Date: Tue, 30 Jul 2024 17:41:52 +0200
Message-ID: <20240730151733.926877892@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 946b6c48cca48591fb495508c5dbfade767173d0 ]

WARN_ON_ONCE("string") doesn't really do what appears to
be intended, so fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 90de47f020db ("page_pool: fragment API support for 32-bit arch with 64-bit DMA")
Link: https://patch.msgid.link/20240705134221.2f4de205caa1.I28496dc0f2ced580282d1fb892048017c4491e21@changeid
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index f4444b4e39e63..3772eb63dcad1 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -445,7 +445,7 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
 	return true;
 
 unmap_failed:
-	WARN_ON_ONCE("unexpected DMA address, please report to netdev@");
+	WARN_ONCE(1, "unexpected DMA address, please report to netdev@");
 	dma_unmap_page_attrs(pool->p.dev, dma,
 			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
 			     DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
-- 
2.43.0



