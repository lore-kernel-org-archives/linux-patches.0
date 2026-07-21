Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9546F44AB7F;
	Tue, 21 Jul 2026 21:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668792; cv=none; b=HS87IytDafuY/RuHp+sCm+IBSUhJimZ1dKZAidarew2FOA+uZGJMFLM7Ky5ieZjTp2uNkvb56cZcvnbem6f4yeqjcE0HUCjMB+aRKz2bQi/2MzN50CnRebnUsLT4jjgKdbd9hLxIluUXobRv01EPpAmUCF+2hh9dJZoQqDECYX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668792; c=relaxed/simple;
	bh=S/9alnhcZbPGrziul94sBjAe2FIeoIprM+FYTZWZHVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCWitZF8Tv/unaDn/t6mzuvCRJj/lkRESg9/g+Az8PxteZfl2czdpYP5tOJUHYr3s86KUFSc0sj4c+2iRhW/+4NYuOk0Ad+U35u3F9+bLs9+T7Fl3inHpVcQdn0QeJX3VDN/6xA89M23GZEJyomu5txQTf9RyswphNXR49pGZ8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEZzEh6r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEZzEh6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ACF1F000E9;
	Tue, 21 Jul 2026 21:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668789;
	bh=gGR79NUFi+Xyk7ViXdU6merJwQHYNLEXGgZxvbTq3S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VEZzEh6rA4SmEk8IW0ZwbwHXjgDYRSSbt8Zrzj8ONGEKeaH5wanRWr+OXeK4U6q6w
	 5eQF1mHeae9gXjtf5Zbjk7A4uLehP0CFEJDAIRE3TRFFE2vbPnGxUa1Ap2E+ARJ3Xa
	 QbFsojiUQQ34PkflRI2wFdt4AITiyNZS60RxRd2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0309/1067] net/sched: sch_htb: do not change sch->flags in htb_dump()
Date: Tue, 21 Jul 2026 17:15:10 +0200
Message-ID: <20260721152431.507572115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7aac0916205b17..99e1a4c1fcb13d 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1145,6 +1145,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	 * parts (especially calling ndo_setup_tc) on errors.
 	 */
 	q->offload = true;
+	sch->flags |= TCQ_F_OFFLOADED;
 
 	return 0;
 }
@@ -1205,11 +1206,6 @@ static int htb_dump(struct Qdisc *sch, struct sk_buff *skb)
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



