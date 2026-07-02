Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FBB33B6CC;
	Thu,  2 Jul 2026 16:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010252; cv=none; b=qHlcCX9M6UbbRR8+p/jeRz5Wfp5+DM+sQS1YAqtweNrRgQ4pm4jIBGnAHDr3MqR6q2ox/KutjC3H09nGsLQcuvuk2ggCex2hYzjxI8xYk88Hw1la6Ol3zMK+jp0O+bWM1P4q8A7gqqTLCgOG/dqgWkBpjLjUb4NCYDzIm0B2Co4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010252; c=relaxed/simple;
	bh=UD+5afjpwvjxecF6kIo3wi41B+Q2miQ+fDD5N2fLFok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRIVa5d2bzhpYFqrSMJOxMGYICkNR339l18J8c4bWDHKMHs96LTDWDqEeZ3kgFJrHOUYCCVmi63RlAw1RhE8yixpHjUFaf3FH7W/v10h44b4T+5KkG9+VEv1gu2BenajMnw71vnWDxkBbIV/HaSJxhkPJ2oPMfpg9HHpMiiubIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tadKgdpz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tadKgdpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7E61F000E9;
	Thu,  2 Jul 2026 16:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010251;
	bh=KpwgAzOLeUZ2lKSxJIgeeZwN+uYIJg7CL7lPoNJNFKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tadKgdpzQzNsKMKeKMTdugSahNmMZyuHWdCVYqM7XD1sBOwcrkEGgCdQukotDKSdo
	 CDCgy3T3slnvChlqg/ZOLcxOiEVBDCRL9uL5+gV6vGZHunOiIaebNsltRhs/FBd7ui
	 JtIg3MSX7AweY+x9eWav2PUGMlUWBKxVIiBTD4Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Berry <kpberry@google.com>
Subject: [PATCH 6.12 038/204] Revert "net: bonding: fix use-after-free in bond_xmit_broadcast()"
Date: Thu,  2 Jul 2026 18:18:15 +0200
Message-ID: <20260702155119.454624163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Berry <kpberry@google.com>

This reverts commit 3453882f36c40d2339267093676585a89808a73d.

There are two versions of this use-after-free fix commit: this one,
which was written to avoid taking a dependency on ce7a381697cb3 ("net:
bonding: add broadcast_neighbor option for 802.3ad"), and the original,
simpler version 2884bf72fb8f ("net: bonding: fix use-after-free in
bond_xmit_broadcast()"), which implicitly depends on the slave counting
changes in ce7a381697cb3. In both the 6.1 and 6.6 stable branches,
commit ce7a381697cb3 was included as a stable dep of c4f050ce06c56
("bonding: 3ad: implement proper RCU rules for port->aggregator"), and
the original version of this fix was subsequently applied.

For consistency, and to be able to apply both bug fixes, we should
revert this commit, apply the series for ce7a381697cb3 ("net: bonding:
add broadcast_neighbor option for 802.3ad"), and then apply
the original version of this fix, 2884bf72fb8f ("net: bonding: fix
use-after-free in bond_xmit_broadcast()").

Signed-off-by: Kevin Berry <kpberry@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5328,22 +5328,18 @@ static netdev_tx_t bond_xmit_broadcast(s
 				       struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct bond_up_slave *slaves;
+	struct slave *slave = NULL;
+	struct list_head *iter;
 	bool xmit_suc = false;
 	bool skb_used = false;
-	int slaves_count, i;
 
-	slaves = rcu_dereference(bond->all_slaves);
-
-	slaves_count = slaves ? READ_ONCE(slaves->count) : 0;
-	for (i = 0; i < slaves_count; i++) {
-		struct slave *slave = slaves->arr[i];
+	bond_for_each_slave_rcu(bond, slave, iter) {
 		struct sk_buff *skb2;
 
 		if (!(bond_slave_is_up(slave) && slave->link == BOND_LINK_UP))
 			continue;
 
-		if (i + 1 == slaves_count) {
+		if (bond_is_last_slave(bond, slave)) {
 			skb2 = skb;
 			skb_used = true;
 		} else {


