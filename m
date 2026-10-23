Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774710;
	b=fpMCbKzjLOgbwyfL7WeYWSp+r9yuuX598Xp3mcA8BQYRnqEJIGO62JlxR4v43JNDahh4
	 PvCRes7CmkZNnFBNul6waeUp40BkhQu1lWgP5l5vEixBX2vrl85aPAYWG6S6tTRikwzVP
	 W1j46D7hDzOq4d4RFXNMAV3/YVl2KR3BvSupui63phTrwLnOdjASGZ9MSzK4q/pcwZogx
	 gJfyDBNbfxoCnE0DnVSjXIjKUL09j0sRaTbU0gTnYLywhQyIaywpMghb9WinvSSf4W0l3
	 6bAsD88AHWvdIJTI4nr2l5axc34zQKxp8QsL7HPEeTMygVOU/Rl6TZ+reAyAu+tDJlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S4thXeR41AvllQhDjYWijjVZjNifLozmQBdQ8DKYm+4=;
	b=ZEw7J+1zvP7GenkzAfIPMXGQ2ouVXqbZzWGw5Y052261n1Yy/orKCDxcVwARf6vyHfRf
	 CbQ0WVcM29tpeQ0pEQr3IBL6D4suD+p07f4t7+kV7/TQlfPZxCVp3vqKh7oLpP5NvzJDc
	 t98L1thO8zpWKlBzxbwRfNAmiT9/VHxNNTXY9AaY1gnAIhA23rd643uqD9avo/Felbn7b
	 AGDDoGgZZUKjEQJUQJTavK8zy60r5LMJ8/EXK1W3vpG9nOadms5nXUj5ZXZEGr/iFtlPC
	 nxCUO+5VbR4d6XL3sT+3GeOJrrIeayYZVRf+bcsex7r54HYCpkWoX5o9ecvehfx04rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqQOoqmL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A33606A31B;
	Fri, 23 Oct 2026 16:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqQOoqmL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9D51F01825;
	Fri, 23 Oct 2026 16:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774709;
	bh=S4thXeR41AvllQhDjYWijjVZjNifLozmQBdQ8DKYm+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqQOoqmLUCzHzIQLcZc2AVlq++1kd2IQDDGkaPyyw2Rbro1DHNWnWWMjVg/ZtCmJe
	 2HG2mvRmqLYPtQdxC+wetr/1/cJ5QjprpdSVu9aspQtBv33uq3C0ka4WChpTIRHuQH
	 DHAeMvmZC+IlY3RB8RzOsH6nWy07NEGUZCDy//Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Barbosa <debarbos@redhat.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 094/242] printk: Postpone kthread startup
Date: Fri, 23 Oct 2026 18:38:56 +0200
Message-ID: <20261023163716.000231448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 5f339c46f153184570f16c8e789c9709b14cbe8b ]

There have been various bug reports related to SMP systems hanging
on boot. The reports vary but seem to have some overlap with regard
to missed IPI's during SMP setup. The reports also show that
reverting NBCON console usage allows the bugs to disappear.

The NBCON kthreads for console printing are started very early
during boot using early_initcall(). Since these kthreads are
asynchronously enabling/disabling interrupts during early boot, they
may be interfering with early SMP setup on some hardware platforms.

Starting the console printing kthreads later has shown to avoid the
hanging on systems that could previously reproduce the issue.

Postpone kthread starting until after all arch initcalls have
completed.

Reported-by: Derek Barbosa <debarbos@redhat.com>
Closes: https://lore.kernel.org/linux-rt-users/arPmYPbFLf2EldIl@debarbos-thinkpadt14gen5.rmtusma.csb
Fixes: 76f258bf3f2a ("printk: nbcon: Introduce printer kthreads")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Tested-by: Derek Barbosa <debarbos@redhat.com>
Link: https://patch.msgid.link/20261016085441.857695-1-john.ogness@linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 96ff9547e888b..fbcfd3e1a1884 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3862,7 +3862,7 @@ static int __init printk_set_kthreads_ready(void)
 
 	return 0;
 }
-early_initcall(printk_set_kthreads_ready);
+subsys_initcall(printk_set_kthreads_ready);
 #endif /* CONFIG_PRINTK */
 
 static int __read_mostly keep_bootcon;
-- 
2.53.0



