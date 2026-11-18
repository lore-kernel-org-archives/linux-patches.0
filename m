Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031989;
	b=mg0aWdfJ+RcbBp/Nn8Y9+Gp9ZGzf9RerrfNoc2B2ZMD8gjlrWbMaGASc9oQTlAX+1VvO
	 E6VTpx7FxPWDFJigT9CJ4q3mMFOSSol5umhsZ+4y2wAKLF/miyXWuL/yZUbjoIyXkN1rb
	 AaOGCN5isarHyNDHMy+7FdrFlO00gjGVveo+rFitlrmtQF2Gc2teiEq6FNsSvRFrZRwCA
	 lf14UDzSK1Jtl26P3w4uBcI+hM+vsqTfiJWySDf6YamTLj7mrOhI8y8NhDloLe6mPh2KR
	 3Ji9YqdGfGeldjz/Pc69F7mkUbi6l9cw3BZ1c+088yXQC5R0DbodMENtXB/6ckgO87w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r4U0sZrxicNuO6OmkShwva8jahDpPmjpxje44U5ZxwI=;
	b=C4kDEil9d4WHXOxb5WvDfeajdZlf3gKsAQbAwEbVtCJXfug/rFcRQAvFE4YYGIcZJAb1
	 15iVHLRmRUiFIqSXTxJElU415zdNhgX1BqHBArXlysWsSca0SwP+hfJ6BiVg1RWM8J9H0
	 wFHNqlc3YYxENPsJZVyEqz6yGEnF16Ma7rz5lG2KuTrBgQ97hB5/Y+Ib3x/uzFMBBmmQ1
	 xa+eyagbiMnV3e2qi7mdk4D9FwOAx2E4+a495fas1BOhwh2E4TpCKJMCxP5VSlL9QNmX4
	 PtMvDzKE8h0gs3kQ6jZzX6Evno6lH+8o/4FMT3mrDb4N6VhiI/ownz9KJdziF3YG9rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oS6xnnHB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C495E606A320;
	Wed, 18 Nov 2026 19:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oS6xnnHB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211001F000C4;
	Wed, 18 Nov 2026 19:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031989;
	bh=r4U0sZrxicNuO6OmkShwva8jahDpPmjpxje44U5ZxwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oS6xnnHBYqwqGfU5RvkMAI1TwgA2D/w2ExMZQT0daeBw+PkAY4lj/DWc304W7/2rM
	 IkLsd5k3+ZQ/GE+B6vGkkrgBSS1kZiSC6VnpAbzOXE5d84o3e9+Qms8Sbwr3YvfbPU
	 CVV8aVaaLG0mICOS/VRXkscxNMvG0XiNMubpUbBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1254/1756] scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait state
Date: Wed, 18 Nov 2026 15:56:21 +0100
Message-ID: <20261118150059.622639831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 92821c2358c78345909889793918af8763808bd4 ]

SAS HDDs powered up with RNOT=1 wait in Active_Wait state for a
NOTIFY(ENABLE SPINUP) primitive and keep returning NOT_READY with
ASC/ASCQ 0x04/0x11, causing endless mid-layer retries and spinup
failure.

Parse the sense data in the slot completion path and, when
LU_NOT_READY_NOTIFY_REQUIRED is returned by a directly-attached SSP
device, queue work that sends the primitive from process context
(sl_notify_ssp() contains msleep()). The work takes a runtime PM
reference with pm_runtime_get_if_active(), pairing with
pm_runtime_put_sync() in the work, so the controller stays resumed until
the primitive is sent.

Fixes: 60b4a5ee9034 ("scsi: hisi_sas: add v3 cq interrupt handler")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://patch.msgid.link/20261009033238.1076098-5-yangxingui@huawei.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 43 ++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  4 +++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  4 +++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  4 +++
 5 files changed, 58 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 3311f9b9eca6a..b38f09b223079 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -163,6 +163,7 @@ enum hisi_sas_phy_event {
 	HISI_PHYE_PHY_UP   = 0U,
 	HISI_PHYE_LINK_RESET,
 	HISI_PHYE_PHY_UP_PM,
+	HISI_PHYE_SPINUP_NOTIFY,
 	HISI_PHYES_NUM,
 };
 
@@ -690,4 +691,6 @@ extern void hisi_sas_sync_cqs(struct hisi_hba *hisi_hba);
 extern void hisi_sas_sync_poll_cqs(struct hisi_hba *hisi_hba);
 extern void hisi_sas_controller_reset_prepare(struct hisi_hba *hisi_hba);
 extern void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba);
+extern void hisi_sas_spinup_notify(struct hisi_hba *hisi_hba,
+				   struct sas_task *task);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 236e23620f21d..30989da029b82 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -975,10 +975,25 @@ static void hisi_sas_phyup_pm_work(struct work_struct *work)
 	pm_runtime_put_sync(dev);
 }
 
+static void hisi_sas_spinup_notify_work(struct work_struct *work)
+{
+	struct hisi_sas_phy *phy =
+		container_of(work, typeof(*phy), works[HISI_PHYE_SPINUP_NOTIFY]);
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	struct device *dev = hisi_hba->dev;
+	int phy_no = phy->sas_phy.id;
+
+	hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
+	dev_info(dev, "spinup notify primitive on phy%d\n", phy_no);
+
+	pm_runtime_put_sync(dev);
+}
+
 static const work_func_t hisi_sas_phye_fns[HISI_PHYES_NUM] = {
 	[HISI_PHYE_PHY_UP] = hisi_sas_phyup_work,
 	[HISI_PHYE_LINK_RESET] = hisi_sas_linkreset_work,
 	[HISI_PHYE_PHY_UP_PM] = hisi_sas_phyup_pm_work,
+	[HISI_PHYE_SPINUP_NOTIFY] = hisi_sas_spinup_notify_work,
 };
 
 bool hisi_sas_notify_phy_event(struct hisi_sas_phy *phy,
@@ -1607,6 +1622,34 @@ void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_controller_reset_done);
 
+void hisi_sas_spinup_notify(struct hisi_hba *hisi_hba,
+			    struct sas_task *task)
+{
+	struct task_status_struct *ts = &task->task_status;
+	struct domain_device *dev = task->dev;
+	struct scsi_sense_hdr sshdr;
+	struct sas_phy *local_phy;
+	struct hisi_sas_phy *phy;
+
+	if (!scsi_normalize_sense(ts->buf, ts->buf_valid_size, &sshdr))
+		return;
+
+	if (sshdr.sense_key != NOT_READY ||
+	    sshdr.sense_code != LU_NOT_READY_NOTIFY_REQUIRED)
+		return;
+
+	if (!pm_runtime_get_if_active(hisi_hba->dev))
+		return;
+
+	local_phy = sas_get_local_phy(dev);
+	phy = &hisi_hba->phy[local_phy->number];
+	if (!hisi_sas_notify_phy_event(phy, HISI_PHYE_SPINUP_NOTIFY))
+		pm_runtime_put(hisi_hba->dev);
+
+	sas_put_local_phy(local_phy);
+}
+EXPORT_SYMBOL_GPL(hisi_sas_spinup_notify);
+
 static int hisi_sas_controller_prereset(struct hisi_hba *hisi_hba)
 {
 	if (!hisi_hba->hw->soft_reset)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 71b5008c3552c..3f7807c03e95d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1272,6 +1272,10 @@ static void slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 				&status_buffer->iu[0];
 
 		sas_ssp_task_response(dev, task, iu);
+		if (unlikely(ts->stat == SAS_SAM_STAT_CHECK_CONDITION &&
+			     !dev_parent_is_expander(device)))
+			hisi_sas_spinup_notify(hisi_hba, task);
+
 		break;
 	}
 	case SAS_PROTOCOL_SMP:
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 89ff33daba404..e88028be489fe 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2428,6 +2428,10 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
 				&status_buffer->iu[0];
 
 		sas_ssp_task_response(dev, task, iu);
+		if (unlikely(ts->stat == SAS_SAM_STAT_CHECK_CONDITION &&
+			     !dev_parent_is_expander(device)))
+			hisi_sas_spinup_notify(hisi_hba, task);
+
 		break;
 	}
 	case SAS_PROTOCOL_SMP:
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 1b21cde7849fc..4b41b6ba8f170 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2436,6 +2436,10 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 			sizeof(struct hisi_sas_err_record);
 
 		sas_ssp_task_response(dev, task, iu);
+		if (unlikely(ts->stat == SAS_SAM_STAT_CHECK_CONDITION &&
+			     !dev_parent_is_expander(device)))
+			hisi_sas_spinup_notify(hisi_hba, task);
+
 		break;
 	}
 	case SAS_PROTOCOL_SMP: {
-- 
2.53.0



