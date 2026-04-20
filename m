Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039B44968FA;
	Mon, 20 Apr 2026 13:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691956; cv=none; b=OEppj/PbcXEx1xWRX7XTmwbfr7IUGg4RoQHoC6MvxCXQiPkCuKAkCuRzXwWH2H04vawsInl+loiUJhaEV6/+XCbrgquo6v8nisKs5N8cm/ZajCc+hBGFN0pTrH+iudjU3KUbj3aQaoAzX7uxdi9waCoWAWTSUYc10vlIy7I+NPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691956; c=relaxed/simple;
	bh=o0DbvR7DFJHvfcl1wEClCjUXG2mwPD4XP513TQOvdDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWG/rq6GNnJ8rezoM8bMIqTIdxVXkhDIUMe66dOegQLNg0LPRN1nM5aVB0PLDlyXl2H5QL2dEKwvzxwsXyfQ9S74eR7aONeYYWCrw1JMerBBBRG9X+dS/CC8z4N6NCWGk7/IHDSAYndgzQULV5eKRY0SYickdyT/11bvtEgV+Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXr4Pg2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXr4Pg2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA993C2BCB4;
	Mon, 20 Apr 2026 13:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691955;
	bh=o0DbvR7DFJHvfcl1wEClCjUXG2mwPD4XP513TQOvdDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXr4Pg2nYFmZcmczYkYkiCzwkkdOCf/RVgOv7iadxsU7WTQGvBX4OVcWKAWM3v7lj
	 G2DfOuWxa3oV5fusALAP5DqnPnSK7+5eaHsXgyszXSmqXoR9A5RrCkk8EWIN2HoR2T
	 emVARbFc0R8pFFwFAW7OOZ7mV1gb/MooigX4DJ4Iu4+1CyhGf138XjJydJmT0BKx8y
	 rM5kFzp2iJsh8lJh6rODQhjDetnYIWxjD4RkwTtGuHHV9RPVv8tOWhiKges0wHMPQe
	 2U020JWeDwS/XLUCEGjSojJoacdNKlfXR8d5yxFDFIfa/hrH6DN6QVbEhQZM0NPEds
	 WQArvOJYI1NLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ruide Cao <caoruide123@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jhs@mojatatu.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	elibr@mellanox.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: sched: act_csum: validate nested VLAN headers
Date: Mon, 20 Apr 2026 09:21:23 -0400
Message-ID: <20260420132314.1023554-289-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Ruide Cao <caoruide123@gmail.com>

[ Upstream commit c842743d073bdd683606cb414eb0ca84465dd834 ]

tcf_csum_act() walks nested VLAN headers directly from skb->data when an
skb still carries in-payload VLAN tags. The current code reads
vlan->h_vlan_encapsulated_proto and then pulls VLAN_HLEN bytes without
first ensuring that the full VLAN header is present in the linear area.

If only part of an inner VLAN header is linearized, accessing
h_vlan_encapsulated_proto reads past the linear area, and the following
skb_pull(VLAN_HLEN) may violate skb invariants.

Fix this by requiring pskb_may_pull(skb, VLAN_HLEN) before accessing and
pulling each nested VLAN header. If the header still is not fully
available, drop the packet through the existing error path.

Fixes: 2ecba2d1e45b ("net: sched: act_csum: Fix csum calc for tagged packets")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Ruide Cao <caoruide123@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/22df2fcb49f410203eafa5d97963dd36089f4ecf.1774892775.git.caoruide123@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/sched/act_csum.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 0939e6b2ba4d1..3a377604ad343 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -604,8 +604,12 @@ TC_INDIRECT_SCOPE int tcf_csum_act(struct sk_buff *skb,
 			protocol = skb->protocol;
 			orig_vlan_tag_present = true;
 		} else {
-			struct vlan_hdr *vlan = (struct vlan_hdr *)skb->data;
+			struct vlan_hdr *vlan;
 
+			if (!pskb_may_pull(skb, VLAN_HLEN))
+				goto drop;
+
+			vlan = (struct vlan_hdr *)skb->data;
 			protocol = vlan->h_vlan_encapsulated_proto;
 			skb_pull(skb, VLAN_HLEN);
 			skb_reset_network_header(skb);
-- 
2.53.0

