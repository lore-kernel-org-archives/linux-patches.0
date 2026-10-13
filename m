Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B564F85B7;
	Tue, 13 Oct 2026 12:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894342; cv=none; b=lEhQhRvaXZIkpYPmXwyokLIs3S5u1oxSWdRJ/qqpCoT2FTx4s2Jkz5u/RyrQBFLTx0zcnRAATX/qt/RkMb4yspMf+YRgdqeaiIyZLHNUKPLVKFqU105Qj200cLOIRjE0Wp3AERJMm2CAtjRl1q1Uysx824+Qgw6y8WnABYJo8fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894342; c=relaxed/simple;
	bh=JI9mBlDccm1QKzg4bqVW+MkTC8YjgPFzAweiUTxSO3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vq65T8uI5IabBUwnEmK2WrZaeyUMbifCPPJpjmkL2D1KTSLL7CcGi2IktrpaO/63YjlnDWw1PfF7Zyl6oP/HAlOl6hxnP+hi4XApCMRD48hzDBsJMoYoYg+eIJxoXRwbJJpXUJIDEgYvkTj/J+lO5of+D/0uSeUmgCbZh8jTPVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIUKbd3k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIUKbd3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF85E1F000FF;
	Tue, 13 Oct 2026 12:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894341;
	bh=/8xgwv/5d4rbyUIAX9i6mO65GqMBrPQAdXX2KVAH/xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uIUKbd3khPfDROnp0vPg6JvJd5/q/KGRecvanj7tUFkbcRpgWP8/zno1jPkAT/n5X
	 dMLEHTOnGmQyNIa2isCENdneBevdS9ECGsALCygFf81wGSUZWNjYUV0VUwKn49guf1
	 WaaIiKZZxam80Md9qsRck23o+5iIUe7QEnkwRPXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1ebbc20f223b99446034@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 526/621] printk: Dont WARN on kthread_run failure.
Date: Tue, 13 Oct 2026 13:38:41 +0200
Message-ID: <20261013112933.303861646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9c1e8ec04c556..5ee30dffa8104 100644
--- a/kernel/printk/nbcon.c
+++ b/kernel/printk/nbcon.c
@@ -1340,7 +1340,7 @@ bool nbcon_kthread_create(struct console *con)
 		return true;
 
 	kt = kthread_run(nbcon_kthread_func, con, "pr/%s%d", con->name, con->index);
-	if (WARN_ON(IS_ERR(kt))) {
+	if (IS_ERR(kt)) {
 		con_printk(KERN_ERR, con, "failed to start printing thread\n");
 		return false;
 	}
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index cc3d57be447d1..dffdbbfa4a005 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3689,7 +3689,7 @@ static bool legacy_kthread_create(void)
 	lockdep_assert_console_list_lock_held();
 
 	kt = kthread_run(legacy_kthread_func, NULL, "pr/legacy");
-	if (WARN_ON(IS_ERR(kt))) {
+	if (IS_ERR(kt)) {
 		pr_err("failed to start legacy printing thread\n");
 		return false;
 	}
-- 
2.53.0



