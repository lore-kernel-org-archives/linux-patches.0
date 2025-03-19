Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D434D1B0F32;
	Wed, 19 Mar 2025 14:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395055; cv=none; b=HEtFtbfibswMjjeB55kHTt/fAZ4z8KaB98yRvsC4ksw1Sb9HKFc6GD9AZIynYeXzvwHR+FJZbRelczg6tjZ9lr2kuHV7y3koIlrS02pceau0aMIqwZc4Uitu1ivx3y5AUV/8sJOfVpiLHWjgueKz0VmZgTwpkkdPpr+VgmjsVCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395055; c=relaxed/simple;
	bh=S/G6Y+RRgNVW9x5Fo+0p2cXCHx/eW0jIah3TslOKLtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MByHNmbkaCvPVA6MIlP9F+W1kLdKVCNZk2Ci/70u66arZ42RkJtb2h878YbbqV72/v7UDWkquDJJCQ8bkldPnqNYRBcIZ3D2vDytGB5iWQy1SxVwEbcnNzs1ObTptm/Ho+ifOWRNz5Rau/2j1P2PzGxMS5GwbhflqhlIEC3vag0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTH2MdAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTH2MdAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6574C4CEE4;
	Wed, 19 Mar 2025 14:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395055;
	bh=S/G6Y+RRgNVW9x5Fo+0p2cXCHx/eW0jIah3TslOKLtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTH2MdAceChAUv1YTbyEG0ZQKQrAglDccy3aifq3VypeUd+HEtv3D9dLs6ohkwUi/
	 gKvyRfncbqvohnYIxAjc3eolohALT4rOqAK8eC8WeUxhfzL3zUNS8TKSmlYjMCmCGG
	 vxHr1P4DPygHhs/U2xp/MJUppcsmK9ZlRpRGIkNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mincho@theori.io>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/231] net_sched: Prevent creation of classes with TC_H_ROOT
Date: Wed, 19 Mar 2025 07:28:59 -0700
Message-ID: <20250319143027.955150898@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d26ac6bd9b108..518f52f65a49d 100644
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



