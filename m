Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061587;
	b=aEFAYCmNAz6Fpdn17HrEyVDR+YdxSIQtRctuLmyUxGgoal9fl6TeelXfqrvPAqUgd6Xm
	 XKYr80gkhTsTZdX19NjZni8YOYBnbLk6RmFDu84Za8tqr82GKcTMJTmMJOQRE1Vt8w7mS
	 xYiYd9l95o9edVftm/kzZb/z/PUHyxaOlcZvRlAhDZx/kW54duq6OfGDktDELyfUb2afj
	 LD7QKjN+pRhU9ByF35xtqcRMb3ebpLeXqnTBWoiWyH2GioD7c/c0Vuoxhb46UNFIQiVPH
	 +2cDP/xlDZZeNACBJS/SaKINeIYBVhzZGjVbca5oiWbKsO6w/PG9A82HDx+LQdRHiEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gLTxEwvQUrtX0aHjWc0jhAqJLD52YhXeYM8n3hiiF8U=;
	b=SASEsfqOrJJflSaCYj9t3iQb8qGgPARlsL+ZBlblnITFkomFis4cMdVMMlyx3YOtFiTi
	 pXSnng0MLXMKHh6ZHqGJ92Ir/d42dd48jpipeYruNCtBSl1KVe+INbhO4zTAbDajResss
	 ffUQH2fa5bLeOvBG70DcrIwDkT8WGr8ggWGWVcNxdglwJ3mkrqJQrpzp0CRWQHYp8j+vN
	 T+/XxFUVMBzk0v7W9graKRPsl9Pr3JXvrO3cMJ+BKEEjH4rhL3gbltDCim8+T/yDfxfOy
	 BUWNAUhl0+BdHAKXHQCFBER3VAKb+Tx9djqxO1Tyr4IgUrYoNMtUX0KFv2+pQvNDKjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rLSSWVla;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70864606A33B;
	Thu, 19 Nov 2026 04:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rLSSWVla
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BDF1F000C4;
	Thu, 19 Nov 2026 04:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061587;
	bh=gLTxEwvQUrtX0aHjWc0jhAqJLD52YhXeYM8n3hiiF8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rLSSWVlazWCMmhXz6sgPElruj/iFzWHGjGfYDil5WgO+JBP5rolbvsslbN0YABHpv
	 mY9tDM+TdwbrLUcB35335B8Il9kaoBsu1zqrDZUvaRaL7LUW8XKzvaI5kFB29WUZTY
	 q54zMzX+9CC9EohyBBG4FaXNTbZa5YRZC0LSusFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1607/1848] nvme: tcp: split controller bringup handling
Date: Wed, 18 Nov 2026 16:00:45 +0100
Message-ID: <20261118150026.823859365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d61a90b9bbb0b..306c13dec74a5 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2613,7 +2613,7 @@ nvme_tcp_existing_controller(struct nvmf_ctrl_options *opts)
 	return found;
 }
 
-static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
+static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 		struct nvmf_ctrl_options *opts)
 {
 	struct nvme_tcp_ctrl *ctrl;
@@ -2679,6 +2679,24 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
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
@@ -2704,11 +2722,6 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
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



