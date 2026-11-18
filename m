Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048115;
	b=MKNLYn9HNNt+bgaQceF1L+epVXiN5crS1hlb3XEhIlI/+YdRfho85Vplv+WbsbcyLIY5
	 HMo8lo6ia3fD8DUleV8vzJsuZEcwPOnRgF/DeZdeeWNANIW9HhBqhlzNhD86VjGKEd/Q2
	 LlPlpio2sqbculZeTYrKWEKqidsqKuJpXTxi02uwHIopNgD1BfKeUS/vtLUOKy231tSZ5
	 MSUY7PKQM00X0TTsRudF+IQjQdlDl725oQH/D1q9AIyFlJ3ugxRvZ9c6WQhylG0qsi+K3
	 UxSPRBkiFHid5cyVOllNZOk187IP7/bGsa3qaepJmgtf0cUoSQ6OI7LXmXVs8NhOppA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cuWBOQOueqt4b+Fw7vJRDMx1KiHyQ19zpApbSUiJnaU=;
	b=lMoMJVsUvhPwlad3xoczN3NABvlP/T2ThazQhHDuI70ylYVxvsexnuzGz4y9L9Nf63re
	 4KYqL9ZjCRNBSnxLU7+F1o2JQViO5vsvZFhqbLVPAYXPWYLfKb3FOHnQ7kG3HEfDwhHkX
	 OfAtTKsrygyPBpdzXZ6m7+l+g+fGpuPkYcGmVZKAr/irkkBKxIP7wMkGbAsIN7Mq3S9Ht
	 xbF2VE3muarYll+5Ef0sw3sGQGBVHdkOOJ0BeDUuKgQIk+jqGRaiU5h2hm+GTOGbC0ZQS
	 v5XCZOu46l52EauKcQ+crBOAbW3vTR26vLsG+MnZbE4ATmz4WOna2rzlEW4beBdXlPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XcCE5GFW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1221606A33A;
	Thu, 19 Nov 2026 00:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XcCE5GFW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DDA1F000C4;
	Thu, 19 Nov 2026 00:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048115;
	bh=cuWBOQOueqt4b+Fw7vJRDMx1KiHyQ19zpApbSUiJnaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XcCE5GFWXhWb+gKXIM2wZ9V2d9ias0s0lAt4oNnUwwCcMxxuzxGuNNwm8XtAj0hCZ
	 tqYQeS68w48n5IwYood6yoUM9TXUO0mNXgq5QidUDxZ1zUzYS7ErGVLphSlj9PFCp/
	 sJgZw5fqFPxV1Bc3cRVTvmtpYTtZNdeToHRCLidI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1880/2857] dmaengine: fsl_raid: zero CF descriptor pool allocations
Date: Wed, 18 Nov 2026 15:48:34 +0100
Message-ID: <20261118150308.926487402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



