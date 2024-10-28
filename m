Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE488837;
	Mon, 28 Oct 2024 06:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098305; cv=none; b=ewOLIetKZGPbEbs8hhnn0OpwfyvUDJjUhb3dy0JQ+qxt244qqEwI7dlxePOYu6tjZGvPrOaTJgeJx4pQDpT3jMwlGYSQ170cqdQ9PZBpoFba+mifEvefTLyY8lpUnat93V1tVubVECM0BahSh4AsguDM5AIiPnoFa7eIGoGPuzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098305; c=relaxed/simple;
	bh=1qp1vvDfKCOpFbbi4HMOQcKbhnHdvWIxr0kuxBFWT6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWpp2CwVHcI7Q5n3PdtnvQ19bo/0Fp7PiEYAJgJ1AZxyYaJnW3Id3aq78Kkdsr2riYnFHlzYD1y5fURA0viUsh3HGaTmByH7Uen7yZq8XVODXhpvFQIyUV9qXzTeR+2bxS82SrjZqRSzVuJRzD0mLrCPfbXr7DQw1lBPpLXngzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huBTCYyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huBTCYyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36275C4CEC3;
	Mon, 28 Oct 2024 06:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098305;
	bh=1qp1vvDfKCOpFbbi4HMOQcKbhnHdvWIxr0kuxBFWT6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huBTCYygh7Z2j0mVZZ+E4xXjLbA6z1qprHz6p3xj2il6KiWxwYGldCMKUrqGfx05Y
	 HnQnLrtC/d8vBgz2VWz5eYMCwB5+LFcXyXF4dSiarHXO7papvC0eRv4DHMCu4gUGZ/
	 qODNJgncoXSYurgEJ8B3BVtSoRppohNFJkB2yrPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b65e0af58423fc8a73aa@syzkaller.appspotmail.com,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 167/261] net: sched: fix use-after-free in taprio_change()
Date: Mon, 28 Oct 2024 07:25:09 +0100
Message-ID: <20241028062316.185009381@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 8498d0606b248..9f4e004cdb8be 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1965,7 +1965,8 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 		taprio_start_sched(sch, start, new_admin);
 
-		rcu_assign_pointer(q->admin_sched, new_admin);
+		admin = rcu_replace_pointer(q->admin_sched, new_admin,
+					    lockdep_rtnl_is_held());
 		if (admin)
 			call_rcu(&admin->rcu, taprio_free_sched_cb);
 
-- 
2.43.0



