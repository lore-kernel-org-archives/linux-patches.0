Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32472257854;
	Thu, 28 May 2026 20:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999501; cv=none; b=nz6n7qlIrzhVklvw8V1cz7cM0fX3xnPCUgkbdieahPQlr8alFhughK1a2ONKdhRUn0ALXlGFzT9GBlLEs0QSoOF04JJnuFpNnXL7TDudVfAIMpZRbOLKZn6Hle2OKR+zRURTG5DhkUsjvk3GH0O+CbuStLQEd/OXV+M8udDfVI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999501; c=relaxed/simple;
	bh=yTUAlCqrZqiUXDPzHTsHpt4J9QWFA3/FFTq9qCCQg4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlFUMxeZksuBHd23FdVSj1NGi+YgLiCDqwYHWDfTMFsgqwbkWnQC2tYbAgkebXsAJFlsNz/mQUSWBBfqPEEtLNof8NVWimiLjIua3luYnGKnaHSXIhG/hkTtCTgDVTuCfUVHa1hDRapiK+KBWtQLkHGp0qcizwV55ryEv/pGnkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHX9Ia+R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHX9Ia+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908F71F00A3A;
	Thu, 28 May 2026 20:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999500;
	bh=tVqFxA22r6BDj4EwjMEy4/nxDiNDW7NpecBEMkkKrrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHX9Ia+RAuSXy6S9/wolQ4AN3qa/06gqzGs6MCKMlQ+Ll1FZrFAKko3T0WoDFE824
	 jN16IcqagN00P3E7cnkF+00jMJgUftviFLqtsEFsQsiIfTNQfdHo/5RnQItxD6o/SY
	 a6TBpDXpVOfgKPpeEoRPpfBocWDvIv8sNZCNQLng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheroz Juraev <goodmartiandev@gmail.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.18 090/377] wifi: iwlwifi: mld: stop TX during firmware restart
Date: Thu, 28 May 2026 21:45:28 +0200
Message-ID: <20260528194640.971451761@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -965,6 +965,16 @@ void iwl_mld_tx_from_txq(struct iwl_mld
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


