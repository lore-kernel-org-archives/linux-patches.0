Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49091CCB5F;
	Wed,  6 Nov 2024 13:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899177; cv=none; b=OjQxmZuGJ8Gsun877TVu3pHfwz6EyEHAbdZAIEhogb3crYS7/+EHBZ+0lyhdemMQm1NES0msO6tAwQvntL840XQ25IVhrnxxpaHODS8o3MiDOne8+Nw/E8OIaGEHSf9OWfmgccEbQ3PrVT7AxIqclJm6oDxGk6O4JuFy/MWNHDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899177; c=relaxed/simple;
	bh=g55l2Eo8UxBA9+gLXL66wV/cEK+uljDHw7QzuBm67x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFZhzKwzdD2tO6FrvZSvgzWUkDLf8JHZpVYbyYycSc6GRIJ2QdpCjGenAcrr159Bk3dqBHcrs49S7F676tD6ZSxdiysIIG9r5eYjb+L9nKoeeVqZVhsI5gx/bJkdVlJYuOSMW1/toafyK1bW618nOV0Iqm0Mx8MBq2UZXCIwD0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6A4YhIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6A4YhIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3860EC4CED3;
	Wed,  6 Nov 2024 13:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899177;
	bh=g55l2Eo8UxBA9+gLXL66wV/cEK+uljDHw7QzuBm67x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6A4YhIEzXUzgyUeYDHEp9E40nBcjPwea62sOhfIoLjOroIMboFbHH/hHHTyld4wj
	 zC63HTm2TgdCAY/Bfi18egfPdYrobtsXkkMP/uFB5JceeKig017c4ZPFIsmFRRJG9A
	 DT8oUFvjEPI+G7I9vyGl/+LERVELHWEZGkhrHBkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dong Chenchen <dongchenchen2@huawei.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/73] netfilter: Fix use-after-free in get_info()
Date: Wed,  6 Nov 2024 13:05:29 +0100
Message-ID: <20241106120300.712949306@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 25524e3933496..9a579217763df 100644
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



