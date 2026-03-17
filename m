Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D7914F70;
	Tue, 17 Mar 2026 16:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765570; cv=none; b=D6+H6uvakscfpHphx3a229eCHpL5kTSnSftjDyssgxCfzBPpSGcE6ejHZLasuOqe1lu7z9U9V158/2MENM2Od1FtPaBxjbvSbj/cW5MF40abWkhwtA0TiQ6YplqC135GYJ62FfoYWyZY/pgLgUkF+swxe8slPK/yDbeczo7+dP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765570; c=relaxed/simple;
	bh=5oDiQOjJjtvhgpPctWMb2oRMyqzNgu0Z6QqI5SBaa58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooINz7GH0jD8Py/8HoebRjaTNeO8q4qFjn2QoWQ43OJXIkAMRF4epfH58hcLYUofO0DwE2WrN8T5vwcLdm0CU+GIzP2m7juAiXupjQikDQ8OTPW0iueCKVOwlkgL0yGNzlZGyrUp1aHVatOfEBe16h1pBa4qmEvHe32RIKu7yL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnY74GjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnY74GjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED290C19424;
	Tue, 17 Mar 2026 16:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765570;
	bh=5oDiQOjJjtvhgpPctWMb2oRMyqzNgu0Z6QqI5SBaa58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnY74GjPS6a4nN7M+ZSoTAsN8a4//O417x6Ntc2pFWgiEKs0VjNbdaZsU8S8TVfqG
	 6UgqOLheTSQT5uoITXKdIlNIPqkiDeNwZIqi/rm12BmCcGD1ypcomJcVaHBGYUa3A9
	 DDkZnMcLQZAs47yM9P/7D0mbqChoeht+VzJktzTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Li <liali@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 041/378] bonding: do not set usable_slaves for broadcast mode
Date: Tue, 17 Mar 2026 17:29:58 +0100
Message-ID: <20260317163008.496864829@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 45fc134bcfadde456639c1b1e206e6918d69a553 ]

After commit e0caeb24f538 ("net: bonding: update the slave array for broadcast mode"),
broadcast mode will also set all_slaves and usable_slaves during
bond_enslave(). But if we also set updelay, during enslave, the
slave init state will be BOND_LINK_BACK. And later
bond_update_slave_arr() will alloc usable_slaves but add nothing.
This will cause bond_miimon_inspect() to have ignore_updelay
always true. So the updelay will be always ignored. e.g.

[    6.498368] bond0: (slave veth2): link status definitely down, disabling slave
[    7.536371] bond0: (slave veth2): link status up, enabling it in 0 ms
[    7.536402] bond0: (slave veth2): link status definitely up, 10000 Mbps full duplex

To fix it, we can either always call bond_update_slave_arr() on every
place when link changes. Or, let's just not set usable_slaves for
broadcast mode.

Fixes: e0caeb24f538 ("net: bonding: update the slave array for broadcast mode")
Reported-by: Liang Li <liali@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20260304-b4-bond_updelay-v1-1-f72eb2e454d0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 739e6eea6b529..5de38258c7d8b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5041,13 +5041,18 @@ static void bond_set_slave_arr(struct bonding *bond,
 {
 	struct bond_up_slave *usable, *all;
 
-	usable = rtnl_dereference(bond->usable_slaves);
-	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
-	kfree_rcu(usable, rcu);
-
 	all = rtnl_dereference(bond->all_slaves);
 	rcu_assign_pointer(bond->all_slaves, all_slaves);
 	kfree_rcu(all, rcu);
+
+	if (BOND_MODE(bond) == BOND_MODE_BROADCAST) {
+		kfree_rcu(usable_slaves, rcu);
+		return;
+	}
+
+	usable = rtnl_dereference(bond->usable_slaves);
+	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
+	kfree_rcu(usable, rcu);
 }
 
 static void bond_reset_slave_arr(struct bonding *bond)
-- 
2.51.0



