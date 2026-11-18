Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029215;
	b=hXoiTqovKIJg9Hni6zDVyRgQWZGl21ArIJgmi1v9byVrzv88oP94rdtzIfdusmqC+I/o
	 g8zXj73QVwwblcMntxkQ8MFpgCIpTp3cYopkz8A96EgMKMIJtIxxzEJuedmEu/24WoZut
	 0cW6TVi64D91DBxE9Rsw/iVovAgndjiwCL+Q8CAbxHC0Mts6IB8abdHro8zEIwQ8XnP5A
	 Q/DFP7LKAhAkJpsYsZ9NTtXrYbuZCYE1om3F67tPWfpZ6NQOhx6Fqt3bEvMy4Heesylvk
	 wt3sjXr8rMM9OVu1EeE6Y5GOT9dG3K/mfg/5IpZXmGEiU7Nf+LtJPijYVhCg8z8YhHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6CzwnkIkb3M32uUJIiQVP0O9DlH821B5E+Ko2XUwIwU=;
	b=mQOjyrOlITRksEstwcglophsbwIGmyGwIUfSCUpzt8DivOMER25UUumvuBz8uhgzm1Qj
	 AH8XFfM9XCvAh/alI9UMAhh3mUVNeMehvuN4gHEuXEAXsEUrJ0DFoTuBwdecWnR3v+WjM
	 P5ndaFxAolhxhCee16jolPUCXSywg7g2qKRD3NRduhXgxbL3MqtsD5d7F7R8CVvAHvUpV
	 oP0s67N5NNOg9xCsOtYiKvdJZo1tp210L16ue/ZCsdgLjhEfrPcDJUS52rASF77cuRsGw
	 CsVBeNWyYZY4SRs9xXsHL3MDDwrAC81cON/oli+U0L/0C3jI8+OPNETTWJNdw+BGL8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P/b5vg9Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EDF606A31C;
	Wed, 18 Nov 2026 19:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P/b5vg9Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76E71F000C4;
	Wed, 18 Nov 2026 19:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029215;
	bh=6CzwnkIkb3M32uUJIiQVP0O9DlH821B5E+Ko2XUwIwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/b5vg9ZMAOabVzgmh5+QdG/uZ8xJfVIBfhCYg3nXntiLEH3DX4753RCoImN0n/lh
	 Gvxv4B0JoNZaHNFxw1SVXOn4hN2ZrE5ngH+8VfZrfnwAxY1adgr48YWINmdxfLlVOl
	 xA2J3nht5mDaYlskEw0Yq7DUHS2n4u/q+3/BRqYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0220/1756] wifi: mac80211: fix key selection for encap offload frames
Date: Wed, 18 Nov 2026 15:39:07 +0100
Message-ID: <20261118150017.061084127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0e80db08668b560b3522849cb705623148bcd4b5 ]

ieee80211_tx_h_select_key() assumes the frame is in 802.11 format
for picking the key, at least when there's no pairwise TK for the
STA to transmit with.

For unicast this is likely not relevant because if there's no
pairwise TK for the STA there's probably not going to be any other
key either. But multicast encapsulation offload frames have no
STA, so it looks at the ethernet header as if it was 802.11. This
may not matter very much since multicast encapsulation offload is
likely to ignore the key selection, but it's still wrong.

Create a separate selection function that doesn't (need to) look
at the frame header - it's data anyway, so either unicast to a
station (with sta pointer) or multicast. For MLO, the driver has
to duplicate the frame and select the key anyway, so just skip
it in that case entirely.

Fixes: 50ff477a8639 ("mac80211: add 802.11 encapsulation offloading support")
Link: https://patch.msgid.link/20260802105818.0feb7ad61047.Ia506ca211176a3c466bc60e4cc3e506df34a4a67@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index bacc732df0c6d..2336786680e87 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -581,6 +581,34 @@ ieee80211_select_link_key(struct ieee80211_tx_data *tx)
 	return NULL;
 }
 
+/*
+ * An 802.3 frame is always a data frame, so there are no 802.11 addresses to
+ * look at: with a station the pairwise key is all that can apply, without one
+ * the frame is group addressed. On an MLD the driver has to pick the group key
+ * itself, as the same frame goes out on several links that each have their own.
+ */
+static ieee80211_tx_result
+ieee80211_select_key_8023(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+
+	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT))
+		return TX_CONTINUE;
+
+	if (tx->sta) {
+		tx->key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx]);
+		if (!tx->key)
+			tx->key = rcu_dereference(tx->sdata->default_unicast_key);
+	} else if (!ieee80211_vif_is_mld(&tx->sdata->vif)) {
+		tx->key = rcu_dereference(tx->sdata->deflink.default_multicast_key);
+	}
+
+	if (tx->key && tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
+		info->control.hw_key = &tx->key->conf;
+
+	return TX_CONTINUE;
+}
+
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
@@ -588,6 +616,9 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
+	if (info->control.flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
+		return ieee80211_select_key_8023(tx);
+
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) {
 		tx->key = NULL;
 		return TX_CONTINUE;
@@ -604,12 +635,6 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	else
 		tx->key = NULL;
 
-	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) {
-		if (tx->key && tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
-			info->control.hw_key = &tx->key->conf;
-		return TX_CONTINUE;
-	}
-
 	if (tx->key) {
 		bool skip_hw = false;
 
-- 
2.53.0



