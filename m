Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0C6431488;
	Thu, 30 Jul 2026 14:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421977; cv=none; b=rsCjYOmCOfP3edczP10FyS9xU6i0C5qRxlX/D0oV4tMiLnGDJq7zxsSYatvtQli4E7ZHabextUyU2Y8UbH0wUkISGeCp0kNv8oXzQio1yqysrhmkrSEMsyMGhJpqE/4JiTCjQ4ku0q0zdaPddqP6FETsrtL3UPCHbFAzQSQmvZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421977; c=relaxed/simple;
	bh=/YWc1Dib0+CzOHdoWnE1ISVx9RWcZhAx7kJFKT5I24c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjK4WQiEggzKR+EgJT79Szj9z42Kl2xeicJkWtJvdVIwQqVkxga3rSewzsDTJgLXGAgTOue4ZYkkOpbAZE4iKkWu5M3KMB3/zuXsFQ8pVCaPnybF1lDwQxbMFIGLWKWNPi3yjKNrW1I/Y8GGbjrcDO2q6gYeRZuebVJiodp/iSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQlZxdy6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQlZxdy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C301F000E9;
	Thu, 30 Jul 2026 14:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421976;
	bh=LmrU8fCQNoLkdeIXNfYNx16Hs+5pMXp3gpiwTB/HLGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQlZxdy6qL7mp9gqXn2cl521Lu/zhVN/uzSEL0yXPnRWdvARYXuENRNX9xB81yPTd
	 wCyzhqxJOn2WgkVP5CM2iaexY3jrMOLdSpd/RgVmPtcWclo8EsiIWCoSnp26LsY5So
	 771CfAer7E83FEBZwcvwJbv2v+UjVVFe5w+kXPV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 284/744] nexthop: initialize extack in nh_res_bucket_migrate()
Date: Thu, 30 Jul 2026 16:09:17 +0200
Message-ID: <20260730141450.326253675@linuxfoundation.org>
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

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit 6347c5314cee49f364aaf2e40ff15415a57a116e ]

nh_res_bucket_migrate() passes an uninitialized netlink_ext_ack to
call_nexthop_res_bucket_notifiers(). When
nh_notifier_res_bucket_info_init() fails (e.g. the kzalloc returns
-ENOMEM), the error is propagated back before any notifier sets
extack._msg, and the error path formats the stale pointer with
pr_err_ratelimited("%s\n", extack._msg). With CONFIG_INIT_STACK_NONE
this dereferences uninitialized stack memory:

  Oops: general protection fault, probably for non-canonical address ...
  KASAN: maybe wild-memory-access in range [...]
  RIP: 0010:string (lib/vsprintf.c:730)
   vsnprintf (lib/vsprintf.c:2945)
   _printk (kernel/printk/printk.c:2504)
   nh_res_bucket_migrate (net/ipv4/nexthop.c:1816)
   nh_res_table_upkeep (net/ipv4/nexthop.c:1866)
   rtm_new_nexthop (net/ipv4/nexthop.c:3323)
   rtnetlink_rcv_msg (net/core/rtnetlink.c:7076)
   netlink_sendmsg (net/netlink/af_netlink.c:1900)
  Kernel panic - not syncing: Fatal exception

Zero-initialize extack so _msg is NULL on error paths that never set it.

Fixes: 7c37c7e00411 ("nexthop: Implement notifiers for resilient nexthop groups")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260713221551.3344650-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index f92fcc39fc4c80..dc95a3d6e899e0 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1788,8 +1788,8 @@ static bool nh_res_bucket_migrate(struct nh_res_table *res_table,
 				  bool notify_nl, bool force)
 {
 	struct nh_res_bucket *bucket = &res_table->nh_buckets[bucket_index];
+	struct netlink_ext_ack extack = {};
 	struct nh_grp_entry *new_nhge;
-	struct netlink_ext_ack extack;
 	int err;
 
 	new_nhge = list_first_entry_or_null(&res_table->uw_nh_entries,
-- 
2.53.0



