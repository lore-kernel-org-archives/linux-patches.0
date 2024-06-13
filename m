Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C67913D607;
	Thu, 13 Jun 2024 12:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281442; cv=none; b=lWoYzuUFd7MSJOW2X81Mp+w8kdoCn9kMcnFT4STOvBi/qtuI8uVIYZBM/QglyDNgIxbkevVV6zX32MnnGoxs4Y/2Q5/eSqYFDDqk/VnpAi2wdgzaz8ZKtOrJxi8Hcia8B6HM9SlX7cZxU7EFevJKxpcFP40//Kr3QeP2/XL6KnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281442; c=relaxed/simple;
	bh=3Mf8Ge05Hd9QcXTa/H1OM11PL5LpVfLLjcN1tENhtEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+/Mp6Dg4ZTLqy8gL3dRo2yJ7Nbymb7nQYuOVUxfPt8tz1u5FXGGUNpg+Lr66yZZhdHnKJvZm8Zj3eVhPE7xLM/7vT5+6gmfD6jvsJHe4G9vmhhpgrwZmfDQix4Ang7kLmDdEmCyumcyvDz39YAPFDC6nPHmAAVaB/BhfS8ID7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgRX6b5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgRX6b5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18674C2BBFC;
	Thu, 13 Jun 2024 12:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281442;
	bh=3Mf8Ge05Hd9QcXTa/H1OM11PL5LpVfLLjcN1tENhtEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgRX6b5t9YjCFWkY9SCFrmnziyp3LPBt+ZDsgQhCu/0godosCyRCOBPBSNqvNKr1e
	 1CUznOlZm2KCkIOeqzGj+JKaxTKamdS5QyXKaec249huJVaU7AZKCIWATPr3Lt0EME
	 HH7G5AYXfYvoPLZ8xWR9i/agToK05XFQu9dOeqfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+b94a6818504ea90d7661@syzkaller.appspotmail.com
Subject: [PATCH 5.10 256/317] netfilter: tproxy: bail out if IP has been disabled on the device
Date: Thu, 13 Jun 2024 13:34:34 +0200
Message-ID: <20240613113257.451916826@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 21a673bddc8fd4873c370caf9ae70ffc6d47e8d3 ]

syzbot reports:
general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
[..]
RIP: 0010:nf_tproxy_laddr4+0xb7/0x340 net/ipv4/netfilter/nf_tproxy_ipv4.c:62
Call Trace:
 nft_tproxy_eval_v4 net/netfilter/nft_tproxy.c:56 [inline]
 nft_tproxy_eval+0xa9a/0x1a00 net/netfilter/nft_tproxy.c:168

__in_dev_get_rcu() can return NULL, so check for this.

Reported-and-tested-by: syzbot+b94a6818504ea90d7661@syzkaller.appspotmail.com
Fixes: cc6eb4338569 ("tproxy: use the interface primary IP address as a default value for --on-ip")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_tproxy_ipv4.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index 61cb2341f50fe..7c1a0cd9f4359 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -58,6 +58,8 @@ __be32 nf_tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr)
 
 	laddr = 0;
 	indev = __in_dev_get_rcu(skb->dev);
+	if (!indev)
+		return daddr;
 
 	in_dev_for_each_ifa_rcu(ifa, indev) {
 		if (ifa->ifa_flags & IFA_F_SECONDARY)
-- 
2.43.0



