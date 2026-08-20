Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4298C215075;
	Thu, 20 Aug 2026 17:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248618; cv=none; b=PD9rpZq9Q8/WhsrcnLWqIDrHUTGvLMg/CAWCU8twpYYPeuq48Z3pjj98/RiJAclPRhnUaJliLk6trZZbhrBzQjLg6GazXo1GLzv3pnugoYKd1JasWwWBGTznxNx9IcZPaqPsX5moUU8Ct7o3ZYl0Kuoz9KpkJO6yEm2zhAw5Zv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248618; c=relaxed/simple;
	bh=FzpxociNs8t6yURbhP8Iw0fWuoyDy1BMsLGL7mgsSEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHv4wzwZ/KI3ttVa71ZuELKkfM35X251JOwiTLF5ogo3FefaHnN7Zpb3U+7EzHdup3FQu/g4JWsvjY3zVv/TyxUChqxsa1YKvjURMLuamJ3dLiBrI+z8cTrBvNxyau4pVdr14nKxfOMTkJvVpawiqrhL0Jq6FShfM1SD+aPDzHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hi9P2iTL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hi9P2iTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944391F000E9;
	Thu, 20 Aug 2026 17:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248617;
	bh=JJk/Nzjhwb+lXpID98fnOG3roN2RDjKAZrYDvFjDMrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hi9P2iTLbVz2TO8VSxppSRTPuuBnl9WRsXjc99ghz1pcMvlaR/R53Gs0SGXJO3hoJ
	 AQyGZl4bl1gdBDdAqUXDMd6sc0AeuZ9bEeT49CQlXPSRFoIo5cyB0Uh5B3NTA+DPvo
	 1SbpKER5JFIUMpuxVbPpkUFtniuYeIEn9kHctPAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 290/303] net/sched: cls_u32: skip hash tables in u32_bind_class()
Date: Thu, 20 Aug 2026 16:57:06 +0200
Message-ID: <20260820145302.189730118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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
index 5e85a8bf21237..1c914e721a3ca 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1330,6 +1330,9 @@ static void u32_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
 {
 	struct tc_u_knode *n = fh;
 
+	if (TC_U32_KEY(n->handle) == 0)
+		return;
+
 	tc_cls_bind_class(classid, cl, q, &n->res, base);
 }
 
-- 
2.53.0



