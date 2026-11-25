Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623310;
	b=T5UaaMAVNFxkqZ0RLTgeHmpJDafJlGzaljk4yIWQxZbOHrqs0r/nFLUssNY6KTpM6kzQ
	 Pk8InrHdfrqkFoHJWk9SsSKzOgrnTrv19SHfru0DSNDwnTLguIy8kC9UjMeHt4rescpuf
	 UcRnWV+spEbpbNiYVFO8LEYAIS6yx7+CttjvEY19OoxoBxcVzCKm4R/ARTypK6FkcEYtl
	 g/A0QTh/yE7t3dCR4XF+VvleoZh1ISfvnuK76jntU6qKfxXnyW7Nuu+c9e89hUCopfmuP
	 aVrsTPOTvHNHXaiwSV8hvENEVDl3EJE7gHqo0AYChzVI2CfISr988ox7oJ21vFLXgMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5/FCg521n8/j8v/3fBnoHWugNprS1lMdyeh110eOUhA=;
	b=qA/niaomg+X2GBHm38QEYOpyoG629tmzcyML6eAcKAu8ucWIYqeHPYIuiyuuulohNok6
	 gmMHm96rq8vKPCIZeBYrIc4BosGOg2+h5MzMl2SGnWdTNqiYA5GhjYE7FRY0gjdE1R/l8
	 roH2gdSocvFP5VRchf2IDR5kfiRBgoj8OlldoN3b3yPXiSn2cWEhSDti+g1MDpzw0Fa7Z
	 hXqmxZxfiW4sImncu0PXSC6BEj/stS3kFs7f8FAQaCL7evaw3l6yt9kCeVB7IKTpFYLKM
	 pEhlNxLNOh5PhTF6LjQGorvl7pbSrtdZK4miVE8/Hl84Vt/BCW2k+0D8BPyhrDOEUQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wwNdNRLI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8B2606A31E;
	Wed, 25 Nov 2026 16:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wwNdNRLI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421E81F000C6;
	Wed, 25 Nov 2026 16:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623309;
	bh=5/FCg521n8/j8v/3fBnoHWugNprS1lMdyeh110eOUhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wwNdNRLIK+ksGJJOuCdt/J3SJwHAA8CjbaeLI0Ian5Ctk7t/kpguvGHuIq27Re1by
	 DR1ZdK3NNHKBvlBsorc5fJt0f+UM+e8NqYGXnuxcSy4P/3uu+7Byr6t8A9xaB+L+bf
	 RhBtqHQ2Z0jJGtQ0hOU3v3+eE8bo5HGxpPYyoz9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 816/990] wifi: mac80211: recheck injected headers after removing FCS
Date: Wed, 25 Nov 2026 15:36:23 +0100
Message-ID: <20261125143841.155059350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2552,6 +2552,12 @@ netdev_tx_t ieee80211_monitor_start_xmit
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
 


