Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E75C131E54;
	Tue, 23 Jan 2024 00:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969100; cv=none; b=BOyUIMb5l8DWo3ZtNtjjGYv4A7qBPQn0aE81BNXxqCsNF6b4x1KG6Drw1uChDrhRpPLNlMKesyR/TuxffF9GWjPJ5nYUzzDw6NedBQTJyn29l24UqZArCr6JyWCmCRbGuKeuwVNTYpvyEzz0CfFUeoDquxeddETgT2Yk0wSsSiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969100; c=relaxed/simple;
	bh=ZE7Wp5pnAbLmsQTI4d9FJ3BjKkJPpRn6TN8JYS1S9dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcCrQVHj02YCnCZ6OPDTdrRHJ6Bgy3NeQdAVOIAGnF03FlJqs6WLIVVi8oJsncIYJRlt75NRG2QTzRA3kRBBtfX0DeviOPhKa89InmLAlQtGQq9dUxiwz2z5F6fU7jtScDft7TC9YsFbJHU/afxTg1i30jbVshB6bOjTzwkK/Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRIr2bB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRIr2bB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22E5C433F1;
	Tue, 23 Jan 2024 00:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969100;
	bh=ZE7Wp5pnAbLmsQTI4d9FJ3BjKkJPpRn6TN8JYS1S9dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRIr2bB0AJD2/4uVRPPxdM6dSpU5pQbpvdZPKGbxWuXI3lMt1zWMSR52LAXY4Jr7D
	 oNVRRYEBiNuubZfYgVOrkrohMi+R7aEqjhzqkBANz152CA+KoBF+/1xbDb0bJ1R7j3
	 MEN2rayD9cyVDMCIprJHpbmwPdB9YyV+P4C5yxsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiwei Lin <s921975628@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Abel Wu <wuyun.abel@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 020/641] sched/fair: Update min_vruntime for reweight_entity() correctly
Date: Mon, 22 Jan 2024 15:48:44 -0800
Message-ID: <20240122235818.735540995@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiwei Lin <s921975628@gmail.com>

[ Upstream commit 5068d84054b766efe7c6202fc71b2350d1c326f1 ]

Since reweight_entity() may have chance to change the weight of
cfs_rq->curr entity, we should also update_min_vruntime() if
this is the case

Fixes: eab03c23c2a1 ("sched/eevdf: Fix vruntime adjustment on reweight")
Signed-off-by: Yiwei Lin <s921975628@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Abel Wu <wuyun.abel@bytedance.com>
Link: https://lore.kernel.org/r/20231117080106.12890-1-s921975628@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d7a3c63a2171..4182fb118ce9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3811,17 +3811,17 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 	enqueue_load_avg(cfs_rq, se);
 	if (se->on_rq) {
 		update_load_add(&cfs_rq->load, se->load.weight);
-		if (!curr) {
-			/*
-			 * The entity's vruntime has been adjusted, so let's check
-			 * whether the rq-wide min_vruntime needs updated too. Since
-			 * the calculations above require stable min_vruntime rather
-			 * than up-to-date one, we do the update at the end of the
-			 * reweight process.
-			 */
+		if (!curr)
 			__enqueue_entity(cfs_rq, se);
-			update_min_vruntime(cfs_rq);
-		}
+
+		/*
+		 * The entity's vruntime has been adjusted, so let's check
+		 * whether the rq-wide min_vruntime needs updated too. Since
+		 * the calculations above require stable min_vruntime rather
+		 * than up-to-date one, we do the update at the end of the
+		 * reweight process.
+		 */
+		update_min_vruntime(cfs_rq);
 	}
 }
 
-- 
2.43.0



