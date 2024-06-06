Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6F3198E79;
	Thu,  6 Jun 2024 14:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683085; cv=none; b=hmDymkvt8iU0xMdH0+jjcvF2oOGnyTEIl/gk/sq36L98dH+AJ8NDMgN75xSAU+GzI4cO9govAp6KxtHmEuHWT+UqY++GmaTb2cKQmjARRzVSvpDsw1WzeFtZjSnrL1LAPV92BrRt9/GXLF6PsTdEJhwJpFlFlPsC/IJwuIl21I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683085; c=relaxed/simple;
	bh=hUMVfHj6OHYLxg7qTTg8x7GFuM/8v0Uak9TNQl/m/EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+WJLH4o9BEKZNOGAKKuZBVx3uuTQadCTFjtkz3FptC9vO0uqJc/j//X4OgBKAXQ4Zad/h1c6Au3bY3aIj0SGBcC8nggCxlwyWSr+9vSyQ9V8vh4C3evjfHauICAoM18k5kvyc0WDb3cj0m6aoHMFdq7gXMY/hFYKW+ILTAwR58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsFNslv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsFNslv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDFAC2BD10;
	Thu,  6 Jun 2024 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683085;
	bh=hUMVfHj6OHYLxg7qTTg8x7GFuM/8v0Uak9TNQl/m/EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsFNslv/PxM0v+MIA6/ExkRsw//QO+LPMPTXRS432S6boHoVLT9EU6i2XCU8VM+y7
	 8edk4W6Zkqc/JhhRzzDKsZuDCrL4LXud0QQNdf9m3oCCwzNeqqY7kjW0GqVgy1mv7k
	 ouoxGEGW3JgMDsuhFER1Z0S4lLWQSzkPIkMBEjgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kubiak <michal.kubiak@intel.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Simon Horman <horms@kernel.org>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 320/374] idpf: dont enable NAPI and interrupts prior to allocating Rx buffers
Date: Thu,  6 Jun 2024 16:04:59 +0200
Message-ID: <20240606131702.591235001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit d514c8b54209de7a95ab37259fe32c7406976bd9 ]

Currently, idpf enables NAPI and interrupts prior to allocating Rx
buffers.
This may lead to frame loss (there are no buffers to place incoming
frames) and even crashes on quick ifup-ifdown. Interrupts must be
enabled only after all the resources are here and available.
Split interrupt init into two phases: initialization and enabling,
and perform the second only after the queues are fully initialized.
Note that we can't just move interrupt initialization down the init
process, as the queues must have correct a ::q_vector pointer set
and NAPI already added in order to allocate buffers correctly.
Also, during the deinit process, disable HW interrupts first and
only then disable NAPI. Otherwise, there can be a HW event leading
to napi_schedule(), but the NAPI will already be unavailable.

Fixes: d4d558718266 ("idpf: initialize interrupts and enable vport")
Reported-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20240523-net-2024-05-23-intel-net-fixes-v1-1-17a923e0bb5f@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c  |  1 +
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 12 +++++++-----
 drivers/net/ethernet/intel/idpf/idpf_txrx.h |  1 +
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 5d3532c27d57f..ae8a48c480708 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -1394,6 +1394,7 @@ static int idpf_vport_open(struct idpf_vport *vport, bool alloc_res)
 	}
 
 	idpf_rx_init_buf_tail(vport);
+	idpf_vport_intr_ena(vport);
 
 	err = idpf_send_config_queues_msg(vport);
 	if (err) {
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index f5bc4a2780745..7fc77ed9d1232 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -3747,9 +3747,9 @@ static void idpf_vport_intr_ena_irq_all(struct idpf_vport *vport)
  */
 void idpf_vport_intr_deinit(struct idpf_vport *vport)
 {
+	idpf_vport_intr_dis_irq_all(vport);
 	idpf_vport_intr_napi_dis_all(vport);
 	idpf_vport_intr_napi_del_all(vport);
-	idpf_vport_intr_dis_irq_all(vport);
 	idpf_vport_intr_rel_irq(vport);
 }
 
@@ -4180,7 +4180,6 @@ int idpf_vport_intr_init(struct idpf_vport *vport)
 
 	idpf_vport_intr_map_vector_to_qs(vport);
 	idpf_vport_intr_napi_add_all(vport);
-	idpf_vport_intr_napi_ena_all(vport);
 
 	err = vport->adapter->dev_ops.reg_ops.intr_reg_init(vport);
 	if (err)
@@ -4194,17 +4193,20 @@ int idpf_vport_intr_init(struct idpf_vport *vport)
 	if (err)
 		goto unroll_vectors_alloc;
 
-	idpf_vport_intr_ena_irq_all(vport);
-
 	return 0;
 
 unroll_vectors_alloc:
-	idpf_vport_intr_napi_dis_all(vport);
 	idpf_vport_intr_napi_del_all(vport);
 
 	return err;
 }
 
+void idpf_vport_intr_ena(struct idpf_vport *vport)
+{
+	idpf_vport_intr_napi_ena_all(vport);
+	idpf_vport_intr_ena_irq_all(vport);
+}
+
 /**
  * idpf_config_rss - Send virtchnl messages to configure RSS
  * @vport: virtual port
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
index df76493faa756..85a1466890d43 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -988,6 +988,7 @@ int idpf_vport_intr_alloc(struct idpf_vport *vport);
 void idpf_vport_intr_update_itr_ena_irq(struct idpf_q_vector *q_vector);
 void idpf_vport_intr_deinit(struct idpf_vport *vport);
 int idpf_vport_intr_init(struct idpf_vport *vport);
+void idpf_vport_intr_ena(struct idpf_vport *vport);
 enum pkt_hash_types idpf_ptype_to_htype(const struct idpf_rx_ptype_decoded *decoded);
 int idpf_config_rss(struct idpf_vport *vport);
 int idpf_init_rss(struct idpf_vport *vport);
-- 
2.43.0



