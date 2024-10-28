Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D318B18E35B;
	Mon, 28 Oct 2024 06:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097801; cv=none; b=X/0k8qSk0uKE0L2xBFbnlC+Uj6anDQuK6ZtrAtAqw7/fcXn/fRw5EncdojRmxu0KzQ+VA5LWJb9nOFgyw3ZgKb/eGy3KhMujWeCrtiFWf7gzq4mdVaS9kJAZ3quqv1q+KAGpV6dP7HHfIo3o5cwzvDnkkNi3ZdImFPDP6s72UfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097801; c=relaxed/simple;
	bh=Y9CjdeMoP0McwqqNtxgNy7xRfuOCdG2QVEusfj+Yzeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLO95eYTOmNhWWoCj+9oUBvMqX6Mb97it9j6rXntaOKhsa9n3yNT3MAZDMfFgpZGL1rUFvHZoyMTPv4mFeCrIWL7h7X3vzVqftxj3UVetO1/a6Cis3fC3boWAVGp6hCx3iYGLsqik9bRuDI7LiUrlVVo7oByyBRuvAAU0Nq5Ufs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpbTq5Cm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpbTq5Cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732A3C4CEC3;
	Mon, 28 Oct 2024 06:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097801;
	bh=Y9CjdeMoP0McwqqNtxgNy7xRfuOCdG2QVEusfj+Yzeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpbTq5CmZt9JxOHG31/9CWcV6xYVkpN5YwOTZHY5WkTWVWTczSSCNSMh+mo/JiUN8
	 QQ0lOQSwT0qbsH6oC5Tm5WjkFp4pM0/woriQmQ/UQPl8ST2zCGZ1nig91B6AZ2prAx
	 kKVdFCB9MugZyUPyjkLIeg39qd+pOMq8o+I7Uqa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b65e0af58423fc8a73aa@syzkaller.appspotmail.com,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/208] net: sched: fix use-after-free in taprio_change()
Date: Mon, 28 Oct 2024 07:25:34 +0100
Message-ID: <20241028062310.417646682@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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
index 87090d6790362..bc8e55c6d63d1 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1988,7 +1988,8 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 		taprio_start_sched(sch, start, new_admin);
 
-		rcu_assign_pointer(q->admin_sched, new_admin);
+		admin = rcu_replace_pointer(q->admin_sched, new_admin,
+					    lockdep_rtnl_is_held());
 		if (admin)
 			call_rcu(&admin->rcu, taprio_free_sched_cb);
 
-- 
2.43.0



