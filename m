Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6ED143C4E;
	Wed, 19 Jun 2024 12:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801963; cv=none; b=cO46x6SOXQ49ux4qyQ2AX3thCqp37Gq5yiCoK1mf59GDVLECLdhR7J04pA3o/hfL1lQxtrezZKSf9ehWrJp7ZbHtHpgDtIjEBZawN7UNd+X3tDEU4OTGK3wyLhTy2bhoK5scbAUE1rIjYh1IlCjgpN5H5XQipol/LLVOITyXcZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801963; c=relaxed/simple;
	bh=KIKd3cs6666Td+sbHGGezzO3Wsw+BCpQHZ0QVIVDiZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXwnwNf54CvrPhMN+g3AiX4oxnY+EeVKvQmyYgOOTq0NiZDMKeRn48EeUrsFRxFZe2GyUHq9X7q2Z4yHPz6FBsJSpLulTiuE+Wd9vk7hx4HadgyfM8UjqcnW6yXCe03DjhSejreuu0naeXBbzLf2O1Pc6zzm9OIV6a2X8e9/Vuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJWDbam5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJWDbam5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCE5C2BBFC;
	Wed, 19 Jun 2024 12:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801963;
	bh=KIKd3cs6666Td+sbHGGezzO3Wsw+BCpQHZ0QVIVDiZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJWDbam5C7h3tJWIukzBYs9GRoxKau6TjDttOu6ToaXtDwotowKA+wDHwxmREfPmx
	 zxkmsI4DEQusIEpPU+fsKMzfNsU7rCkn7RtpRB0L9pLmtNqeI0iGz16pqi3MzCuBQN
	 99PxXxXnDVQEuOBiQBUb+22gnwmPxf/Dj52inicc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Cong Wang <cong.wang@bytedance.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/267] net: sched: sch_multiq: fix possible OOB write in multiq_tune()
Date: Wed, 19 Jun 2024 14:53:06 +0200
Message-ID: <20240619125607.712284564@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



