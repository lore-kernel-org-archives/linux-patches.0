Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C3232BF5D;
	Thu, 28 May 2026 19:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998273; cv=none; b=g3eSdZPzC2tK9yulMeMGlQM5IXWwHFHEyadcrX/dEuTY5ZTGWNGnaJudLhEvCGeuOdiE376pFIg7LPlPYgP1qT2XSFiIZ0w0eHCKvhRx0wkbSgIitGQ/22rJpB2n8v1JtUD482b5/AA6HxhAoK+I02rSawkrKCsMV71vI2wa684=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998273; c=relaxed/simple;
	bh=vC+xNQKr/Eic/1mFqFCfSq2QU7VEE5AldwrEJONxNVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIgmNWCndHNADgQbALQmCoS5hc39VeAk3fK05KGKzW8J8ZjlUU6Eutq+Ojl/mq8m3MVVKzuAatWWHIko6y+EpZm6fSb/kg9IFjiBA6fxjkQov+lAB0iK9aac+3eXGUlNPkw3plcC6ad93VU9zh7ZG7h4fUwU7j8Plv4wmMA0788=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8+vRs63; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8+vRs63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31211F000E9;
	Thu, 28 May 2026 19:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998272;
	bh=eLNo8YGKJNtnff60yE/KX7cJDi1TfcvyoO80r38vIL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8+vRs63zHTT+kc7n6Pc1DZuuEjEwXK4SUMzTOr2PtSyd6+YxBc7mYFht3a+kMbsj
	 adJ9WvBNxXh+gDPzPZul0HglVz8IwiDmuykz8VVmdIkgOxvyoeK9ueFBFABvuiZJp8
	 JkQVejtOHf4qE6nMwwBgBPhO2hDuHqxMCd1+/vlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheroz Juraev <goodmartiandev@gmail.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 7.0 079/461] wifi: iwlwifi: mld: stop TX during firmware restart
Date: Thu, 28 May 2026 21:43:28 +0200
Message-ID: <20260528194649.205004264@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sheroz Juraev <goodmartiandev@gmail.com>

commit 2becb38a3e217ef2b2f42fddd7db7a25905ec291 upstream.

When iwlwifi firmware crashes (e.g., NMI_INTERRUPT_UNKNOWN on Intel
BE201/Wi-Fi 7), iwl_mld_nic_error() sets mld->fw_status.in_hw_restart
to true. However, iwl_mld_tx_from_txq() does not check this flag before
dequeuing frames from mac80211 and pushing them to the transport layer.

Since the firmware is dead, iwl_trans_tx() returns -EIO for each frame,
which then gets freed immediately. Under high-throughput conditions
(e.g., Tailscale UDP traffic or active SSH sessions), this creates a
tight dequeue-send-fail-free loop that wastes CPU cycles and generates
rapid skb allocation churn, leading to memory pressure from slab
fragmentation.

The RX path already has this guard (iwl_mld_rx_mpdu checks
in_hw_restart at rx.c:1906), and so does the TXQ allocation worker
(iwl_mld_add_txqs_wk at tx.c:156). Add the same guard to
iwl_mld_tx_from_txq() to stop all TX during firmware restart.

Frames left in mac80211's TXQs are naturally drained after restart
completes, when queue reallocation triggers iwl_mld_tx_from_txq()
via iwl_mld_add_txq_list(), or when new upper-layer traffic invokes
wake_tx_queue.

Tested on ASUS Zenbook 14 UX3405CA with Intel BE201 (Wi-Fi 7) on
kernel 6.19.5 where the firmware crashes approximately every 10-15
minutes under Tailscale traffic.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sheroz Juraev <goodmartiandev@gmail.com>
Link: https://patch.msgid.link/20260315081221.2678478-1-goodmartiandev@gmail.com
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/tx.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -971,6 +971,16 @@ void iwl_mld_tx_from_txq(struct iwl_mld
 	u8 zero_addr[ETH_ALEN] = {};
 
 	/*
+	 * Don't transmit during firmware restart. The firmware is dead,
+	 * so iwl_trans_tx() would return -EIO for each frame. Avoid the
+	 * overhead of dequeuing from mac80211 only to immediately free
+	 * the skbs, and the potential memory pressure from rapid skb
+	 * allocation churn during high-throughput restart scenarios.
+	 */
+	if (unlikely(mld->fw_status.in_hw_restart))
+		return;
+
+	/*
 	 * No need for threads to be pending here, they can leave the first
 	 * taker all the work.
 	 *


