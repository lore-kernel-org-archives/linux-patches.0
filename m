Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45492233D9E;
	Sat, 30 May 2026 18:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165077; cv=none; b=un99EVS6ae2HZvpWAeZc5dsjGmJEYoZs9on6CgLKmp9L0BsSovjnjJTfVfcblL+K/8RFEMUl8IS059b611MbuxRB9JWDAJ/DcN6bFJZ10OSUrU0IHKuC8sbpecCIFFndBunElypI6QyjhMqhS2dGu+LVYXtZOiiK6O0lhi7nMtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165077; c=relaxed/simple;
	bh=yAVb8fz5NyEJ66S+fc7IW6yHA1wsKWVWnGlGfv2+66U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPNmjM8021FBGZMffEPkH3j7W72+mEoKte4RLilAsNVew3OVtax+7al57tkTDpdWmHAypeO8zaSCLfhj4gvAWE0TZ1jeYT0mk1MLqr0dKh2Ek0eXF+FGCsO5Yp8fQYx8RHUw+R0M8BLJXJHOs7sl0zH+bUGUxC6wKTzgLZNI9QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPRggBk8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPRggBk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8896D1F00893;
	Sat, 30 May 2026 18:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165076;
	bh=+fB9sseWT7NvFHsyM6+5gARUYEPLZPkQeDkko0/mKDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iPRggBk88Zo9EY9bKw3Socyqt6szcN+CwQZnI7mb6FzEJAgk7QUJRJwngUmbN1SRH
	 pN/+ouaZlA27pYLfX8wy3BYYc+XwfazDserO43vj2lBekXBlL/33neKJQKLCvKgq0f
	 Hj4yABjuXun+faw/uVFzEst5YR8KhJzdLpQzYMUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 743/776] netfilter: bridge: eb_tables: close module init race
Date: Sat, 30 May 2026 18:07:37 +0200
Message-ID: <20260530160258.985097787@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5390b25cdb45e..9374a3207a276 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2582,19 +2582,20 @@ static int __init ebtables_init(void)
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



