Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2D71422B5;
	Thu, 13 Jun 2024 11:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278666; cv=none; b=YJUV2i+gNuW65pdYQTedBIkYChRWbXr+ViWCgt4pGb3XGeFXRwpnDYZ9xs23sZU3g1NhtkdizCqAVe6Dg6axGxBcgJr8En+AKJvGQ1qGalnF3jdDrN+QxfudflVN+r1e5Cvz6Ob/xT7xljCN4IT4xUhpMGxbVQ69qyjnDeqnOx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278666; c=relaxed/simple;
	bh=X4VrjcV36iz+e8dq+LZJtIxflw73vJWB4Ls2dM0o/qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJlPfNWcK4mfQg6qCB2Jx8XmUCM6cHh6XOTCCBkNCpOU/hHzxjiG944uHBaFK9AI1y51J3hYrRWbBgzNAkmvouoyQ3rIgDKPaTTXy48/4kvlJ0ZbbDxfvVxOYRpEsjcS4SVJJj0kBNC6nnqUqBNSGt+bZg5pVJSw8eacPbXL14s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwwodDdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwwodDdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B512FC32786;
	Thu, 13 Jun 2024 11:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278666;
	bh=X4VrjcV36iz+e8dq+LZJtIxflw73vJWB4Ls2dM0o/qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwwodDdPYb5oNFb9ekkSSqYTu6/EpAHHUSgbSzWnKhyJRRwDQSGi/z7plMPALhHnl
	 63Bej+dRxXllGJpjklnsmyJZF2NeAW2ahbBlgVPNRL1Pn/gJIjJ1hXEWq6JuS9dWGb
	 yi7hBzvYccnrKX4izGh2Hww7OZE9v11Glhby1kl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Prestwood <prestwoj@gmail.com>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/213] wifi: ath10k: poll service ready message before failing
Date: Thu, 13 Jun 2024 13:31:17 +0200
Message-ID: <20240613113229.122193011@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit e57b7d62a1b2f496caf0beba81cec3c90fad80d5 ]

Currently host relies on CE interrupts to get notified that
the service ready message is ready. This results in timeout
issue if the interrupt is not fired, due to some unknown
reasons. See below logs:

[76321.937866] ath10k_pci 0000:02:00.0: wmi service ready event not received
...
[76322.016738] ath10k_pci 0000:02:00.0: Could not init core: -110

And finally it causes WLAN interface bring up failure.

Change to give it one more chance here by polling CE rings,
before failing directly.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00157-QCARMSWPZ-1

Fixes: 5e3dd157d7e7 ("ath10k: mac80211 driver for Qualcomm Atheros 802.11ac CQA98xx devices")
Reported-by: James Prestwood <prestwoj@gmail.com>
Tested-By: James Prestwood <prestwoj@gmail.com> # on QCA6174 hw3.2
Link: https://lore.kernel.org/linux-wireless/304ce305-fbe6-420e-ac2a-d61ae5e6ca1a@gmail.com/
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240227030409.89702-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 41eb57be92220..967a39304648e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1697,12 +1697,32 @@ void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
 
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 {
-	unsigned long time_left;
+	unsigned long time_left, i;
 
 	time_left = wait_for_completion_timeout(&ar->wmi.service_ready,
 						WMI_SERVICE_READY_TIMEOUT_HZ);
-	if (!time_left)
-		return -ETIMEDOUT;
+	if (!time_left) {
+		/* Sometimes the PCI HIF doesn't receive interrupt
+		 * for the service ready message even if the buffer
+		 * was completed. PCIe sniffer shows that it's
+		 * because the corresponding CE ring doesn't fires
+		 * it. Workaround here by polling CE rings once.
+		 */
+		ath10k_warn(ar, "failed to receive service ready completion, polling..\n");
+
+		for (i = 0; i < CE_COUNT; i++)
+			ath10k_hif_send_complete_check(ar, i, 1);
+
+		time_left = wait_for_completion_timeout(&ar->wmi.service_ready,
+							WMI_SERVICE_READY_TIMEOUT_HZ);
+		if (!time_left) {
+			ath10k_warn(ar, "polling timed out\n");
+			return -ETIMEDOUT;
+		}
+
+		ath10k_warn(ar, "service ready completion received, continuing normally\n");
+	}
+
 	return 0;
 }
 
-- 
2.43.0



