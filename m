Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393E01DEFD8;
	Wed, 19 Mar 2025 14:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395211; cv=none; b=dxLa6t3qs94VE1t53fgk5mfDEeAAWIyuq2Rdb8VpOFCOH4xpi9N5bYrbNiBSF4TZ72LbklvmZNzVgAQZ94UDzk/55eD+q+Y62M+1azPe0aKtMARk+B/lIRoGeT94BNCKa+/Tr6kAUFiSMuTK93P0thMV48SUPehXQoGzBq4ngpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395211; c=relaxed/simple;
	bh=BO5/yqfXmMAy4FmzIFrsLRv+Mm0p0OKu59q5d1C8UUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgNiEqDc+tULbHSzF00wEdqskcCuf23onEvedf2izOWShZ0hrb7bwaMn+N5jP7sXIO8IuBGPWJUvtI3Mfi5+o14y3Zr6wZm29P3HU+Y7ECxaUdRSijrEYleUwn7B4PZFC1BXIxEeijQ2/Z9hRwl23kfzUqNIOhMxx0ZZXN7G4ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gF0OCOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gF0OCOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B497C4CEE8;
	Wed, 19 Mar 2025 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395211;
	bh=BO5/yqfXmMAy4FmzIFrsLRv+Mm0p0OKu59q5d1C8UUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gF0OCOnPxDVq9PhW1WRE+6fco/LgrhEbGtS/P/cOzfmb8oGfGyx4U3sGembrFuL+
	 LCUM4IxcUMvto84k2xZsAAAsSyZv0RpBDSXkDu+0fLrFqgs0ZhN2PUXLR5blIcnESU
	 Wxb2bV0EdjhEEwU+EQvrNCSqykkPm9nLCNfMJN9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mincho@theori.io>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/166] net_sched: Prevent creation of classes with TC_H_ROOT
Date: Wed, 19 Mar 2025 07:30:00 -0700
Message-ID: <20250319143020.775321143@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7cddaa6321c7c..df89790c459ad 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -2197,6 +2197,12 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
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



