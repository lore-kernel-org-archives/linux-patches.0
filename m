Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CF117B424;
	Wed,  3 Jul 2024 11:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005331; cv=none; b=PjOTib3uhOt50Ym61/S6dmF5c56cdHHMvQ/SAkhKfMZTQWN/WL7OP/oRRQty51XGNziIqr0GvkYajTNyO+3xA/hs6BTSdoZFwhnvUkSW5QqA06A8dismZvyjA14fr8QyYC6RN9/HqAEqA0BfOL6C0QJBlT2gq4EROKLQ/uODDf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005331; c=relaxed/simple;
	bh=cOX/JhgxgGP0v+T1YDJDALASo/FkLf4xgudDMrAtedU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npOu90v7NdsczPQrjEKpT5Wdob3/o69bso+1AD1mucVPPSAsZc78Zhraa2nYqse6L5QfPYxMycORL/utj+zwA4y9QhcX0PzQg/LXGjhQXn4nB36fsJJo3Qs/az5ea3ggnSfySEdVmIkvQVD4b+Jv0G5qM5lhtJNbeHhZDj+w+SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOa8jdji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOa8jdji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E02C2BD10;
	Wed,  3 Jul 2024 11:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005331;
	bh=cOX/JhgxgGP0v+T1YDJDALASo/FkLf4xgudDMrAtedU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOa8jdjiRJaM3/iCjCuN1ubXZT2e+WzkYXBXf2LUvzNc9+NLMxZotJ1TnB6XZ5N2Q
	 4zz0HkH81mUlWLU2UqQsUJ++4vXjDF/eU06V3GxFj65sH6DCHtG8HzGCKWnEXOZkzE
	 Usm/Mfsti45JVJv+eTgbIpXBrgasPuFt1mkMPoIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Cong Wang <cong.wang@bytedance.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/356] net: sched: sch_multiq: fix possible OOB write in multiq_tune()
Date: Wed,  3 Jul 2024 12:35:51 +0200
Message-ID: <20240703102913.677154505@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8b99f07aa3a76..caa76c96b02ba 100644
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



