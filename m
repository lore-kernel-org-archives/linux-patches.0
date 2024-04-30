Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929D012C46B;
	Tue, 30 Apr 2024 10:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474224; cv=none; b=TRCMpzfPg0Sw6G8iU/xcca+CsNKKXLsIbRS7AbzfEGXfQ2dlDWcQshRbRES0huRQVIQ2OYtbmkf7ARubIPOfEo+EfUbJtakgSSsE1kuIIFKU9Tah/RbQ4u3kl9NasB6xW7dLctYoJCx9YBhzqUQVsOXmnoB6HvIGzHcQZpDQrsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474224; c=relaxed/simple;
	bh=NzCuhWaJMyw9P6P2OR6raMerTlXZhrHxNtT8iTCr490=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oozkf3zDouR5KA0FwkGEJa654PK8gWQ88sX/8okfx+owKCfzNIiCqLWgy1feXFFRqtxFu7qst9wgSm+iRToI0Plk2WDuwjkR2+d3q6jGEJguPRG3eac4EDW9LyABw4qNI10OU+IYzoalualaj+KHfnIpioEnseZLis+68Hf0xVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/HPJHio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/HPJHio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE2BC4AF19;
	Tue, 30 Apr 2024 10:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474224;
	bh=NzCuhWaJMyw9P6P2OR6raMerTlXZhrHxNtT8iTCr490=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/HPJHiozAbkyQ3+Zf3dOs/zpVsOTBWeoPDnkBTcGSKbpaSfIENhtyZteKLoK7vW4
	 LFN8mbjIBDXMZS6oEWgnG9eZbW/J8ZJPf30dshPjCZZaJ366IWKwrCXa4aWZnSmwmZ
	 l1cokk7W9tQeflwjNHO6EU3XJO2uZ1pgty2UbDAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Eric Dumazet <edumazet@google.com>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 093/228] net: openvswitch: Fix Use-After-Free in ovs_ct_exit
Date: Tue, 30 Apr 2024 12:37:51 +0200
Message-ID: <20240430103106.486074646@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <v4bel@theori.io>

[ Upstream commit 5ea7b72d4fac2fdbc0425cd8f2ea33abe95235b2 ]

Since kfree_rcu, which is called in the hlist_for_each_entry_rcu traversal
of ovs_ct_limit_exit, is not part of the RCU read critical section, it
is possible that the RCU grace period will pass during the traversal and
the key will be free.

To prevent this, it should be changed to hlist_for_each_entry_safe.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://lore.kernel.org/r/ZiYvzQN/Ry5oeFQW@v4bel-B760M-AORUS-ELITE-AX
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 74b63cdb59923..2928c142a2ddb 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1593,9 +1593,9 @@ static void ovs_ct_limit_exit(struct net *net, struct ovs_net *ovs_net)
 	for (i = 0; i < CT_LIMIT_HASH_BUCKETS; ++i) {
 		struct hlist_head *head = &info->limits[i];
 		struct ovs_ct_limit *ct_limit;
+		struct hlist_node *next;
 
-		hlist_for_each_entry_rcu(ct_limit, head, hlist_node,
-					 lockdep_ovsl_is_held())
+		hlist_for_each_entry_safe(ct_limit, next, head, hlist_node)
 			kfree_rcu(ct_limit, rcu);
 	}
 	kfree(info->limits);
-- 
2.43.0



