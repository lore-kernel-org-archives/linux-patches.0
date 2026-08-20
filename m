Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAF13803D7;
	Thu, 20 Aug 2026 17:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247804; cv=none; b=r3K8p4F9184Uj/O1R7JgkflF6ZygBtGvDGni5iIJFitfR+98rN4meFveTyu0ozT5M71QJH4v1o41FjNjLpnABwKaogYQfhZEx+TQ/sZEaWtCe9jPtd+crGg6Tj1fTGvSPr9F1iX+ekMjVbzxWXalliq9ZE2qAVn7LXWWbJ1TqTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247804; c=relaxed/simple;
	bh=mypNwgJzcg/ZhJFqiiJ5U4YubdfecrySimHaXspNaeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGwQEBY1oflVzYxGSiW+Xbg5g9bRDRFwgv1D5V4GJaAwlsSFrEl2NYQL/Vz4M6stYLFMTysQdGvl0tPABOm4GoQgUKLppMmUsj5XN7IpGvxPaBAacRuIZGPoWw9pseY15PWvDbtf8l318uAN9YV35ieBy6EJo9a/be4/atHZBHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yv1ymccC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yv1ymccC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7D01F000E9;
	Thu, 20 Aug 2026 17:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247803;
	bh=VsyMhxI+NOxqZZprQRJZU/jMw/JqycrTD2L0fK9wdUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yv1ymccCuDyBZyCjeNalgmYzqdqQtwcpNbtvzh/JxjatJB2jBVfKQKgliTYzPOWZR
	 Zh7DBI8a7M+qKwyzDmIoCcqn1U+okvJksTQzC9TKF+Y0WKT2yweVhn/0fK8/ovZlvD
	 xGfD4HG6pLulOd8wmY2aj3CNgUpxwlg8xyAaOwh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/166] net/sched: cls_u32: skip hash tables in u32_bind_class()
Date: Thu, 20 Aug 2026 16:56:56 +0200
Message-ID: <20260820145215.888961645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 6d3724e616faf952c3adcf8414fc21a828ef3709 ]

u32_walk() enumerates both struct tc_u_hnode and struct tc_u_knode
through the walker callback. u32_bind_class() unconditionally casts the
passed fh to tc_u_knode and accesses &n->res, so when fh is actually a
tc_u_hnode, which has no tcf_result member, this results in a
slab-out-of-bounds read of res->classid in tc_cls_bind_class().

The issue can be reproduced with the following commands:

    tc qdisc add dev lo root handle 1: hfsc
    tc class add dev lo parent 1: classid 1:1 hfsc sc rate 1000kbit
    tc filter add dev lo parent 1:1 protocol ip prio 1 u32 match u32 0 0 flowid 1:1
    tc class add dev lo parent 1: classid 1:2 hfsc sc rate 2000kbit

Fix this by skipping hash tables via the TC_U32_KEY(handle) check.

Fixes: 07d79fc7d94e ("net_sched: add reverse binding for tc class")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/1786089038-36366-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 9829df127d054..e0805fa99e647 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1336,6 +1336,9 @@ static void u32_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
 {
 	struct tc_u_knode *n = fh;
 
+	if (TC_U32_KEY(n->handle) == 0)
+		return;
+
 	tc_cls_bind_class(classid, cl, q, &n->res, base);
 }
 
-- 
2.53.0



