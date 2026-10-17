Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02673C10AC;
	Sat, 17 Oct 2026 17:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259544; cv=none; b=D1aGIlBChl3GPsfSB6CitSoPtXjxW8ib8R3d7Zok70BtIGRpZDnYagdexsF3OU8EQ7vP6etmvtayUmgN6qDb5tBiuf9IIGbWykvpDPAgN0fvjRZ+6P/qHBp88EKF6lLYn2+W4m8jNkcD9ExuyCbOR6WVBACIJGCWAvGjQh9TslM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259544; c=relaxed/simple;
	bh=xnsqIXuiRPDlIkY7idoo8Ml5+zLzoyts/EA18IhZUCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9hbI3WAPZsslU5iEkop1ZH/D1ao+R1fHMSwegz2UxGQiAps1ey3jAlYf2t+pPp8Pum2JSbRT2Ccqhqn7T3eWGvE+qM0HHtDXcjb5X6lrE19MV3mPPDAfaNl/w7muw/Mqwh4+BUOieP1+81SzrPBcQy1oye8GJ5pXSPPow5qhMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIXmqQG2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIXmqQG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D297F1F000C5;
	Sat, 17 Oct 2026 17:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259542;
	bh=Lj31FFEezYM3KDfpkOiHTh2E73CMa7d7VvJtpjoJ2SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YIXmqQG2bIjo7u3vBZSPUrOaAmhMwHJpOG2ygTLeKzoSMkurM3ajvRZd7ZsQAHS1y
	 CgutQRgj2c7bCwaoQqn4HX78m/0nfyurqJ9STAsU3zAdUT9j8zNFSWDZ6UFSEhuEmN
	 MKQyLSpB9NC2Tw4DZFcyLB3I/LPO55v4/SmU1Uhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1250/1674] NTB: core: Add .get_dma_dev() callback to ntb_dev_ops
Date: Sat, 17 Oct 2026 17:58:42 +0200
Message-ID: <20261017160503.223141812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 362a4549f2acfb03390ddfcd91041e65a11a739f ]

Some NTB implementations are backed by a PCI function that is not the right
struct device to use with DMA API helpers (e.g. due to IOMMU topology, or
because the NTB device is virtual).

Add an optional .get_dma_dev() callback to struct ntb_dev_ops and provide a
helper, ntb_get_dma_dev(), so NTB clients can use the appropriate struct
device for DMA allocations and mappings.

If the callback is not implemented, ntb_get_dma_dev() returns the current
default (ntb->dev.parent). Drivers that implement .get_dma_dev() must
return a non-NULL device.

Suggested-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: format doc]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260306031443.1911860-2-den@valinux.co.jp
Stable-dep-of: da6d997ac556 ("ntb: Store original DMA address for future release")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ntb.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/ntb.h b/include/linux/ntb.h
index 191b524e5c0dc..5c29e904a9c52 100644
--- a/include/linux/ntb.h
+++ b/include/linux/ntb.h
@@ -256,6 +256,7 @@ static inline int ntb_ctx_ops_is_valid(const struct ntb_ctx_ops *ops)
  * @msg_clear_mask:	See ntb_msg_clear_mask().
  * @msg_read:		See ntb_msg_read().
  * @peer_msg_write:	See ntb_peer_msg_write().
+ * @get_dma_dev:	See ntb_get_dma_dev().
  */
 struct ntb_dev_ops {
 	int (*port_number)(struct ntb_dev *ntb);
@@ -329,6 +330,7 @@ struct ntb_dev_ops {
 	int (*msg_clear_mask)(struct ntb_dev *ntb, u64 mask_bits);
 	u32 (*msg_read)(struct ntb_dev *ntb, int *pidx, int midx);
 	int (*peer_msg_write)(struct ntb_dev *ntb, int pidx, int midx, u32 msg);
+	struct device *(*get_dma_dev)(struct ntb_dev *ntb);
 };
 
 static inline int ntb_dev_ops_is_valid(const struct ntb_dev_ops *ops)
@@ -391,6 +393,8 @@ static inline int ntb_dev_ops_is_valid(const struct ntb_dev_ops *ops)
 		/* !ops->msg_clear_mask == !ops->msg_count	&& */
 		!ops->msg_read == !ops->msg_count		&&
 		!ops->peer_msg_write == !ops->msg_count		&&
+
+		/* ops->get_dma_dev is optional */
 		1;
 }
 
@@ -1563,6 +1567,26 @@ static inline int ntb_peer_msg_write(struct ntb_dev *ntb, int pidx, int midx,
 	return ntb->ops->peer_msg_write(ntb, pidx, midx, msg);
 }
 
+/**
+ * ntb_get_dma_dev() - get the device to use for DMA allocations/mappings
+ * @ntb:	NTB device context.
+ *
+ * Return a struct device suitable for DMA API allocations and mappings.
+ * This is typically the parent of the NTB device, but may be overridden by a
+ * driver by implementing .get_dma_dev().
+ *
+ * Drivers that implement .get_dma_dev() must return a non-NULL pointer.
+ *
+ * Return: device pointer to use for DMA operations.
+ */
+static inline struct device *ntb_get_dma_dev(struct ntb_dev *ntb)
+{
+	if (!ntb->ops->get_dma_dev)
+		return ntb->dev.parent;
+
+	return ntb->ops->get_dma_dev(ntb);
+}
+
 /**
  * ntb_peer_resource_idx() - get a resource index for a given peer idx
  * @ntb:	NTB device context.
-- 
2.53.0



