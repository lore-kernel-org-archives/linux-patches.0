Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622489;
	b=ob1CkJhTdMm9Qae/e0xXDLfI7SBA1Z7/sf4KXjNAZ++7VV9A7gq1nJdkItnS6uH/DT5C
	 5vtS7K6bQGXU5wvVr7k3Sjh0oOAU1TzSsmiHfCc+LuzzhdG9Bc5O2B/NacP3sLtgS+3Ja
	 iE3lpJWDrIJ918G8ZICiMt+2dhCbz2g8rYb5iNHU2JQi/QFc+P7kXzaMECrADFsqNzNO7
	 nz+Ra06S1gyXg9jLCYqsldS6EZAD00PnqraC5Hd/8kMvQ8kgjY61JDkR1uhIdGpspJqpK
	 JGpwja8VV7q0jIJlQcj5sYh3XDurld2LyTIDoDR16NHkl1sv8JMHIV0VT5jo/OAVY0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6A0HZB1EyghcX13A4LcpTBn/csVkxuFzTqGISDnFqpU=;
	b=x5Y9PZx8HNLvh70OQI4Ncbf9q7/KNtiKdp7ph2dWnXzkcwIyZdRse7pVCNn9H6ghSdNe
	 7xmAHN7y0Hvj1vzZhdTe99sVmmSyiiH9lJpL+EpGcg65eBBCsmB2kit9iaHSXqIRd9X9B
	 gNr2/IaOmyjF/7gzi3Zbb7NIgBeZmiN1YWHtpMFP+RAk6hKocLgg9BHcqnHsWIrOUkvt0
	 Ja+LvvQkGLgucm8pTz2ssz7RQceKzpe+2v98ZbUSYkmaOcmHNTjmFVej48kMn+aNDLnuv
	 PXsE5KMvvg7ONmE0fr3rdA1xKsuC8AoxRmWtUtI71D5DTmZ0w/ukUl7YWSozCrxGLqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HSA5dbKD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021A3606A32E;
	Wed, 25 Nov 2026 16:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HSA5dbKD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3A41F000D8;
	Wed, 25 Nov 2026 16:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622488;
	bh=6A0HZB1EyghcX13A4LcpTBn/csVkxuFzTqGISDnFqpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSA5dbKDnmjqpHzbEOBvvrfZtbSF5ZMGiEeWTRHKqVVEEhNJn3M9ps5VxHdYZLlkK
	 EN9XCdZT8IuleLGEqnWIwuQ+Yh+gn8BMhIkL1/dlbmOiK9/QcHPwqGxM0yI0Zjrj0P
	 X02oC37RLWhVnc563TYSiyih7VrgvRldn5+SqdFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 555/990] RDMA/vmw_pvrdma: Pin QP and SRQ rings writable to match device DMA write access
Date: Wed, 25 Nov 2026 15:32:02 +0100
Message-ID: <20261125143835.098242400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 89abac4b60b708037595255ea2614b6967c86ee5 ]

pvrdma embeds a pvrdma_ring_state header directly inside the QP and SRQ
ring buffers, and the hypervisor writes cons_head into that header.
Pinning with access=0 does not force a private page copy (no
FOLL_WRITE), so the hypervisor may write into a shared page.

Pass IB_ACCESS_LOCAL_WRITE for all three rings. The SRQ ring_state is
not currently used by the driver but is pinned writable for consistency.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-4-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[ sashal: Replaced ib_umem_get_va() calls with the older ib_umem_get() name while changing the access argument from 0 to IB_ACCESS_LOCAL_WRITE. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c  | 6 ++++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index 98b2a0090bf2a..3017a4080235d 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -270,7 +270,8 @@ int pvrdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 				/* set qp->sq.wqe_cnt, shift, buf_size.. */
 				qp->rumem = ib_umem_get(ibqp->device,
 							ucmd.rbuf_addr,
-							ucmd.rbuf_size, 0);
+							ucmd.rbuf_size,
+							IB_ACCESS_LOCAL_WRITE);
 				if (IS_ERR(qp->rumem)) {
 					ret = PTR_ERR(qp->rumem);
 					goto err_qp;
@@ -282,7 +283,8 @@ int pvrdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 			}
 
 			qp->sumem = ib_umem_get(ibqp->device, ucmd.sbuf_addr,
-						ucmd.sbuf_size, 0);
+						ucmd.sbuf_size,
+						IB_ACCESS_LOCAL_WRITE);
 			if (IS_ERR(qp->sumem)) {
 				if (!is_srq)
 					ib_umem_release(qp->rumem);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
index bdc2703532c6c..99748f0f296dd 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
@@ -146,7 +146,8 @@ int pvrdma_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *init_attr,
 		goto err_srq;
 	}
 
-	srq->umem = ib_umem_get(ibsrq->device, ucmd.buf_addr, ucmd.buf_size, 0);
+	srq->umem = ib_umem_get(ibsrq->device, ucmd.buf_addr, ucmd.buf_size,
+				IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(srq->umem)) {
 		ret = PTR_ERR(srq->umem);
 		goto err_srq;
-- 
2.53.0



