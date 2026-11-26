Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705537;
	b=j+2mXWqZCk99K0bT1DVnzyJRowczXtO5SZMqSeNG964Xeqzkzv5vnJChH5Ooy4HdxYEs
	 uc02hv/6LBmo7iU0+8P6x5OGcAadp9exqGaX7x7Uo+/FF6ZX7UhxBPwEAFfJwlPG35poM
	 mtoJMrzzNS+zewgA4nYKsw2hZsQrbXCeUJfHlguKsIEyX3bPA4dHmt0ZjQi5EP86G3PR0
	 fXrNv/6K/DvFDAv1F5eFBbBl7KsXlOPNgPGBdNjY9PZdUjHVJtV1+8xJdsDDpbdBALRkZ
	 UPgH0yA8xgCsxMmFPwyojCEZfL1pEp/ojQH/mwi9c6BaXL45hVCH+NWWOwcOwFCgNOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vg1vo/aFz0wC1k1DI+ujQ8iDHavhpF0cgHZ/4g94wVQ=;
	b=5I3pVhX1AGg/YTVXjQtAeMX0y+yF+aRS9YKyBpUvilEEZlLBGJfFemHmCX7eTfUJd/lM
	 W4Z9AgUB5J+vA6C0D7Xx9p7hhmOsPi59psTIDPsZMrz+Z8fW+S5/BmMxTr6kZy7a4RRf+
	 mMTPY46ppBhtLbB/kU7QD3vMFPmA9m7O/FbcWFaVTyAunINA0Hg1cDbAwVdg2kD1SuoZM
	 TElbEu0Q08WsLjbHBmSvnCvROOp2zBupwSNGT/gq5+SM0qj+cH2JlE2a2YzBKgQ9Q/neA
	 2VjttMz5hxeXUgKVgbfRAvGh0qn6eNVXqpMKVwNj5DMb7/9Kq4TineREk7aayOSz72g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HPy/514N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF63606A31E;
	Thu, 26 Nov 2026 15:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPy/514N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6231F000CF;
	Thu, 26 Nov 2026 15:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705536;
	bh=Vg1vo/aFz0wC1k1DI+ujQ8iDHavhpF0cgHZ/4g94wVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPy/514NX3s2+/+k81vGtTk5kznDT8GTKfcLdnw40ZhwyGswCR8M3ISN1zWStBZMy
	 XOBml5cFhn/oSTjLQgUdS0NjMmBBwQSWA8ArTe1d79CffVjmttQAYYxm6JEX2kDi/B
	 gEpsnTpbIe+4XZSyn+8YNg4/+KvX3wtS758/16gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 232/319] wifi: mac80211: recheck injected headers after removing FCS
Date: Thu, 26 Nov 2026 15:40:00 +0100
Message-ID: <20261126144011.985072332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit 339564c7ac50464695dfed847f89d118f4cc1dc5 upstream.

Injecting a short frame with IEEE80211_RADIOTAP_F_FCS on a monitor
interface can pass a truncated 802.11 header to transmit handlers.

ieee80211_monitor_start_xmit() validates the linear 802.11 header before
parsing radiotap. Radiotap parsing then removes the four-byte FCS without
rechecking the remaining header length. Software encryption can subtract
the larger header length and pass the resulting negative length as an
unsigned size.

Recheck the required linear header length after pulling the radiotap
header and before handing the frame to the transmit path. Require at
least addr1, which the transmit path reads even for extension frames
whose header is shorter.

LLM assistance was used to find the bug and review.

Fixes: bddc0c411a45 ("mac80211: Fix NULL ptr deref for injected rate info")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142101.11994-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/tx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2424,6 +2424,12 @@ netdev_tx_t ieee80211_monitor_start_xmit
 	/* remove the injection radiotap header */
 	skb_pull(skb, len_rthdr);
 
+	/* FCS removal may have shortened the 802.11 header. */
+	hdrlen = max_t(int, hdrlen,
+		       offsetofend(struct ieee80211_hdr, addr1));
+	if (skb_headlen(skb) < hdrlen)
+		goto fail_rcu;
+
 	ieee80211_xmit(sdata, NULL, skb);
 	rcu_read_unlock();
 


