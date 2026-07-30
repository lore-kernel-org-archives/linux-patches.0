Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0B8413D8F;
	Thu, 30 Jul 2026 14:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421829; cv=none; b=e4ndBiV2T3S5lrHsMsXkJ0f7JwQppVgDuxtRNvTZ07RtizZTgo/qKlFB2BGyr8NqnLDo2oU5vemtuvX0hEnJ7AM5CadhUXtInphJY4J2akh4gzPSTurfMyEtSKmDLB3cJ1dviNHt0ueodutxPQmyaOMZ2r+hayeVXmPL08dPJt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421829; c=relaxed/simple;
	bh=jqVXvGUhiPP31K9ApCJApPuvwoCE3H2pSqWx2MxCLVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5YMaCeksQPLHVHl/NKHRwQ1xQwgZh7WyJY8WGudj01FVaLXHTMT7ce0ItzRwGECLl3hkZ4K/VBFamIylcho7n6CSB4vtLt8DdnOuPf5VzGh6BGoUBWHbT5h+wr0otDEJQqDJNraHxL6r3P0PBZbp0+87uLj6/H4IYIHNiahihU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Olx8MJvu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Olx8MJvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A391F000E9;
	Thu, 30 Jul 2026 14:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421828;
	bh=tKuxo4Yr2zFtdKT0BVwEX4580e9q7xWobUdwCWD9KfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Olx8MJvu2IrErtKb5AkfJCd4P4H+4tOAFqmH/uNMUq6sjeo9SQuE5Yxfdy/bqxOEm
	 Li4/et/+ZT+kBk8czdtSACMr6eXmwi4cXS29mN5QeokgeGaQ8Mhe4SrbaqTeFj3Tyq
	 jsrcGxKlIntA3qqwPSXJchHb6FaqpsTliqCI+Y0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianheng Peng <pengqh1@chinatelecom.cn>,
	Zhaolong Zhang <zhangzl68@chinatelecom.cn>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 235/744] bonding: fix devconf_all NULL dereference when IPv6 is disabled
Date: Thu, 30 Jul 2026 16:08:28 +0200
Message-ID: <20260730141449.289224047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhaolong Zhang <zhangzl68@chinatelecom.cn>

[ Upstream commit 1c975de3343cdef506f2eecc833cc1f14b0401c4 ]

When booting with the 'ipv6.disable=1' parameter, the devconf_all is
never initialized because inet6_init() exits before addrconf_init() is
called which initializes it. bond_send_validate(), however, will still
call bond_ns_send_all() even ipv6 is indeed disabled. It will lead to
NULL derefence of net->ipv6.devconf_all in ip6_pol_route().

 BUG: kernel NULL pointer dereference, address: 000000000000000c
 [...]
 Workqueue: bond0 bond_arp_monitor [bonding]
 RIP: 0010:ip6_pol_route+0x69/0x480
 [...]
 Call Trace:
  <TASK>
  ? srso_return_thunk+0x5/0x5f
  ? __pfx_ip6_pol_route_output+0x10/0x10
  fib6_rule_lookup+0xfe/0x260
  ? wakeup_preempt+0x8a/0x90
  ? srso_return_thunk+0x5/0x5f
  ? srso_return_thunk+0x5/0x5f
  ? sched_balance_rq+0x369/0x810
  ip6_route_output_flags+0xd7/0x170
  bond_ns_send_all+0xde/0x280 [bonding]
  bond_ab_arp_probe+0x296/0x320 [bonding]
  ? srso_return_thunk+0x5/0x5f
  bond_activebackup_arp_mon+0xb4/0x2c0 [bonding]
  process_one_work+0x196/0x370
  worker_thread+0x1af/0x320
  ? srso_return_thunk+0x5/0x5f
  ? __pfx_worker_thread+0x10/0x10
  kthread+0xe3/0x120
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x199/0x260
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1a/0x30
  </TASK>

Fix this by adding ipv6_mod_enabled() condition check in the caller.

Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Signed-off-by: Qianheng Peng <pengqh1@chinatelecom.cn>
Signed-off-by: Zhaolong Zhang <zhangzl68@chinatelecom.cn>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20260707010622.487333-1-zhangzl2013@126.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index cd9b0a6d652174..75abd6d9af3a4e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3446,7 +3446,8 @@ static void bond_send_validate(struct bonding *bond, struct slave *slave)
 {
 	bond_arp_send_all(bond, slave);
 #if IS_ENABLED(CONFIG_IPV6)
-	bond_ns_send_all(bond, slave);
+	if (likely(ipv6_mod_enabled()))
+		bond_ns_send_all(bond, slave);
 #endif
 }
 
-- 
2.53.0



