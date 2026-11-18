Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056155;
	b=hOZyYGhBdgIb+HgJoA9YCRH/5DnDQaQFjFFJFFcVF+A5W9ULVRGTnbmKXBewGYb0pM4Q
	 Y44Wo6fiBD5nJHXIHFveg//jJqpSEk2/5Abf5EJyj/5zX/Nzu8rX3Yv0d6W6W95SLexFV
	 LQX8XvC+rTxwXrXYciR2ENP2exVYmP6EWfKUhqWiMwt74x8eZywWovCgGLqA/eOpzK1uu
	 tt6bFnKMniPfZ88ESqHt3yi/LA2qsvGcZQejtIqo1mu10Eh2udimEYdFbqkB1b8dgKdsQ
	 4ExAXEGSf+ApIbmgueTtLk7tPmkml8kIQ/vVDRMGw65h4lj20KAN+69qZlsZX2Boa0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=htEVvHgVysRZkNK9Wje/EOoCokWyr66PofyllPgSGGA=;
	b=lbp8dQSG/L81E6+i9rFFsEitXM8w40+3DsrOf/VA8J33pHLQ6BbQlER1Lv4730iNpyWi
	 92BfSxUKyy4bQI2/plbPNWfKsQ2E9NuTPj0u/rxlodnChecREuhwCwYOH11BpoVlG5jk+
	 YDsrpqTobR3+UfJB3Etfj3YjI2hpSMonZXwjXmWwQDq64TqIlKyjxhPRsY4XKsAk9ifn9
	 TS0srC+rafTg2Wi0w/mLKPn6+4gvGuzgZu+lmBdUpAg4AoW6VApdOuKc9kpbcPNVmSfIt
	 NNOs/ePBZXTcVRwaU8gCg/GnUpngcMUhgJoHvpSwWSAX2v9pKPAfBNciguf5AyjXydA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPrfDLHI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CD3606A31C;
	Thu, 19 Nov 2026 02:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPrfDLHI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB341F000C4;
	Thu, 19 Nov 2026 02:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056155;
	bh=htEVvHgVysRZkNK9Wje/EOoCokWyr66PofyllPgSGGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPrfDLHIDEk9+nxwgFCn2P2u/JiIFZu60sq74hCg6OkUCK3dkrXvICVc29+YR0NKI
	 sg9/6ifqtcZCMiPCGnoEpEjkdHc7pTXYR6Rf36eSCSUoLu8pVjJhS1FVdxM5Ni4/u0
	 ZwIFxTXbQPzmfG5iEmWBHLW+goIvb55lL7piJJ2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1886/2214] nvme: tcp: split controller bringup handling
Date: Wed, 18 Nov 2026 15:59:22 +0100
Message-ID: <20261118150126.674350411@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 10fd7fb676d71482b64bc61f5058b1011133f984 ]

Drivers must call nvme_uninit_ctrl after a successful nvme_init_ctrl.
Split the allocation side out to make the error handling boundary easier
to navigate. The nvme tcp driver's error handling had different returns
in the error goto label's, which harm readability.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 87a1ac965502 ("nvme-tcp: store and use the caller's network namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 98df67f1bff96..ff6bcc31163e1 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2627,7 +2627,7 @@ nvme_tcp_existing_controller(struct nvmf_ctrl_options *opts)
 	return found;
 }
 
-static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
+static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 		struct nvmf_ctrl_options *opts)
 {
 	struct nvme_tcp_ctrl *ctrl;
@@ -2703,6 +2703,24 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
 	if (ret)
 		goto out_kfree_queues;
 
+	return ctrl;
+out_kfree_queues:
+	kfree(ctrl->queues);
+out_free_ctrl:
+	kfree(ctrl);
+	return ERR_PTR(ret);
+}
+
+static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
+		struct nvmf_ctrl_options *opts)
+{
+	struct nvme_tcp_ctrl *ctrl;
+	int ret;
+
+	ctrl = nvme_tcp_alloc_ctrl(dev, opts);
+	if (IS_ERR(ctrl))
+		return ERR_CAST(ctrl);
+
 	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_CONNECTING)) {
 		WARN_ON_ONCE(1);
 		ret = -EINTR;
@@ -2728,11 +2746,6 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
 	if (ret > 0)
 		ret = -EIO;
 	return ERR_PTR(ret);
-out_kfree_queues:
-	kfree(ctrl->queues);
-out_free_ctrl:
-	kfree(ctrl);
-	return ERR_PTR(ret);
 }
 
 static struct nvmf_transport_ops nvme_tcp_transport = {
-- 
2.53.0



