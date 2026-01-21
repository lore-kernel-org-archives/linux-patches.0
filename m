Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665C63376B8;
	Wed, 21 Jan 2026 18:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019826; cv=none; b=dmQZJsdTYJitGH8tj7mm0S87jAsMzgAKVD/iFJd5RlWRHOw/+PwithDKtxP5VYiapyWhGvKabNDTAgAJi4LHY1uS29O9cNNZXMInIknz06Ye5MHtbylPKBgZeY3Aw9t44H8MybYpKXV13cPa9XCYH4eQV2sWjNitqg5ZIEXVIa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019826; c=relaxed/simple;
	bh=afAR2lIdsHvhN0tGaB75gvAB6fSI5JJpT4+x9Ofrp8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xy+QQDXzW+SaQ5EJCfRVLsXu51tsDfjAL4daPWELucwCu28+gihUvRFkEHqPDHCjZqjn9H30cIHdhNE4e+UqSJWd9SOWP0KBGrG+KUoYxMhyUDBVXv5AwER1/677BTlK+RDm/pO3dPnvcAiD1DqqxsvxbOKTvJsN/rxGoxVvuBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SbSpasut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SbSpasut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72A5C4CEF1;
	Wed, 21 Jan 2026 18:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019826;
	bh=afAR2lIdsHvhN0tGaB75gvAB6fSI5JJpT4+x9Ofrp8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SbSpasuttjunGJfzfgY7XAdAX5xLxqLpqkGPOmjd4S9EDDTYVMuFqBZMviAJCwKXI
	 lZTTFUSyt0io1Ch1s69cMeH/IFZ/Em2RFP4r3CYdY2+hRd2sF/jZGBqgli9F23QZiV
	 RwJVYkAJILCvLQHKxsO0Ri1Z3MHZTDV7r801M1dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
	Johan Hovold <johan@kernel.org>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 118/139] dmaengine: stm32: dmamux: fix OF node leak on route allocation failure
Date: Wed, 21 Jan 2026 19:16:06 +0100
Message-ID: <20260121181415.698224230@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit b1b590a590af13ded598e70f0b72bc1e515787a1 upstream.

Make sure to drop the reference taken to the DMA master OF node also on
late route allocation failures.

Fixes: df7e762db5f6 ("dmaengine: Add STM32 DMAMUX driver")
Cc: stable@vger.kernel.org      # 4.15
Cc: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://patch.msgid.link/20251117161258.10679-12-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/stm32/stm32-dmamux.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/stm32/stm32-dmamux.c
+++ b/drivers/dma/stm32/stm32-dmamux.c
@@ -143,7 +143,7 @@ static void *stm32_dmamux_route_allocate
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
 		spin_unlock_irqrestore(&dmamux->lock, flags);
-		goto error;
+		goto err_put_dma_spec_np;
 	}
 	spin_unlock_irqrestore(&dmamux->lock, flags);
 
@@ -165,6 +165,8 @@ static void *stm32_dmamux_route_allocate
 
 	return mux;
 
+err_put_dma_spec_np:
+	of_node_put(dma_spec->np);
 error:
 	clear_bit(mux->chan_id, dmamux->dma_inuse);
 


