Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C199D32A3FD;
	Wed,  8 Apr 2026 18:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673714; cv=none; b=pdN42AtSTMpjdMgdtmnCFDYuqEmkkQzoC7yEMiauNVziCUaN2Ibr3IkaknMO5VyBUEsQm18MIdPJg8x6kC40RcJIUNCnXWit91bRBRD396sfoGK/gxJWsDUF3BiFv6u1+Gx0JD9MWysGUcWRb/Z/qMJfEthCEpWf5+B3UiC5Y2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673714; c=relaxed/simple;
	bh=+nJ6H205fY+yS1pzemnMjEmLNjS+IdC4Zi9GTiM1L5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTqVXqUO+TYhPAH8K1aSlfHUU7jTEMybwXvCVWLvd0q9t4LYCOo9UZq5cfjkyfJT6/Eyvc0o3bwDfahTeHif2biItOrS5nPLZYF87u9VgHU8NBv8ZdRkCucCaJfgBn42Ra9S0spVaDAHwmJ0uiDSSEr0gHkkCgerHJTtPV1f9Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuyJozGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuyJozGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C28C19421;
	Wed,  8 Apr 2026 18:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673714;
	bh=+nJ6H205fY+yS1pzemnMjEmLNjS+IdC4Zi9GTiM1L5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuyJozGFht6GEaF6QNeADuilROpN7K+DczIFcMvxR4/RZUL4/jDFYIy7Ak9nf/Hba
	 kCBQazVR19dmJfyIUhGoKZuG8QWVENq+VXUwULLfKgN4Q97BnjW9/1qxslF2RNYPy1
	 ynIMCAi7MFbsgNopZc0gVR8Rz8A41j4VKIm4zjro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1543a7d954d9c6d00407@syzkaller.appspotmail.com,
	Guoyu Su <yss2813483011xxl@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/242] net: use skb_header_pointer() for TCPv4 GSO frag_off check
Date: Wed,  8 Apr 2026 20:01:41 +0200
Message-ID: <20260408175929.365051309@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2748ee051bd1b..9c4f0e5f2c136 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3609,10 +3609,15 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
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
 			features &= ~dev->mangleid_features;
 	}
 
-- 
2.53.0



