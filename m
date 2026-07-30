Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403F544AB81;
	Thu, 30 Jul 2026 16:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427449; cv=none; b=bYfnLNlpYVRQZ3CiBEJUE4th1WWXJVOyJ1+hXTWGUKZh2ADkSfVyBjF4cjhW2/w4TH2wJv2joppuMGefPWtcq3A9IEkG3CvM8LC89qfKenJFBF2G06ucyx6qjmg84dMeeOAeCGUDlJoTI6r2MqwPRowh3+DdQEQz/eOwSV66RD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427449; c=relaxed/simple;
	bh=Ocrh86hxgmUc40Cyu0IwxFAA10BZ7JrAF1Mzx94+WsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcej6z4JJakTfGR4VDrf22ISRcVY0T1S0U7XHBj5WIdbAJ1EMknwWeeVbvNWGqJFaA/qu/yeqxsFzzQabj7MQYphJWigxNqFFFoapQEbfmBDX0ZZMcnCWA5l/OWqY86JyAx1wIZXTGTrCaaHMHX+gZ7uK5vohCcIf96F4rXnvoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WIhJz/zL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WIhJz/zL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C79A1F000E9;
	Thu, 30 Jul 2026 16:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427448;
	bh=Bd7dwT8HTxvkziFZAQOPeN2l3fcxj7SBiGK62aepbTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WIhJz/zLFYjSa3xkMtXU+oA4nznZNYy+/T8B4qRAflG422Nzm1LmoL+OgMWXIAk3k
	 IXdByLWzRvBdjSEJ4Iof+gUWa3DX+6GjKuGBsvPoP52le4OdboG2JjuZ6OG4v+oxti
	 oZff4Kz69+41/Sfm7SJdpSM4CE0uj8p8Jz2IhnNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/484] nexthop: initialize extack in nh_res_bucket_migrate()
Date: Thu, 30 Jul 2026 16:11:09 +0200
Message-ID: <20260730141427.204504361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index 4f30ddd2016b68..e751464f4fad9e 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1527,8 +1527,8 @@ static bool nh_res_bucket_migrate(struct nh_res_table *res_table,
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



