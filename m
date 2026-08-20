Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C293F19E992;
	Thu, 20 Aug 2026 17:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247273; cv=none; b=NyPbKlNLrFCBAvNqI2EZeekhc4Ppo62KsBq4RlbLyU7gMFpMVhOC5Pkb7P15t6JWt2UV1abWfHlKeE31qvSSJMEWxudoNQDA7NabrVTvHvi5lzWHJmjf0F0nZrutvvVM5v0UYu7gp/0J3Ng8WXsQ9fF7iJghh8cBvgOAGkjmJAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247273; c=relaxed/simple;
	bh=yDOrwfrdfWZqet2C7ipFsI8w8cWHBYRWkSjwudZgDlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bR3Pp0gP2SQoO9k1nVLKH8brl1yidoGqToJZWvgm3/Y0nudpQFh1eaGiNvAHC0XTV1O2UKNGu/MzKwMAbhExGyXM581wg4f2aK+S+Il6fryIUeAlirXa3ayxXnRg2PdT17zMe4QetYQBRKBp8YudrI9WJIOhXsASJY2xZX/PI0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GzX/NyI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GzX/NyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295FD1F000E9;
	Thu, 20 Aug 2026 17:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247272;
	bh=hjpwl49rTbH743fl6nz2FPGTCpx3JjUZ9AUfa04Q9PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1GzX/NyIhHzfUXIOnAKYaCUVvKPiWum4lVHOjjNYe7qFVbQTImKmz+la1Kp6ncv3h
	 Pv/v/GrIZuuJcYRCnSu9i1S7Lkhtp9ktUxycNvvpdAV11/BHZBPv8GBSgRORAXyXds
	 eGrrC2HEHt41vh41YX6qO9j3rCbRaOL9x6J+D9BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/220] net/sched: cls_u32: skip hash tables in u32_bind_class()
Date: Thu, 20 Aug 2026 16:56:39 +0200
Message-ID: <20260820145229.805249089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 58e849c0acf41..a90de52e1ac8d 100644
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



