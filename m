Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020353;
	b=whN91o12EYKSpTz9kPgTlTJIaqYVysrdhoMgC+c74k6Dm6Y03crQI9gLrnTMHDNgYkoD
	 SAuJkqTAfwlWnUH49HYyhkN9DPvBw/n15Z0+UA0h799UWAdeiPqZMCBNNia7R8bv9x5Yp
	 pS+LKHmsXrR0KRRoYDJNr2srlSGwbJPmVTyzo6n6ntyv3s5Qs/WmxItbO5NG2l8tSqKYb
	 SLFcKzVNQio4jbnEuYawSiNrRpyfFJCzJBUBoZ+Q0HNLfZrDEciqKHovwIa1mYg+wJ/ww
	 7tAQn4+myxMEHEIkCSUaTGj/vP+1VUc7Tecx8gv87CkdnMLsA5vn+NGZNvwi0c1lt1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U+BNm1+46zvW8Nv6idOFOqgvd2KDOMiiL6TlwXdyS5A=;
	b=JMq+hoGuBV0FaUNqKJO6fWDEawLOlRIONYVrMPaJ6Y/1i73lzQCKjuES7aR2LR0xW1b/
	 4m1fHXinmMirJ1TgKXMFL+Mq8UgVAyH07HDgl21XQVmfD7/iPK9jXoHEazyW0pXDb8tOS
	 h3+c5Jl2///Wi+Zl163aoVX4NuPTMC6ZFRU2A8RGYO5u3WtjLUrSaOYankTy4/CATYoTk
	 WykIZv7luIE1IilZuKdWS3nOn0/aKlbp63bsIauGZVxjA3lB45S9UlL9lX5i6BEGeBEx5
	 Ggj3ZHjw+Zpar1mg31IEiXjbeBt6SeNLZbfivQhqr0fKAgbpoYWhwRHuVgg1mV8hXlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KOlNDp6o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073C3606A331;
	Wed, 18 Nov 2026 16:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KOlNDp6o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DBD1F000C4;
	Wed, 18 Nov 2026 16:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020352;
	bh=U+BNm1+46zvW8Nv6idOFOqgvd2KDOMiiL6TlwXdyS5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KOlNDp6ouD7FsdnYlt6Dinlm0ZRsV5ae742n1ZDbyRYPbpaCyRfpecuMuP6LKnFhS
	 WMoBtg/1+W0hTvPrdHRzvMgrDAUNrbtC3rtbWbOVJbD7mjkgKq72hrFF/EbUzpjmkl
	 aMHYsL9PeR7QEWIZHMmoktNTT8G3pkL+Df1roqf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1919/2651] scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait state
Date: Wed, 18 Nov 2026 15:52:39 +0100
Message-ID: <20261118150355.839217760@linuxfoundation.org>
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
index 944ce19ae2fc1..cf7aa0a699cde 100644
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
index 9c363e2373538..e74ab20fdbda0 100644
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



