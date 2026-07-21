Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7C846DFF5;
	Tue, 21 Jul 2026 18:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657158; cv=none; b=Re2BTFnbeJe+tqUg0+SnHfh6o8nC+QNukgvxd3qmz0rEewxEl+ikrXCfkZl2YBXjs8NcomG1xAQSApmHHogdoR1YyamViCV+pvsN4PpYCiI2Qod1+ROC9jlcz26i8UlgRvMZd+jzvS7WBZ8N+RTYzqA8Z3QuqGWoOtqugaURHFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657158; c=relaxed/simple;
	bh=1bk7WYuB5qMafXeucb04Ejf07emYT3Hhs1Mpup9t3MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V9GOSO+5ieY+FA2ywTFAElORfq3KfKTUqulKvllHHdtqCMigCO5cUxCaa8qOGngC3wnRTzJ8jXuvqFDaqNim2ASJjn0SAo/jbtZAM61wkQZdrR2J7gRKxEgx50yBbgw24Y8QK0jP5Ge6fRnFz86e79RrFD2KV7QPc2QkWtf1FlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pv9sqa/b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pv9sqa/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280981F000E9;
	Tue, 21 Jul 2026 18:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657157;
	bh=xjPtoHgD5+0t6Q4SHsdP3vFb26mDO5Wh1K+agps1Ktg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pv9sqa/bJhf7JWWA0/ypQ2TfuhGrNuRfELiMWiRZEMiGme3wF1UIkThFSYjudcLZd
	 KWptY+VBV7qUeHdNjlce6+TQwhARjToXGJuJAt6uZGkLujtosv7glrho1sTV8IrDz2
	 +0QnzKZQfjNZi9EfI+n25pwEdGj3z/EP21i5HaJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0660/1611] dmaengine: dma-axi-dmac: Properly free struct axi_dmac_desc
Date: Tue, 21 Jul 2026 17:12:56 +0200
Message-ID: <20260721152530.230349172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 4910ce1b3b35687bb2a5e742c4bfbea3c647c980 ]

Use axi_dmac_free_desc() to free fully the descriptor at fail path when
call axi_dmac_alloc_desc() in axi_dmac_prep_peripheral_dma_vec().

Fixes: 74609e568670 ("dmaengine: dma-axi-dmac: Implement device_prep_peripheral_dma_vec")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260424-dma-dmac-handle-vunmap-v4-2-90f43412fdc0@analog.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dma-axi-dmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dma-axi-dmac.c b/drivers/dma/dma-axi-dmac.c
index 0f25f6d8ae71fa..a04b09b8cd6f8e 100644
--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -643,7 +643,7 @@ axi_dmac_prep_peripheral_dma_vec(struct dma_chan *c, const struct dma_vec *vecs,
 	for (i = 0; i < nb; i++) {
 		if (!axi_dmac_check_addr(chan, vecs[i].addr) ||
 		    !axi_dmac_check_len(chan, vecs[i].len)) {
-			kfree(desc);
+			axi_dmac_free_desc(desc);
 			return NULL;
 		}
 
-- 
2.53.0



