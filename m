Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE8D17967A;
	Wed,  3 Jul 2024 10:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003801; cv=none; b=LHaX8Ytgy82kLWDelvPl1AkYXSxKnAMuPOGzGHBMiPc19JyUJIm+bhCBUfaqcNV6J2p56ZJZzhK/cQPiayc+WfpP25/NZBbfefEZCFlXmVASgzwTDPEjEs2dsYBA/Cffnid2eGYXGtR1UdNDbskE4McfvD5qAT0vJU4eBNDbkCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003801; c=relaxed/simple;
	bh=PKjqseXSVIEVhmhIRT/Ju6tVCWGDjrIHKM3uHTcPLXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBHE2O0qxhU1NkUMEnFZkjT4oqtl06BK4Bf8dE3rmw7uAcqRQ2tQ1dDny0Gh70ZxIp9QpqYmDoBAo6ytrwDEkX8HCjQSZEUsXqpYR5/TJlB+grSz8l1Fq5JsyJ0XdZ/bijFdSnE29ut0Fd7uycAiJ4JbBXwsdB+Ru1fYbHjZXf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXCgXyVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXCgXyVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EACC2BD10;
	Wed,  3 Jul 2024 10:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003801;
	bh=PKjqseXSVIEVhmhIRT/Ju6tVCWGDjrIHKM3uHTcPLXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXCgXyVVChsV571040U67lYKskHgzYQ2IK3elvQlS/GEaud7mEpMWS7WQWrqw+Xeg
	 spFEJi+TMdI+rYRm590EdFdSlCZVFEjKg8TTuiYWvhYtR1BkbskPOB3YJCHAKHUXNA
	 iIY5KRrIy0suYcaV6IFls9anXMyeSavyLrfbscis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Cong Wang <cong.wang@bytedance.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/189] net: sched: sch_multiq: fix possible OOB write in multiq_tune()
Date: Wed,  3 Jul 2024 12:37:49 +0200
Message-ID: <20240703102841.815902010@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1330ad2249317..b822d3e74637d 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -186,7 +186,7 @@ static int multiq_tune(struct Qdisc *sch, struct nlattr *opt,
 
 	qopt->bands = qdisc_dev(sch)->real_num_tx_queues;
 
-	removed = kmalloc(sizeof(*removed) * (q->max_bands - q->bands),
+	removed = kmalloc(sizeof(*removed) * (q->max_bands - qopt->bands),
 			  GFP_KERNEL);
 	if (!removed)
 		return -ENOMEM;
-- 
2.43.0



