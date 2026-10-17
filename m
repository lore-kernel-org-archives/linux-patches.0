Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DB23AAF60;
	Sat, 17 Oct 2026 17:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258489; cv=none; b=WX1y6+tdkRZFTbRu1/hQt+X6eA6XQOhkbe2v8KF2Td/ZhqIwBZ5ob1Cn+PtRR3XFqj7CiM503OspowrfwKz7+Mf5XUeIlILCPLrWAWVdiUzElMQnYnBAC7hQkTtMEDZgsKKRI4cj7USL7nGm+X6RQVCwxKqdkbbtXXh/hHPlBt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258489; c=relaxed/simple;
	bh=YMcBpd6HXNi/FIVYALQsc/lBiQiyR5XTJVtB8MtqtNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3HpEwXAEIdxyh17LrltaUpdjlP58Bz3g1rU/tfYuxk2kIj1dYvThqFn92ULPNqL0R41WJR8OWWL43B20OZQYl5hP/BXtNxBsPxh6UKVLviaQEPeI+lEZbaiLJD/EFciw9jCHSCjVN0sZ95Utr3SEnAcOHOTk0IBtKZo6KRA9AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnZ1rPKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnZ1rPKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8EF1F000C4;
	Sat, 17 Oct 2026 17:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258487;
	bh=RTUk1RtRQ5vHNTXDX33BolRy/xyoAnX2XMaUMdFZBt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnZ1rPKIk0+hUNk8Fydm4qwMU0I/Vqew3s+S8+CkjhjU496NcGIGCcgjO4TF4qPE/
	 qoUTDkRH2fH9vgjctNgie5zcHrxrIrRt0+fQJGx4ujfNA/Xp47X2XE0yp1K3CUD3eE
	 7id3QqoqwU/GjWK05+yFFJPQf+FvPmhJW3UITBXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1543a7d954d9c6d00407@syzkaller.appspotmail.com,
	Guoyu Su <yss2813483011xxl@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0902/1674] net: use skb_header_pointer() for TCPv4 GSO frag_off check
Date: Sat, 17 Oct 2026 17:52:54 +0200
Message-ID: <20261017160454.280299985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index a2cb45938f562..502b22c604693 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3603,10 +3603,15 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	 * IPv4 header has the potential to be fragmented.
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
 			features &= ~NETIF_F_TSO_MANGLEID;
 	}
 
-- 
2.53.0



