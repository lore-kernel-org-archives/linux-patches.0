Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947301C1F02;
	Wed, 19 Mar 2025 14:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394857; cv=none; b=tSc8WqE2w8H3xH6PsA3o4deeURsTRML6tjCE7Rd6PPuUu3BJ7OxLTmkxoOceJR9oJHwUG/4gnQqJdBvCoYJAVQCf7Xn99+E9PENarDjqb4at77/mzJ4fa4kJ7b72oE4iRHAsT9/x0IUZaokrvIgRNl9W+Z05gMN9jqmB2CxUWmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394857; c=relaxed/simple;
	bh=Rl2t7T/CIXOCiopS6FrMjVXZBMDXjkiY0ZjijWjiiuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwFErKJA2mrsvgKAgmlJfPLuL/878d8G2NvrA1KZtbzorVeva51QdRWAYGZz4VU+6aT2jlAwboKG/l6BY8lz8n5piSwaAu6hAL/2O6GFv8bM9cfDiE4oGR3BVHCZ811D1BrTv5+KRT+mqnD8aZL3fb7UcxOsJfa85Pt5S3+DCYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlsqEMsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlsqEMsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C35C4CEE8;
	Wed, 19 Mar 2025 14:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394857;
	bh=Rl2t7T/CIXOCiopS6FrMjVXZBMDXjkiY0ZjijWjiiuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlsqEMsuBjn3rNtgsYzcv7aAUpg86P8tSIGa6L8vaPVPxVOXY28L9wg9mja3GzQR+
	 g9XeMwSD7EzA6fYkvUzwVORsoTq4crtjGPO8t++6XH5xHHS5BitSR7qWrLnGtYae/V
	 U4ipZI773df/u08810vQKU4jJCHUJXIMmzYgddEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mincho@theori.io>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 046/241] net_sched: Prevent creation of classes with TC_H_ROOT
Date: Wed, 19 Mar 2025 07:28:36 -0700
Message-ID: <20250319143028.861921413@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index fac9c946a4c75..778cf54df69b0 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -2254,6 +2254,12 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
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



