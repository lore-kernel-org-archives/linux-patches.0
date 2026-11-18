Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060492;
	b=QuBB++RvZMejaMCuqRnwZOaOAwqj4Wtp1Q8yOoxTNra5+K1BJt9Cl1tIvAjGUY+n65CD
	 xpwlD7/S9rSOp9ISCxVksX5k4CAFIL0IEw+GuV3TUk3quHX/imoJaPfj4tjls1vfBkLoH
	 eg3SZ1QLaxZEZqRdLXUaRS5KAqBvSztiT49byYK/k6Y70KrBp278CPQWqbvulYPuj0915
	 NHZNqNNRxMLUGktJJrfF/0cXUxoUlf5Sqg2Xaht4DnyqQCqQZxucr4f9POw7CRiBe54Hl
	 aF5mtRh5SX3u6UfKIGdsaidf0I5/IP6jMkTA8YmJG8wyr8t2Z0r49glSW4Bq6NdUrVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wc2r61kTWPAJ4FkzlqCuIfPV8AKOcORYy/mZklNJWtw=;
	b=erjqkn7wIeHEmAgpsgs0RnFObxBUcLiteAu7d6w0jisMPgiHxB2A0hDesr0fF0CmV3uu
	 +zTVewBXVs/CHJPm+gs2OyRtagN1mIKPjUUYAiE4AZeuNSSoG2KQXPwN79pmW3lJipndF
	 FcLOSG8r0HGDAM6zTJsEc+qZRChmNnKKeYz8UFFJAJLnZQqgRWSHzgAGOxSOi6eOJChpq
	 7s+L+BtR86JBJAm1uU8LrovmP0Fqk0tq06ywyW6bhsrg6lVNvaVk4aEO47B1kZKN6Wnnt
	 aPyUjAY7cf3VUlfnRWEqs3w+U8ax4s99GX0qJyafzzdMIKB0lFoBdPyyt//Hefc8xAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLKQsZ32;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FE4606A320;
	Thu, 19 Nov 2026 03:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLKQsZ32
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8BD1F000C4;
	Thu, 19 Nov 2026 03:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060492;
	bh=wc2r61kTWPAJ4FkzlqCuIfPV8AKOcORYy/mZklNJWtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLKQsZ32T1HF84xuz9s9a9Zkx2QMYCjaynkolcy0wsarS/1d7TCTe3cOf/ltJf2te
	 n0zoV6GksFJRqHM4kDb+dmyVza/slX9J6Eeh2L+KmCwSf9xPgFM72L9AQzYojCSJ6F
	 gyCoHL1dCycrYSnUK5iuNNVmEv0tHmSd855WkDWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1218/1848] dmaengine: fsl_raid: zero CF descriptor pool allocations
Date: Wed, 18 Nov 2026 15:54:16 +0100
Message-ID: <20261118150010.955319949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



