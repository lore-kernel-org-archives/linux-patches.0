Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CBE264F97;
	Tue, 25 Mar 2025 12:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905532; cv=none; b=j/g3uKxkVVZB4PCSsksDAHuagw+olWLmjOxBaboxfN1l7HI7A+ZW5SN7/Ry758xrEJTJbCgGzUSoEbQK7Kfiq4siB2POCAGhI64LIDI0shy6k0ob7qNoI6lGiQfTNrA5mtc6qnJkLX0lSLQJqE5aOlaH0adtmgRxYcqTEQ5nric=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905532; c=relaxed/simple;
	bh=BZmy/0TZsfbLeWJc/4mrOpu/MlfBB4jt2zkcPkOIre8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+p/vimOd65Kqt3InktpKXFlLmzDDVulhQVLb3ngRPCyI5mjpS33Rmxb0ZH5xn5IQEPQ89YYjzyn8FDhLE8xPYTEsXZwHlM9v4tRIm8xEgtrHmYAakcNbcTRUJ7bMmvfRiC4MJdYAgpA8MJxSwYyTP+7f90XtbvT5N2cukW6cg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIzU/BLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIzU/BLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE590C4CEE9;
	Tue, 25 Mar 2025 12:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905532;
	bh=BZmy/0TZsfbLeWJc/4mrOpu/MlfBB4jt2zkcPkOIre8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIzU/BLXrnleQEZ5qpE7aBXgUWVW7Yv3ofrmPidxkaw/2fEqwwhKKebRzauUZ/i/0
	 CxY9RbryTF5xvgGvPVEEceGre/htsBsXQ1sRkvq3s1vjK08l9mWl7gNsmQRtHmypSc
	 6fvawAouxwSNKhKmJe3yt3CYTgjMZUrfMkPPJcf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mincho@theori.io>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/198] net_sched: Prevent creation of classes with TC_H_ROOT
Date: Tue, 25 Mar 2025 08:19:47 -0400
Message-ID: <20250325122157.300215706@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cb379849c51a4..c395e7a98232d 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -2200,6 +2200,12 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
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



