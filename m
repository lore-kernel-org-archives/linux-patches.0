Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF513B2FDC;
	Wed, 30 Sep 2026 17:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790197; cv=none; b=Qh0wdevPiX65/GRr4KjCwc9l79fqZRUaF11+zfJYVEzmtDvYoOEArbtzsaZuwusqquVSvwEwqW+kRMOIRZxn0AlWFZPQ1d/I8sCNHZxwQQeisKFS944fZF7wKI7IR85phDGXlKomcEnM0xT3rLyquxsw7GLYC3Z0HSoYPwH/Uec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790197; c=relaxed/simple;
	bh=189cBYefWk3Ji61ZhqLK7TRwvlP2tZrlchI6TpyKkKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yo+zaWZuzy8tkaQGGqxq37GYgef7aAh8k5etSrMyw43AK/n7GUeveIcfT8vkucGDpbQhfHO909fGra9JJDGtWt1OzN4qHfsKKZXmuyKcPY8ztnrOV//vtrE/kM9O3Q02+uIiktzSqAm5mt4AlR89AWlMYo9YpTgeQELaCDo+caI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBedhMae; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBedhMae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5D31F00898;
	Wed, 30 Sep 2026 17:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790196;
	bh=Xhhg8SsBsozV5vBVwtrwHSp+NfEoCh9weGlja5+Sh0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBedhMaeYniJYTPt/89br0l3cCvCEEezorZU2NiwXROlgwudY3RBxwslx9Le6ikpx
	 2MbwIJvq+sx8Bsoqz31urM+UbcjObRWxksKGM9tlci0NLKLnTR3EN6bdrIxpc9Stf7
	 Io5PhfdTNjbfKEfdILGZ4oDnpXTWfUlrjRDwm+aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 745/877] idpf: disable DIM work before freeing q_vectors
Date: Wed, 30 Sep 2026 17:27:36 +0200
Message-ID: <20260930152430.770435492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 7dd4c829bac2916be98a3e34b41daaba7f42b4c4 ]

idpf never drains the Tx/Rx DIM works before freeing the memory they
live in.  tx_dim and rx_dim are embedded in struct idpf_q_vector, they
are queued from the NAPI poll via net_dim(), and idpf_vport_intr_rel()
ends with kfree(rsrc->q_vectors).  Nothing in the driver cancels them.

idpf_tx_dim_work() and idpf_rx_dim_work() then run on freed memory:
idpf_vport_intr_write_itr() writes the ITR register through
q_vector->intr_reg.tx_itr / rx_itr, void __iomem pointers loaded out of
the freed q_vector.  No configuration is needed to get there --
IDPF_ITR_IS_DYNAMIC() is defined as (itr_mode) and idpf_vport_alloc()
initialises both modes to IDPF_ITR_DYNAMIC.

Draining after idpf_vport_intr_napi_dis_all() is not enough on its own.
idpf_net_dim() is called from inside the
"if (napi_complete_done(napi, work_done))" branch of the poll, and
napi_complete_done() has already cleared NAPIF_STATE_SCHED by then.
napi_disable_locked() waits only while (val & (NAPIF_STATE_SCHED |
NAPIF_STATE_NPSVC)), so napi_disable() can return while the poll tail is
still queueing the work, and a plain cancel_work_sync() would be
re-armed behind the drain.

Use disable_work_sync(): schedule_work() on a work with a non-zero
disable count is dropped by clear_pending_if_disabled() before
__queue_work() is reached.

Move idpf_init_dim() to idpf_vport_intr_alloc() so the works are
initialised on every path that can reach the drain -- the three
"goto intr_deinit" sites between idpf_vport_intr_init() and
idpf_vport_intr_ena() get there without the enable side having run.
Nothing re-enables them: rsrc->q_vectors is freed on every exit from
idpf_vport_open() and on every idpf_vport_stop(), so the count dies with
the object.

It is a race, not a deterministic failure -- net_dim() only schedules
once DIM_NEVENTS events have accumulated and the profile index changes.
A KASAN ifup/ifdown loop under load is the way to see it.

Fixes: c2d548cad150 ("idpf: add TX splitq napi poll support")
Fixes: 3a8845af66ed ("idpf: add RX splitq napi poll support")
Cc: <stable@vger.kernel.org> # see patch description, needs adjustments for <= 6.9
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -3574,6 +3574,26 @@ static void idpf_vport_intr_ena_irq_all(
 }
 
 /**
+ * idpf_vport_intr_dis_dim_all - Disable DIM work for all q_vectors
+ * @rsrc: pointer to queue and vector resources
+ *
+ * The DIM works are embedded in the q_vector array that
+ * idpf_vport_intr_rel() frees, and the poll arms them after
+ * napi_complete_done() has already cleared NAPI_STATE_SCHED.  Disable
+ * rather than just cancel, so that a poll tail still running past
+ * napi_disable() cannot queue them again behind the drain.
+ */
+static void idpf_vport_intr_dis_dim_all(struct idpf_q_vec_rsrc *rsrc)
+{
+	for (u16 v_idx = 0; v_idx < rsrc->num_q_vectors; v_idx++) {
+		struct idpf_q_vector *q_vector = &rsrc->q_vectors[v_idx];
+
+		disable_work_sync(&q_vector->tx_dim.work);
+		disable_work_sync(&q_vector->rx_dim.work);
+	}
+}
+
+/**
  * idpf_vport_intr_deinit - Release all vector associations for the vport
  * @vport: main vport structure
  * @rsrc: pointer to queue and vector resources
@@ -3583,6 +3603,7 @@ void idpf_vport_intr_deinit(struct idpf_
 {
 	idpf_vport_intr_dis_irq_all(rsrc);
 	idpf_vport_intr_napi_dis_all(rsrc);
+	idpf_vport_intr_dis_dim_all(rsrc);
 	idpf_vport_intr_napi_del_all(rsrc);
 	idpf_vport_intr_rel_irq(vport, rsrc);
 }
@@ -3663,7 +3684,6 @@ static void idpf_vport_intr_napi_ena_all
 	for (u16 q_idx = 0; q_idx < rsrc->num_q_vectors; q_idx++) {
 		struct idpf_q_vector *q_vector = &rsrc->q_vectors[q_idx];
 
-		idpf_init_dim(q_vector);
 		napi_enable(&q_vector->napi);
 	}
 }
@@ -3983,6 +4003,8 @@ int idpf_vport_intr_alloc(struct idpf_vp
 		q_coal = &user_config->q_coalesce[v_idx];
 		q_vector->vport = vport;
 
+		idpf_init_dim(q_vector);
+
 		q_vector->tx_itr_value = q_coal->tx_coalesce_usecs;
 		q_vector->tx_intr_mode = q_coal->tx_intr_mode;
 		q_vector->tx_itr_idx = VIRTCHNL2_ITR_IDX_1;


