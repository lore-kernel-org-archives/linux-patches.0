Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AB63B19BA;
	Sat, 17 Oct 2026 16:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255639; cv=none; b=BTxjkFPwNYafe5mZa6UssOb/r6SddcMZz3s74jmykkEdmRbZKN2zMmWzjsVykY+N03NXpfJP+mvHbXLUr9f8ihVIN1NuXwB/Ls3mYEkcf2ypNNK4xNCEc1YyJX5D+3wc0xKL1/52t0jT6TUfNqLhsEuudiEaVEuR93uwQDFSKA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255639; c=relaxed/simple;
	bh=WSL/9aLn9IBHN9YfHi4HsX9RzCDghagVvC9G8tcQcbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeW4+FO2UsVRb5dlSVvTjXWbNqhT/EliHRRoC31j1TWvbtvwKujdYLsdblcKL/RPlP7ALLLKuEkSHPvoDWc4lYsci7xAJaMnnapONzt3mfG7GPmaBGaJzKVBlQOXIiF8qSxcZmRUF7AFOyhSDWXREqiKxOeS/oHZENIfmCkYxMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8x8cj/F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8x8cj/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EA61F000C4;
	Sat, 17 Oct 2026 16:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255637;
	bh=7sbYLKEzmtIwSTxPFwSGcvymn+mU/k2QmBTBmWV7RaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8x8cj/F6i3WVz45KMnDE4IGlsKNiNHP/tBDV85wwQQ5DOAbjCi1GnNpd1gfjPr3z
	 RqwwFy9h/sZKYhWLDPYHzIUdCrHcfjux3tuDVF5Gv1001wK9jjtYVvrAfVJYFneBoA
	 wL6XyfAug3qwZfJhrVhd1ww88GqNiiufgUdFGMW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1ebbc20f223b99446034@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 799/869] printk: Dont WARN on kthread_run failure.
Date: Sat, 17 Oct 2026 18:00:40 +0200
Message-ID: <20261017160057.389195757@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index df7769c4fb0f2..a947b1a75cce3 100644
--- a/kernel/printk/nbcon.c
+++ b/kernel/printk/nbcon.c
@@ -1333,7 +1333,7 @@ bool nbcon_kthread_create(struct console *con)
 		return true;
 
 	kt = kthread_run(nbcon_kthread_func, con, "pr/%s%d", con->name, con->index);
-	if (WARN_ON(IS_ERR(kt))) {
+	if (IS_ERR(kt)) {
 		con_printk(KERN_ERR, con, "failed to start printing thread\n");
 		return false;
 	}
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 1c5c26168cefd..d5c1dff1617c4 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3638,7 +3638,7 @@ static bool legacy_kthread_create(void)
 	lockdep_assert_console_list_lock_held();
 
 	kt = kthread_run(legacy_kthread_func, NULL, "pr/legacy");
-	if (WARN_ON(IS_ERR(kt))) {
+	if (IS_ERR(kt)) {
 		pr_err("failed to start legacy printing thread\n");
 		return false;
 	}
-- 
2.53.0



