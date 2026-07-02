Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD9030C15A;
	Thu,  2 Jul 2026 16:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010791; cv=none; b=pffvyHdSUiBS96uHoY0gN9bX2zBlsXhGmugWtWppB4bi6xQokEEWvcMA0+rAeDLQpN49e1cOtXYsAc2k55fcywJnECKZWXboEtPFJ2lA10Av9VfOgXT19YgfyLkDh1psc+x6C9gYuC1A5tlNeDuWWOmUMqrmeTI3Pt8ysEIDVLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010791; c=relaxed/simple;
	bh=mJreA93oD+c8nqRqwE8tAGGq588QQkkjEkzM90mgl8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5DnbdMhdchLVMT8QL3+CifiEhVmLWoKV0dscZ1Ui+zidVM/w7tsPOTZtv8R5/VNCbH6H87hK9HoQU/S/gk+1Nl9Shc/iOFQ4g9BMPo+GvGuXSbYNftO7fFp4MK1UFS1s29HZwFec/ut2EJt/EdxSxIEZh8VdvF4Kc9mbQ3M45U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9ZCtzLN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9ZCtzLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DAF1F000E9;
	Thu,  2 Jul 2026 16:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010790;
	bh=q8fLjxaIuNTjuzTSpBgrPmkPUSh97mdUjPWLlMEN4a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9ZCtzLNNR4Nbaf73WByRo/E2Tqvvxqm0+sB/BHlJ3MmSNNLDR3FQg5OVWccZ+oXP
	 x+kQZJ1k8254ApzbWBwlKmpBAbG7bdx7HZiC9hfH/9/XJJic5xh4UATBCmQybfIvpS
	 kusczuJUq/mTRBt+dsIJsZ83l9Fr8s2Vz4itaj5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/175] phonet: Pass ifindex to fill_addr().
Date: Thu,  2 Jul 2026 18:18:58 +0200
Message-ID: <20260702155116.579387331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 08a9572be36819b5d9011604edfa5db6c5062a7a ]

We will convert addr_doit() and getaddr_dumpit() to RCU, both
of which call fill_addr().

The former will call phonet_address_notify() outside of RCU
due to GFP_KERNEL, so dev will not be available in fill_addr().

Let's pass ifindex directly to fill_addr().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 71de0177b28d ("net: phonet: free phonet_device after RCU grace period")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/phonet/pn_netlink.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/phonet/pn_netlink.c
+++ b/net/phonet/pn_netlink.c
@@ -19,7 +19,7 @@
 
 /* Device address handling */
 
-static int fill_addr(struct sk_buff *skb, struct net_device *dev, u8 addr,
+static int fill_addr(struct sk_buff *skb, u32 ifindex, u8 addr,
 		     u32 portid, u32 seq, int event);
 
 void phonet_address_notify(int event, struct net_device *dev, u8 addr)
@@ -31,7 +31,8 @@ void phonet_address_notify(int event, st
 			nla_total_size(1), GFP_KERNEL);
 	if (skb == NULL)
 		goto errout;
-	err = fill_addr(skb, dev, addr, 0, 0, event);
+
+	err = fill_addr(skb, dev->ifindex, addr, 0, 0, event);
 	if (err < 0) {
 		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
@@ -92,8 +93,8 @@ static int addr_doit(struct sk_buff *skb
 	return err;
 }
 
-static int fill_addr(struct sk_buff *skb, struct net_device *dev, u8 addr,
-			u32 portid, u32 seq, int event)
+static int fill_addr(struct sk_buff *skb, u32 ifindex, u8 addr,
+		     u32 portid, u32 seq, int event)
 {
 	struct ifaddrmsg *ifm;
 	struct nlmsghdr *nlh;
@@ -107,7 +108,7 @@ static int fill_addr(struct sk_buff *skb
 	ifm->ifa_prefixlen = 0;
 	ifm->ifa_flags = IFA_F_PERMANENT;
 	ifm->ifa_scope = RT_SCOPE_LINK;
-	ifm->ifa_index = dev->ifindex;
+	ifm->ifa_index = ifindex;
 	if (nla_put_u8(skb, IFA_LOCAL, addr))
 		goto nla_put_failure;
 	nlmsg_end(skb, nlh);
@@ -140,7 +141,7 @@ static int getaddr_dumpit(struct sk_buff
 			if (addr_idx++ < addr_start_idx)
 				continue;
 
-			if (fill_addr(skb, pnd->netdev, addr << 2,
+			if (fill_addr(skb, pnd->netdev->ifindex, addr << 2,
 					 NETLINK_CB(cb->skb).portid,
 					cb->nlh->nlmsg_seq, RTM_NEWADDR) < 0)
 				goto out;


