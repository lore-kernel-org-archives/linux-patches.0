Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04A3360745;
	Thu, 20 Aug 2026 15:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238618; cv=none; b=IYg/EvllJUQoRh5hT2R9wfh9lYT4xLfBHEcP8xhKEUZr9vwPjj+p7V43ptJCkSJoJ/LPePO4wPZuBm6zRV09l5N9P9a6w2D3OwDKrp1gchiaGxPQEx/OJzpz6fOg6xCuqdtsYowFjwo+2toMHvJJTp8alubIWt5FbsGxfywoSVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238618; c=relaxed/simple;
	bh=25eUadmWc5jaSEio1LNDYe95ApLF6KZJvRBpEHxELuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/7E6/+7tgOUOMxPkAwcBWSkMKxwVfVfpRNKxaIh2OVHK3YJuN2TARkQgYkR4Q7CY61+AcavLrRC2XG/oA/LGmffu6YVhq79pgIsOWp2+4OmCc++NwcIDtm3KN+5HVGYAYNwT7GO5yd9HFPv4s6DyvP0bZ78xnLxzadLYBVzNXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsMLlwcz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsMLlwcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1F31F000E9;
	Thu, 20 Aug 2026 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238617;
	bh=2j9jeNTpFOeVw3B+8dyngCrYyS7yDQMxL0/rmStuUiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VsMLlwcztLI9x8KIbgpeV3TOzDhnJ7O0d/Etgvy5qWvBq0YAsyeJFQdJaxXzqieZB
	 LjA7iyfrFrwfKaSkgx+27asP1Bsp46K6UyTzWSLPcJuKnBR3Eo5fhpjoVIwTCAz30g
	 GHO1wDXt/FQqcBinGXPWZZSV/IBFrpLkHIM9Wpuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 210/228] net/sched: cls_u32: skip hash tables in u32_bind_class()
Date: Thu, 20 Aug 2026 16:55:52 +0200
Message-ID: <20260820145251.413528267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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
index ac98b1c2144a7..c297d7dbcf916 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1346,6 +1346,9 @@ static void u32_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
 {
 	struct tc_u_knode *n = fh;
 
+	if (TC_U32_KEY(n->handle) == 0)
+		return;
+
 	tc_cls_bind_class(classid, cl, q, &n->res, base);
 }
 
-- 
2.53.0



