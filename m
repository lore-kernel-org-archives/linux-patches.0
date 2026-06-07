Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E4B4071C7;
	Sun,  7 Jun 2026 10:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826781; cv=none; b=unZsxUY1OrdY0047XPm8fZim3acPvr1tjBQxLMPs5jQipJ+7hAID8w9HXvKWmVJtVNNlYGpaK/0rLHL0TVstGr2CLwpbXw2fqI9TDeada8/DjSBWuoo/c5/YqAYKIPlf1bBONLqugQmAj7F0PV2p2w/uoiqL7j8BozZMPcN+sf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826781; c=relaxed/simple;
	bh=t/7aRltzSw4CKj8IMyjJEAwzM25rq3ngKHRjbEGHk2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljvZCzNTosI2f7JPtANGJJxJDQ5q7LK2uIFI8XaC6OCLqyAoGTAcSUG4K/KCeqbjexdT14Z0zgDMxf0RqSuspfKvaj2//bZHrlOxTX52frumsH71QiZ05S53neTs13YrRjP00Fj9fWGr4SQScke2qhQ5YCqNZPkI2TiC0O/NoBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrfjDXqD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrfjDXqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310FA1F00893;
	Sun,  7 Jun 2026 10:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826779;
	bh=08m9gixWkRPsLnnX/LM6TULpUNggaJEXiOTugWtKriw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yrfjDXqDJ/lCvVfFtbg1hRT8RkwFoUFR/pBLWwGvFXMDfzMAIS9AGlOC8mGCa5j5w
	 /NJbVnWwKBRYUBklt+plv24r28xQhLor5Cq9zvP2CFYo2Ro0TSuwVx6kdHashaTJmK
	 4gkm+A7Wf7v17cGO0gk4pzwPwaaMc5hf5F3bYfcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usama.arif@linux.dev>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/315] xfrm: move policy_bydst RCU sync from per-netns .exit to .pre_exit
Date: Sun,  7 Jun 2026 11:56:31 +0200
Message-ID: <20260607095727.675932036@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Usama Arif <usama.arif@linux.dev>

[ Upstream commit 3e52417318473782012b236d0325bf7d2266a597 ]

The struct pernet_operations docstring in include/net/net_namespace.h
explicitly warns against blocking RCU primitives in .exit handlers:

    Exit methods using blocking RCU primitives, such as
    synchronize_rcu(), should be implemented via exit_batch.
    [...]
    Please, avoid synchronize_rcu() at all, where it's possible.

    Note that a combination of pre_exit() and exit() can
    be used, since a synchronize_rcu() is guaranteed between
    the calls.

xfrm_policy_fini() violates this: it calls synchronize_rcu() before
freeing the policy_bydst hash tables (so no RCU reader is mid-
traversal at free time), but runs from xfrm_net_ops.exit -- once per
namespace -- so a cleanup_net() of N namespaces pays N full RCU
grace periods serially.

Use the documented pre_exit/exit split. Move the policy flush (and
the workqueue drains it depends on) into a new .pre_exit handler;
xfrm_policy_fini() then runs in .exit and frees the hash tables
after the synchronize_rcu_expedited() that cleanup_net() guarantees
between the two phases. Providing O(1) RCU grace periods per batch
instead of O(N).

Observed on Linux 6.18 with a workload doing unshare(CLONE_NEWNET)
at ~13/sec sustained: cleanup_net() and the netns_wq rescuer kthread
both stuck in xfrm_policy_fini()'s synchronize_rcu(), >300k struct
net accumulated in the cleanup queue, Percpu in /proc/meminfo climbed
to 130+ GB on 256-CPU hosts, and memcg OOMs followed. setup_net and
__put_net counts were balanced, ruling out a refcount leak.

Fixes: 069daad4f2ae ("xfrm: Wait for RCU readers during policy netns exit")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 29c94ee0ceb256..96e9262c4b482a 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4276,21 +4276,21 @@ static int __net_init xfrm_policy_init(struct net *net)
 	return -ENOMEM;
 }
 
-static void xfrm_policy_fini(struct net *net)
+static void __net_exit xfrm_net_pre_exit(struct net *net)
 {
-	struct xfrm_pol_inexact_bin *b, *t;
-	unsigned int sz;
-	int dir;
-
 	disable_work_sync(&net->xfrm.policy_hthresh.work);
-
 	flush_work(&net->xfrm.policy_hash_work);
 #ifdef CONFIG_XFRM_SUB_POLICY
 	xfrm_policy_flush(net, XFRM_POLICY_TYPE_SUB, false);
 #endif
 	xfrm_policy_flush(net, XFRM_POLICY_TYPE_MAIN, false);
+}
 
-	synchronize_rcu();
+static void xfrm_policy_fini(struct net *net)
+{
+	struct xfrm_pol_inexact_bin *b, *t;
+	unsigned int sz;
+	int dir;
 
 	WARN_ON(!list_empty(&net->xfrm.policy_all));
 
@@ -4368,6 +4368,7 @@ static void __net_exit xfrm_net_exit(struct net *net)
 
 static struct pernet_operations __net_initdata xfrm_net_ops = {
 	.init = xfrm_net_init,
+	.pre_exit = xfrm_net_pre_exit,
 	.exit = xfrm_net_exit,
 };
 
-- 
2.53.0



