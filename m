Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021267;
	b=XZiwdr92B/2jm9Ed8QwBthwtK0kvz4aGezcjTV0BLm+7GJOOKt1NjaGae7Wn+YCkeY5M
	 SIo2rp4XjgHdXidFVLhL3QhiZnOQfzsLJkITGGbcZPsKYQZzhYbPaSeML7wJ/20jgTGcG
	 QzsP4dRRMhTeDC0fQOEdaAy7pq2Gt8lUbUpA4kF+A7KVKwrMIdCuCntPyBmBi3iTTUIyq
	 6muizQ92KVIXOCLOdzgW8+WhtUC7X7WC0XXWDAFDFKtgDxX9TAUQGq1nQwrGZrY/S9KuU
	 Ve0t/Hrq37qhARrqe4PxkPs+la0ps9YdmjQtwbJe64yksYoK1Cymcsjhrwcs+6q/2RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lvuuh7ehMArgdQTfI+SP1F1dCp/g1pB7F/bmFIy0adA=;
	b=qn8CGj7aP3eFWFxO2KZOeOaPMLrdNKwGLGkCSd2A8IwSt8WrcADL8/dK8n+y5d27AUB+
	 iLe26txEL+CEzCxlwN7NS8o/KCD+X3bpWP9gfuP9tdV7TXfO7xP32/UHjIBvO7yBQAn0R
	 rVj1yFtXvF4lQqhXR3y0jsouc55ewSr+cQcxIFUcaVGackAUd1pV318M74xvCzMC8DXdI
	 s+N9bm6GgDO2jF9w+P5I5wvi5y4YFyNhvll3JR9+lXgSKIFT4LPk9PGYpJGSfOOddR1Nk
	 43YqWdeT7Lc0iyILMIPleF/xbIh9OLw/GZV8R3tRHyVUnvBdsw19tNLDFIjt1U6e9YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rs/64aat";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8575A606A320;
	Wed, 18 Nov 2026 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rs/64aat
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D510D1F000C4;
	Wed, 18 Nov 2026 17:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021267;
	bh=Lvuuh7ehMArgdQTfI+SP1F1dCp/g1pB7F/bmFIy0adA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rs/64aatTrzTeNLNv+TzyLVK8EiTD9qQv4xu/T2thqttQl1c3Uj6m5m/5ULMiLLCB
	 9JxEP83eyO4lboTOtf0gn+IMACw8Iu411uyMZeUnSBgn9iXS2n5HwXEwlQDOQIFy3Q
	 NSRsfaOHG/W8xDZLg97GVpWuWhJHciLk+anRMh/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunny Tiwari <sunnytiwari@google.com>,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2229/2651] RDMA/irdma: Bound in-flight CQP ops across deferred completions
Date: Wed, 18 Nov 2026 15:57:49 +0100
Message-ID: <20261118150405.784398549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 970b61aa3e24f..ade451a4eb23e 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -5329,7 +5329,11 @@ int irdma_sc_static_hmc_pages_allocated(struct irdma_sc_cqp *cqp, u64 scratch,
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
index b060ddc8b67bc..554f5d8962b9d 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -265,6 +265,7 @@ static void irdma_process_ae_def_cmpl(struct irdma_pci_f *rf,
 		irdma_sc_cqp_def_cmpl_ae_handler(&rf->sc_dev, info, false,
 						 &scratch, &sw_def_info);
 	}
+	irdma_process_bh(&rf->sc_dev);
 }
 
 /**
-- 
2.53.0



