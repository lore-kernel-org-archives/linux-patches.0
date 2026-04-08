Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B2B34AB06;
	Wed,  8 Apr 2026 18:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674466; cv=none; b=HJkjosJYYY5fLGN6n35mTtZimHcn8krzsZolEw3ZaYD9M5pPOiyodPatJ7FUcCwh2C4xiOKMs1coh0uOvWhjDxm2NphC21Z0QR57PD1qm8ffFFUA4hpqkaJaxZO83g93E+s3Rk6b7H3ahAB1FY3Mc40VYS6YLvK/W1U9h3dMhno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674466; c=relaxed/simple;
	bh=DasIIP8qYNyVhKmu4svHjd/qS0dJych17gkdGFQvsCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oF0lddCXy1jTqSu7194p4kIa/OwvW+h+dRFTzUwoDXu5nMztYmn/BqsyamRpZvPkO+77I6J4k/2/p+R9+ghQW0GlaanQMHg6lLBwh84f7cGymRoNYTUm0dHCOh2KxYP2DLqqmgrn01vgcKUxC/PvE0RB2UjssUgQF8yW8vXx79I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHMB+9f1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHMB+9f1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BA2C19421;
	Wed,  8 Apr 2026 18:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674466;
	bh=DasIIP8qYNyVhKmu4svHjd/qS0dJych17gkdGFQvsCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHMB+9f1X7UKegdwGRTsyUxJb+ar4EPtxnkZJH6kZxxTCUjKOpliojsYJL3sg4l6H
	 GJokdz7WNcc0hf7h/xMrc8T39fI4feyU+XFI1QtcwsPbCHAlHpBQ4Gc8t3lx+zwxlG
	 gdneg+UPTK3x2qUmGMd5oQS4xK7b9bG6KcFq9/Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1543a7d954d9c6d00407@syzkaller.appspotmail.com,
	Guoyu Su <yss2813483011xxl@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 066/311] net: use skb_header_pointer() for TCPv4 GSO frag_off check
Date: Wed,  8 Apr 2026 20:01:06 +0200
Message-ID: <20260408175941.880037711@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 8439bac371b7d..384250c3a519c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3815,10 +3815,15 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
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



