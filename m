Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5309029B795;
	Sat, 17 Oct 2026 16:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254774; cv=none; b=O7bQBjcq9UL3LsrodDFMOU/FJ/9FxVpoXmlNru9QAFDfwPpIcGUYmnqtOmf8gFtLUdxnWEvvfV5UmlgRY84D99VfS5tKTjgqjIp95TbM6b56/g239gEScpkS0KeaS/MtZaqOM+ubiEJOddwCmsV7nflPqoCa0YAsBltswOAU2Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254774; c=relaxed/simple;
	bh=TQYQNA7HfEgEP49+gKsCioVNm80b7oWc6zIiwH71ODE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNHXbGeIMhqEXW25w0vrzTd8QPr5p29M5UTdnPMbu5YK9u0SPl41Q53fiDsiICALl/jd4vwD7NZ8A/A8VPFP6Zr3+lGMx+5jODLOTq8YB2+ailAVBW78Lh0eEfVxmxpxOk8vppyqROd9XiKb15yF1hl8hRZDk8k7DlvjF4PuJmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFPq1PG5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFPq1PG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A041F000C4;
	Sat, 17 Oct 2026 16:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254773;
	bh=amveonLik3+wC4aERq5P0bFbwMDnpPslUKqr1IdAbfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uFPq1PG56HPo9KlqPUUgsBYmzJNEBYTJLS2JDHgNzpuboR6eU4lCW7zDo8437Q/Ex
	 eza97Cjoh4aci1BWDVji+yCbJubY5wu+FtRYSsT0p4dGx88WMRly7UISdHS32Qm9lT
	 xNsGHkNrxAJcnMau0Y9CdUnY+z7+4jijQv1uikNo=
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
Subject: [PATCH 6.12 555/869] NTB: core: Add .get_dma_dev() callback to ntb_dev_ops
Date: Sat, 17 Oct 2026 17:56:36 +0200
Message-ID: <20261017160051.314074299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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



