Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10553126D8;
	Mon, 13 Oct 2025 15:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370027; cv=none; b=WpoU7NKtFB8BZ8kDP/9uZbbHEbeI6YveR2PW+L/TMFKvH/t6Xb7um7dVrmvyVrvGY890QaeRTG0iuPQvObh5IOttHmPsWDl5GA49/ljRtOGYt6Qiv51pKqrIHpERixbzn06YGLlS9a1hQD3HuHzdv6CQ4XhVi/0/IJH+TMIyfMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370027; c=relaxed/simple;
	bh=FsLplzXsr9d9cuok2qR8cTaprG+wiCz6KEnJwvHdAZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ztsa+5dZblYsp1rVwkYMkU+7IJSqDXNPqxa+vhA/fJ+ZSJo3+37MsM4soUKgTVSeLRWMoGdZAiKbzJNjlpqVTzkRrKFCtbSREGfDvoFqU0hdUrziu+ofKQuEMrlxS/x7TlJObQFE9TwO2o2dzX1AczvsZ0LdkCZPJjAEtqZk4lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaC6kLUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaC6kLUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BFAC4CEE7;
	Mon, 13 Oct 2025 15:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370026;
	bh=FsLplzXsr9d9cuok2qR8cTaprG+wiCz6KEnJwvHdAZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaC6kLUWwZaavCtTjS5BO2pZMhDvODzOp03NoXpoHwXxikw61MR2DOr54uC/u7ZPo
	 Dq2JYcmBtDSphq9dzOQrtkoQdb6iz8oHHdQeh37CRq5dYEr70kmXnZM/++ACbY55J/
	 qxH1vb+tzpMr3F2aXaRofH6Np9k59eEHKok31NoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 419/563] wifi: ath12k: Refactor RX TID deletion handling into helper function
Date: Mon, 13 Oct 2025 16:44:40 +0200
Message-ID: <20251013144426.468095412@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>

[ Upstream commit 7c32476253f11210ac24c7818ca07e19bc032521 ]

Refactor RX TID deletion handling by moving the REO command
setup and send sequence into a new helper function:
ath12k_dp_rx_tid_delete_handler().

This improves code readability and modularity, and prepares
the codebase for potential reuse of the REO command logic in
other contexts where RX TID deletion is required.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250806111750.3214584-3-nithyanantham.paramasivam@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Stable-dep-of: 5e32edc69425 ("wifi: ath12k: Fix flush cache failure during RX queue update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 27 +++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index adb0cfe109e67..8c61c7f3bbdc9 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -21,6 +21,9 @@
 
 #define ATH12K_DP_RX_FRAGMENT_TIMEOUT_MS (2 * HZ)
 
+static int ath12k_dp_rx_tid_delete_handler(struct ath12k_base *ab,
+					     struct ath12k_dp_rx_tid *rx_tid);
+
 static enum hal_encrypt_type ath12k_dp_rx_h_enctype(struct ath12k_base *ab,
 						    struct hal_rx_desc *desc)
 {
@@ -769,6 +772,21 @@ static void ath12k_dp_rx_tid_del_func(struct ath12k_dp *dp, void *ctx,
 	rx_tid->qbuf.vaddr = NULL;
 }
 
+static int ath12k_dp_rx_tid_delete_handler(struct ath12k_base *ab,
+					     struct ath12k_dp_rx_tid *rx_tid)
+{
+	struct ath12k_hal_reo_cmd cmd = {};
+
+	cmd.flag = HAL_REO_CMD_FLG_NEED_STATUS;
+	cmd.addr_lo = lower_32_bits(rx_tid->qbuf.paddr_aligned);
+	cmd.addr_hi = upper_32_bits(rx_tid->qbuf.paddr_aligned);
+	cmd.upd0 |= HAL_REO_CMD_UPD0_VLD;
+
+	return ath12k_dp_reo_cmd_send(ab, rx_tid,
+				      HAL_REO_CMD_UPDATE_RX_QUEUE, &cmd,
+				      ath12k_dp_rx_tid_del_func);
+}
+
 static void ath12k_peer_rx_tid_qref_setup(struct ath12k_base *ab, u16 peer_id, u16 tid,
 					  dma_addr_t paddr)
 {
@@ -828,20 +846,13 @@ static void ath12k_peer_rx_tid_qref_reset(struct ath12k_base *ab, u16 peer_id, u
 void ath12k_dp_rx_peer_tid_delete(struct ath12k *ar,
 				  struct ath12k_peer *peer, u8 tid)
 {
-	struct ath12k_hal_reo_cmd cmd = {};
 	struct ath12k_dp_rx_tid *rx_tid = &peer->rx_tid[tid];
 	int ret;
 
 	if (!rx_tid->active)
 		return;
 
-	cmd.flag = HAL_REO_CMD_FLG_NEED_STATUS;
-	cmd.addr_lo = lower_32_bits(rx_tid->qbuf.paddr_aligned);
-	cmd.addr_hi = upper_32_bits(rx_tid->qbuf.paddr_aligned);
-	cmd.upd0 = HAL_REO_CMD_UPD0_VLD;
-	ret = ath12k_dp_reo_cmd_send(ar->ab, rx_tid,
-				     HAL_REO_CMD_UPDATE_RX_QUEUE, &cmd,
-				     ath12k_dp_rx_tid_del_func);
+	ret = ath12k_dp_rx_tid_delete_handler(ar->ab, rx_tid);
 	if (ret) {
 		ath12k_err(ar->ab, "failed to send HAL_REO_CMD_UPDATE_RX_QUEUE cmd, tid %d (%d)\n",
 			   tid, ret);
-- 
2.51.0



