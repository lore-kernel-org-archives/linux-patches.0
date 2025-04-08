Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C4B266EFE;
	Tue,  8 Apr 2025 10:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109691; cv=none; b=r20h1ffkHS1Z8Zef7fyzYp+kqJj6PfL9/q4BDKWRWLV83T/AqKuntNZtH6PJyYxqXCiGaXKaDd/scaYuLXdkzCBj5sudjPZU5ACFFpTHPttsyWeIRVbXdBqIXytiPcnhVAp/NLW0QjZcFzR32vebSvCNZdQ2oEmTFGXvb7ym9GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109691; c=relaxed/simple;
	bh=k26pDkyDFeDbbZESzv1+l8KFrWPOu9fKS0GtRYT+Vu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgC5HL8PJswAFYz09r9Qf+FIsWE8jpWpsJ6EwsFzJxB9a+j2dZ7cdNQE622T6UGkePzr2sJB0+leASRBBw6L0SZKhgl1Q03CnwNS2RzsqXmNCia4XbT1VUG5DFau00cbc9ZZBYkKdw6g2NuT2sq0okR5ESYa2ZuL9tCYggTDm0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZqGQWH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZqGQWH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8B5C4CEE5;
	Tue,  8 Apr 2025 10:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109690;
	bh=k26pDkyDFeDbbZESzv1+l8KFrWPOu9fKS0GtRYT+Vu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZqGQWH8Sn0ESt6O30XFLJljCZXro4EeOwsWCDHXefKKw8noVypTa6DpwpuxTsRQt
	 twR8aPOzkNvtJ3QdD2CbUQxv2MTP2/JHhAx1w8kv3EnJXMpwSZ8CPsGRqUK/SF6nmj
	 Wp0CQFjXT5huJ5kuvDQOXXsflePTFPx5lQDDj6pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mincho@theori.io>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/227] net_sched: Prevent creation of classes with TC_H_ROOT
Date: Tue,  8 Apr 2025 12:46:36 +0200
Message-ID: <20250408104820.941520037@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 238ae7b0ca5ba..b8fb94bfa9606 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -2169,6 +2169,12 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
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



