Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033235;
	b=ioATyznBnpsmG105ncb+QLtSu3v74XF4aKrEEN7cihyaYqKEi+6K/BhPM9V7HXoGytdL
	 OiJsoLry+DTbbldQGbQwAnIkxZetGtaXg4dAdILRx7XUSd6L+US5CjKMiFlaW0Gk6BrQK
	 kyA5DD4v9W51OG9okxIP+EFiXVBd+jP4kQbQAs/fWV3mkfW603vkOtAUZgM3kloYSExFX
	 BsLaKpYI3mpAPwIcjZrvF8Gpt5NOdCh8Kk4b4kVK3VtQHL1EGO04KGbX/ZOowptKcv/xO
	 2JXyye+rfzw+Ro/ohpYw8nWV14ZokFk3oQEQfOZg0ubBpEwqFWbpJy2kJ8wFxak+VRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KIPTC5vbDaxij/i+Lrx1KCIzoeshsQzb7V8j4eUtMIE=;
	b=Q2VPHTqLUzhocIi3KLVIA/YTkjNVvwHdfjSx3KAVPnJqihNZQirJohwBmf+KmgOpRSS2
	 wQcD6ue8U7H74+8zmUqBE1rg5UxzOyy8y38DZGIx+/cDcxndAv4lJ278/DYUOasfCHqOp
	 QXUZWAO2AC7FsuTd2my0GUJVyXtkrpaFlX5riXNwLd75cWLvZvjvkkujDhUsWgex/S2u8
	 6KQr7PYq1aPKGr+L8t9NZOikbL2KBTxHHy1P6qLu1Bmx3EexkfxPMLdARbyyCuDkterS5
	 KB/B5G72ED+3YFXAUZw7mt3LDskIntGpz7Cs26wEbDsEjuCYy7otznQUn7ET4I/4ldg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IR7qWylL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6A4606A333;
	Wed, 18 Nov 2026 20:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IR7qWylL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26C31F000C4;
	Wed, 18 Nov 2026 20:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033235;
	bh=KIPTC5vbDaxij/i+Lrx1KCIzoeshsQzb7V8j4eUtMIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IR7qWylL4uwGNq3NJyOMDdx/AnFVbrud4jfp4u99aldI+Y5LRUdGMYNH3DgQ3IRCc
	 sUHgF7EgGwf7+2ne13pxwAn8ByxzYZfZ7v9j4dIOEcB5u5iwMALm06bsLviDIhO9Yf
	 /Fx6dyKj2egony2wiZzVJa6/6l2nvBtFvPBXcEy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1653/1756] ice: set in_use only after preparing Tx timestamp index
Date: Wed, 18 Nov 2026 16:03:00 +0100
Message-ID: <20261118150115.536599138@linuxfoundation.org>
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

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 50870d62116038e6f1e17a6aedcf2a95cec37ec7 ]

The ice_ptp_request_ts() function is used to request a timestamp index for
use with a packet. When reserving an index, it sets the start time and
saves a pointer to the skb into the appropriate index. The function marks
the in_use bit first before doing any of these steps. The IRQ handler which
clears the timestamps reads the in_use bits uses a lockless flow for
reading the in_use bits to determine which ones are in-use. This is
necessary as actually processing a complete timestamp must be able to sleep
so we cannot hold the timestamp tracker lock over the entire sequence.
Additionally, blocking the Tx hotpath with such a lock indefinitely would
be problematic.

However, the existing flow now has a very narrow window where the IRQ
handler could see a timestamp as in-use but read a stale value for its
"start" time.

Fix this by ordering the sequence to mark the in_use bit last, and add a
memory barrier to prevent re-ordering of the previous writes to setup the
index.

This was found and reported by Sashiko while reviewing an unrelated change.

Closes: https://sashiko.dev/#/patchset/20260821-jk-e825c-minimized-fixes-v1-0-9d0731eb4858%40intel.com?part=7
Fixes: ea9b847cda64 ("ice: enable transmit timestamps for E810 devices")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20261027-reduction-v1-2-81237c67a361@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index f0dab91ce831e..9587b807e6648 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -724,6 +724,12 @@ static void ice_ptp_process_tx_tstamp(struct ice_ptp_tx *tx)
 		bool drop_ts = !link_up;
 		struct sk_buff *skb;
 
+		/* Paired with smp_mb__before_atomic() in ice_ptp_request_ts()
+		 * to ensure ordering the in_use bitmap and the indexed fields
+		 * in the tstamps array.
+		 */
+		smp_rmb();
+
 		/* Drop packets which have waited for more than 2 seconds */
 		if (time_is_before_jiffies(tx->tstamps[idx].start + 2 * HZ)) {
 			drop_ts = true;
@@ -2642,11 +2648,13 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
 		 * a reference to the skb and the start time to allow discarding old
 		 * requests.
 		 */
-		set_bit(idx, tx->in_use);
-		clear_bit(idx, tx->stale);
 		tx->tstamps[idx].start = jiffies;
 		tx->tstamps[idx].skb = skb_get(skb);
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+		clear_bit(idx, tx->stale);
+		/* Ensure index is setup before marking it as used */
+		smp_mb__before_atomic();
+		set_bit(idx, tx->in_use);
 		ice_trace(tx_tstamp_request, skb, idx);
 	}
 
-- 
2.53.0



