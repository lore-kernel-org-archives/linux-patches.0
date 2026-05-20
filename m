Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B3E3F1AD9;
	Wed, 20 May 2026 17:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299168; cv=none; b=Z3qge3uaidc8QvJLdsn5BKtBvw5PDiW7MbuirIuWPDB3dDwuOldtg6Nk8mjcYHiDDXBPjKDfKn3jauwg8cx3XWIhdRDrgGvnYfUBXscHepPJ8/zQT7lLI1HwNLU4WaOFDkgwvSqnvceukwIBbi0WQdKGuvmg2dfZ1+73oKeTOcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299168; c=relaxed/simple;
	bh=Veuwbopb5jtuP4qL6YaoI5kO8stHJ0nb27LK4tzQIFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3fwMTm6diYkn10JzF5JYul0f9OaipZph+n7rSibmvFrwoHVn4eVCWL+zFs9mkKEz/zTcw6DzKDGuDwt7EytoNJVXHK6pOLq/pmumqTjzIzIgpVTL1O3DPbOb15l8/KgRSLHt/hMj1nnvTUfKEZeWneMJqkhBEuI1v22w40Rj3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSiNs/au; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSiNs/au"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DACD1F000E9;
	Wed, 20 May 2026 17:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299167;
	bh=xHqw4KzgqKtZ8JVXoA/Riih1NUlZkfyruYV8NCf2lms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jSiNs/aujnTagbBYPjn088l7Q7h8TOTz9VEi6H7xmUylMTQrwlmUXwG0fljMLrkTx
	 AwK1oJulKYMnFOj1X+MF6XSP/dn4/VC3dh2VqWS+vp5hpdk2aTR/IpXbDdur4Shqm7
	 F6Il5v0p8BM76/ZH0TQ3GK9fvmZqVzIEDF/djQ+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 688/957] net/sched: sch_fq_codel: remove data-races from fq_codel_dump_stats()
Date: Wed, 20 May 2026 18:19:31 +0200
Message-ID: <20260520162149.460848654@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bbfaa73ea6871db03dc05d7f05f00557a8981f25 ]

fq_codel_dump_stats() acquires the qdisc spinlock a bit too late.

Move this acquisition before we fill st.qdisc_stats with live data.

Fixes: edb09eb17ed8 ("net: sched: do not acquire qdisc spinlock in qdisc/class stats dump")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260421142509.3967231-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq_codel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index a141423929394..90e1dfac6f594 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -584,6 +584,8 @@ static int fq_codel_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	};
 	struct list_head *pos;
 
+	sch_tree_lock(sch);
+
 	st.qdisc_stats.maxpacket = q->cstats.maxpacket;
 	st.qdisc_stats.drop_overlimit = q->drop_overlimit;
 	st.qdisc_stats.ecn_mark = q->cstats.ecn_mark;
@@ -592,7 +594,6 @@ static int fq_codel_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	st.qdisc_stats.memory_usage  = q->memory_usage;
 	st.qdisc_stats.drop_overmemory = q->drop_overmemory;
 
-	sch_tree_lock(sch);
 	list_for_each(pos, &q->new_flows)
 		st.qdisc_stats.new_flows_len++;
 
-- 
2.53.0



