Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A501EA8D;
	Mon, 12 Aug 2024 16:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479189; cv=none; b=CGSqvn/wiKHIUnLM6yWyORMJbfVn4EW2YzZTBQXh7DMy4VRLylxzlib0zM1XXugqGV8b9i2q2ibkiBUwylO246HPResiBu+qXV+WzVBKSnU3i9G97DYM1mYJtreJ61+yLBR0XwjWwbOHmJ1iS5o4A4fJ26+yTqK+l+OYH6zI5Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479189; c=relaxed/simple;
	bh=HUfCjQFzlaEjX4dkDow1sM0TJFTp7QwCGUOB0dGQwLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCDRDWgojHddP+2VtpwhgOAOV0MVB5lRewAPaUURcBLvruK79pj9iw7MEsFRLd9XBAfni+5EV22qXP8e27lFMhIVYUD7yxNPNdmne0CEL5qVvjNMy731IL9U1R0q7ih5FDG+7GuzkFRdO22inSR+nuU4q2mnEWCgEtD3ZusQU9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bgk65a/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bgk65a/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87599C4AF0D;
	Mon, 12 Aug 2024 16:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479189;
	bh=HUfCjQFzlaEjX4dkDow1sM0TJFTp7QwCGUOB0dGQwLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bgk65a/taApuBAtTyKcHEMA4h27Rctqz/2KoJNiK2w8ybtiqqXxqUBNRVdybJWMwV
	 RDJFwwQWIfhcpHJc8s5Qpm7zk8WGgbeuuRN+buHxb7OTYnTYRwEvcP+5cILk7Byi1d
	 SXXAIddwATO/vBKf7VXwaEXasA2JLAL4YzfJGhGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <quic_kangyang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/189] wifi: ath12k: add CE and ext IRQ flag to indicate irq_handler
Date: Mon, 12 Aug 2024 18:01:06 +0200
Message-ID: <20240812160132.537190084@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kang Yang <quic_kangyang@quicinc.com>

[ Upstream commit 604308a34487eaa382c50fcdb4396c435030b4fa ]

Add two flags to indicate whether IRQ handler for CE and DP can be called.
This is because in one MSI vector case, interrupt is not disabled in
hif_stop and hif_irq_disable. So if interrupt is disabled, MHI interrupt
is disabled too.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4

Signed-off-by: Kang Yang <quic_kangyang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231121021304.12966-3-quic_kangyang@quicinc.com
Stable-dep-of: a47f3320bb4b ("wifi: ath12k: fix soft lockup on suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.h |  2 ++
 drivers/net/wireless/ath/ath12k/pci.c  | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index c926952c956ef..33f4706af880d 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -181,6 +181,8 @@ enum ath12k_dev_flags {
 	ATH12K_FLAG_REGISTERED,
 	ATH12K_FLAG_QMI_FAIL,
 	ATH12K_FLAG_HTC_SUSPEND_COMPLETE,
+	ATH12K_FLAG_CE_IRQ_ENABLED,
+	ATH12K_FLAG_EXT_IRQ_ENABLED,
 };
 
 enum ath12k_monitor_flags {
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index a6a5f9bcffbd6..f27b93c20a349 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -373,6 +373,8 @@ static void ath12k_pci_ce_irqs_disable(struct ath12k_base *ab)
 {
 	int i;
 
+	clear_bit(ATH12K_FLAG_CE_IRQ_ENABLED, &ab->dev_flags);
+
 	for (i = 0; i < ab->hw_params->ce_count; i++) {
 		if (ath12k_ce_get_attr_flags(ab, i) & CE_ATTR_DIS_INTR)
 			continue;
@@ -406,6 +408,10 @@ static void ath12k_pci_ce_tasklet(struct tasklet_struct *t)
 static irqreturn_t ath12k_pci_ce_interrupt_handler(int irq, void *arg)
 {
 	struct ath12k_ce_pipe *ce_pipe = arg;
+	struct ath12k_base *ab = ce_pipe->ab;
+
+	if (!test_bit(ATH12K_FLAG_CE_IRQ_ENABLED, &ab->dev_flags))
+		return IRQ_HANDLED;
 
 	/* last interrupt received for this CE */
 	ce_pipe->timestamp = jiffies;
@@ -428,6 +434,8 @@ static void __ath12k_pci_ext_irq_disable(struct ath12k_base *ab)
 {
 	int i;
 
+	clear_bit(ATH12K_FLAG_EXT_IRQ_ENABLED, &ab->dev_flags);
+
 	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
@@ -483,6 +491,10 @@ static int ath12k_pci_ext_grp_napi_poll(struct napi_struct *napi, int budget)
 static irqreturn_t ath12k_pci_ext_interrupt_handler(int irq, void *arg)
 {
 	struct ath12k_ext_irq_grp *irq_grp = arg;
+	struct ath12k_base *ab = irq_grp->ab;
+
+	if (!test_bit(ATH12K_FLAG_EXT_IRQ_ENABLED, &ab->dev_flags))
+		return IRQ_HANDLED;
 
 	ath12k_dbg(irq_grp->ab, ATH12K_DBG_PCI, "ext irq:%d\n", irq);
 
@@ -626,6 +638,8 @@ static void ath12k_pci_ce_irqs_enable(struct ath12k_base *ab)
 {
 	int i;
 
+	set_bit(ATH12K_FLAG_CE_IRQ_ENABLED, &ab->dev_flags);
+
 	for (i = 0; i < ab->hw_params->ce_count; i++) {
 		if (ath12k_ce_get_attr_flags(ab, i) & CE_ATTR_DIS_INTR)
 			continue;
@@ -956,6 +970,8 @@ void ath12k_pci_ext_irq_enable(struct ath12k_base *ab)
 {
 	int i;
 
+	set_bit(ATH12K_FLAG_EXT_IRQ_ENABLED, &ab->dev_flags);
+
 	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
-- 
2.43.0



