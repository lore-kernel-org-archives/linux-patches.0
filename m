Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54D51BF38;
	Sat,  3 Feb 2024 04:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933803; cv=none; b=k+S/1B9nEfYPzsKMhFQ7g+Idf1pKI8Hx9xR2JK4z8wYiq/4620+520dBOBEGnzzrgVlnrlHvo3eY5qPGHEd/mqNyEKj/GH69VnX1z/Mclco2qal0NQWUe1WQeoP1sAL0uLhjI33vw8Zn8kWDlL++dbdIh+/5nlV/xHUh2ejqAZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933803; c=relaxed/simple;
	bh=0tllTTXbp7ZSrhsbgb4tl67It0hYuie1+vZF5uvNzWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uG4nK+5kz8nDNPn99lP5I7QFMGzO4H0zN2D9b552xJBg0sFg7zN46SdRCaRZWc2Uam9OruOU/34lQ/WllTu68tOi/cRJgFzNXEObj/ffmlRik1V17xB16Ow0OLKjZ3XOjum3d8Nr7yAKF7i+i8zf0lbk22zt5o0yqIUEWyxnyas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOXM6pAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOXM6pAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFD9C433A6;
	Sat,  3 Feb 2024 04:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933803;
	bh=0tllTTXbp7ZSrhsbgb4tl67It0hYuie1+vZF5uvNzWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOXM6pAPksAbW30Ik8WaUr7o7gJ9Wf1eaCT94Yooc+0lFhLvGk4hFvzlEdWPHlllo
	 ghCiUlQIw9VOLj7uzG7geUFodPGiJuBz+DWXu+cRxvOR5rj7qQooXDR8wKJfr6yWL1
	 zzn7PvsWvufOiUmcO0JBjV+MDLlqbeoFaYxY9Yz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 092/353] wifi: ath11k: fix race due to setting ATH11K_FLAG_EXT_IRQ_ENABLED too early
Date: Fri,  2 Feb 2024 20:03:30 -0800
Message-ID: <20240203035406.712629600@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 5082b3e3027eae393a4e86874bffb4ce3f83c26e ]

We are seeing below error randomly in the case where only
one MSI vector is configured:

kernel: ath11k_pci 0000:03:00.0: wmi command 16387 timeout

The reason is, currently, in ath11k_pcic_ext_irq_enable(),
ATH11K_FLAG_EXT_IRQ_ENABLED is set before NAPI is enabled.
This results in a race condition: after
ATH11K_FLAG_EXT_IRQ_ENABLED is set but before NAPI enabled,
CE interrupt breaks in. Since IRQ is shared by CE and data
path, ath11k_pcic_ext_interrupt_handler() is also called
where we call disable_irq_nosync() to disable IRQ. Then
napi_schedule() is called but it does nothing because NAPI
is not enabled at that time, meaning
ath11k_pcic_ext_grp_napi_poll() will never run, so we have
no chance to call enable_irq() to enable IRQ back. Finally
we get above error.

Fix it by setting ATH11K_FLAG_EXT_IRQ_ENABLED after all
NAPI and IRQ work are done. With the fix, we are sure that
by the time ATH11K_FLAG_EXT_IRQ_ENABLED is set, NAPI is
enabled.

Note that the fix above also introduce some side effects:
if ath11k_pcic_ext_interrupt_handler() breaks in after NAPI
enabled but before ATH11K_FLAG_EXT_IRQ_ENABLED set, nothing
will be done by the handler this time, the work will be
postponed till the next time the IRQ fires.

Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.23

Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231117003919.26218-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/pcic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/pcic.c b/drivers/net/wireless/ath/ath11k/pcic.c
index 16d1e332193f..e602d4130105 100644
--- a/drivers/net/wireless/ath/ath11k/pcic.c
+++ b/drivers/net/wireless/ath/ath11k/pcic.c
@@ -460,8 +460,6 @@ void ath11k_pcic_ext_irq_enable(struct ath11k_base *ab)
 {
 	int i;
 
-	set_bit(ATH11K_FLAG_EXT_IRQ_ENABLED, &ab->dev_flags);
-
 	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
@@ -471,6 +469,8 @@ void ath11k_pcic_ext_irq_enable(struct ath11k_base *ab)
 		}
 		ath11k_pcic_ext_grp_enable(irq_grp);
 	}
+
+	set_bit(ATH11K_FLAG_EXT_IRQ_ENABLED, &ab->dev_flags);
 }
 EXPORT_SYMBOL(ath11k_pcic_ext_irq_enable);
 
-- 
2.43.0



