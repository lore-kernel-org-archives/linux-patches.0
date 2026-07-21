Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBCC46AA69;
	Tue, 21 Jul 2026 20:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665709; cv=none; b=vGf3kILY6tbefdp+2PJHYXpG59ZMw14O+vjlpq/LWQnwqVxtL9A2Ii1KQvJELEkkAuGK4lFkNDioIpQNjOfzTkMmUwIJw5P58MQkhCpU3tZVdSEZuV5XB3XlWHPKWaQeT3WCbS+noPVXgdhFY/4gW6I7YfwuHBVoaCQcxV0zUBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665709; c=relaxed/simple;
	bh=3pKs8PzWdcqhVTsN7lx/42IMTGfHxlmrFw30Zwx0520=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpD3QVfQPJLIOBj+vC2s0wCkVRZaEnCrSFOU4QAUKzrmx1/v0LKHPT1RKO53bzTv9ea7D09xJbJLslI0ZFpuJPhD2NCXWj+F1ZxKdR2IiVN0TbSNAZgvNv5o4i+By7pVjfAFcCv2kqjbrASCQq1RoDT9fYsHxM+2BTHYxj58aY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iO2i0dqy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iO2i0dqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C481F000E9;
	Tue, 21 Jul 2026 20:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665708;
	bh=EBkAm3FQo+UoGBcQmXLYoKYZi1L14ekoz2GcUnzfrBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iO2i0dqywdQia8GlfizLGutCIJY7NA8bKXD2/8OMGLvWsj8bhNWG1EVzJCEavFCsG
	 ibk6P5CswCh7qP5IwT+kJHdPGFCa5/nBwot4Cjrv4X8TW7tu9WA0hzz92tJrAvvF0s
	 2hj/tCN2d3Qfvw/1LcHJHhFd3Yp3I2aLmMo3NQaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0404/1266] net/sched: sch_htb: do not change sch->flags in htb_dump()
Date: Tue, 21 Jul 2026 17:14:01 +0200
Message-ID: <20260721152450.873123327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c8a426062923ac..2388c1213e1d26 100644
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



