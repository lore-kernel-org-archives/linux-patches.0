Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BA03D6CB4;
	Fri,  9 Oct 2026 14:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555847; cv=none; b=AL80tTwLpa7gqwZWusBQLCfzb79Jb61Zy/GUf14UKnh6fgM+aZi8kK4SP8DbnOo2zOAjHMUxsGySrnANxSCcRO6yEc9P6XyQB424xQliLWLqDnKBuvF/hM2XP97o0zeMAYab9Gac2mKx7oe5FW5QFGyBYQKDZRuZb3GMODkze1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555847; c=relaxed/simple;
	bh=Zn0KyTrLCamDkunvoj4EcArNbQeD01Ejj/3Lw2aaryk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+aIxJtp5AkSv6vA81cRMrC9Tu/cz2lsPpffOPf1hSIWHlYM4xL3BCesDPIRf0GatlsccWctD4AGUOHp3Lr8wq0c8xHhmizSK4OevjwAvgYC+Sc98NXMKpXYartf1lOBqzjJB5CYN6kZHLEcTzW2cEzWThOjPwUNn4HNUR/jia8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lx1vl5dY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lx1vl5dY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3621F000FF;
	Fri,  9 Oct 2026 14:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555846;
	bh=MoHjTAePVSUizalizNw8lA6NCSFyYPIqVXMnb50wDho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lx1vl5dY9tyjpPCSloY3rLGFhynUMNFqmHPTcpH4WW+WE9jvwdk4XczGg+ayHha/4
	 aBM1OCBHz1BMTH4qxEeYQ+n7OlPc9s38hyQBbr5R1tSrMtlEavREgv1w7A/An9Rwzb
	 etUUwHcu0WoyuF3erY5P4p+O84aiKrnakfVgUE14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 079/428] wifi: mac80211: drop oversized fragments to avoid extra_len overflow
Date: Fri,  9 Oct 2026 16:06:56 +0200
Message-ID: <20261009140947.905848735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchao Zhang <ndaugoing@gmail.com>

[ Upstream commit 5e4f3509793b4db2c0835340224743db680e861f ]

In ieee80211_rx_h_defragment(), fragment payloads are accumulated into
entry->extra_len as subsequent fragments arrive:

        entry->extra_len += rx->skb->len;

When the final fragment arrives, the head fragment is dequeued, and
pskb_expand_head() is called with entry->extra_len to ensure sufficient
tailroom for all queued fragments before copying:

        if (skb_tailroom(rx->skb) < entry->extra_len) {
                if (unlikely(pskb_expand_head(rx->skb, 0, entry->extra_len,
                                              GFP_ATOMIC))) {
                        ...
                }
        }
        while ((skb = __skb_dequeue(&entry->skb_list))) {
                skb_put_data(rx->skb, skb->data, skb->len);
                dev_kfree_skb(skb);
        }

In commit 69f132236827 ("mac80211: shrink struct
ieee80211_fragment_entry"), entry->extra_len was narrowed from unsigned
int to u16 in order to reduce structure memory footprint.

However, an IEEE 802.11 frame sequence can contain up to 16 fragments
(frag numbers 0..15). If a sequence of large fragments arrives (e.g. from
a malicious peer or rogue AP), the sum of fragment lengths can exceed
65535 bytes (for example, 15 fragments of 4400 bytes total 66000 bytes).
Because extra_len is a u16, this addition overflows and wraps around
modulo 65536 (e.g. 66000 wraps to 464).

Consequently, pskb_expand_head() allocates only the truncated amount of
tailroom (or is skipped entirely if the head fragment already has >= 464
bytes of tailroom). When skb_put_data() subsequently iterates through the
queued skb list, it appends the full payload into the undersized buffer,
causing skb_put() to trigger skb_over_panic() and crash the kernel in
softirq context.

A legitimate MSDU in IEEE 802.11 is at most 2304 bytes (or up to 7935/11454
bytes for A-MSDU, which is not fragmented), well below U16_MAX.

Fix this without increasing the size of struct ieee80211_fragment_entry by
checking whether adding the incoming fragment length would exceed U16_MAX.
If so, purge the queued fragments and drop the frame.

Fixes: 69f132236827 ("mac80211: shrink struct ieee80211_fragment_entry")
Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
Link: https://patch.msgid.link/20260918034004.85078-2-ndaugoing@gmail.com
[assign a separate drop reason]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/drop.h | 1 +
 net/mac80211/rx.c   | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/net/mac80211/drop.h b/net/mac80211/drop.h
index f06a8aa905c53..f433ee17cce51 100644
--- a/net/mac80211/drop.h
+++ b/net/mac80211/drop.h
@@ -108,6 +108,7 @@ typedef unsigned int __bitwise ieee80211_rx_result;
 	R(RX_DROP_U_UNHANDLED_PREQ)		\
 	R(RX_DROP_U_UNHANDLED_MGMT_STYPE)	\
 	R(RX_DROP_U_NO_LINK)			\
+	R(RX_DROP_U_DEFRAG_OVERFLOW)		\
 /* this line for the trailing \ - add before this */
 
 /* having two enums allows for checking ieee80211_rx_result use with sparse */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5e26be8e27d8f..7ead509304ebe 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2499,6 +2499,12 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	}
 
 	skb_pull(rx->skb, ieee80211_hdrlen(fc));
+	if (unlikely((u32)entry->extra_len + rx->skb->len > U16_MAX)) {
+		I802_DEBUG_INC(rx->local->rx_handlers_drop_defrag);
+		__skb_queue_purge(&entry->skb_list);
+		return RX_DROP_U_DEFRAG_OVERFLOW;
+	}
+
 	__skb_queue_tail(&entry->skb_list, rx->skb);
 	entry->last_frag = frag;
 	entry->extra_len += rx->skb->len;
-- 
2.53.0



