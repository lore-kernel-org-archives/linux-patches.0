Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A061063C3;
	Tue, 23 Jan 2024 01:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974076; cv=none; b=aeh16kSabCxMt7SHV47CwLv2/gvF5qQQQ05vrat75T23F3I30PGhtiCoW/qEBabsybAUO7rH6Ot98cJGh6IZej/yW7czveI1CmwVZm2cB8uJ6gU6vsYAEJush6feL8vkE5QyCAHfGq0X8kPAPDVO61RPRU7qgJSKAUJXSNDmxjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974076; c=relaxed/simple;
	bh=Zx93t4WrYNTYsFZhS59scngehJmuPRWc1qIZcn7Vfco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xymc7JKQ3F0yh6neogWCpODShUGls+tyR0S2VNHBHBI4SCO/ydZOwSnD8nnb0Wpg4ck/82C4IDB0R+wVx949dnHF7xO+tp4lIG4A2OyIe/osQAZcSIgC+lDYN5gU8fVv0BNY2KIePRyyqjOB7H4nMHHAwDBzRXoP/iYa76CEqKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HI77i0sf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HI77i0sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C63EC433C7;
	Tue, 23 Jan 2024 01:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974076;
	bh=Zx93t4WrYNTYsFZhS59scngehJmuPRWc1qIZcn7Vfco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HI77i0sf8aJuz3RaPlSc1N9QLqxUIvOxBvKeOogd6cNIG0HkMnrooFZBHFzLRkbs1
	 Y+NMpdSmQvNSv71P1HEL5JCn/3F9Z1ZjVpYsRw2I0IxjR6+pGqd6pQDlQ10Hirm/Sh
	 wgp2zNU772UFu2+7D+fV+35l5fNQqFeHKr43jTzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiwei Lin <s921975628@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Abel Wu <wuyun.abel@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/583] sched/fair: Update min_vruntime for reweight_entity() correctly
Date: Mon, 22 Jan 2024 15:51:11 -0800
Message-ID: <20240122235812.834374640@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index fa9fff0f9620..d336af9cba13 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3771,17 +3771,17 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
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



