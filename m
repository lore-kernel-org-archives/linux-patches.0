Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026798;
	b=tzkPOrdByHQVEAr0nv7lvDiYUGCcgD/nNtAmrYfJ3rPE+f1pOZ8tUk9oB6jI8x88R2Rv
	 2pzPF26pqIISbj2wIxr2hipvFNUOnQ090Z1xXfpXvOZL2OTvZEt+0j5ek5AC1gZ6V8uQj
	 mf4eLZxfydMXXL5HhPa/IR1JbgpdxtxRuQWdXwM3AHlKMr0tOHiXT3s0+W+Mky7m+3/Ht
	 lY5i7PJkK7jG595RVcS7HwZJLWo8qi340/427Gdel/WKEhTl72B6fCLWJb1EVdpbckoa9
	 H/4f7btG6XsSV9l6GWkwRiEEiOtDci0XjjB6Xe9EhCyhZa2BfEzzLKSDdRcGIFf4e5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=emQBRJ9wTKUryaIt66lCYrtOz9x7vdjeCuPP2a+Vdeo=;
	b=kLpnU4ZVMG2BNCFVJMDBgNuAwgol47nVvM1gwiuhqqqk6TNIT5cfEwz35TNLFJs67zgE
	 ynOoYCXvq0bfsN5OCe7Y/6OrnxjefICBX24alHsTnJMY7Jdw0UvdqfjhLDppbUvJEeiFZ
	 L8IgdNCypEMEzcVMSuocasXjQo2enNg+J8HpEkt9xKhtcALk7DtI9mmtTC00i945GNpok
	 Q3OJt5J2Zz80FawzLbEpWwvALD4w8njlDWwL7bfKckyMLfpBQpcrMrRe4dwrGSJUhbsV3
	 SLlKqRiP98DnbtEk8/5CWCDLFhysQsO9HWLBBMeVpKd+eb0iDZ1jCRLEG6MoR40MlgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I0jsP9T9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFCF606A31C;
	Wed, 18 Nov 2026 18:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I0jsP9T9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4A11F000C4;
	Wed, 18 Nov 2026 18:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026798;
	bh=emQBRJ9wTKUryaIt66lCYrtOz9x7vdjeCuPP2a+Vdeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0jsP9T9XohYC6HauYZSGmnd7efVKtS1xJEL29KUe9q2/CKQdleeLMhMgFbi1KSQJ
	 I7+hOBjDR+rV7JFUkuLXkau41lczAZ+P7odXIau9amyw0K6qGp6oI4OfIwKQhb8aKD
	 vR/fPObfH4mg3jpSEttZnhNde+XdtihMd5xyCfqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1564/2151] scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait state
Date: Wed, 18 Nov 2026 15:54:59 +0100
Message-ID: <20261118150218.863293060@linuxfoundation.org>
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
index 1323ed8aa7171..d48ba3747b81b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -163,6 +163,7 @@ enum hisi_sas_phy_event {
 	HISI_PHYE_PHY_UP   = 0U,
 	HISI_PHYE_LINK_RESET,
 	HISI_PHYE_PHY_UP_PM,
+	HISI_PHYE_SPINUP_NOTIFY,
 	HISI_PHYES_NUM,
 };
 
@@ -689,4 +690,6 @@ extern void hisi_sas_sync_cqs(struct hisi_hba *hisi_hba);
 extern void hisi_sas_sync_poll_cqs(struct hisi_hba *hisi_hba);
 extern void hisi_sas_controller_reset_prepare(struct hisi_hba *hisi_hba);
 extern void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba);
+extern void hisi_sas_spinup_notify(struct hisi_hba *hisi_hba,
+				   struct sas_task *task);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index c2b082f1252c3..5a0470cc3dd25 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -996,10 +996,25 @@ static void hisi_sas_phyup_pm_work(struct work_struct *work)
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
@@ -1639,6 +1654,34 @@ void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
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
index fa94d7110714f..5fcb8d5002f52 100644
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
index f3516a0611dde..f16896e962fdd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2427,6 +2427,10 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
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
index fbd476a3f1318..80980e669202a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2435,6 +2435,10 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
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



