Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3B21F9ED3;
	Wed,  6 Nov 2024 12:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897400; cv=none; b=XL6iv3GHnI65+DIFNRSD5XjRq/fjiMiacE3sK8Hk2Z5qPvBEv3KeYhvUB/O5Ebd6ClIA02QTYJ64ZQILN6OoGoSXG0bxoQx4lE9b1Le1OEK/lEq8b3JdTU/aAQrRcKh9TWfnKN3Nml3CvW/6mbWGnAkxvJgmhgPvXUAuNMs7iac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897400; c=relaxed/simple;
	bh=mfWiPRX70Hlecz5wui/6sFpwYGiRwwted69AYVYmoTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMuUF1RDMhQ/HXtxaPsirkQTymBbVIc9J8E5louCjPL+Q9HZvyOJn96mGIAi5xc9r+aulALpXTOlW1KySqszJUWe4uJMJeruVo+OWBJjKBhDB8vsq38AVa2XFoBRKmcog9jSZ6L8KgI0Pak8VO1AuCidN3GR51i9io6tzOZLJUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8rR5LGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8rR5LGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9314DC4CECD;
	Wed,  6 Nov 2024 12:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897400;
	bh=mfWiPRX70Hlecz5wui/6sFpwYGiRwwted69AYVYmoTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8rR5LGdw6h0STbX3dQbqbV53kAu6j8cYTp1VpgBqFC2ML0Fs+9mMU2wq86ZsvwvN
	 RUKIr8WCcHXNz1Q5Eff+dVZpiareSwmLgOclaBDM4skdMh2c6K4uJDgFTx3haNZZCq
	 yjqqMsQmKotNX68Pj/GLH7lkazDO9qPpmcunhypE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dong Chenchen <dongchenchen2@huawei.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/151] netfilter: Fix use-after-free in get_info()
Date: Wed,  6 Nov 2024 13:03:41 +0100
Message-ID: <20241106120309.748614448@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dong Chenchen <dongchenchen2@huawei.com>

[ Upstream commit f48d258f0ac540f00fa617dac496c4c18b5dc2fa ]

ip6table_nat module unload has refcnt warning for UAF. call trace is:

WARNING: CPU: 1 PID: 379 at kernel/module/main.c:853 module_put+0x6f/0x80
Modules linked in: ip6table_nat(-)
CPU: 1 UID: 0 PID: 379 Comm: ip6tables Not tainted 6.12.0-rc4-00047-gc2ee9f594da8-dirty #205
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:module_put+0x6f/0x80
Call Trace:
 <TASK>
 get_info+0x128/0x180
 do_ip6t_get_ctl+0x6a/0x430
 nf_getsockopt+0x46/0x80
 ipv6_getsockopt+0xb9/0x100
 rawv6_getsockopt+0x42/0x190
 do_sock_getsockopt+0xaa/0x180
 __sys_getsockopt+0x70/0xc0
 __x64_sys_getsockopt+0x20/0x30
 do_syscall_64+0xa2/0x1a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Concurrent execution of module unload and get_info() trigered the warning.
The root cause is as follows:

cpu0				      cpu1
module_exit
//mod->state = MODULE_STATE_GOING
  ip6table_nat_exit
    xt_unregister_template
	kfree(t)
	//removed from templ_list
				      getinfo()
					  t = xt_find_table_lock
						list_for_each_entry(tmpl, &xt_templates[af]...)
							if (strcmp(tmpl->name, name))
								continue;  //table not found
							try_module_get
						list_for_each_entry(t, &xt_net->tables[af]...)
							return t;  //not get refcnt
					  module_put(t->me) //uaf
    unregister_pernet_subsys
    //remove table from xt_net list

While xt_table module was going away and has been removed from
xt_templates list, we couldnt get refcnt of xt_table->me. Check
module in xt_net->tables list re-traversal to fix it.

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/x_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 21624d68314f9..e50c23b9c9c41 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1268,7 +1268,7 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 
 	/* and once again: */
 	list_for_each_entry(t, &xt_net->tables[af], list)
-		if (strcmp(t->name, name) == 0)
+		if (strcmp(t->name, name) == 0 && owner == t->me)
 			return t;
 
 	module_put(owner);
-- 
2.43.0



