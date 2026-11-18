Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054952;
	b=AiJKOEbMeYg8CTSjiGx2LwFRwGynf3bUvXdSW+YQQOTMistJYG2jUt7HAzvjam1hH2a5
	 AnDoygCV9C2SapzrJ8YyH1YKpEorYb2VHQzLD4dWGQjfHkBOr4BoxVQVCIv6K9St9q4xv
	 u4FCtDF/ZGfASxYIgt8X9qOGp/eSbRWNxbulq09Fzu4aywWYlB267bROStdau8eShzv4D
	 exs7xjyyFO9xjuL72DV10x7DxuC4ENEfkvV0vqwBA89mLoEiRAmRTx0SCkHG/4CjFWTzL
	 Te8gN1r8Vupt5JB/AdijdxO0ypbk5CejlDdAmAbCcVYU6gbpSCsfH2H/TpN7AEwGnSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/6Sn0c8y+ThCb7U5ZJuS+xpzbkQOd1NCCn2G8Jl6xv8=;
	b=yPaVLJCiKR+6WQ3Yyqz26bajJNkhu2PMJsuD+k2oDcuYZvYThy2S5s9zvF5SUazzQcu6
	 GK2c1YGkv2sudF8tWre/SLbcSekfKhscOZ65ojyyWnLOwYVSpk0i+mt+8lnKXCUWWWjl6
	 rKNyqrvfFFIrzOtTNEgYrj4vS7DEpYtfE24RtbZwY2I08KnrfKsbWrdEcA/jnSPGsnJYB
	 8OEVVJlA91v+xcFIYmnX9odbPn0wTwDwNAbN1OL0orD4CcW/rc3g2Id+fxpLIHoAsKweQ
	 tUf/x93RKrlBVzWmiN98dKUdPjyZ3d8FZzNJ/PqhT8DxeCMjMe3sOt9kyjc2gqc3QSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wFfo3ktO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58492606A320;
	Thu, 19 Nov 2026 02:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wFfo3ktO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613551F000C5;
	Thu, 19 Nov 2026 02:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054951;
	bh=/6Sn0c8y+ThCb7U5ZJuS+xpzbkQOd1NCCn2G8Jl6xv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wFfo3ktOS0QvBkMrhaHOHSoZwjEPUwp9nRQUhWobPcDn4EUwfeaGCYLul1KrpFv1X
	 iJd0XPFUbI96immD7gpx+NUK432YkogdrXLGIfly+gm+EOcva6LvVNnRYDsPrFAg10
	 oVbxyE/8XPvbRzLaAMjRfKiAOSa7yaawmBuXsaZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1457/2214] dmaengine: fsl_raid: zero CF descriptor pool allocations
Date: Wed, 18 Nov 2026 15:52:13 +0100
Message-ID: <20261118150109.355871343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 26d48e9fb6997f4026dd86daecf8d2c12258f698 ]

The compound frame descriptors and embedded CDBs are allocated from the
cf_desc_pool with dma_pool_alloc(), which does not zero the memory. Only
cdb32, the gfm coefficients and the frame address/length fields are
programmed; the dpi_dest_spec/dpi_src_spec fields in the CDBs and the
rbro32 field of each frame are left uninitialized. The hardware reads
the whole block (frame 0 length is sizeof(struct fsl_re_xor_cdb) or
sizeof(struct fsl_re_pq_cdb)), so uninitialized heap contents are
exposed to the device on each new descriptor.

Use dma_pool_zalloc() in both fsl_re_chan_alloc_desc() and
fsl_re_alloc_chan_resources() so the descriptor and CDB memory is
zeroed before it is handed to the RAID engine.

Fixes: ad80da658bbc ("dmaengine: Driver support for FSL RaidEngine device.")
Assisted-by: opencode:deepseek-v4-flash-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260820031654.28450-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl_raid.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/fsl_raid.c b/drivers/dma/fsl_raid.c
index facd8b0f48f47..d8914ddbedf7c 100644
--- a/drivers/dma/fsl_raid.c
+++ b/drivers/dma/fsl_raid.c
@@ -304,8 +304,8 @@ static struct fsl_re_desc *fsl_re_chan_alloc_desc(struct fsl_re_chan *re_chan,
 		if (!desc)
 			return NULL;
 
-		cf = dma_pool_alloc(re_chan->re_dev->cf_desc_pool, GFP_NOWAIT,
-				    &paddr);
+		cf = dma_pool_zalloc(re_chan->re_dev->cf_desc_pool, GFP_NOWAIT,
+				     &paddr);
 		if (!cf) {
 			kfree(desc);
 			return NULL;
@@ -593,8 +593,8 @@ static int fsl_re_alloc_chan_resources(struct dma_chan *chan)
 		if (!desc)
 			break;
 
-		cf = dma_pool_alloc(re_chan->re_dev->cf_desc_pool, GFP_KERNEL,
-				    &paddr);
+		cf = dma_pool_zalloc(re_chan->re_dev->cf_desc_pool, GFP_KERNEL,
+				     &paddr);
 		if (!cf) {
 			kfree(desc);
 			break;
-- 
2.53.0



