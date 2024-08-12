Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F2B134AC;
	Mon, 12 Aug 2024 16:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479993; cv=none; b=g3f2ujWafjg1J/hQHgWoSrvgDyQYjrChJiMQ67yS20oJ8qB7v84oDZ/B98zSbZDAClE+wzw6eD/J1soi/qmQp6KAFCgZHngH+QmjWmR41TZoUvzOQrPKYhqg6y3P9lmVpiXRy2LJ3FlJ/ZKqs1znOYZC0KUk7QIUrdC7IXUFXQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479993; c=relaxed/simple;
	bh=72bkisED54y7RcUhaqN2nxAF+iL194/g/qn6S22iqLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNt21SOnurVUB7olCKsjApnAMqgkHKrkUzrJvPn2GUJOIwdajImaGNL7FUG75+t3K8il2ckhjxZlRRzxY7dpeYQDfLaQJ5Qalgakz38sgP1VcuTgLjyQU3KTw0xtlafSu0q8gSMx6Rafiqe8XiQI66aTxQxGubVIKfVZsVqf5Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hb0SjdSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hb0SjdSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADB4C32782;
	Mon, 12 Aug 2024 16:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479993;
	bh=72bkisED54y7RcUhaqN2nxAF+iL194/g/qn6S22iqLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hb0SjdSYLs/k73ckSFAAj+sdzySMKifAgYaltAfw0vMK5dH7+OZHRftFWAiLWZ0bB
	 1bBLPVp+G5AqVd1efVPN9hJI7JMB46KxyPeI0zQVjOm7gQaGCIyBtrhoiGwkK5YU0B
	 MzHe9AyXGNCAnSKN9qDZyQfTjczAdTgfkoXEgZlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 064/263] wifi: ath12k: fix race due to setting ATH12K_FLAG_EXT_IRQ_ENABLED too early
Date: Mon, 12 Aug 2024 18:01:05 +0200
Message-ID: <20240812160148.994688689@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 0a993772e0f0934d730c0d451622c80e03a40ab1 ]

Commit 5082b3e3027e ("wifi: ath11k: fix race due to setting
ATH11K_FLAG_EXT_IRQ_ENABLED too early") fixes a race in ath11k
driver. Since ath12k shares the same logic as ath11k, currently
the race also exists in ath12k: in ath12k_pci_ext_irq_enable(),
ATH12K_FLAG_EXT_IRQ_ENABLED is set before NAPI is enabled.
In cases where only one MSI vector is allocated, this results
in a race condition: after ATH12K_FLAG_EXT_IRQ_ENABLED is set
but before NAPI enabled, CE interrupt breaks in. Since IRQ is
shared by CE and data path, ath12k_pci_ext_interrupt_handler()
is also called where we call disable_irq_nosync() to disable
IRQ. Then napi_schedule() is called but it does nothing because
NAPI is not enabled at that time, meaning that
ath12k_pci_ext_grp_napi_poll() will never run, so we have
no chance to call enable_irq() to enable IRQ back. Since IRQ
is shared, all interrupts are disabled and we would finally
get no response from target.

So port ath11k fix here, this is done by setting
ATH12K_FLAG_EXT_IRQ_ENABLED after all NAPI and IRQ work are
done. With the fix, we are sure that by the time
ATH12K_FLAG_EXT_IRQ_ENABLED is set, NAPI is enabled.

Note that the fix above also introduce some side effects:
if ath12k_pci_ext_interrupt_handler() breaks in after NAPI
enabled but before ATH12K_FLAG_EXT_IRQ_ENABLED set, nothing
will be done by the handler this time, the work will be
postponed till the next time the IRQ fires.

This is found during code review.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240524023642.37030-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 55fde0d33183c..f92b4ce49dfd4 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -1091,14 +1091,14 @@ void ath12k_pci_ext_irq_enable(struct ath12k_base *ab)
 {
 	int i;
 
-	set_bit(ATH12K_FLAG_EXT_IRQ_ENABLED, &ab->dev_flags);
-
 	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
 		napi_enable(&irq_grp->napi);
 		ath12k_pci_ext_grp_enable(irq_grp);
 	}
+
+	set_bit(ATH12K_FLAG_EXT_IRQ_ENABLED, &ab->dev_flags);
 }
 
 void ath12k_pci_ext_irq_disable(struct ath12k_base *ab)
-- 
2.43.0



