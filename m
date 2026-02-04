Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4F4270540;
	Wed,  4 Feb 2026 15:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217241; cv=none; b=N9V6J+dXakBB9yqnDHoX0JTLxr3Z8N9WXY4XS++H6g3RN4+n48fZxWtgmUMNNYvbBR3JCSX0uBL2PS24QnrIW2214TGCEN4UgAA+4UC8yefnfKPj93m9nMXGl+lQD7/Ql0n3vtVHNJgTYVfeEeSZ8KSrzlc7TTNtTpiNd5JXf+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217241; c=relaxed/simple;
	bh=kHUZ+2ReShk68M2bMWFGlFUdot73qRTYGOq4tPHG6F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMnIdpSL0XwCOtWgioSuTpmeYyrTsiyZ6I7aW6LqMzwwb++xQ67oRPpqAyCIF94jOgQnNUVjI5CRHXyY/zcN2PJ8BwRJ3oz+7L46jU1sBsr6L4KTVcvdJbRHQJ2Rs7aVNzGdSA+JJEKcdY36APpFSum3j3n03ZTUA7qFS8nws2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUWu+jwE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUWu+jwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482C7C4CEF7;
	Wed,  4 Feb 2026 15:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217240;
	bh=kHUZ+2ReShk68M2bMWFGlFUdot73qRTYGOq4tPHG6F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUWu+jwEa1XQ6Jdvw/ERbGMMxwxe42P2PF28QpnF95ZiMFLJOSuo/VInEghAIef4F
	 AqXkVLWaN2telaVRBqXDUCtKw4jgkFNxbgzkzlYwZ3zuJcnotcICujxOXQ/rpK104s
	 3gErNYGj/ruooOpZp+1ZI+28bILSJMv8iBF8a6hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
	Johan Hovold <johan@kernel.org>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/206] dmaengine: stm32: dmamux: fix OF node leak on route allocation failure
Date: Wed,  4 Feb 2026 15:39:55 +0100
Message-ID: <20260204143904.112227324@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit b1b590a590af13ded598e70f0b72bc1e515787a1 ]

Make sure to drop the reference taken to the DMA master OF node also on
late route allocation failures.

Fixes: df7e762db5f6 ("dmaengine: Add STM32 DMAMUX driver")
Cc: stable@vger.kernel.org      # 4.15
Cc: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://patch.msgid.link/20251117161258.10679-12-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/stm32-dmamux.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/stm32-dmamux.c
+++ b/drivers/dma/stm32-dmamux.c
@@ -140,7 +140,7 @@ static void *stm32_dmamux_route_allocate
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
 		spin_unlock_irqrestore(&dmamux->lock, flags);
-		goto error;
+		goto err_put_dma_spec_np;
 	}
 	spin_unlock_irqrestore(&dmamux->lock, flags);
 
@@ -160,6 +160,8 @@ static void *stm32_dmamux_route_allocate
 
 	return mux;
 
+err_put_dma_spec_np:
+	of_node_put(dma_spec->np);
 error:
 	clear_bit(mux->chan_id, dmamux->dma_inuse);
 


