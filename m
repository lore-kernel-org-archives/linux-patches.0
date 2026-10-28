Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207562;
	b=5hZTeA+VnipHtVB6x+1KG1wys9MbTYSouI+zx24Q25cIJFziFekPvYdQOA12xKOdjo16
	 o43jFXTd9CCIE3tLnImo+gmvIJj29b/VYzUWvolZvsJVoclhCxj7VjTgPcMDLDzCH0qR1
	 iqATbAzs1No7FyMmhtR9Z19YktFeXiamaONoF8yr6b6mgoKzybSFnj+SsE3Gp0aYqlM7c
	 vnocOoapA1KASy7AQrdEE26WIkoupD1Uj/SuDIrqPJB0rMHlKKtZsel/o7WtcYdJQ9shB
	 h2xfbWHZJRn2rKr4v9QhZcQpjD0f93gX8nu27D+7pvcCfmL9chditDC9VkSDrt+ApcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wS7612M0o050wcaKhrwoGZTAaMQBcNX43dKB/py4sgc=;
	b=hFw+hafOYrV0wDrSpFLxLlx03IxLYqaYFIYXQB8r78uYsFJjrLoHZhyg/sx072hrDSgz
	 uqBO4WsxNMeRyq0wUkJMBY/u66qxbNNbGByVOLZnF7+KjZhueRbiNHIy7xwRetGv3NSum
	 10K6XC6oEr3paIyxCde5cacJy5wVuV1gbeEgldFyiijM7nBZoanm6T09LeedE5MHxvqwl
	 vmjLxiAq9WDLnelbaw6B0fdZ6fJEmcFEf1SnVHTKYEZNpiiRFj65DJ0uJqMTblH+2baPa
	 L6YLD9QB8lYYHH8jKThXe9BvmDMbR+Bu4rAjE/gQDjL9hdg5J929PVYQxUBMfFxqDRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JUtHGxuT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56805606A31A;
	Wed, 28 Oct 2026 17:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JUtHGxuT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EEB1F01825;
	Wed, 28 Oct 2026 17:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207562;
	bh=wS7612M0o050wcaKhrwoGZTAaMQBcNX43dKB/py4sgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JUtHGxuTE/4rm+OdloDO94vUgkI4XDLguXkT53+jm9iGAJCIsiNN1iHphpQJQuAXO
	 db5gRHnCIp9/JA9QirZZ4klc/quPVNrxoY58MjN9ugQ4DSZ63QRlwVoALjcQ4gToKr
	 OGjTd1O1tn+JiX28xzKUzVXnQyUvDCPkSgdK2wqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Barbosa <debarbos@redhat.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/247] printk: Postpone kthread startup
Date: Wed, 28 Oct 2026 17:57:43 +0100
Message-ID: <20261028165948.803630998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d5c1dff1617c4..72845f87089b6 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3767,7 +3767,7 @@ static int __init printk_set_kthreads_ready(void)
 
 	return 0;
 }
-early_initcall(printk_set_kthreads_ready);
+subsys_initcall(printk_set_kthreads_ready);
 #endif /* CONFIG_PRINTK */
 
 static int __read_mostly keep_bootcon;
-- 
2.53.0



