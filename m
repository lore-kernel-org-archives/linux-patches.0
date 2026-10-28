Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215301;
	b=4lnaqDvhRRcK/CRWpULpzY+p52lUtqe/ROWEnF/sa1O09VjxbLVOf3xDcfGPhFvscV5g
	 s5tFM1zQf6hxaE99/yaO6e4OT8UtyfT6fR7CgO1Ohu8xHjw8zBF7E7DnNkHzN8RGVIM68
	 19IWf8FItDQE6A906ebGmGEN/yRIR51AkAQEnS3dsd/iqLgGghOScYZBeQzA9FLHldUhE
	 xP/u+hJXWDmPYGePV5YcZQRbJpr0hmbLXeQF8xobFD545GLiYrGPC6gZvI9uARVdgee7A
	 sF+I4eVotd0Ob0kKTpnO29xbXDQKEI7WrgrJ9Q59hecP3jKLaM+vxaOPAa43EOcKV9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3chPYbm9TcgUVp6WzJ4gQx7dbF8Z6uKNryYHZ201GtU=;
	b=ur4iMr++36ipOLdDG/tlgytB0ESgq7qqZoanVi0lJ4sBwY03HkmqxnByQB9ID7RmEDeO
	 xpkWzbVrOYtOpT1koula+a4O/fm7jvHM+jd+zIakQ0UJ+Rdvg3beNFgZ1QvF/rCWiPUcU
	 kH7e10zgi8vOsvv71twS6KTcnzEKIbIeSSPd7TUtJ97nbOEyNTjxc8i9tsOnLC11wmHyz
	 3Mb7yJs+LDj9/YAefZOT+GaroJuT1+tPg8G7Nvu4dngSjc9WubZSgklhhJNxlewvVt8Cn
	 5/a5nWfDIh43g7huAXC7vz/YG4JK3n1NVEGuD/O2McMP7AankuOfVup+VrGMDtB/WAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ltSprf78;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F50A606A320;
	Wed, 28 Oct 2026 19:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ltSprf78
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941DB1F01829;
	Wed, 28 Oct 2026 19:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215301;
	bh=3chPYbm9TcgUVp6WzJ4gQx7dbF8Z6uKNryYHZ201GtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltSprf785az8he5NF464qek67NNmTjvC0CKeBKdqYFMaVncRooucvUMSIWsMvQkrN
	 lt1LeM5bpnvNNrAKpXCX45F1AgprTuFVY0+HZXacpRDkZ1G9ZTf47TehzNNeLtv20Z
	 MsubC6MtvzUifbtXBU7kj3da8Av9bA3y4teZ+KU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1136/1887] netfilter: bridge: eb_tables: close module init race
Date: Wed, 28 Oct 2026 17:53:52 +0100
Message-ID: <20261028170525.256402747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 27414ff1b287ea9a2a11675149ec28e05539f3cc ]

sashiko reports for unrelated patch:
 Does the core ebtables initialization in ebtables.c suffer from a similar race?
 Once nf_register_sockopt() completes, the sockopts are exposed globally.

sockopt has to be registered last, just like in ip/ip6/arptables.

Fixes: 5b53951cfc85 ("netfilter: ebtables: use net_generic infra")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 32e73f04d5b17..ca6f0b7710823 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2607,19 +2607,20 @@ static int __init ebtables_init(void)
 {
 	int ret;
 
-	ret = xt_register_target(&ebt_standard_target);
+	ret = register_pernet_subsys(&ebt_net_ops);
 	if (ret < 0)
 		return ret;
-	ret = nf_register_sockopt(&ebt_sockopts);
+
+	ret = xt_register_target(&ebt_standard_target);
 	if (ret < 0) {
-		xt_unregister_target(&ebt_standard_target);
+		unregister_pernet_subsys(&ebt_net_ops);
 		return ret;
 	}
 
-	ret = register_pernet_subsys(&ebt_net_ops);
+	ret = nf_register_sockopt(&ebt_sockopts);
 	if (ret < 0) {
-		nf_unregister_sockopt(&ebt_sockopts);
 		xt_unregister_target(&ebt_standard_target);
+		unregister_pernet_subsys(&ebt_net_ops);
 		return ret;
 	}
 
-- 
2.53.0



