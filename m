Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039588;
	b=mRPjUbYCSP3wMdHAMtDBt5bJtPzXW2+H+vxCEj/HZi8RkEC1dt8b9/NRiPzYXCi3st7l
	 MTPSyOSSpG6d948WXXSTnzHAnrt+Ubp7nvmXHn9zGPZG0yjmaOCVVW+N2qttukB8tq+6t
	 ynEYxzc/ZdDD6kl9sEETUjBCRepmsHa7izesHUdklXfEnLF/RSKh+lo/xSAqmsHa6GdDV
	 P3QHPXCwc4tB0tffWs+xnhOplnbC0r3c3ARqMWYs/iSz1PnCm6AN3ZY6DdKYlIrHvZp8u
	 J3qNInGb090tvDfzJQ4q1bFu+jNUOOGXSuJ4ZDnNm2e0yD2mtxS1PAw060KE/OmuRjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W4NCpip3BEScrVaZo5BvXXKAmeXcutLHJ4cmZrOd/fQ=;
	b=dNnVPCtOeKTPcdv4zePXpzIE6VZ8xXKyOyY4QuYoeeec+1xzBrwHAAv0Ii0PynFtNoUJ
	 OCwPAu00DxlT7UEJRmbJsI/Rmt2QJSarg7A3zgwGNiYa0jUb2MWFet1qmp5fG79N7M04R
	 t8C4KQlaIPuyiI5HcJjsb+iGcH273f2U1DWNiX1UlKwxnr7irNJeX9G6tDW/QjuUabQgM
	 4Qki4H47noPVkB93XR6PDgEz3cNv48tHXDW4zw1y15Jta9xA7LsMcd49PwMvoocgxnQUR
	 +5Aa680DT+36JTfXR94CwBtXal09S5Rvo/lQrtwg5aOumK0oqfKHyRTs49cCaBcLCVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdFNdjem;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D0B606A31C;
	Wed, 18 Nov 2026 22:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdFNdjem
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8831F000C4;
	Wed, 18 Nov 2026 22:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039587;
	bh=W4NCpip3BEScrVaZo5BvXXKAmeXcutLHJ4cmZrOd/fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdFNdjemymU6W0IpQM4Fvi0df7rse0h7RGEzXd1WGMzeiILDnEIhsv3RDokuJe7Cr
	 oQv8dlEUXUadFzM6YzvIGRbB/2zfU9JCj2uITgSBq/pqhSmba67e2/u+8Ft1sL1/6P
	 szZotVO/Zyq3ZuQGYuptm2z2BRBt7Gth/ODBrUkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2155/3318] dmaengine: fsl_raid: zero CF descriptor pool allocations
Date: Wed, 18 Nov 2026 15:46:17 +0100
Message-ID: <20261118150426.678308600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6c1db188b6525..142d1aaff7244 100644
--- a/drivers/dma/fsl_raid.c
+++ b/drivers/dma/fsl_raid.c
@@ -305,8 +305,8 @@ static struct fsl_re_desc *fsl_re_chan_alloc_desc(struct fsl_re_chan *re_chan,
 		if (!desc)
 			return NULL;
 
-		cf = dma_pool_alloc(re_chan->re_dev->cf_desc_pool, GFP_NOWAIT,
-				    &paddr);
+		cf = dma_pool_zalloc(re_chan->re_dev->cf_desc_pool, GFP_NOWAIT,
+				     &paddr);
 		if (!cf) {
 			kfree(desc);
 			return NULL;
@@ -594,8 +594,8 @@ static int fsl_re_alloc_chan_resources(struct dma_chan *chan)
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



