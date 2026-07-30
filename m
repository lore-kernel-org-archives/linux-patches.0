Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3289372ECB;
	Thu, 30 Jul 2026 15:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424042; cv=none; b=eg0tGWJ5Pu6sFwCCc192A2P3WdY5Ap3RaluX7hqSwNCIDWV+QWf93A15nA666kEBhmda9JqKUwfON6EWB5lQ4GaUiQqQrXytJyD/9emx8JPO8hiRV95TylkUYVlfyzgJEoKqhKVH7OYXnmyKyuCpPUUEVN309Jq4mrP55CimK/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424042; c=relaxed/simple;
	bh=NQSN58G3aaOCfTuWU4eZjz0ntDCrqd7O20qckzDOh74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIgd6D5cPk3SuYEv+115SYsb3/hGCEQb8orf3c5Aun1NtC48A1t0TpKfKO1SL+zfxNDODbETTGSoRwS6h38COBY8j+VB2Yf7ZHf9wAvOrPuSqUJ8cMvQXB9zlT8XmceokgXzEwxwMyUTvJzT+z+Cd+Wt/26uzUtg2Dhph6ej47A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRwZ80dQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRwZ80dQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1841F000E9;
	Thu, 30 Jul 2026 15:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424041;
	bh=8nrkX5u0GDuugyPv/teq1WuYtibGphV4kFIHLF5mIEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRwZ80dQy04g8yuCEtLZS6pxPxZzHo1lQqTScLlEOyBGmrBitamDBKcoKQ763cPid
	 9YLPVn6vZb/7vtbX0BXTrm6vBaPrWEEWolDJ3qcK78+uv8+JizLuU94nd4Xauvzd1p
	 aFB6Kk/DfzVcXnevZHkchHy5E4/F580sUjGJdaD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 254/675] nexthop: initialize extack in nh_res_bucket_migrate()
Date: Thu, 30 Jul 2026 16:09:44 +0200
Message-ID: <20260730141450.536573990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5a95b64b61c59e..a8bf1ec548995f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1791,8 +1791,8 @@ static bool nh_res_bucket_migrate(struct nh_res_table *res_table,
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



