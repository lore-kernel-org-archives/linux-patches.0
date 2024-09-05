Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAEF18D65E;
	Thu,  5 Sep 2024 09:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530298; cv=none; b=R+s9TelK7BAs2grpyaoaxSKZtMz4+5CZqnt4RDy32rG9ar8YIR4LgPX90PVdESJ/mDcAYkyYoS5vqt5sFG1qKBHnKErwHJJQnIoVHWCuSTbmYFY8jhVQxSrHeIm76pC+eVYh9DV07voBtFdGLDsH1jhHk5iIqxEFpmYSfFr74jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530298; c=relaxed/simple;
	bh=uDPdmNjJOlOu7LWy/3yV2Q6eKcKnchaomhDLCWE3rOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPZmiCGZZjqrmLR2fA5rsVQ3RZ97v6XbvnADc9jZ8+8FiqUaO2ARmJjoHwWoi2HdmuYytxK82cYUDblJrT7/E5/gTyzi3goGJnHXkYjfYS72rO0gflYAxxurvz6E2dGx9BjJ1UeKRWBEiS09ymoqmLkyZ1ofEq3P0ctnxQeFXko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yovvXNwV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yovvXNwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F695C4CEC3;
	Thu,  5 Sep 2024 09:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530297;
	bh=uDPdmNjJOlOu7LWy/3yV2Q6eKcKnchaomhDLCWE3rOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yovvXNwVIVf18A4irmBRnsPXTGoQeb1e5H4mn1DAA3tKoUGmqSiMPynHWzYhuzsRb
	 5cusIyYvxTbAOOTnZ+N57CkFJ1b+nyMf/gWPbKEpdb0Xyy7NS3AqRTymBTA76JyLHu
	 y3tZ2inxDPbzb6s3DRJuF22XWGISFOJTOnG0iVf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Dautricourt <olivierdautricourt@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/132] dmaengine: altera-msgdma: properly free descriptor in msgdma_free_descriptor
Date: Thu,  5 Sep 2024 11:41:41 +0200
Message-ID: <20240905093726.659182427@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Dautricourt <olivierdautricourt@gmail.com>

[ Upstream commit 54e4ada1a4206f878e345ae01cf37347d803d1b1 ]

Remove list_del call in msgdma_chan_desc_cleanup, this should be the role
of msgdma_free_descriptor. In consequence replace list_add_tail with
list_move_tail in msgdma_free_descriptor.

This fixes the path:
   msgdma_free_chan_resources -> msgdma_free_descriptors ->
   msgdma_free_desc_list -> msgdma_free_descriptor

which does not correctly free the descriptors as first nodes were not
removed from the list.

Signed-off-by: Olivier Dautricourt <olivierdautricourt@gmail.com>
Tested-by: Olivier Dautricourt <olivierdautricourt@gmail.com>
Link: https://lore.kernel.org/r/20240608213216.25087-3-olivierdautricourt@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/altera-msgdma.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/dma/altera-msgdma.c b/drivers/dma/altera-msgdma.c
index 8c479a3676fc..711e3756a39a 100644
--- a/drivers/dma/altera-msgdma.c
+++ b/drivers/dma/altera-msgdma.c
@@ -233,7 +233,7 @@ static void msgdma_free_descriptor(struct msgdma_device *mdev,
 	struct msgdma_sw_desc *child, *next;
 
 	mdev->desc_free_cnt++;
-	list_add_tail(&desc->node, &mdev->free_list);
+	list_move_tail(&desc->node, &mdev->free_list);
 	list_for_each_entry_safe(child, next, &desc->tx_list, node) {
 		mdev->desc_free_cnt++;
 		list_move_tail(&child->node, &mdev->free_list);
@@ -588,8 +588,6 @@ static void msgdma_chan_desc_cleanup(struct msgdma_device *mdev)
 	list_for_each_entry_safe(desc, next, &mdev->done_list, node) {
 		struct dmaengine_desc_callback cb;
 
-		list_del(&desc->node);
-
 		dmaengine_desc_get_callback(&desc->async_tx, &cb);
 		if (dmaengine_desc_callback_valid(&cb)) {
 			spin_unlock_irqrestore(&mdev->lock, irqflags);
-- 
2.43.0



