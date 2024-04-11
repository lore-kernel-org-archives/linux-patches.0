Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A2A145B14;
	Thu, 11 Apr 2024 10:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830158; cv=none; b=lMIUDvk0SvFi7BLtdFzzHgy7mK4fn5z+OO8DYjWjp0ksouTOmDR9/9kN8aTd5q92YGuOHg6ODV2pZ4tAB4BpH0r/IANFySTxjvrUxwsmhuaPaO4PNCzNbEi22FEe6I7R9ims5ECXx6rg58snaKpOQR2S4KBk5S3z0oXnZN6RNlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830158; c=relaxed/simple;
	bh=T7L7ReBVeE2F+9pIl63G9HdB94s6xK5YzgQjbG0lDMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klI7qQvmD7ZNT+a2jFCHkZq2JH4BabshpNSpfqDw01YSGX9up3Mc09QtIgk+xN0rKwdDnPfnk+ZLK2sLjL2wBOz/SD6rNZU9zBGtP7eWqC8X6gd5pmEcrDUSyhUwJM/a+BQ34nOz3mq2pc/BSgx5dIeBMNO3iAgjIa1eAjohTDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuEeZ1qH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuEeZ1qH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78187C433C7;
	Thu, 11 Apr 2024 10:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830157;
	bh=T7L7ReBVeE2F+9pIl63G9HdB94s6xK5YzgQjbG0lDMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuEeZ1qH+Ssq3s5QqFs+x3137HYCpRBa1PwAX66pppn9OuRtvj2xSE6IitkrDwNmU
	 t71F3s4WWH6cw/omGGXln2D0XG6cjz1s9xR1h/NpAxR2xLYJ1cCF6sOqDNeoIFmYz7
	 MrFvII2ola/PQrknECgGAtl/2xPbWiCTFveuUEP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 015/143] printk: For @suppress_panic_printk check for other CPU in panic
Date: Thu, 11 Apr 2024 11:54:43 +0200
Message-ID: <20240411095421.369742659@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 0ab7cdd00491b532591ef065be706301de7e448f ]

Currently @suppress_panic_printk is checked along with
non-matching @panic_cpu and current CPU. This works
because @suppress_panic_printk is only set when
panic_in_progress() is true.

Rather than relying on the @suppress_panic_printk semantics,
use the concise helper function other_cpu_in_progress(). The
helper function exists to avoid open coding such tests.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20240207134103.1357162-7-john.ogness@linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 7a835b277e98d..e1b992652ab25 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2328,8 +2328,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (unlikely(suppress_printk))
 		return 0;
 
-	if (unlikely(suppress_panic_printk) &&
-	    atomic_read(&panic_cpu) != raw_smp_processor_id())
+	if (unlikely(suppress_panic_printk) && other_cpu_in_panic())
 		return 0;
 
 	if (level == LOGLEVEL_SCHED) {
-- 
2.43.0



