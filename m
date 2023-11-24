Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D40528DBB;
	Fri, 24 Nov 2023 19:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0dUwK4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF352C433C8;
	Fri, 24 Nov 2023 19:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852511;
	bh=tsBQnpPYU8zCYEvJkHf74Pfd/PNuo/p3mKrRN/tv3uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0dUwK4MoTMLIj9djTAWHdJHPTDpzZ5jsPE8wSU+4Sfaa4pjx2BLLiCkZ3scpcDAc
	 MLWTe+Cxk+qhBNKWfSAjb0ynOafOvXmOMerWavy4aCQ2Qvd4ZBeT+FyPRWOqxyJrfG
	 phXJnUt9n96IWUS6C4HEk0+k3/yWNU7puRGVMmIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/193] wifi: ath10k: Dont touch the CE interrupt registers after power up
Date: Fri, 24 Nov 2023 17:52:20 +0000
Message-ID: <20231124171947.699026457@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 170c75d43a77dc937c58f07ecf847ba1b42ab74e ]

As talked about in commit d66d24ac300c ("ath10k: Keep track of which
interrupts fired, don't poll them"), if we access the copy engine
register at a bad time then ath10k can go boom. However, it's not
necessarily easy to know when it's safe to access them.

The ChromeOS test labs saw a crash that looked like this at
shutdown/reboot time (on a chromeos-5.15 kernel, but likely the
problem could also reproduce upstream):

Internal error: synchronous external abort: 96000010 [#1] PREEMPT SMP
...
CPU: 4 PID: 6168 Comm: reboot Not tainted 5.15.111-lockdep-19350-g1d624fe6758f #1 010b9b233ab055c27c6dc88efb0be2f4e9e86f51
Hardware name: Google Kingoftown (DT)
...
pc : ath10k_snoc_read32+0x50/0x74 [ath10k_snoc]
lr : ath10k_snoc_read32+0x24/0x74 [ath10k_snoc]
...
Call trace:
ath10k_snoc_read32+0x50/0x74 [ath10k_snoc ...]
ath10k_ce_disable_interrupt+0x190/0x65c [ath10k_core ...]
ath10k_ce_disable_interrupts+0x8c/0x120 [ath10k_core ...]
ath10k_snoc_hif_stop+0x78/0x660 [ath10k_snoc ...]
ath10k_core_stop+0x13c/0x1ec [ath10k_core ...]
ath10k_halt+0x398/0x5b0 [ath10k_core ...]
ath10k_stop+0xfc/0x1a8 [ath10k_core ...]
drv_stop+0x148/0x6b4 [mac80211 ...]
ieee80211_stop_device+0x70/0x80 [mac80211 ...]
ieee80211_do_stop+0x10d8/0x15b0 [mac80211 ...]
ieee80211_stop+0x144/0x1a0 [mac80211 ...]
__dev_close_many+0x1e8/0x2c0
dev_close_many+0x198/0x33c
dev_close+0x140/0x210
cfg80211_shutdown_all_interfaces+0xc8/0x1e0 [cfg80211 ...]
ieee80211_remove_interfaces+0x118/0x5c4 [mac80211 ...]
ieee80211_unregister_hw+0x64/0x1f4 [mac80211 ...]
ath10k_mac_unregister+0x4c/0xf0 [ath10k_core ...]
ath10k_core_unregister+0x80/0xb0 [ath10k_core ...]
ath10k_snoc_free_resources+0xb8/0x1ec [ath10k_snoc ...]
ath10k_snoc_shutdown+0x98/0xd0 [ath10k_snoc ...]
platform_shutdown+0x7c/0xa0
device_shutdown+0x3e0/0x58c
kernel_restart_prepare+0x68/0xa0
kernel_restart+0x28/0x7c

Though there's no known way to reproduce the problem, it makes sense
that it would be the same issue where we're trying to access copy
engine registers when it's not allowed.

Let's fix this by changing how we "disable" the interrupts. Instead of
tweaking the copy engine registers we'll just use disable_irq() and
enable_irq(). Then we'll configure the interrupts once at power up
time.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2.c10-00754-QCAHLSWMTPL-1

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230630151842.1.If764ede23c4e09a43a842771c2ddf99608f25f8e@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 4870a3dab0ded..f7ee1032b1729 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -827,12 +827,20 @@ static void ath10k_snoc_hif_get_default_pipe(struct ath10k *ar,
 
 static inline void ath10k_snoc_irq_disable(struct ath10k *ar)
 {
-	ath10k_ce_disable_interrupts(ar);
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	int id;
+
+	for (id = 0; id < CE_COUNT_MAX; id++)
+		disable_irq(ar_snoc->ce_irqs[id].irq_line);
 }
 
 static inline void ath10k_snoc_irq_enable(struct ath10k *ar)
 {
-	ath10k_ce_enable_interrupts(ar);
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	int id;
+
+	for (id = 0; id < CE_COUNT_MAX; id++)
+		enable_irq(ar_snoc->ce_irqs[id].irq_line);
 }
 
 static void ath10k_snoc_rx_pipe_cleanup(struct ath10k_snoc_pipe *snoc_pipe)
@@ -1048,6 +1056,8 @@ static int ath10k_snoc_hif_power_up(struct ath10k *ar,
 		goto err_free_rri;
 	}
 
+	ath10k_ce_enable_interrupts(ar);
+
 	return 0;
 
 err_free_rri:
@@ -1209,8 +1219,8 @@ static int ath10k_snoc_request_irq(struct ath10k *ar)
 
 	for (id = 0; id < CE_COUNT_MAX; id++) {
 		ret = request_irq(ar_snoc->ce_irqs[id].irq_line,
-				  ath10k_snoc_per_engine_handler, 0,
-				  ce_name[id], ar);
+				  ath10k_snoc_per_engine_handler,
+				  IRQF_NO_AUTOEN, ce_name[id], ar);
 		if (ret) {
 			ath10k_err(ar,
 				   "failed to register IRQ handler for CE %d: %d\n",
-- 
2.42.0



