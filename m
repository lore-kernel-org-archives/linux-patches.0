Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE56175A99;
	Mon, 17 Aug 2026 14:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976126; cv=none; b=VZrqQF9OViNyYd/MZjJhyhvZ8DfUnF6KWgk+ZxqV5RNJ8Bn2TrwPajIVfC8eHawtCwbshH3qUk1EznqcNiHQPHptmrGH5hHDAnlO2StWBfgPUBVtlucuzt7kDHyYrtYRWL+NBZAsx7drR1aRoFxpNQ2r14u/glEmryI0J969TZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976126; c=relaxed/simple;
	bh=qgI0Lxy5bphnHfTXCGEyM3QLfW3qV7vDQau305ctiKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAxeUMVwbckUZyFWPx9VVlWagDYkUuSYa5ZAZgaHTQwpxzyDDgGxSUrdAyP09asFN45iujXcPXHcjlrxtWrNpPs5lDx78PxTSPi1fFQVkV9vk6wCHU8zqBb3kB3act5PWWzpxJzXfilq/SjFhQlu6B4vUop/X0QsQb8gGt//M7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LU2qOaF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LU2qOaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20721F000E9;
	Mon, 17 Aug 2026 14:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976124;
	bh=4NOVpIV9+vPnUpIVBz4ivzb2TkPCvMQZHLZsSEK/stU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1LU2qOaFh+0pKNVuELE+xH6vWGIy9c1hrf6un6c2fMSWWr3eU1C/zGQ/7GB8Rc71g
	 uToxBLbN8W3IckROPMJ4a7hxZBBdQBXjnFzZVfemfOQFq18ERbI2/ARJa8qqQvkVOn
	 1C+Fu+U2cvc3Id0cHItHv0spXnLHnUUk0sAnqH/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 264/389] wifi: mwifiex: use the subframe length when parsing A-MSDU TDLS frames
Date: Mon, 17 Aug 2026 15:31:43 +0200
Message-ID: <20260817132549.479850729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -56,7 +56,7 @@ static int mwifiex_11n_dispatch_amsdu_pk
 			    ntohs(rx_hdr->eth803_hdr.h_proto) == ETH_P_TDLS) {
 				mwifiex_process_tdls_action_frame(priv,
 								  (u8 *)rx_hdr,
-								  skb->len);
+								  rx_skb->len);
 			}
 
 			if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)


