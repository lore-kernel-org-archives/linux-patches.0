Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C067431159C;
	Thu, 28 May 2026 20:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001407; cv=none; b=j4c34Emeb/zPvnmGMaptvlvqQ5sv6Jc7vUGS5WEodBNFljA5fvuppJv4Lmr2BM0vA1wwqpuDR8xQJzuGOeRN4TtK2B+QqdY7gu28SEsm/yH2a/P5yCSvzUHeUVq8ign0q4d5kw7lQho1NyeErYhXt6TyfdNn26uZS8zvrFtIUSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001407; c=relaxed/simple;
	bh=Fc13Nzxdi8RGpGRgbdZphkBhX15UVk+qQNJX2ppdO4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+mAVlanVMwRUBkDDo+Y/SkGrKa4a/wcwsLuzn8tfylFKrlB6Y3YiFxkzine2MTjHk3gPPrAqpVCvZkOX/poUPTGE6C01UYUDLIe+ybeGcUftkcw0aLq9pz2G1RLabKaXKuTVzJsNYLBI2bUCgGDQ24PO8BdspQOHp9GTK6gQ38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQaFzXCn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQaFzXCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99021F000E9;
	Thu, 28 May 2026 20:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001406;
	bh=IsOr9pl6i0nGFW9b6tgpObyUIgj6X4D/sFiUOcRo1q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQaFzXCn4OBVlLu5rb1jl2JXnlVcHCckiym4MKbCmiQQ1umJGrpJkAv52Zvc+vZuE
	 nOweuWXoRQ4w0306hirk3pSBDuURoJW5UCkOzBzf5AqUJx8TU/rFIjfP0SeUwceIgn
	 o/QQY/nvr600bft/lAtvgAfMJKjVhlW/p93vW1KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/186] netfilter: ebtables: close dangling table module init race
Date: Thu, 28 May 2026 21:49:57 +0200
Message-ID: <20260528194932.099936229@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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
index 33d8640d21ac1..43c808e525e87 100644
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
index fdb988c24916a..f76d45dfe9b46 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -93,18 +93,16 @@ static struct pernet_operations frame_filter_net_ops = {
 
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
index 8b981b2041b5d..af0732e2f889d 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -93,16 +93,14 @@ static struct pernet_operations frame_nat_net_ops = {
 
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



