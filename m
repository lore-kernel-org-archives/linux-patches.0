Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056035;
	b=HkSqk2cYl0cE+OAoOmRKC9MvdSChOA0djjPzOrirzPA+LL1wq8KvQ/4UsKNS+LWehmV8
	 3fHIfWqHtd8EvNEzRgZVz1j3ZQMaV+vvEh+EEKUaUfLYy3FwRQ7c0nuHNtd+5Kpyrxz1Q
	 awEpk8CUy6+M9e/Jvmy8bP8ns2Pbe1XDs0jgISH+iwhWSXNkiKK4YGdEzwuKvmY8HFw/S
	 fINzlufegMLnIxMkgGNajHfwNA6dOzCIjx7sCUtdiZjiRFQew22kGTzvRKLWHuRsgMIb/
	 7QE5gGwz5IWEI+Z5QzVkVpXKr23GBtoPjj9VSYcSTKF8TkVC/EyNGcnQu6ZEn8Jt/xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ve4R5kZHcLs/1fDbtuF10vE3KldOSaZjnlq3fniimUA=;
	b=OLu1Sn/gidz44kZfIOSrAaHlNoKAp8kt+vqNpnlkMXGSwqSMMEBwk1o4rs2pBJZsvR2s
	 zX5pCe7abInBThJGZ+uLsojZfByOHJK5bp+sy1vR1bJ4t63x/1fj2/NbHQtfzwnFVVnfV
	 egjxtf4+/y0zQdkzSlHg+9vvrk7qwmgBrq9031dxvnWjpWFF/6ZCN8upww94co38KtkIk
	 p7nvXU8wN/zdVGR5cpTVe+WWoXI81AyGSZSQvvbiUc4HWVImP/2qhyfx74UJEoO/hnb34
	 oYwd7hluRqEpPOwx9vJAzfHav8jqP2ovqIHpInfv3TWYCHJ3dL/0gE3r8Myob570QgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZB7ZG2uz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AF0606A320;
	Thu, 19 Nov 2026 02:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZB7ZG2uz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A871F000C4;
	Thu, 19 Nov 2026 02:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056035;
	bh=Ve4R5kZHcLs/1fDbtuF10vE3KldOSaZjnlq3fniimUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZB7ZG2uzx+datQXbLdszgML6ZzGzq2pPhYyMOGMsStTv2fUIvgonEGXgmpmn4ExVX
	 DR5utvzzQihJVYm2vDAsqHY/8GtFu3QgNKvHU10kiHnaUCPc4w7T+BTvAyBsMwyjis
	 OZw/ldvCrA4tZf6JtNPGIymSu7bBsJo22pRivfTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1843/2214] RDMA/mlx5: Cancel software CQ notifications before teardown
Date: Wed, 18 Nov 2026 15:58:39 +0100
Message-ID: <20261118150125.143633547@linuxfoundation.org>
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

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit a0ab2bb269e7fd8523f87950b91a42a36c7f8f2a ]

GSI completions queue notify_work to invoke the CQ completion handler.
CQ destruction drains hardware events and core polling, but does not
cancel this software notifier.

Fixes: 25361e02c448 ("IB/mlx5: Generate completions in software")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Link: https://patch.msgid.link/20261008141209.6923-1-prathameshdeshpande7@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index ff98fd80c03a7..cc37994ef924d 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1042,6 +1042,9 @@ int mlx5_ib_pre_destroy_cq(struct ib_cq *cq)
 	struct mlx5_ib_dev *dev = to_mdev(cq->device);
 	struct mlx5_ib_cq *mcq = to_mcq(cq);
 
+	if (!cq->uobject)
+		cancel_work_sync(&mcq->notify_work);
+
 	return mlx5_core_destroy_cq(dev->mdev, &mcq->mcq);
 }
 
-- 
2.53.0



