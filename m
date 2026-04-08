Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E093F37F01B;
	Wed,  8 Apr 2026 18:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672967; cv=none; b=Z9wYIfot1l8uwqw/TMkEhAO9+quqQ2xxx02C5CqxVy5NiTIgkPcICP1o/58E+LFg1FdLyYvEddkHGpZ01yzUOec7t7L8qnZmiXRfHOoNXJOG/cTnskpDjAQ76ypvoMaYevPf2UFWXPfRx1POUIKe1b0RVCqdGQGo4d53ZKXb7b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672967; c=relaxed/simple;
	bh=7D8zjF+dZyTUp6fXwCgRcLOfb/Lf//W0wBT4yznu5NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8fHR20VYe67BP7xX69GRXTNuBzALes6o0jLeJCylWG0584AIq7ronjyzUtJDcrg2T9vAH2xWdDFKmaxrroFlNPL7jgyEiH2Rqn+Xiys7g2zBcyuie1+IIWdtmyCnTgMLOZwAAgmaYrk3KlDuEezIS9oUIuLoqu0U4GvM8Se3NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tW7270B+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tW7270B+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785BBC19421;
	Wed,  8 Apr 2026 18:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672966;
	bh=7D8zjF+dZyTUp6fXwCgRcLOfb/Lf//W0wBT4yznu5NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tW7270B+2qHS0vs9EalK5VebgSvm6GLa0yrX8YdkMi0or4xXCs+E80g1MRlqgvLlR
	 mn3u/RUg+xUEiBbuiqHkPSzodqOArmro2QmkODd+JIFeRgkslJQy3z0JTfS+CJkYhP
	 CpX/gLcH3gDh3aPk/wkMOkd3umb1npHx3E5LO7k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1543a7d954d9c6d00407@syzkaller.appspotmail.com,
	Guoyu Su <yss2813483011xxl@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 050/277] net: use skb_header_pointer() for TCPv4 GSO frag_off check
Date: Wed,  8 Apr 2026 20:00:35 +0200
Message-ID: <20260408175935.725003568@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Guoyu Su <yss2813483011xxl@gmail.com>

[ Upstream commit ddc748a391dd8642ba6b2e4fe22e7f2ddf84b7f0 ]

Syzbot reported a KMSAN uninit-value warning in gso_features_check()
called from netif_skb_features() [1].

gso_features_check() reads iph->frag_off to decide whether to clear
mangleid_features. Accessing the IPv4 header via ip_hdr()/inner_ip_hdr()
can rely on skb header offsets that are not always safe for direct
dereference on packets injected from PF_PACKET paths.

Use skb_header_pointer() for the TCPv4 frag_off check so the header read
is robust whether data is already linear or needs copying.

[1] https://syzkaller.appspot.com/bug?extid=1543a7d954d9c6d00407

Link: https://lore.kernel.org/netdev/willemdebruijn.kernel.1a9f35039caab@gmail.com/
Fixes: cbc53e08a793 ("GSO: Add GSO type for fixed IPv4 ID")
Reported-by: syzbot+1543a7d954d9c6d00407@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1543a7d954d9c6d00407
Tested-by: syzbot+1543a7d954d9c6d00407@syzkaller.appspotmail.com
Signed-off-by: Guoyu Su <yss2813483011xxl@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260327153507.39742-1-yss2813483011xxl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 90b029c311a14..1ef939d935cf6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3791,10 +3791,15 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	 * segmentation-offloads.rst).
 	 */
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4) {
-		struct iphdr *iph = skb->encapsulation ?
-				    inner_ip_hdr(skb) : ip_hdr(skb);
+		const struct iphdr *iph;
+		struct iphdr _iph;
+		int nhoff = skb->encapsulation ?
+			    skb_inner_network_offset(skb) :
+			    skb_network_offset(skb);
 
-		if (!(iph->frag_off & htons(IP_DF)))
+		iph = skb_header_pointer(skb, nhoff, sizeof(_iph), &_iph);
+
+		if (!iph || !(iph->frag_off & htons(IP_DF)))
 			features &= ~dev->mangleid_features;
 	}
 
-- 
2.53.0



