Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B8335677D;
	Thu,  2 Jul 2026 16:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009842; cv=none; b=Tmjf93tW2Of26VCYNLfRCzCo32DZf06kByc3Yej47ejgw/S/Jd8Hf/xKggbTBmrgNlRL7bsF2Ed6dhDrql/8bRGWK+4rNQ2xk3UKdahtNGrp17JMf+JcIu4aXY7Y/IJ0mSWbvktg67qY9I+72cV3qCSWRYBG8F1AbHTh+4DpEbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009842; c=relaxed/simple;
	bh=tTuk9lwsV6BeVBd7Q5PFlXnjzmCAiaPSg7YOWJ2QIb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koNZnrpQUl+bsB/2OmmPFW5hRRHIA7yEGEZXBI/+2eS98HCAQQG/x3vmp42qhJgG4Qo9vL+qGIN0P9ljo0mODyXooTOIQM3tlLv8qILQpuk1RQEsiXoYFMBYK6lPg6ZkHlwDmc00n7Wj5UxCEv7HXW0AhHmhfGsv+eKyfPFHXgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+OhmY9h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+OhmY9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D303C1F000E9;
	Thu,  2 Jul 2026 16:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009841;
	bh=8HIw5JcM22ht/c/RtMehgrjoXfAcY0e9cQNqvQfQV2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y+OhmY9htwUd11CE1qW2IqDN6IjJdDjzbDRMlgIGPVbQd61S/0qmOE0C03hi0wTWI
	 Mzg8FPYNBYUV8gr6U9pCp3eLYTLpWn49ZLvXO6sYjJE8fkmroi4NKO4WXv2b7WLrVj
	 cX490Wq3USLE/+yIl6P75yRXmr7cFZA6+HZPWQ8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@idosch.org>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/129] net/sched: act_pedit: free pedit keys on bail from offset check
Date: Thu,  2 Jul 2026 18:18:44 +0200
Message-ID: <20260702155112.275424371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 1b483d9f5805c7e3d628d4995e97f4311fcb82eb ]

Ido Schimmel reports a memleak on a syzkaller instance:
   BUG: memory leak
   unreferenced object 0xffff88803d45e400 (size 1024):
     comm "syz-executor292", pid 563, jiffies 4295025223 (age 51.781s)
     hex dump (first 32 bytes):
       28 bd 70 00 fb db df 25 02 00 14 1f ff 02 00 02  (.p....%........
       00 32 00 00 1f 00 00 00 ac 14 14 3e 08 00 07 00  .2.........>....
     backtrace:
       [<ffffffff81bd0f2c>] kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
       [<ffffffff81bd0f2c>] slab_post_alloc_hook mm/slab.h:772 [inline]
       [<ffffffff81bd0f2c>] slab_alloc_node mm/slub.c:3452 [inline]
       [<ffffffff81bd0f2c>] __kmem_cache_alloc_node+0x25c/0x320 mm/slub.c:3491
       [<ffffffff81a865d9>] __do_kmalloc_node mm/slab_common.c:966 [inline]
       [<ffffffff81a865d9>] __kmalloc+0x59/0x1a0 mm/slab_common.c:980
       [<ffffffff83aa85c3>] kmalloc include/linux/slab.h:584 [inline]
       [<ffffffff83aa85c3>] tcf_pedit_init+0x793/0x1ae0 net/sched/act_pedit.c:245
       [<ffffffff83a90623>] tcf_action_init_1+0x453/0x6e0 net/sched/act_api.c:1394
       [<ffffffff83a90e58>] tcf_action_init+0x5a8/0x950 net/sched/act_api.c:1459
       [<ffffffff83a96258>] tcf_action_add+0x118/0x4e0 net/sched/act_api.c:1985
       [<ffffffff83a96997>] tc_ctl_action+0x377/0x490 net/sched/act_api.c:2044
       [<ffffffff83920a8d>] rtnetlink_rcv_msg+0x46d/0xd70 net/core/rtnetlink.c:6395
       [<ffffffff83b24305>] netlink_rcv_skb+0x185/0x490 net/netlink/af_netlink.c:2575
       [<ffffffff83901806>] rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:6413
       [<ffffffff83b21cae>] netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
       [<ffffffff83b21cae>] netlink_unicast+0x5be/0x8a0 net/netlink/af_netlink.c:1365
       [<ffffffff83b2293f>] netlink_sendmsg+0x9af/0xed0 net/netlink/af_netlink.c:1942
       [<ffffffff8380c39f>] sock_sendmsg_nosec net/socket.c:724 [inline]
       [<ffffffff8380c39f>] sock_sendmsg net/socket.c:747 [inline]
       [<ffffffff8380c39f>] ____sys_sendmsg+0x3ef/0xaa0 net/socket.c:2503
       [<ffffffff838156d2>] ___sys_sendmsg+0x122/0x1c0 net/socket.c:2557
       [<ffffffff8381594f>] __sys_sendmsg+0x11f/0x200 net/socket.c:2586
       [<ffffffff83815ab0>] __do_sys_sendmsg net/socket.c:2595 [inline]
       [<ffffffff83815ab0>] __se_sys_sendmsg net/socket.c:2593 [inline]
       [<ffffffff83815ab0>] __x64_sys_sendmsg+0x80/0xc0 net/socket.c:2593

The recently added static offset check missed a free to the key buffer when
bailing out on error.

Fixes: e1201bc781c2 ("net/sched: act_pedit: check static offsets a priori")
Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20230425144725.669262-1-pctammela@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
(cherry picked from commit 1b483d9f5805c7e3d628d4995e97f4311fcb82eb)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_pedit.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 1b076c4f2d1af5..09310b56b45beb 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -258,7 +258,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		if (!offmask && cur % 4) {
 			NL_SET_ERR_MSG_MOD(extack, "Offsets must be on 32bit boundaries");
 			ret = -EINVAL;
-			goto put_chain;
+			goto out_free_keys;
 		}
 
 		/* sanitize the shift value for any later use */
@@ -283,6 +283,8 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 
 	return ret;
 
+out_free_keys:
+	kfree(nparms->tcfp_keys);
 put_chain:
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
-- 
2.53.0



