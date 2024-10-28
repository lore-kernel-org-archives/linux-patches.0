Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365F1152E1C;
	Mon, 28 Oct 2024 06:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096961; cv=none; b=Yb4Y93npu/yWAzlJTh+O1fTj6qbD4lybtsmTprwLaahtBRccKAo/Qcoc+LRJcqP1TH/IZGQqEIAmeP9/DQg71MdhUCPwKL44jZfdgsiNAHl5k9b66Naf1LmYz0My1wXKh2ulBxIX6b5745ZSkQEJaPP5mtYGrMk0QjCqYbOj6y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096961; c=relaxed/simple;
	bh=pPRQFskTPW0E9aw6B8L9C6fUqh3NNOSUVoBoWozdf9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjG39jCNvPy8SA1QN6uOHS9X2W8PCK6Pss9JLnL48b+C3wwQtmJ/Nl8VBKVZndkKKLjjUdQQQZwBJLD7ukLt/vQxTrqtgCH5CPa5LOnUe9gEE3TunkwnVki2/lG3aqXsDs6HnCVknxFZeZpYcHCv9Sd0LAd9nMDExlN+1Vt48h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkmf6wLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkmf6wLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADC2C4CEC3;
	Mon, 28 Oct 2024 06:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096961;
	bh=pPRQFskTPW0E9aw6B8L9C6fUqh3NNOSUVoBoWozdf9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkmf6wLHFpuAsYx57KcdY4uJ6yOpDG6w752GIyjfYKzoP2WkSVlz4oPFLX8U0K4y9
	 Xm5bCLefRH8njYosWNa6mJzi1edE6fgsE7fGJUFltQKvlAi4uBMSByWpPPZl2sZ3ED
	 jG+8ST4CTfYP1v4yWzUpG23GYlfQdgoKmHcPXyWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b65e0af58423fc8a73aa@syzkaller.appspotmail.com,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 61/80] net: sched: fix use-after-free in taprio_change()
Date: Mon, 28 Oct 2024 07:25:41 +0100
Message-ID: <20241028062254.310783307@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit f504465970aebb2467da548f7c1efbbf36d0f44b ]

In 'taprio_change()', 'admin' pointer may become dangling due to sched
switch / removal caused by 'advance_sched()', and critical section
protected by 'q->current_entry_lock' is too small to prevent from such
a scenario (which causes use-after-free detected by KASAN). Fix this
by prefer 'rcu_replace_pointer()' over 'rcu_assign_pointer()' to update
'admin' immediately before an attempt to schedule freeing.

Fixes: a3d43c0d56f1 ("taprio: Add support adding an admin schedule")
Reported-by: syzbot+b65e0af58423fc8a73aa@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b65e0af58423fc8a73aa
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20241018051339.418890-1-dmantipov@yandex.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 49831bd6a37d5..44b971ef343ce 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1612,7 +1612,8 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 		taprio_start_sched(sch, start, new_admin);
 
-		rcu_assign_pointer(q->admin_sched, new_admin);
+		admin = rcu_replace_pointer(q->admin_sched, new_admin,
+					    lockdep_rtnl_is_held());
 		if (admin)
 			call_rcu(&admin->rcu, taprio_free_sched_cb);
 
-- 
2.43.0



