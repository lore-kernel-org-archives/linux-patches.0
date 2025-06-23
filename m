Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CCC254B09;
	Mon, 23 Jun 2025 13:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685423; cv=none; b=jL/tTJXVJiEaF8Y46Y9WyYjw7zRW3CVOzl5a2o1OAaMVsnmx5xpfQ44u7Pi5JWLfteyqXpESSHtVU9KfVo0YIz7un+WTz3gmdATKQZLm0F7XOOB/bjr5DhM5hposnsjM0VAdJ9AVdFz/ly0ZTIpIvJUyWzWmPSyOte2EftGJMlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685423; c=relaxed/simple;
	bh=g0U+tGD+JPZ0LHpNGbRSAXbMSZONrFk/7BFBdhzqLZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOZBBMpsF/JgU0tZjN4bVv7fB+fBqNsSjDArlmMVEc5vaCm753k3U7+kN1y0cl9FtvavehbUdO35/j1vky7z/JNquHV/IIiOWY5AKwIkEBeTTR09CYLCnTnv0G6SESKR3V/4xOC4C6hdGEva0NY/M0epemPR00zg0LuJHH2VdQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBs8DTHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBs8DTHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804C3C4CEF1;
	Mon, 23 Jun 2025 13:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685422;
	bh=g0U+tGD+JPZ0LHpNGbRSAXbMSZONrFk/7BFBdhzqLZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBs8DTHeDjtTPFFJQuF49GF6UfZ0ZcopbXUuEPrcXO5WOTBX5zZc6STVuTHlq4gCl
	 nc8gRXdm9mzQJTpLM8UYmg5uHgHUesaYBxN4plVtvpftJlKwAQcrU0teWSCIVANNY6
	 Rz9x7I/lW0JABcLEXIa4eZEhMAux52yNzwp1gHI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stone Zhang <quic_stonez@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/411] wifi: ath11k: fix node corruption in ar->arvifs list
Date: Mon, 23 Jun 2025 15:03:01 +0200
Message-ID: <20250623130634.119462288@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 48a449fbd2bcc..e86ecdf433de5 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -968,6 +968,7 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
 void ath11k_core_halt(struct ath11k *ar)
 {
 	struct ath11k_base *ab = ar->ab;
+	struct list_head *pos, *n;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -981,7 +982,12 @@ void ath11k_core_halt(struct ath11k *ar)
 
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



