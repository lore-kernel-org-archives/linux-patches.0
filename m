Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625202;
	b=en+VjCQmf3u21Sy/+7C9XxO5VWZPauO+ek3M07j8fZxktFp4J7gMsy4KIba0jwGrZV5f
	 0jpfM75OMFf4e64bfOGAr9MNf6cKboJ47fyNxRVzQlEVVAZpDxOftipOOIgRW92mWODAD
	 PtI1YbZmyasiCirTMlm9UO5uBQKxHGXcLWS2jscBXqxLe/GXMM9mL+RxDgktUWIXGN3Hg
	 /MKgoaiyuDJVjKF6EOtGXKYLeqVTUT8Know0zIbvQxWiLsKwhTbdPZ6IT6+6Ti1QgFJs3
	 yBujG4pepKM0BVLeKZytKMSc58s0Ew0O90fzit3IQA1VNFCdUZEMk7XFrB8eHUL71Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3uA1kX6IRpK8Um6Q2/bcDpCG6AhKG7P3tqQGwf80u6o=;
	b=y98PKZPcsfqJyQO6LgEINCSLwp02jG4DQJ26tg0mse6AHxKYVKbDb4jYT1OFIIHtfF6l
	 fwgm8lyVpqyhkCQgsHD1w26zSsElRc2iNuyOPZ3RNvFfVWd8S9lBEFu3k9VsQIr+NPCST
	 ryIWlIkXXaKCe0EngHveHVkE44Texq+hmwP/2GbA9379j0Ee3whcEvVs+55FvprDsjlin
	 eCEP44l6AMtkU0LbhvAFPmZ+iBdNcmlqn6Xp+PEhwc9NWAZXWNCUCEbPaXhFMekp/8cAs
	 L+AOuGtMo8BSjDeWvcIqs0v19MsKTBHDuUkycsCFs8Su/WWDQ+bpfIoQz79hjM9yYBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6QLdQR6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C9E606A321;
	Wed, 25 Nov 2026 16:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6QLdQR6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111B01F000C6;
	Wed, 25 Nov 2026 16:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625201;
	bh=3uA1kX6IRpK8Um6Q2/bcDpCG6AhKG7P3tqQGwf80u6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6QLdQR6z1XEMfj0d3tmeChg4f/sMF3eGigxpqzW5rCEbwL6b9NsXu6an8QMAx+BQ
	 kI1JdfV5mcIn86rOFZWIXzzc4bHYXw6jS8mqHwcw2gPgKn/KGAnff9OHdd8dzUU35u
	 z47StRldkLdXxoxSg0WEvihBZs2HTH624ztQ9fyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 439/816] RDMA/vmw_pvrdma: Pin QP and SRQ rings writable to match device DMA write access
Date: Wed, 25 Nov 2026 15:33:07 +0100
Message-ID: <20261125143859.351975180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced ib_umem_get_va() with ib_umem_get() in the three ring-pinning calls and re-wrapped the arguments and continuation indentation to fit. ]
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



