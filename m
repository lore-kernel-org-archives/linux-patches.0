Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F7A148FEB;
	Thu, 13 Jun 2024 12:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280239; cv=none; b=t7DxhvWMjZ3krad65XGBsYJiVmpb0RnrJafLEJLHI6xNTcmyT8w/r2lKBLmWxHH1iwkYxYCEqf9MvDtybZ7zn272vk0c7/aRZZ1XgAQ3neVGEgSSZOVwDUraOXsw7kUBPlC3whBDSk+LjHfwEmr25w+ozFBUVMLnPkj+96sQ9/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280239; c=relaxed/simple;
	bh=z0sRN5WE/PgwUbOhdgtC3zBo44SCOK72QCWPRMVMw8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qw6SePR16ntFECetPLBZGdd8j3o3KPSL/BuFcV1PaVIXNm3tOOfYW/6VkpFkheJnuv4xF3iX8l8N8zxaHUfLZTj7WUE3ThiZOvTwLjdig2DWz8nGfkBK+zMCZixPX7W0+9VDYQfuAIMmHlWvPnnX3CdRoVbykPHz9jSeaOe3mqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2ODDP0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2ODDP0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598C5C2BBFC;
	Thu, 13 Jun 2024 12:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280239;
	bh=z0sRN5WE/PgwUbOhdgtC3zBo44SCOK72QCWPRMVMw8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2ODDP0P2E3J/x84SbcLZBmi0zv6Ulq9zi14B2fOvrd+/PtIXGMgV+uegCKPd+yYX
	 RIBGlBvrlR7W4ELGF22M9M3GSFMy1+9RpE2FCP5QpZpvpZvcC6kYllZsA7jB7g2I4O
	 Vp95xthV/A5+TWlNO/i1oTr50M13hW20Pyy/K2Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+b94a6818504ea90d7661@syzkaller.appspotmail.com
Subject: [PATCH 5.4 158/202] netfilter: tproxy: bail out if IP has been disabled on the device
Date: Thu, 13 Jun 2024 13:34:16 +0200
Message-ID: <20240613113233.845157572@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



