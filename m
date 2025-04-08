Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B22735973;
	Tue,  8 Apr 2025 11:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112291; cv=none; b=RMRP8+Z5qtRSCPdqXf97YuCWaZOFjQnMQPxuHcdIKcrn6buWEzKnxmm/7aVk0oW2ETkykhjKs+NjGcbx+feNKWDbiWT5QIyo15IhtGCtQxdiEPIY40r4fygNjD8UzGvqVfhPxiHFjxP9ktmJL2H/K8pSAIh8BcR4G5pyElHMvnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112291; c=relaxed/simple;
	bh=JdoWyvXuwX8ffB7P3vfiYBLp3jQQqW1NBgTkpIXBSOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heiOxBI9EMuArZIBZU7VsjRR49khKew7UGApYdBRaztKYvlL5IYubSpi8YwIS4Y0InxVUvpfD84ecwDF97Dv4U8/X3BftCMIO3SMASxd74ASpLOA5vUOaWQSCxqybTL2/U8VSVRdzmSPilw6R11awTaNRI8M88AhM9FWaXMKSUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVtRbSjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVtRbSjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC394C4CEE5;
	Tue,  8 Apr 2025 11:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112291;
	bh=JdoWyvXuwX8ffB7P3vfiYBLp3jQQqW1NBgTkpIXBSOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVtRbSjPTr4Sh68bKK5KBOu5SD6//YUbFdiVNwHv06v6x2JgSxVLNyvan07XusXis
	 4zrNu0c9IaaNJPkBCWE3XhlyK0DR3T7thKN9VcBYZxDz3ZjxhCh0GDYd+L6nENtHFv
	 orFmhK3gvNK7+dqeauzeggyAkF+zHhb/at1W7Opc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mincho@theori.io>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/279] net_sched: Prevent creation of classes with TC_H_ROOT
Date: Tue,  8 Apr 2025 12:46:38 +0200
Message-ID: <20250408104826.793238094@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 0c3057a5a04d07120b3d0ec9c79568fceb9c921e ]

The function qdisc_tree_reduce_backlog() uses TC_H_ROOT as a termination
condition when traversing up the qdisc tree to update parent backlog
counters. However, if a class is created with classid TC_H_ROOT, the
traversal terminates prematurely at this class instead of reaching the
actual root qdisc, causing parent statistics to be incorrectly maintained.
In case of DRR, this could lead to a crash as reported by Mingi Cho.

Prevent the creation of any Qdisc class with classid TC_H_ROOT
(0xFFFFFFFF) across all qdisc types, as suggested by Jamal.

Reported-by: Mingi Cho <mincho@theori.io>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: 066a3b5b2346 ("[NET_SCHED] sch_api: fix qdisc_tree_decrease_qlen() loop")
Link: https://patch.msgid.link/20250306232355.93864-2-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 516874d943cd9..d9ce273ba43d8 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -2164,6 +2164,12 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 		return -EOPNOTSUPP;
 	}
 
+	/* Prevent creation of traffic classes with classid TC_H_ROOT */
+	if (clid == TC_H_ROOT) {
+		NL_SET_ERR_MSG(extack, "Cannot create traffic class with classid TC_H_ROOT");
+		return -EINVAL;
+	}
+
 	new_cl = cl;
 	err = -EOPNOTSUPP;
 	if (cops->change)
-- 
2.39.5



