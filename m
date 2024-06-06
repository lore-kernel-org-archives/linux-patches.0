Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD281A0AE5;
	Thu,  6 Jun 2024 14:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683639; cv=none; b=mhhhA/ooCk8fsg3MyZfeu+gcZKnxn3gptFB+e0EYRc5DJVKHMbPQtjtz9NjSjlWwqDQL7iPOmsD+Sfc3Vi+8NvFXco2ucgbiRg+eHY2GfVMN41MzacOdgHQIhRcCSZaDiAXMEJFrFUOuUMB+McGwEmHL7imxZl0WzYWHX/EUR5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683639; c=relaxed/simple;
	bh=TXd0TuzCp7RVjA7Ruc44Xv3b2yEYI16R69OTeCNZXxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyVtZg/61cZRGIkHoUCQqheNgALoNXlFpULLJpxlgt+fJvQNNeQxJhmWsFZ9D43TDNA7pZwKT5qssYrbFG2j8dfellu+Rk7GTljwPn1M77m+r+hiLvN5kFj6AiKwxTRKl7AyeOnyUmit2Msj1qLRD4zn2wI1ovfZHwaeX9KNfxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgZtwsfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgZtwsfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EF7C4AF0C;
	Thu,  6 Jun 2024 14:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683639;
	bh=TXd0TuzCp7RVjA7Ruc44Xv3b2yEYI16R69OTeCNZXxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgZtwsfybK86Xsp8PWwlR498AGZWxU9F3Ofe6AuB5A3KCpFwi4eQmWHfxNIeHV1H1
	 /J5awSY2IKJZvRqoaOGh1iAwDFQ+t5O0JUvmxw8RbVispC97jE5bfSNscUQP5G5ujA
	 VqBq5PYU5HorCu1lK0gXs3pFMv9CNqRTwr+WjG9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+b94a6818504ea90d7661@syzkaller.appspotmail.com
Subject: [PATCH 6.1 459/473] netfilter: tproxy: bail out if IP has been disabled on the device
Date: Thu,  6 Jun 2024 16:06:28 +0200
Message-ID: <20240606131714.858572282@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



