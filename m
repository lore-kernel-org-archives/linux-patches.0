Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C720915AD3
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AD3C433CA;
	Wed, 20 Sep 2023 12:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213542;
	bh=Jq1xqmxdyJ6ZH4Zba26sqZgJuRrRPJgYrdx9bzv6bIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YwWI2Cm7jat5uY73IV4kQVT3FOMO+WoqTJFS2des/B7GuYuex92/kzdxXmQDOuxMZ
	 9+hfhbMWDA8UY3fyEHlzGsBOgAFaOI/SvpOj0UPFoDK/NmOaEjUHZ4sjtN7fKIu/v9
	 dEfoNtNKtaveSdvhMUSNuuzB27ao5Z6jBzZ6NLOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Leong <wmliang@infosec.exchange>,
	Wander Lairson Costa <wander@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 276/367] netfilter: nfnetlink_osf: avoid OOB read
Date: Wed, 20 Sep 2023 13:30:53 +0200
Message-ID: <20230920112905.707349264@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit f4f8a7803119005e87b716874bec07c751efafec ]

The opt_num field is controlled by user mode and is not currently
validated inside the kernel. An attacker can take advantage of this to
trigger an OOB read and potentially leak information.

BUG: KASAN: slab-out-of-bounds in nf_osf_match_one+0xbed/0xd10 net/netfilter/nfnetlink_osf.c:88
Read of size 2 at addr ffff88804bc64272 by task poc/6431

CPU: 1 PID: 6431 Comm: poc Not tainted 6.0.0-rc4 #1
Call Trace:
 nf_osf_match_one+0xbed/0xd10 net/netfilter/nfnetlink_osf.c:88
 nf_osf_find+0x186/0x2f0 net/netfilter/nfnetlink_osf.c:281
 nft_osf_eval+0x37f/0x590 net/netfilter/nft_osf.c:47
 expr_call_ops_eval net/netfilter/nf_tables_core.c:214
 nft_do_chain+0x2b0/0x1490 net/netfilter/nf_tables_core.c:264
 nft_do_chain_ipv4+0x17c/0x1f0 net/netfilter/nft_chain_filter.c:23
 [..]

Also add validation to genre, subtype and version fields.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Reported-by: Lucas Leong <wmliang@infosec.exchange>
Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_osf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 9dbaa5ce24e51..573a372e760f4 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -316,6 +316,14 @@ static int nfnl_osf_add_callback(struct net *net, struct sock *ctnl,
 
 	f = nla_data(osf_attrs[OSF_ATTR_FINGER]);
 
+	if (f->opt_num > ARRAY_SIZE(f->opt))
+		return -EINVAL;
+
+	if (!memchr(f->genre, 0, MAXGENRELEN) ||
+	    !memchr(f->subtype, 0, MAXGENRELEN) ||
+	    !memchr(f->version, 0, MAXGENRELEN))
+		return -EINVAL;
+
 	kf = kmalloc(sizeof(struct nf_osf_finger), GFP_KERNEL);
 	if (!kf)
 		return -ENOMEM;
-- 
2.40.1



