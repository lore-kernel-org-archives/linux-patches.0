Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6374225A357;
	Wed, 25 Feb 2026 01:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983785; cv=none; b=D0szg1ap6VkbZTErJvkE+DbeLim2Qr7RySSW4KmqhLQBg98D/k8z7WETFBuDTsb5OAyZuc81tdeP9u8EeBbFVUO362wubtnsNH3UpjXFc0NP/oIgwJbJ2cy1nZ/af13ZjO0r0oawlg5+U1Pg8bZ3JQDcT1dCvpGRYG6pUm902wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983785; c=relaxed/simple;
	bh=5c9DwKiB3v0CcUTHn8YlsYkfn2qAGZKIKfQt4mBtB+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPTAywBHTwxU1jvKHMHnwCCOE5ur19CjoBXoxi9dydXGCo9lTGcgnSDe3mIMjSG2g47DjOGPkASK1wGcghJO7LV0qkV+EobtMN2CNZEemcLZLPgLJgiFczDUcGObX5mwij/mVfrwjOxkO7FUd5nSHH1+D9IL/2zhCvPUb0IHeXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAsMRhQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAsMRhQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D79DC116D0;
	Wed, 25 Feb 2026 01:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983785;
	bh=5c9DwKiB3v0CcUTHn8YlsYkfn2qAGZKIKfQt4mBtB+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAsMRhQn0rXGcCbZ8Uv62w8T4Z+Qx7lQc6irJ//bV1sMuFwb0N6dtflnAEGxZ5YDf
	 xUFCS3l9JexOF504biDI7vDs3yr2FWRqWEjat7gp3R22RK4zjxMg255pFNMeEr/msq
	 n+828pdUiQWbWYzQo8cL0WGxANGiOTYD+Mjzbu3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/641] crypto: octeontx - fix dma_free_coherent() size
Date: Tue, 24 Feb 2026 17:16:39 -0800
Message-ID: <20260225012350.835757277@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 624a6760bf8464965c17c8df10b40b557eaa3002 ]

The size of the buffer in alloc_command_queues() is
curr->size + OTX_CPT_NEXT_CHUNK_PTR_SIZE, so used that length for
dma_free_coherent().

Fixes: 10b4f09491bf ("crypto: marvell - add the Virtual Function driver for CPT")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
index 88a41d1ca5f64..6c0bfb3ea1c9f 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
@@ -168,7 +168,8 @@ static void free_command_queues(struct otx_cptvf *cptvf,
 			chunk = list_first_entry(&cqinfo->queue[i].chead,
 					struct otx_cpt_cmd_chunk, nextchunk);
 
-			dma_free_coherent(&pdev->dev, chunk->size,
+			dma_free_coherent(&pdev->dev,
+					  chunk->size + OTX_CPT_NEXT_CHUNK_PTR_SIZE,
 					  chunk->head,
 					  chunk->dma_addr);
 			chunk->head = NULL;
-- 
2.51.0



