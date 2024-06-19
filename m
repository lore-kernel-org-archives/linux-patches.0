Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BE5143C58;
	Wed, 19 Jun 2024 13:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802889; cv=none; b=JL4Zf4Ph+naqi8a5JLkp2qdvI7tj5FQPvyvxOB02Q6nh1EFq4uGxCa7dn+YhsSLx5SMEy/Hv035LsImP4QWyQPdNqj9WuBNQQegtone6I/jDNB9M7pOEriJ/Fy41JFWFEXIXFA+u53bR5NjCCp0zcJzgcGCAEriKyQWj07SN+uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802889; c=relaxed/simple;
	bh=bm/0Tr0CdwwNQZR6JJwv2qTUeymw45Ofus8IHuvfO7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DD/ME2MYO1xjfEqpeDWzwErtFJ6w5ii126IMeQtV/Ov8mDUzQSclWiBG09TL91QPfCUTLLO15avborF2vSoHuwJnwY8LMc0n8tmg6Dv4rq7zWIXO8eeOcYAEQfLFHrzCggQny//jZ97CoaJ/OZgX7gkaGySNf9uoUx3Lu6N9lMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zp49/YGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zp49/YGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DDEC2BBFC;
	Wed, 19 Jun 2024 13:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802889;
	bh=bm/0Tr0CdwwNQZR6JJwv2qTUeymw45Ofus8IHuvfO7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zp49/YGb7VB5u9YsP+O+ZTTL42QFuvyYwvZx8rUbjS6obuI3YfKpZivZsnahHG0rq
	 nJtw/dAPoRC1oCDpC3Hbblfy2LcAWIoUr2spGpLE7G0YOagLsjY1s/Sts8H8x6cLi4
	 8BzBVcvAE3iuNeUP/feG7/Ku3yjn21kxUOAgbVGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Cong Wang <cong.wang@bytedance.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 040/281] net: sched: sch_multiq: fix possible OOB write in multiq_tune()
Date: Wed, 19 Jun 2024 14:53:19 +0200
Message-ID: <20240619125611.392021699@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 79e93a19d5fab..06e03f5cd7ce1 100644
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



