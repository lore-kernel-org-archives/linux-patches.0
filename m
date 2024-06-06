Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D8F1A186B;
	Thu,  6 Jun 2024 14:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683747; cv=none; b=VrGxA/bsx/UXgS9Uyld65F2VmqMfHEqGW1vA4pTfarY8TkdgA95ehvSsUivow+Fm2Pi+ohFGrdtchoFc04t2JL0Rrtk20Z/HO35hhLtrxhgB849a1oy+IXMkd/deZb/ri8vfyqURD+TI4IsVcQ4kMtec2hDsWRkBcciFqUizkzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683747; c=relaxed/simple;
	bh=Fzb9WOhf8YlhoDrUigfCIkgQBBffq2NfqVMY+sF6uAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIpixydSzo+FXKtsiz3/pCUZMTIBEMthfYaSGzAwi1e0w00ieHll/06n2bScZ/+fIzTbs7V/efpJTwGmH4dzw+dcqd/+lo/NDuGGi2cduPPx6qRU6G7eD+bT2LInAGoXnQxsxQt5QGb9JfbX8uAt0ry/bqraF4moYkUgXcfm1Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOutRQaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOutRQaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23ADFC2BD10;
	Thu,  6 Jun 2024 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683747;
	bh=Fzb9WOhf8YlhoDrUigfCIkgQBBffq2NfqVMY+sF6uAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOutRQaCZG+8PwPfBE5wCItL5Fgcw3WANsHa2g5soxpeYF+5Xz2sEQUt1aAIbQLaR
	 U9fJii2lyCLdRBCPQeDt1uEklWLTG6MX68EYVEciWRNy3QgpGhyUL5Mqcy8AYEgAw2
	 7wIa84V/tJ+X7mSBOsIUtRR/FxP1zRywAFpTt5oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+b94a6818504ea90d7661@syzkaller.appspotmail.com
Subject: [PATCH 6.6 713/744] netfilter: tproxy: bail out if IP has been disabled on the device
Date: Thu,  6 Jun 2024 16:06:25 +0200
Message-ID: <20240606131755.343360391@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 69e3317996043..73e66a088e25e 100644
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



