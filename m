Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049655;
	b=sAzJas5o6kk+Vd2pSw0JpL0pw+m0UKi7x23HXrDasn4BdCJBMKFBPrzPqpuXSBy1DA8+
	 O6VYddexYQosS6FwAbCrUPZdCzQwVUyvEHGH8UiPljx8rPtWYQZvlQF6SRkNXgH9vz8uO
	 CFe03/xaq/EU34iq5NITpC4ZrRUE0tniI53Zk4cQ+3Smk0udglHyvzX/H6mVlwwU1M9u/
	 w1wuCOvh5z55jM5jYZXjqO0LGgxO0dGRSg2asr+kzWFHAux7FHA/tN9krqIdj8FyNu9Wl
	 8XUOnOOr6x2Tzn2AgiM2nT0aFkGp+Dpw5pT+tWCE0wasypuahq/xOulAQVuRSPRyIVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GKFiA5fNLMkInFHlutQ3bHhW6fvuUGmjL13weXLurYw=;
	b=BaI6CU50UcD3ruxEQGDbL1GcKhqlPXU1ASWG92GGvI9IssCT6XIIhEfRzTh4JBuhNNkC
	 5ZcZk4/33x7kFwGGrCad/DeImdbuGcNRNa40gjTVlJVSvtpK0W7Mnhl2pHwqcg4Caq/mq
	 TGuhi5ZBL6Fp8vsq/UKYaJK4ufK0fZiRGcYLVkR/IYo66YXcfnzff38Eqs3pqC7tNtzQ6
	 GLSuNna0nGldmTuxU3Ages7MpkoRWmNt4TND0XAXILtXBNAOMcUEYW7zrUYRIOHWidSRg
	 8eUdQ0AVFxqroxj1IdzotBCAZvidogW8JXvCamb3TxzHDSD+04qkkoHBpXyWdeScinw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2VCIp+Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAF7606A31C;
	Thu, 19 Nov 2026 00:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2VCIp+Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8CC1F000C4;
	Thu, 19 Nov 2026 00:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049655;
	bh=GKFiA5fNLMkInFHlutQ3bHhW6fvuUGmjL13weXLurYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2VCIp+YAYPSwsGhu+9haK9ltvZHxQSvWlbp/gAPfGGP4paJvDSHkv67QfL+lZ2JD
	 Ps1EYdSFr6zpn0ASOFsMWT6GebjwLJDcQgOKzLB/yCaX1201gtJ8xhlUP0sndJYW6d
	 QuUY752CCg82ZetEjWE1trBOz5lgPeslDbOJ23/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2429/2857] nvme: tcp: split controller bringup handling
Date: Wed, 18 Nov 2026 15:57:43 +0100
Message-ID: <20261118150329.024219029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6dea467719256..883fe959d5507 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2714,7 +2714,7 @@ nvme_tcp_existing_controller(struct nvmf_ctrl_options *opts)
 	return found;
 }
 
-static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
+static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 		struct nvmf_ctrl_options *opts)
 {
 	struct nvme_tcp_ctrl *ctrl;
@@ -2790,6 +2790,24 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
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
@@ -2815,11 +2833,6 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
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



