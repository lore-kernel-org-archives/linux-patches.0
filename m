Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209492;
	b=Ul2MxwXSlbxOQ1owoI8zfXRMgVP5an+O5iZvVeDgfX6KU+AzwfPFVE7hS8CLG9NyIUs4
	 ITlGBCCL2xZU5ZlD7CNE3loNqIPw4wQnWGTQCCxMSGw9HScU9yZR/wsGYsOWaxFI3VCt7
	 Gdcr+HiJg25xemSAgKpIbh8gM8nqQZYlZ3yIRKeJQgZjywpg86s68DAw9hoAwdPk5GWUC
	 RgRAvzOnQnmbfqG42Rqt3tSzlCJRNVMkEY8T7vP68Gaad2OKfx0WWEoPggq3S3rz5z/rg
	 x5riJmT2speojfp0AJJ+wTIIbthTlFZmnK6exAyGtu3IPVoXCZGZa6J37rkRFM9qtWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ldkYVP2XG1NakVzQIRqOixi928oBwuJts4fGmfjHFj4=;
	b=TpR+xEHqsCBmNpdfli/HKvDqkJ8nFbDjtw6j7c0n5NUNGEBvMAcle3iolep7dVLehRDM
	 j5aPAyLc8J7WBrSgxUsmnGz2/0Zyz7vUuiUnSVjyYA3lfQQJQaGeyDqWvoBDizf0oQP5I
	 jPWTt9k6FG7NXhwiVF36jqFJIxAl/CNMst+u+kFVattXKvVO0p9aqJuFt9Fj+l6oJ0TLt
	 KmDKl+C1PI/ZIxgXhLlFpgn2hmSXVNwwBm/HAdv/YWolx4JoBKwa69p76T4xkE+gelKF4
	 nQo4nfV4os8OWJkehBLBvpFcGXUUL1zjs1VW1q9ESKphCmY5TRMHsvYlLv5V2cjgUhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7VmZ6Km;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0996606A31C;
	Wed, 28 Oct 2026 17:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7VmZ6Km
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9471F01829;
	Wed, 28 Oct 2026 17:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209491;
	bh=ldkYVP2XG1NakVzQIRqOixi928oBwuJts4fGmfjHFj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7VmZ6Kmg5fuLHFjmBGYoU8vmyPCUNzRbtlq3O6M0c92lJfbgTirAvtZpFp7PGR1C
	 SN+1/W0fuf0s+tqS2L2mWWJkFD0a7DoJ/yEpgcy5yrynpmowaHAip+Mtb1uqoQz/7T
	 /OTXsrXcgyf+m8ayhHxaStyaSmjFlPBESTKomLdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 490/516] netfilter: nf_tables: release flowtable after rcu grace period on error
Date: Wed, 28 Oct 2026 18:00:42 +0100
Message-ID: <20261028170015.084763961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d73f4b53aaaea4c95f245e491aa5eeb8a21874ce ]

Call synchronize_rcu() after unregistering the hooks from error path,
since a hook that already refers to this flowtable can be already
registered, exposing this flowtable to packet path and nfnetlink_hook
control plane.

This error path is rare, it should only happen by reaching the maximum
number hooks or by failing to set up to hardware offload, just call
synchronize_rcu().

There is a check for already used device hooks by different flowtable
that could result in EEXIST at this late stage. The hook parser can be
updated to perform this check earlier to this error path really becomes
rarely exercised.

Uncovered by KASAN reported as use-after-free from nfnetlink_hook path
when dumping hooks.

Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
[ Backport to 5.10.y: 5.10 registers the flowtable hooks before the
  transaction is allocated and has no err_flowtable_hooks label. As in
  the 5.15.y backport of this fix, call synchronize_rcu() in the
  nft_register_flowtable_net_hooks() failure branch, before the hooks
  and the flowtable are released. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 63592c73a7a17..95a03b01014e7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7296,6 +7296,7 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 					       &flowtable->hook_list,
 					       flowtable);
 	if (err < 0) {
+		synchronize_rcu();
 		nft_flowtable_hooks_destroy(&flowtable->hook_list);
 		goto err4;
 	}
-- 
2.53.0



