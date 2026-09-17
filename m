Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741634DDB20;
	Thu, 17 Sep 2026 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658767; cv=none; b=BGtDwHUm2CIf4nPoADV+k7QjtYaTbAHNLquaOwuUZMNEp4u1hk1qg9iHUywPoX4TCIqN8Z9tQGYTxWb7x1ca+zfK+y5vuv/ChO5dsbGAjl0u7EtQ/+1QYM3AOgySDR619Smrtx3ggD2HmyEpsJqE4ayqlePtlrdT8PsgkTKD3mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658767; c=relaxed/simple;
	bh=GhZPf+sw4hpOD3mgFW2Y2T0vDvhojZLNccQweP8vG4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qq+/nDYR7+CLSoc3hiblKs8V4REjK8xyKT3makxXnGMBI7iopteKxFBIM7w0EV359aMnwBwCYTnKCQMEhJIQLJ5WYfjh6cV/dh+ORvsWjljZSKRDQR3yiyPLL8bSV7YC04ZXp9AcXV7xIW4a7orr8RkqWX4RxQfd488gBL3KNu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2kWEflp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2kWEflp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA451F0089A;
	Thu, 17 Sep 2026 15:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658755;
	bh=5MuAV9dZ9vqaqCuvBOAx8ckZo0jw15SMeaAa10tEBc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u2kWEflp/I7Sk60Kb5e0VWVkjL6OdPLccCIwpBoxVnR8FDby4KCnJHqseyy0kf1hx
	 2YvafyKGVnQKBnmBybFG/2JjUxdsyoN4a+btBa27GQLfzAhk2OhOhYA1vf06SIRURp
	 GoXRuNrlSBhHo7HAGkkZjlW+rpOhg80GcJkOutwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1ebbc20f223b99446034@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 028/733] printk: Dont WARN on kthread_run failure.
Date: Thu, 17 Sep 2026 16:05:36 +0100
Message-ID: <20260917151351.421469975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 72dd0ec09e7cc98ed58ddeac26575e5d1ab8a93d ]

Since __kthread_create_on_node() returns -EINTR upon SIGKILL,
we should not use WARN_ON() in order to catch kthread_run() failure.

Reported-by: syzbot+1ebbc20f223b99446034@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1ebbc20f223b99446034
Fixes: 5f53ca3ff83b ("printk: Implement legacy printer kthread for PREEMPT_RT")
Fixes: 76f258bf3f2a ("printk: nbcon: Introduce printer kthreads")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://patch.msgid.link/76bb4c1c-5d85-4635-b3bb-fc06f292c59e@I-love.SAKURA.ne.jp
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/nbcon.c  | 2 +-
 kernel/printk/printk.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/nbcon.c b/kernel/printk/nbcon.c
index 4b03b019cd5ee..a5921a84a80ed 100644
--- a/kernel/printk/nbcon.c
+++ b/kernel/printk/nbcon.c
@@ -1382,7 +1382,7 @@ bool nbcon_kthread_create(struct console *con)
 		return true;
 
 	kt = kthread_run(nbcon_kthread_func, con, "pr/%s%d", con->name, con->index);
-	if (WARN_ON(IS_ERR(kt))) {
+	if (IS_ERR(kt)) {
 		con_printk(KERN_ERR, con, "failed to start printing thread\n");
 		return false;
 	}
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 6d363e42e2a05..96ff9547e888b 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3732,7 +3732,7 @@ static bool legacy_kthread_create(void)
 	lockdep_assert_console_list_lock_held();
 
 	kt = kthread_run(legacy_kthread_func, NULL, "pr/legacy");
-	if (WARN_ON(IS_ERR(kt))) {
+	if (IS_ERR(kt)) {
 		pr_err("failed to start legacy printing thread\n");
 		return false;
 	}
-- 
2.53.0



