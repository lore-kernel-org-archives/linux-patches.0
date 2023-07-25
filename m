Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3221EA7E
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8295EC433C7;
	Tue, 25 Jul 2023 10:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282619;
	bh=l+S3awHmfaJzvv1vTt99gDKuXSmNtLhr00nSuPlsKBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtUL4HEvjwY3IwZ4xsDLrSvlZ4s/UieRePi/aX4xmZNMT0GghZJtf9md/0T5II7pT
	 oHkegkeOMIvgFbtMXWmfKHjc1xdgBhx2is8PwH3uFJ73Cl78pY1uEHYHThZjqll4N+
	 xQWUS7W5TqYrzhixI6rQlbo/IxMpxQ8zFWiAUFO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 165/227] net: sched: cls_u32: Undo refcount decrement in case update failed
Date: Tue, 25 Jul 2023 12:45:32 +0200
Message-ID: <20230725104521.741676071@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit e8d3d78c19be0264a5692bed477c303523aead31 ]

In the case of an update, when TCA_U32_LINK is set, u32_set_parms will
decrement the refcount of the ht_down (struct tc_u_hnode) pointer
present in the older u32 filter which we are replacing. However, if
u32_replace_hw_knode errors out, the update command fails and that
ht_down pointer continues decremented. To fix that, when
u32_replace_hw_knode fails, check if ht_down's refcount was decremented
and undo the decrement.

Fixes: d34e3e181395 ("net: cls_u32: Add support for skip-sw flag to tc u32 classifier.")
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index ed358466d042a..5abf31e432caf 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -928,6 +928,13 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 		if (err) {
 			u32_unbind_filter(tp, new, tb);
 
+			if (tb[TCA_U32_LINK]) {
+				struct tc_u_hnode *ht_old;
+
+				ht_old = rtnl_dereference(n->ht_down);
+				if (ht_old)
+					ht_old->refcnt++;
+			}
 			__u32_destroy_key(new);
 			return err;
 		}
-- 
2.39.2



