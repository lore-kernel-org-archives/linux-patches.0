Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625893;
	b=3AWuaXMp76sOL8OgirPSaTPw/ICV2Q7oHVBuuN0bj20l1EB66dts80/bo0o9GWfYQzPW
	 0InenYXzUwkYne55lq0dBlcASaLgr/Z8jAwsS+Qr6Abm6mlL9uioMj+Xty7LXF8DsX7u9
	 XxIslw8deeyoJaSYlwG5/Dc6PSGvGJFUQ766fiyiD/6qN8uiBkqOOop8AoZgCpbyOnm5y
	 DFxNUyK6xTLtwHk6RUuLcylrfsswdxgYrcKa0/CfyrerTdnlifFba3cvyAX5pL7HRf/Bu
	 CpFJ1xgjJZTCzGniYq97rlc5E2yhX5AGivKCcbX0DQjZi1l16O/m1y4nLY5hJstGLww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z9QXju0vjXb2/2f4vKbcvMzWhAx5RypYODecQ/PQLN0=;
	b=loy0lydM5++CMWaDk6Af5mY29NV3qGhfKGemOgNY2XaFoF77d+36JU/IBDC6NZGyLAwy
	 CplVUbISV+Ok7oQ9h6B9rdNOMCLgQdRnbwEvJMNLontj628thaeurK/XQzofJ1JlCg3yF
	 U5bu6eDMh3kcJ3KnS+FTOoPOOQMQHYlothsNkL7YJstOWsIj26lKAEWhFiHXY/BO7a6w+
	 mpm2wn7MqgYxxnUFfPyWuxw1U+wFPKrmz5sEa8rN88uT5TdUoLwmUX8fXBEbiXLF2aqjR
	 4TGB4rPyLpwBLF6OEeLLGCvoq+Ga0NZVGPg7lgBXbnXbWvAwnrD7tFTT45ouU1zgX2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OE/tPxMl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C82606A338;
	Wed, 25 Nov 2026 16:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OE/tPxMl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C92F1F000C0;
	Wed, 25 Nov 2026 16:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625892;
	bh=Z9QXju0vjXb2/2f4vKbcvMzWhAx5RypYODecQ/PQLN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OE/tPxMlujBtdGJsZWcGl8W0Xz3ePeyeDTMe6lsgcepwfk3SFk4RNP3ywJjQVb9Bn
	 fqPm16y4ZZ7Ow7xgBA5pkuieQBtgojIDFNJ/rBLC5twpNuxMlGrnY0cfCN46xv3G1D
	 fb8St9Mvh0Pl+0dAOcl677v0klJQp6GZzVUPZ1dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 665/816] wifi: mac80211: recheck injected headers after removing FCS
Date: Wed, 25 Nov 2026 15:36:53 +0100
Message-ID: <20261125143904.570686864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
@@ -2553,6 +2553,12 @@ netdev_tx_t ieee80211_monitor_start_xmit
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
 


