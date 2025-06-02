Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BF021CC4F;
	Mon,  2 Jun 2025 14:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872910; cv=none; b=DMqKrjNYFsRjL/nHsbaNGN87XMljJeITe37ClNAXH0Hb0ZNCjof1YuoHQM2BVa76d9vpUD7k/D7bBUwDNniWaDxASbkZX3/yqOI6fhaO2nfUZJyhYPxwYujjCjS3qS1hpXZ8HK2bx5jnJldgeTihfceoTXnzrLMBCm1xWcJXr4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872910; c=relaxed/simple;
	bh=Fs4MIocid0kw2KCVsu/RJQe+PYcoyVQxureeutZ51Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZ8retsp1JfCRKhI2h+aXJ1sqb3pECwHKeetjVyISMX0vsFpsUcytgAIRELLHKD1J4u4NIpnVIQsMPKtxorPTAsGfhu2djRTmjRT0hMVDQWnr68TQ6RalrPB4VmvLH2W13Wme0w7Eb76ozeLHTHBGzxP8U9OUmPh5vF5eh0jNQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2RGvuwp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2RGvuwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A42C4CEEB;
	Mon,  2 Jun 2025 14:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872909;
	bh=Fs4MIocid0kw2KCVsu/RJQe+PYcoyVQxureeutZ51Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2RGvuwpzwzEW0fU8wsr/68SeWjmhPqIDG+FK84Wc6T+Xe51s4eUj16RoDAz1gvxh
	 CCo1DDrGB5IpbGK3E3Pc8a4CNnoF8Ie9tR+E8/d8P7cHGfQa8T8X6H6HJE/C7oB9II
	 QIJMU9uf3EUV6ulKTDwul8F92LlbbsTtBwxTYWYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purva Yeshi <purvayeshi550@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 35/55] dmaengine: idxd: cdev: Fix uninitialized use of sva in idxd_cdev_open
Date: Mon,  2 Jun 2025 15:47:52 +0200
Message-ID: <20250602134239.662345824@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Purva Yeshi <purvayeshi550@gmail.com>

[ Upstream commit 97994333de2b8062d2df4e6ce0dc65c2dc0f40dc ]

Fix Smatch-detected issue:
drivers/dma/idxd/cdev.c:321 idxd_cdev_open() error:
uninitialized symbol 'sva'.

'sva' pointer may be used uninitialized in error handling paths.
Specifically, if PASID support is enabled and iommu_sva_bind_device()
returns an error, the code jumps to the cleanup label and attempts to
call iommu_sva_unbind_device(sva) without ensuring that sva was
successfully assigned. This triggers a Smatch warning about an
uninitialized symbol.

Initialize sva to NULL at declaration and add a check using
IS_ERR_OR_NULL() before unbinding the device. This ensures the
function does not use an invalid or uninitialized pointer during
cleanup.

Signed-off-by: Purva Yeshi <purvayeshi550@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://lore.kernel.org/r/20250410110216.21592-1-purvayeshi550@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 22aa2bab3693c..19a58c4ecef3f 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -225,7 +225,7 @@ static int idxd_cdev_open(struct inode *inode, struct file *filp)
 	struct idxd_wq *wq;
 	struct device *dev, *fdev;
 	int rc = 0;
-	struct iommu_sva *sva;
+	struct iommu_sva *sva = NULL;
 	unsigned int pasid;
 	struct idxd_cdev *idxd_cdev;
 
@@ -322,7 +322,7 @@ static int idxd_cdev_open(struct inode *inode, struct file *filp)
 	if (device_user_pasid_enabled(idxd))
 		idxd_xa_pasid_remove(ctx);
 failed_get_pasid:
-	if (device_user_pasid_enabled(idxd))
+	if (device_user_pasid_enabled(idxd) && !IS_ERR_OR_NULL(sva))
 		iommu_sva_unbind_device(sva);
 failed:
 	mutex_unlock(&wq->wq_lock);
-- 
2.39.5



