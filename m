Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE02917555;
	Sat, 30 May 2026 18:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165074; cv=none; b=LTj6hqHLH1LGD0+cjONEh4D02ylFOpJorULjAGUN67Gz8qcxand7ZkESuLBO8DJHNO5E5EomnqbZpMW+ODmSErgy32ZZIEnF8klBTyZEpbnKv/8Jy7bpADEQOdDLNR7BkahvafPbS6nrCc/VGDWuWmCGPExreM8yCp33nBmX25c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165074; c=relaxed/simple;
	bh=OeBmWiXvBBFZ4/XAQQtTP5SjtuqyVsakbV3U5nZ5YFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+4JuAq70GRnXhNFolNT/NtIDMaMGM3SIWnbRh8O5ZxJjLHvaTMU73Yu9eSqCwQmdrObU55VYIWIY2SablZpzUzZZeS2v4DQwqGgPUULOzxX0e7i0HObrHrO9zyucJs8ki1dGF06BYu7DX0Nb9s7Q83wDfcZadXZ3tCubILJyPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vuv0oUyf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vuv0oUyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6EC1F00893;
	Sat, 30 May 2026 18:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165072;
	bh=WwB5B2N2WqivN367DyRy3eiAT8m6UNsgmJMV6vPFpjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vuv0oUyfOqxy7KR/etnFhINFUBiQmXt9a0c/rMFo8/DFpvxwFIjFyMBnTbADENE1r
	 gjmTCJ0DdKlAw0qUpZd5jWezGMth87wGkkswm3KfIgI/sSJShdxkd88bWaMbCmlub6
	 cZPjQyfphxRARiBFU1qm3numgFk20dx079jZAyG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 742/776] netfilter: ebtables: close dangling table module init race
Date: Sat, 30 May 2026 18:07:36 +0200
Message-ID: <20260530160258.961618892@linuxfoundation.org>
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

[ Upstream commit 92c603fa07bc0d6a17345de3ad7954730b8de44b ]

sashiko reported for a related patch:
 In modules like iptable_raw.c, [..], if register_pernet_subsys() fails,
 the rollback might call kfree(rawtable_ops) before [..]
 During this window, could a concurrent userspace process find the globally
 visible template, trigger table_init(), [..]

The table init functions must always register the template last.

Otherwise, set/getsockopt can instantiate a table in a namespace
while the required pernet ops (contain the destructor) isn't available.
This change is also required in x_tables, handled in followup change.

Fixes: 87663c39f898 ("netfilter: ebtables: do not hook tables by default")
Reviewed-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtable_broute.c | 12 +++++-------
 net/bridge/netfilter/ebtable_filter.c | 12 +++++-------
 net/bridge/netfilter/ebtable_nat.c    | 10 ++++------
 3 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index c5d6fb937394c..d54afb88761e6 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -112,18 +112,16 @@ static struct pernet_operations broute_net_ops = {
 
 static int __init ebtable_broute_init(void)
 {
-	int ret = ebt_register_template(&broute_table, broute_table_init);
+	int ret = register_pernet_subsys(&broute_net_ops);
 
 	if (ret)
 		return ret;
 
-	ret = register_pernet_subsys(&broute_net_ops);
-	if (ret) {
-		ebt_unregister_template(&broute_table);
-		return ret;
-	}
+	ret = ebt_register_template(&broute_table, broute_table_init);
+	if (ret)
+		unregister_pernet_subsys(&broute_net_ops);
 
-	return 0;
+	return ret;
 }
 
 static void __exit ebtable_broute_fini(void)
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index ee3d6d5a03a35..28f6a1f33898a 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -100,18 +100,16 @@ static struct pernet_operations frame_filter_net_ops = {
 
 static int __init ebtable_filter_init(void)
 {
-	int ret = ebt_register_template(&frame_filter, frame_filter_table_init);
+	int ret = register_pernet_subsys(&frame_filter_net_ops);
 
 	if (ret)
 		return ret;
 
-	ret = register_pernet_subsys(&frame_filter_net_ops);
-	if (ret) {
-		ebt_unregister_template(&frame_filter);
-		return ret;
-	}
+	ret = ebt_register_template(&frame_filter, frame_filter_table_init);
+	if (ret)
+		unregister_pernet_subsys(&frame_filter_net_ops);
 
-	return 0;
+	return ret;
 }
 
 static void __exit ebtable_filter_fini(void)
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index c98840b68fc52..a9450d6e49565 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -99,16 +99,14 @@ static struct pernet_operations frame_nat_net_ops = {
 
 static int __init ebtable_nat_init(void)
 {
-	int ret = ebt_register_template(&frame_nat, frame_nat_table_init);
+	int ret = register_pernet_subsys(&frame_nat_net_ops);
 
 	if (ret)
 		return ret;
 
-	ret = register_pernet_subsys(&frame_nat_net_ops);
-	if (ret) {
-		ebt_unregister_template(&frame_nat);
-		return ret;
-	}
+	ret = ebt_register_template(&frame_nat, frame_nat_table_init);
+	if (ret)
+		unregister_pernet_subsys(&frame_nat_net_ops);
 
 	return ret;
 }
-- 
2.53.0



