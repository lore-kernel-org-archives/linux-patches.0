Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354232DFF14;
	Tue, 17 Jun 2025 15:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175220; cv=none; b=GP3jp57dIkOQPYWYiv+racrlDa4EUcoFChjV5v5M1+ieJ0uV82hiDXGqQEG+UNieLry8jKE1ZVnrPlaf7uakaFQ+SKZPXmy8S2CzAYyNO9DEjCIbRU7H1nmyQCbA+fvfsc+T5gE37JQ5bQnmda+9gGRyY+47KddWqzo9fdE/0Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175220; c=relaxed/simple;
	bh=NaKwAF2bCRSrb6W2B8rTcHsbUQPdepgLhn8HYmw21C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGfEZ5BrMY7uqPYx+D5U7IIrZ/Rw4IiZtjTO6myllXJnTR3UQsNuUn/ZFVZc2VpVicd/UqF1nHZ8L2eIpp3MtQvyNJBcJiZJEjDiQf0lCGzXkirer6R57+vQn3gH4auwqAjOcINft1tqj0WqeQm4iahpd2UlE5Sjk26kaCPZ424=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aARsz+KJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aARsz+KJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FFBC4CEF0;
	Tue, 17 Jun 2025 15:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175219;
	bh=NaKwAF2bCRSrb6W2B8rTcHsbUQPdepgLhn8HYmw21C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aARsz+KJPdvCJ+vywwBfr3826N0DeeLqvSzOnRpXhXaaZ6YPVk63IAZiLUeieNc0+
	 kCJcxZiE3du34gP4WJGopUX3qUBfg+FjNvEz+/fpdOgv3wmDTp2dFvHdFD+fI6cVMO
	 OMRueAFGtFe9LsF4n8h0VsHHofeRnk4QPAYn5hAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stone Zhang <quic_stonez@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/512] wifi: ath11k: fix node corruption in ar->arvifs list
Date: Tue, 17 Jun 2025 17:21:11 +0200
Message-ID: <20250617152423.849577902@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Stone Zhang <quic_stonez@quicinc.com>

[ Upstream commit 31e98e277ae47f56632e4d663b1d4fd12ba33ea8 ]

In current WLAN recovery code flow, ath11k_core_halt() only
reinitializes the "arvifs" list head. This will cause the
list node immediately following the list head to become an
invalid list node. Because the prev of that node still points
to the list head "arvifs", but the next of the list head "arvifs"
no longer points to that list node.

When a WLAN recovery occurs during the execution of a vif
removal, and it happens before the spin_lock_bh(&ar->data_lock)
in ath11k_mac_op_remove_interface(), list_del() will detect the
previously mentioned situation, thereby triggering a kernel panic.

The fix is to remove and reinitialize all vif list nodes from the
list head "arvifs" during WLAN halt. The reinitialization is to make
the list nodes valid, ensuring that the list_del() in
ath11k_mac_op_remove_interface() can execute normally.

Call trace:
__list_del_entry_valid_or_report+0xb8/0xd0
ath11k_mac_op_remove_interface+0xb0/0x27c [ath11k]
drv_remove_interface+0x48/0x194 [mac80211]
ieee80211_do_stop+0x6e0/0x844 [mac80211]
ieee80211_stop+0x44/0x17c [mac80211]
__dev_close_many+0xac/0x150
__dev_change_flags+0x194/0x234
dev_change_flags+0x24/0x6c
devinet_ioctl+0x3a0/0x670
inet_ioctl+0x200/0x248
sock_do_ioctl+0x60/0x118
sock_ioctl+0x274/0x35c
__arm64_sys_ioctl+0xac/0xf0
invoke_syscall+0x48/0x114
...

Tested-on: QCA6698AQ hw2.1 PCI WLAN.HSP.1.1-04591-QCAHSPSWPL_V1_V2_SILICONZ_IOE-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Stone Zhang <quic_stonez@quicinc.com>
Link: https://patch.msgid.link/20250320053145.3445187-1-quic_stonez@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 7eba6ee054ffe..674c4763333f3 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1915,6 +1915,7 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
 void ath11k_core_halt(struct ath11k *ar)
 {
 	struct ath11k_base *ab = ar->ab;
+	struct list_head *pos, *n;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -1929,7 +1930,12 @@ void ath11k_core_halt(struct ath11k *ar)
 
 	rcu_assign_pointer(ab->pdevs_active[ar->pdev_idx], NULL);
 	synchronize_rcu();
-	INIT_LIST_HEAD(&ar->arvifs);
+
+	spin_lock_bh(&ar->data_lock);
+	list_for_each_safe(pos, n, &ar->arvifs)
+		list_del_init(pos);
+	spin_unlock_bh(&ar->data_lock);
+
 	idr_init(&ar->txmgmt_idr);
 }
 
-- 
2.39.5



