Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12856181B87;
	Sun,  1 Sep 2024 16:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208495; cv=none; b=sku6bQq4aGb2+C8ZqYoXmie4V1sImbqWuGlt+W/QI43c+ROf5ZdyDQjq0Y0V8Yoc34k7WdPmwrQ+H+BLmt618XU699KwXIXvDAnK2c5/QZEjBrBz9DN0m+JskjqhnEoGdkTg0WE5qYORuxnH/tIbIX17UOkKc6M65RWb766AMA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208495; c=relaxed/simple;
	bh=rcuRA8I0NBD2/CFtUXTgi/PxiM02m39/4IdibUTzdW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDv7jbLdxraNO91ux48XfbT/RF2a3FCXnfc3glnFcjtq4ps0HSplJk+VuqZJYldEYgz7O0bw4CK1wIO7HbvhYDTjDZZuG+aT7osasPPwfaiwe6CmS0HsTWeQyKFY2Ui98PFa1dLwflkAGbr8SVBzvNs0lquw4jaQvTbbD7cRB2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2QGBUVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2QGBUVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72760C4CEC3;
	Sun,  1 Sep 2024 16:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208494;
	bh=rcuRA8I0NBD2/CFtUXTgi/PxiM02m39/4IdibUTzdW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2QGBUVjQeMiOiMggxe5MZ3LBPQncTUZ3G7RCA4bbwNvTjguiRefNO5qGM0eSH7+V
	 vzq9xIBLS87o2IKpuGKQFmLEbhhioL4Z9kZxkApdXoRgsw1hvNTNrM+XJd2yWddre2
	 vAwQXe4bXyu5xwxA8Tgz3MjfUYZPrlmZDPhQkYBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	John Sperbeck <jsperbeck@google.com>
Subject: [PATCH 6.10 100/149] net_sched: sch_fq: fix incorrect behavior for small weights
Date: Sun,  1 Sep 2024 18:16:51 +0200
Message-ID: <20240901160821.220956437@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bc21000e99f92a6b5540d7267c6b22806c5c33d3 ]

fq_dequeue() has a complex logic to find packets in one of the 3 bands.

As Neal found out, it is possible that one band has a deficit smaller
than its weight. fq_dequeue() can return NULL while some packets are
elligible for immediate transmit.

In this case, more than one iteration is needed to refill pband->credit.

With default parameters (weights 589824 196608 65536) bug can trigger
if large BIG TCP packets are sent to the lowest priority band.

Bisected-by: John Sperbeck <jsperbeck@google.com>
Diagnosed-by: Neal Cardwell <ncardwell@google.com>
Fixes: 29f834aa326e ("net_sched: sch_fq: add 3 bands and WRR scheduling")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Link: https://patch.msgid.link/20240824181901.953776-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 2389747256793..19a49af5a9e52 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -663,7 +663,9 @@ static struct sk_buff *fq_dequeue(struct Qdisc *sch)
 			pband = &q->band_flows[q->band_nr];
 			pband->credit = min(pband->credit + pband->quantum,
 					    pband->quantum);
-			goto begin;
+			if (pband->credit > 0)
+				goto begin;
+			retry = 0;
 		}
 		if (q->time_next_delayed_flow != ~0ULL)
 			qdisc_watchdog_schedule_range_ns(&q->watchdog,
-- 
2.43.0



