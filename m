Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C9618F2CF;
	Mon, 28 Oct 2024 06:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097389; cv=none; b=L8SxNrMZK8YIu9lmg6V966jnoVKGKv82G9lKsC8yY/jDMRSEFyU5CfjzFSMvAtaW36WfUqJ6itWtOZa/wLBCfismCfjGAicrhP7De6huG3/5nMeZ6EJhKOaBUHPJ4b2tPBkRqO1UkxUnyUFHCG/N9YASo55JjJ4rutdTHZFD4Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097389; c=relaxed/simple;
	bh=v5cUK1lp2s0RrMqhLSf7NZUUlvdO7rC50x//51HxHAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssZYI/QAwLYn0KQJ1Z3O1u6ehcesRXjTRwXigBxULf7oDQEPechzJPiIvNI5gt/eCGs/S3bJJS+gDn+R8s48Ausam9P6C7Rqg4sentLb207CqAQWITlcoY7PC/TWpx+uIkswS6+h7fnjp8cbRibQa7F2NX9wc2lloq45kew/2yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tUU4ACR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tUU4ACR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB21C4CEC3;
	Mon, 28 Oct 2024 06:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097389;
	bh=v5cUK1lp2s0RrMqhLSf7NZUUlvdO7rC50x//51HxHAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tUU4ACRqV09OHmHwx3yv4gR75d4rw2YkkOa8M3Ikb8plnv8ztjDAh0E9UFW/Dymh
	 0KoOXYXSqjlWlpjkyFlYOy4kIGVSbjy60x6csLxluQwRBM2K4LDd9ZJa6JnlqJ7DYc
	 dVhA9xhF3qZ7nxVKNWHbPdcS8nddwVn4WHXc6O6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b65e0af58423fc8a73aa@syzkaller.appspotmail.com,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/137] net: sched: fix use-after-free in taprio_change()
Date: Mon, 28 Oct 2024 07:25:39 +0100
Message-ID: <20241028062301.574814796@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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
index 07f6f5343dd71..212fef2b72f50 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1681,7 +1681,8 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 		taprio_start_sched(sch, start, new_admin);
 
-		rcu_assign_pointer(q->admin_sched, new_admin);
+		admin = rcu_replace_pointer(q->admin_sched, new_admin,
+					    lockdep_rtnl_is_held());
 		if (admin)
 			call_rcu(&admin->rcu, taprio_free_sched_cb);
 
-- 
2.43.0



