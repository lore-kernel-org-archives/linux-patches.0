Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D083368B8;
	Tue, 21 Jul 2026 17:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655811; cv=none; b=txlFxwrEYPqxWOEjAHmLqNAL7Ix5xD5o3eCtEhKtTTBIkS9RkrJvo3ttCnwoLTOMMzM50gLsvTUJw+CfhyZmGKQy564ucq2Bm6/2G7GvWzh3Do84x9phZ5WYO9B+EYbPGKZJdj1q4eJXhv/SI45eriXQxx1BWksZ2166XQOeG5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655811; c=relaxed/simple;
	bh=9VPK1CZkYI0rQJVoMIxj7HUu1D9g1NgpJU66B88c338=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rg0NgNRuOGxPSHO0BNliIzkJ+KdaYKuvBm08h2SX2kbfcainlpAPa4Rk9NBC3Xy8OaA2sTPZSRvQG5ux5c53T+ft7OGbGSYRQKNKGci9xWeTE2JfWRT1ugxd5SgdNRaTFjlBKMjF9i7jQeYjLGpajS5SCM+3Fj+eCrZV8xzDR14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGLMu+Nr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGLMu+Nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFF01F000E9;
	Tue, 21 Jul 2026 17:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655810;
	bh=P04ICVEAdbKQda8DwjPA1M4QMrsSu5Z1Kx+01lXbbUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jGLMu+NrMwRZYLqXOM8qN02XWJ/x+iy15S39Qaa7zqZmEgeaWXtQDo91e5QCahRwh
	 JXd3hFgjOYpQ7EEEiWrTz+FTN3DMsohMK1WAXCAfFdFSpMty7FCfY5c+Um0J9OH6HK
	 ZTBi8QZTbN3pwsM5h5kKl1j8c5pQggg42yG/nzg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0151/1611] net/sched: sch_htb: do not change sch->flags in htb_dump()
Date: Tue, 21 Jul 2026 17:04:27 +0200
Message-ID: <20260721152518.275615597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 9b949fa69129e4b694ed11ee3be6d6edd4a9b8f4 ]

htb_dump() runs without holding qdisc spinlock.

It is illegal to touch sch->flags with non locked RMW,
as concurrent readers might see intermediate wrong values.

Set TCQ_F_OFFLOADED in control path (htb_init()) instead.

Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260514095935.3926276-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_htb.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index b5e40c51655a73..1dc8570aa77768 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1148,6 +1148,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	 * parts (especially calling ndo_setup_tc) on errors.
 	 */
 	q->offload = true;
+	sch->flags |= TCQ_F_OFFLOADED;
 
 	return 0;
 }
@@ -1208,11 +1209,6 @@ static int htb_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct nlattr *nest;
 	struct tc_htb_glob gopt;
 
-	if (q->offload)
-		sch->flags |= TCQ_F_OFFLOADED;
-	else
-		sch->flags &= ~TCQ_F_OFFLOADED;
-
 	sch->qstats.overlimits = q->overlimits;
 	/* Its safe to not acquire qdisc lock. As we hold RTNL,
 	 * no change can happen on the qdisc parameters.
-- 
2.53.0



