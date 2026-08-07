Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9AF1C84D0;
	Fri,  7 Aug 2026 15:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116140; cv=none; b=SsngQNUxBtw1JNo1lXYA2Yxd+av8Ltq9vVC/I2HqS6M8DMZa6+9irwkH9y2wsAbs5EjYB4KpgrT9fnFdgX1TshcA1SF1/9V2wn/RCWBCDYlfZGfryihkKTrHcldMNg10O7osQKq6apWRweDPaRnabfGqtzUsLfL9NeUYGyBKKUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116140; c=relaxed/simple;
	bh=f3zLFLYpwHzGm9HLvSG2s/ei6ot6eBjmhU4of2/k1rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzYxvxSg+5zTUfm1YVWJ46UIWKy6UOdz8TxLge9Y5GpMrDgQ8h/LVcE9jaYlwf1LyUNeAo0jiWYM5JG0+dNNbVVvD4h6NOJb7fqzmQVaUasoZDBaO9taVqeummVT6twr5spVea0exU5bBtdAI5f3VAn1FJGwGACxLdC+CfM5oh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQ8KI5AB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQ8KI5AB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630AC1F000E9;
	Fri,  7 Aug 2026 15:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116138;
	bh=Vv1vK6OpdNjhiP763bGK3arSbNsFXFxU0TNTjougpzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQ8KI5ABH4W4C7S4UqNAaVYkTCAWJkzjQxNWv90bNEVQuno8aWwfxu75dqh3Hfhat
	 pC3T9sg0lDHGfHN6X4cmf1V/QlaYfbIzh1tP66xVMw3flUZPaPYO9NfWdAujrPsyTL
	 TNBlZNzBGeEa5FFPWQMSRfO7zbWvOwLJlSg6fofM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 127/261] wifi: mwifiex: use the subframe length when parsing A-MSDU TDLS frames
Date: Fri,  7 Aug 2026 16:38:04 +0200
Message-ID: <20260807143418.107379875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit 99a948382af8a225e2d5e54a7052158cd6281cc6 upstream.

mwifiex_11n_dispatch_amsdu_pkt() splits an A-MSDU with
ieee80211_amsdu_to_8023s() and walks the resulting subframes. For each
subframe it passes the subframe data pointer to
mwifiex_process_tdls_action_frame(), but pairs it with skb->len, the
length of the A-MSDU parent, instead of rx_skb->len:

	rx_skb = __skb_dequeue(&list);
	rx_hdr = (struct rx_packet_hdr *)rx_skb->data;
	if (ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
	    ntohs(rx_hdr->eth803_hdr.h_proto) == ETH_P_TDLS) {
		mwifiex_process_tdls_action_frame(priv, (u8 *)rx_hdr,
						  skb->len);
	}

The parent is not a valid description of that buffer, and may not be
valid memory at all. ieee80211_amsdu_to_8023s() ends with

	if (!reuse_skb)
		dev_kfree_skb(skb);

and it only sets reuse_skb when the parent is linear, is not a
head_frag, and is being consumed as the *last* subframe. So when the
parent does not qualify for reuse it has already been freed, and the
read of skb->len is a use-after-free. When it is reused, skb->len is
the length of the last subframe, applied to every earlier subframe,
which over-states the buffer whenever an earlier subframe is shorter.

The callee cannot absorb a wrong length, because it derives its own
ceiling from the value it is given. Each frame type computes

	ies_len = len - sizeof(struct ethhdr) - TDLS_*_FIX_LEN;

and the element walk is then bounded entirely against that ceiling,

	for (end = pos + ies_len; pos + 1 < end; pos += 2 + pos[1]) {
		u8 ie_len = pos[1];

		if (pos + 2 + ie_len > end)
			break;

so a too-large len moves end past the end of the subframe and the walk
reads and copies beyond it. The A-MSDU layout is chosen by the sender,
which makes the difference between the last subframe and a shorter
earlier one remotely selectable. Reaching this requires TDLS support in
firmware and the TDLS ethertype on the subframe.

The other caller, mwifiex_process_rx_packet(), is correct: it passes a
pointer and a length that describe the same region of the RX buffer.

Pass rx_skb->len, the length of the subframe actually being parsed.

Fixes: 776f742040ca ("mwifiex: fix AMPDU not setup on TDLS link problem")
Assisted-by: Codex:gpt-5.6-sol
Assisted-by: Kimi:K3
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260728115325.19128-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -44,7 +44,7 @@ static int mwifiex_11n_dispatch_amsdu_pk
 			    ntohs(rx_hdr->eth803_hdr.h_proto) == ETH_P_TDLS) {
 				mwifiex_process_tdls_action_frame(priv,
 								  (u8 *)rx_hdr,
-								  skb->len);
+								  rx_skb->len);
 			}
 
 			if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)


