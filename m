Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027462;
	b=SJ6PdRhyCPOuGCY6iaE+vidX9Te4aK+XoVMG0i2YuqaVKSwmOsRBSZCs5l1yBLp7jwPg
	 zC8H4iyG6IGWZMIBzNKxk7H6jlMqmnaH8O+98rt4UZvs1AWwR6iDMFDbRBj3YBuWo+66k
	 8gnWnYex7hLJMGrLmeDYKU9uSPE0UTPvtQkLeW0XhC4hrBrfCHUFZRHwexWO2/TKe/zJz
	 joBbjP2FZs+7PcCze43qVXxgRfZdMClSsD/BH3sLIXEqC4ngCOG0IYK1jtBe5+O/+vyOf
	 LC40s1JqmW0rowKvH31uH5TeLah/SCwXulIx9PrXmhmvloPtLj4oopJJaKLm1jD0pbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9889g8u8DkD5CDN27Bv3Vk1cd49iJpNMODz560dlKwU=;
	b=aR0QY97itHxACvXOG/KnFZg3AvD/6uXS5SRhoOiMBo/EW7y1yzyzsKiMCYaTiF6eM/Xx
	 t8ZmPOCJ1gG8g/28ikUa3t3H27h+sa9/FcfPPt+ltHHq3WA0rlrBWjRVPLbgJRKuhu8eq
	 9hpe20RdS3BVyrkGpVIEEVEtgn5XV3aVxjgtDTx3eI4y8GaNOFULaJs7I4gynXwZkEILU
	 RHo3obakomEl9M5wZFZODRIZd5fwSGxtBR95wXSZyDJaYHFsV3Ctu28xTl7pn4vtWMLKD
	 l/q1topdcTcYc9VTYRrFh5Oanmi/noG4RQs3PIeODtYF7wglImtEk2JCGwUYkD+gJXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Soo1NBPC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209E860A2611;
	Wed, 18 Nov 2026 18:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Soo1NBPC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AA11F000C9;
	Wed, 18 Nov 2026 18:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027462;
	bh=9889g8u8DkD5CDN27Bv3Vk1cd49iJpNMODz560dlKwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Soo1NBPCuIqHkwvQBczUL7uVCFjqDeOm/4rf3xbVbhvZNW6DnY29QdgecDowrfdU+
	 vgjcEP0UR3Fo6LeljGC8gz8gdtXg08fvQa++9jW8PYZEts4CYcCd5ql8EgeNQMnKpa
	 Onpjr17dyadetDHCQWLJ7T3KtwTHb3Geo+WvoO80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunny Tiwari <sunnytiwari@google.com>,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1798/2151] RDMA/irdma: Bound in-flight CQP ops across deferred completions
Date: Wed, 18 Nov 2026 15:58:53 +0100
Message-ID: <20261118150227.307555225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Sunny Tiwari <sunnytiwari@google.com>

[ Upstream commit c3e8e9451e6f1b69f685b75e0fbf14f3d0fb2539 ]

On IRDMA_GEN_3+ devices, CQP operations can complete in two stages:
Stage-1 on the CCQ acknowledges receipt and moves an entry from
cqp->ooo_avail to cqp->ooo_pnd, while Stage-2 signals final completion
via an AEQ event or a subsequent CCQ CQE.

In irdma_sc_ccq_get_cqe_info(), Stage-1 processing advances
cqp->sq_ring.tail so the SQ descriptor slot can be reused once consumed
by hardware, whereas cqp->completed_ops is only incremented on Stage-2.
Because irdma_cqp_ring_full() only checks cqp->sq_ring, a burst of
backlogged commands in dev->cqp_cmd_head allows irdma_process_bh() to
submit more concurrent in-flight CQP commands than the maximum supported
limit (cqp->sq_size - 1) while earlier commands await Stage-2. This
causes CQP completions to be lost and synchronous waiters to time out
with -ETIMEDOUT (-110).

Fix this by:
  - Updating irdma_cqp_ring_full() to bound total in-flight CQP
    operations (cqp->requested_ops - cqp->completed_ops) to
    (cqp->sq_size - 1).
  - Calling irdma_process_bh() at the end of irdma_process_ae_def_cmpl()
    so backlogged commands are drained after Stage-2 AEQ completions
    increment cqp->completed_ops and free in-flight capacity.

Fixes: c7db0abe5f2b ("RDMA/irdma: Add GEN3 CQP support with deferred completions")
Assisted-by: Gemini
Signed-off-by: Sunny Tiwari <sunnytiwari@google.com>
Link: https://patch.msgid.link/20261017052856.3570063-1-sunnytiwari@google.com
Reviewed-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/ctrl.c | 6 +++++-
 drivers/infiniband/hw/irdma/hw.c   | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index 7e56d5e618962..a7c574c907ad9 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -5406,7 +5406,11 @@ int irdma_sc_static_hmc_pages_allocated(struct irdma_sc_cqp *cqp, u64 scratch,
  */
 static bool irdma_cqp_ring_full(struct irdma_sc_cqp *cqp)
 {
-	return IRDMA_RING_FULL_ERR(cqp->sq_ring);
+	u64 in_flight = cqp->requested_ops -
+			atomic64_read(&cqp->completed_ops);
+
+	return IRDMA_RING_FULL_ERR(cqp->sq_ring) ||
+	       in_flight >= (cqp->sq_size - 1);
 }
 
 /**
diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 1baffb595898c..7d01f68bdf4f5 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -197,6 +197,7 @@ static void irdma_process_ae_def_cmpl(struct irdma_pci_f *rf,
 		irdma_sc_cqp_def_cmpl_ae_handler(&rf->sc_dev, info, false,
 						 &scratch, &sw_def_info);
 	}
+	irdma_process_bh(&rf->sc_dev);
 }
 
 /**
-- 
2.53.0



