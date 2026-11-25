Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620072;
	b=GQLKzvlQq6CYljxOT96lROIelDi+k41V6y/Dh/7gsxyKiRc4B9st6WGOSdjluB+8C/e5
	 dEcXRKKoWR9CA4wHLU3LGGdCSGKR5iybW+nJWD2W+2uNtwLJ3yNjBhefvcTLoiiLWp6/e
	 Qi1ijWNgTXNJ1GVZDKSSEG0YQMhfSIPGEcPMAt5Rhz2UzKKEMe/DeSCc2OTzCvTv8LM8K
	 FI/X3HzDeuTeCj1WK/pTQlsN+6SvRNFRHI+fhb7J2IXFLSN0jeI7xDdn+PSS1l3lv+8Fd
	 WHEmoI5jhDZbBDUdvT45MiNad7gsGcJKSNHrsSwnV1t33Kuwd/3wTWx+6ahjIcJ3oNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iSByA0ZsSLk/PiVw502mFDAIV9BbQMeq9nuswzzlrTc=;
	b=YBpQD6SlcdLNLv4bVv0dPzJjW6y+TzzG2JJuFtBYeePZBF6/ThSdVnYAb1hdM6w/3A9w
	 37zYMcFNYIUoiM1FtmXP+A31TsJ9SgU+D9d5uTeTrnjztmOa3LcE7R+ZadXDdqn83Chz6
	 VBpkwmReXQsrlmFDWgLduFappHcGoaQBurYdFnuwm4XKEw8Q+keSSeNVnl4EHBwBFzosO
	 g6SVJr5HGB5ruCnkr5ET+xEeB9Rynt/VSR2Xurtc0n2fkaFl6O198pDGjM7k26TGySENd
	 mTJiP/EPg/xIW7SCdTAUKrKNkLcg3xHD9yhKmhppHHFV3Kt5ehD4TDJX4lo0rFDdxNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJ6YL8o3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F19E606A31E;
	Wed, 25 Nov 2026 15:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJ6YL8o3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0833D1F000C0;
	Wed, 25 Nov 2026 15:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620071;
	bh=iSByA0ZsSLk/PiVw502mFDAIV9BbQMeq9nuswzzlrTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJ6YL8o3JY0KDStq+V62Vgv1f2uLNixqCQpV8waEF13C3ZgMsNcU4NM2u156DnNX4
	 /NcDuETWk07G/EElYk/zmYXuIMCcXPaE2ltmRGlNIdjG/09s8BEnk680LlNluKSmr1
	 aBR7i/oX1IbrGdQiYt8moDz/Z2/MDF06qJQz2V0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.3 0800/1005] wifi: mac80211: recheck injected headers after removing FCS
Date: Wed, 25 Nov 2026 15:35:38 +0100
Message-ID: <20261125143840.475636814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2586,6 +2586,12 @@ netdev_tx_t ieee80211_monitor_start_xmit
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
 


