Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EABD375226;
	Sat, 28 Feb 2026 17:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301550; cv=none; b=MTjiqZTK17jqo3RKhGdYqRGT1ntsCQDTL8/jx8GaX0tZWFH6pUZp1hEk6S9qdon6EMywc+6IMYeMf5QtcUOq+EZeG9aoLeQZDE2XPHkcBoggw9C4nraYsRt9pCvV9tVjvA9WMpmiR9sq7FaVW5oRe/n3sTE9uk3M/74yXPAZFF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301550; c=relaxed/simple;
	bh=UyULersl7ZgEjSJZEV+xxB3ZkP0sOWni99ZT4GmK+ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9WmcSQ3LxZuGcBIRdgp9Z0kSQJERqn8LhaIUL8UmBO3B9YjugQqVu9hnGWn3SsTkQeGjO1iAgzRvBOiSIxMJtj1Hod7MO5sl/YZWyBzF5KwE/WA1PDr7DlRpOCakQxef/Zr53Gt+3KjbLmTUrN2N2Q6+hq+7p8EsaL4dyfAn3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+czHWO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+czHWO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3145C116D0;
	Sat, 28 Feb 2026 17:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301550;
	bh=UyULersl7ZgEjSJZEV+xxB3ZkP0sOWni99ZT4GmK+ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+czHWO9+kB7jJ0PXGw0sluk/+YdSQUY9LR019paoAooooWKLaygdh0v7jRkVzECD
	 ejFesGs18JIF9LX0E8XnumyDuIVOBdREXwXyF2sXCdyH3u/G3K/irSn2iQQAeBNxV3
	 FbmH857Xk7rfccJhw2kaJ4X+kBoYzJTmvQzqX1Y22bP+gbNd3J91VO0EgWRnyMkgAa
	 Ud0I6HIWwryupU+6DGifGVJhXUcmkLZK8Ld7eragS2+LbQ49yno9kVVicIIrunMEdh
	 XGmCJcDKiPNjG1Rsnh2WALM1LsIUPDPzZ4X+UoErvmie8fZh9r+bn5Uq4msdGguKdx
	 +yG1KJeIhHXlg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ruitong Liu <cnitlrt@gmail.com>,
	stable@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 733/752] net/sched: act_skbedit: fix divide-by-zero in tcf_skbedit_hash()
Date: Sat, 28 Feb 2026 12:47:24 -0500
Message-ID: <20260228174750.1542406-733-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ruitong Liu <cnitlrt@gmail.com>

[ Upstream commit be054cc66f739a9ba615dba9012a07fab8e7dd6f ]

Commit 38a6f0865796 ("net: sched: support hash selecting tx queue")
added SKBEDIT_F_TXQ_SKBHASH support. The inclusive range size is
computed as:

mapping_mod = queue_mapping_max - queue_mapping + 1;

The range size can be 65536 when the requested range covers all possible
u16 queue IDs (e.g. queue_mapping=0 and queue_mapping_max=U16_MAX).
That value cannot be represented in a u16 and previously wrapped to 0,
so tcf_skbedit_hash() could trigger a divide-by-zero:

queue_mapping += skb_get_hash(skb) % params->mapping_mod;

Compute mapping_mod in a wider type and reject ranges larger than U16_MAX
to prevent params->mapping_mod from becoming 0 and avoid the crash.

Fixes: 38a6f0865796 ("net: sched: support hash selecting tx queue")
Cc: stable@vger.kernel.org # 6.12+
Signed-off-by: Ruitong Liu <cnitlrt@gmail.com>
Link: https://patch.msgid.link/20260213175948.1505257-1-cnitlrt@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_skbedit.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 8c1d1554f6575..5450c1293eb50 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -126,7 +126,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	struct tcf_skbedit *d;
 	u32 flags = 0, *priority = NULL, *mark = NULL, *mask = NULL;
 	u16 *queue_mapping = NULL, *ptype = NULL;
-	u16 mapping_mod = 1;
+	u32 mapping_mod = 1;
 	bool exists = false;
 	int ret = 0, err;
 	u32 index;
@@ -194,6 +194,10 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 			}
 
 			mapping_mod = *queue_mapping_max - *queue_mapping + 1;
+			if (mapping_mod > U16_MAX) {
+				NL_SET_ERR_MSG_MOD(extack, "The range of queue_mapping is invalid.");
+				return -EINVAL;
+			}
 			flags |= SKBEDIT_F_TXQ_SKBHASH;
 		}
 		if (*pure_flags & SKBEDIT_F_INHERITDSFIELD)
-- 
2.51.0

