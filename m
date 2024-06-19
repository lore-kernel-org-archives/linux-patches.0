Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90FA14659A;
	Wed, 19 Jun 2024 13:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803542; cv=none; b=cNpVeDW3x4nIM+F7F5EYLomc6CrKPeYfhI6lo2i8zCauzRxLCJCPhDNezvOQj4f3BdCrsLeccAsD8VIbB+6TM9nv7g4xkns16xjPD4krdGWPqRA7f1r0VW/Aekoc7PgHm48kb0V8YZrDqaaFb+yf5DRe3Sj+5jgQ57HaLs97ud0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803542; c=relaxed/simple;
	bh=0pv3BTuxOdvuSLcEN4JjpPZdDalrTaBcPhYC+33FsiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qve5didzKPRFAJvuyh6tK4tKdp9ki8Yx7khs38e2qpN3OqUsQw5h1Ss4SRLGcUq5b1yCXAtZ+4nfb9MoZrXC5SnjeP/oR7QXxr7fw4FioGNl9qXD/FVVI/JHnBZhREB0VHy2trvQgk1x6Tw5weJpV7b/dJknQaIRZfpoDisezLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BZ/8q2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BZ/8q2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBED5C2BBFC;
	Wed, 19 Jun 2024 13:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803542;
	bh=0pv3BTuxOdvuSLcEN4JjpPZdDalrTaBcPhYC+33FsiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BZ/8q2AlVU2eqCcJ0E1euJziaQWAFMIjcZQmBYQNLIG0pgKEaX7l/uH8+D4puWSV
	 DYTK0G+pDMQU0BmCvhk48XLJVh3nIKsWIc9q+QzzHlal6lA2K5eQ3a5BX9IbDtpUmQ
	 rPa/lHHLQJnmdl3xY/mFBi3hx67VmQjrsEfOQ8XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Cong Wang <cong.wang@bytedance.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/217] net: sched: sch_multiq: fix possible OOB write in multiq_tune()
Date: Wed, 19 Jun 2024 14:54:23 +0200
Message-ID: <20240619125557.424723941@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit affc18fdc694190ca7575b9a86632a73b9fe043d ]

q->bands will be assigned to qopt->bands to execute subsequent code logic
after kmalloc. So the old q->bands should not be used in kmalloc.
Otherwise, an out-of-bounds write will occur.

Fixes: c2999f7fb05b ("net: sched: multiq: don't call qdisc_put() while holding tree lock")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Acked-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_multiq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index 75c9c860182b4..0d6649d937c9f 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -185,7 +185,7 @@ static int multiq_tune(struct Qdisc *sch, struct nlattr *opt,
 
 	qopt->bands = qdisc_dev(sch)->real_num_tx_queues;
 
-	removed = kmalloc(sizeof(*removed) * (q->max_bands - q->bands),
+	removed = kmalloc(sizeof(*removed) * (q->max_bands - qopt->bands),
 			  GFP_KERNEL);
 	if (!removed)
 		return -ENOMEM;
-- 
2.43.0



