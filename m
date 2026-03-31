Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592C44218B4;
	Tue, 31 Mar 2026 16:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974667; cv=none; b=h6dypROK2h3jlY+fUY9QwLr6uFJ4I//GzexBxxfgKEoxAQN/ruhwreDIcqvSnyq/bnbBm9ZNbV33QRbXfTQrmLZPxjEqH3kJFomB5ktWJd+ePyL6rusxPouTiiTLNzYbD+f3TSHgiMPz/aNNzdYo7lN4SKMY7P3gq19tCEcvjxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974667; c=relaxed/simple;
	bh=ULerxe3B3T16OSioGAOQCOb3U7fS/mN/ZP1l3PhOzgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekkMX/nWmnWUEfyahT28FhvOEgsSaG9KHsK5R+PP3cq5XuQvrFtHVuewt6JaaRCd5l07uJlWvp9LG4KdrGAiIyfcHboc9+/iMuYYKbpBBjfOF62Q3i+GvdCFXayPYhSfaR1AOoPDtP24P+EXMLwN1JFgJIpxcK0OPf+AcDAcffM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0WxzSOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0WxzSOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29F9C19423;
	Tue, 31 Mar 2026 16:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974667;
	bh=ULerxe3B3T16OSioGAOQCOb3U7fS/mN/ZP1l3PhOzgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0WxzSOz0T+u+FvrZEeuKCf0ti5RLXYeXwx08Wn24ouR1tDK+Y5L3FyBYLW2ZKf2u
	 6y2dF0bAQNiqSe6J8ZmPE2q0vIZ30C8P4qkLYCY/1nd8RYvFQznpgT++P6WKyf0dN4
	 A3M7kMDQbsazaNDqtmBGl0oGFJs9fmM+vaslg8m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/175] dmaengine: idxd: Fix freeing the allocated ida too late
Date: Tue, 31 Mar 2026 18:22:37 +0200
Message-ID: <20260331161736.150357196@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit c311f5e9248471a950f0a524c2fd736414d98900 ]

It can happen that when the cdev .release() is called, the driver
already called ida_destroy(). Move ida_free() to the _del() path.

We see with DEBUG_KOBJECT_RELEASE enabled and forcing an early PCI
unbind.

Fixes: 04922b7445a1 ("dmaengine: idxd: fix cdev setup and free device lifetime issues")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-9-7ed70658a9d1@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 20d380524f4ee..5ded4a0887bc8 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -161,11 +161,7 @@ static struct device_type idxd_cdev_file_type = {
 static void idxd_cdev_dev_release(struct device *dev)
 {
 	struct idxd_cdev *idxd_cdev = dev_to_cdev(dev);
-	struct idxd_cdev_context *cdev_ctx;
-	struct idxd_wq *wq = idxd_cdev->wq;
 
-	cdev_ctx = &ictx[wq->idxd->data->type];
-	ida_free(&cdev_ctx->minor_ida, idxd_cdev->minor);
 	kfree(idxd_cdev);
 }
 
@@ -585,11 +581,15 @@ int idxd_wq_add_cdev(struct idxd_wq *wq)
 
 void idxd_wq_del_cdev(struct idxd_wq *wq)
 {
+	struct idxd_cdev_context *cdev_ctx;
 	struct idxd_cdev *idxd_cdev;
 
 	idxd_cdev = wq->idxd_cdev;
 	wq->idxd_cdev = NULL;
 	cdev_device_del(&idxd_cdev->cdev, cdev_dev(idxd_cdev));
+
+	cdev_ctx = &ictx[wq->idxd->data->type];
+	ida_free(&cdev_ctx->minor_ida, idxd_cdev->minor);
 	put_device(cdev_dev(idxd_cdev));
 }
 
-- 
2.53.0



