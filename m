Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D994149E03;
	Tue, 25 Jun 2024 09:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308580; cv=none; b=WYhTqxjazJOLwZiHr7WfAdD/f4GpEH8cuhsNfH9MW4efKkqVxZLCUjQruXYW94HOCCzM5UmKzqVVd13iO0n2V9J3SrWnow7FZ6hGxIO839UUNiFW3V3VcBHgKdt/N1fmaLmq2MIlA0G1hE6NVhPnFWjSkwPd83FRGemJfB76XgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308580; c=relaxed/simple;
	bh=VJkr4i7p0zRqkzwGKIsJJNb6YdOSfiUHBkQGY3VPD0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9w26s3HCoZXZQo4n3nLa+TnliSw9gsMLfO69nN3VYkqj5t5Hn2d5qilN8oil0cpzet7KXvFRiM/8lEUTDjBSpG52NtkCPVD5ZjEljnh7Km/oXa2Um1IwxJltW381MSyxmB+MIKLvFP94It6+6icuCnAhXFUVoLNTd6T0xXUbMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kq9q9PwT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kq9q9PwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D21C32781;
	Tue, 25 Jun 2024 09:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308580;
	bh=VJkr4i7p0zRqkzwGKIsJJNb6YdOSfiUHBkQGY3VPD0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kq9q9PwTCFQYTPln42iUV0gotoQbZ5UOHUd9eiGK4YULQaWo97McNcZEm3/b15cwI
	 71fsxX1lRLl3Hyc2tbocQlsaTd7LBhZJhy16aH6Xtbd0Jx9ghyk0FydPeyeXV1DcwX
	 XW2TlNKtvYM0zxP3n9nGchTaWQmTbx3+OsU/29DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuang Li <shuali@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 128/250] sched: act_ct: add netns into the key of tcf_ct_flow_table
Date: Tue, 25 Jun 2024 11:31:26 +0200
Message-ID: <20240625085552.979104238@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 88c67aeb14070bab61d3dd8be96c8b42ebcaf53a ]

zones_ht is a global hashtable for flow_table with zone as key. However,
it does not consider netns when getting a flow_table from zones_ht in
tcf_ct_init(), and it means an act_ct action in netns A may get a
flow_table that belongs to netns B if it has the same zone value.

In Shuang's test with the TOPO:

  tcf2_c <---> tcf2_sw1 <---> tcf2_sw2 <---> tcf2_s

tcf2_sw1 and tcf2_sw2 saw the same flow and used the same flow table,
which caused their ct entries entering unexpected states and the
TCP connection not able to end normally.

This patch fixes the issue simply by adding netns into the key of
tcf_ct_flow_table so that an act_ct action gets a flow_table that
belongs to its own netns in tcf_ct_init().

Note that for easy coding we don't use tcf_ct_flow_table.nf_ft.net,
as the ct_ft is initialized after inserting it to the hashtable in
tcf_ct_flow_table_get() and also it requires to implement several
functions in rhashtable_params including hashfn, obj_hashfn and
obj_cmpfn.

Fixes: 64ff70b80fd4 ("net/sched: act_ct: Offload established connections to flow table")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/1db5b6cc6902c5fc6f8c6cbd85494a2008087be5.1718488050.git.lucien.xin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index baac083fd8f10..2a96d9c1db65b 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -41,21 +41,26 @@ static struct workqueue_struct *act_ct_wq;
 static struct rhashtable zones_ht;
 static DEFINE_MUTEX(zones_mutex);
 
+struct zones_ht_key {
+	struct net *net;
+	u16 zone;
+};
+
 struct tcf_ct_flow_table {
 	struct rhash_head node; /* In zones tables */
 
 	struct rcu_work rwork;
 	struct nf_flowtable nf_ft;
 	refcount_t ref;
-	u16 zone;
+	struct zones_ht_key key;
 
 	bool dying;
 };
 
 static const struct rhashtable_params zones_params = {
 	.head_offset = offsetof(struct tcf_ct_flow_table, node),
-	.key_offset = offsetof(struct tcf_ct_flow_table, zone),
-	.key_len = sizeof_field(struct tcf_ct_flow_table, zone),
+	.key_offset = offsetof(struct tcf_ct_flow_table, key),
+	.key_len = sizeof_field(struct tcf_ct_flow_table, key),
 	.automatic_shrinking = true,
 };
 
@@ -316,11 +321,12 @@ static struct nf_flowtable_type flowtable_ct = {
 
 static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 {
+	struct zones_ht_key key = { .net = net, .zone = params->zone };
 	struct tcf_ct_flow_table *ct_ft;
 	int err = -ENOMEM;
 
 	mutex_lock(&zones_mutex);
-	ct_ft = rhashtable_lookup_fast(&zones_ht, &params->zone, zones_params);
+	ct_ft = rhashtable_lookup_fast(&zones_ht, &key, zones_params);
 	if (ct_ft && refcount_inc_not_zero(&ct_ft->ref))
 		goto out_unlock;
 
@@ -329,7 +335,7 @@ static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 		goto err_alloc;
 	refcount_set(&ct_ft->ref, 1);
 
-	ct_ft->zone = params->zone;
+	ct_ft->key = key;
 	err = rhashtable_insert_fast(&zones_ht, &ct_ft->node, zones_params);
 	if (err)
 		goto err_insert;
-- 
2.43.0



