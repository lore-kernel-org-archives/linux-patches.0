Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773943;
	b=3e4IIDKhIxKodWGRQFiR88otd+MgL0DnhDnMo1SGh+FNKdGcxvYDC3n8T3zzmnAQ+EEd
	 Lc47Shvo381SB/gJaqH67APlIlb8jMZ1B4+Ta0Ld1nJWODrGE2SoTXNbzJAvXxH2yo2nW
	 L8fx/AfSIm3O4nOPXb/rIM/M0L2E95UmRMXn3AdQyvPXUJd7fDg2c00YWg4mh1QxtoiQx
	 502DJHeMZThwp9ddhyGOs7XZYxfx1VGPzLsg2+0rDLK8FToTyovc1+dDkQgMSV19vB9/9
	 UOrzcHRgPUJWuZqIDpb24L/irjVHlZIGLmtQeiztazdDe443CIShxqpjEjjgLofYcKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EnGdlOIK/ppaSuLQ5eGYGo3xMlf4eA6KG821GY2LaGg=;
	b=5ToBxEjvElZFvNVmbpGAFWiDxQk7qEjEfQxYTM7PQ45IswUrS+ZIvIJO5HfOA0qtxf4M
	 PRz7y3obBhJRDg/kEeKnCfSRhSyyGv9u6tqLhRyBdd1kxz/si6OTRrCRVVlbw9BXH+UaH
	 KYXDMhdM7Aw2+R3uF5CsPxivYVBARD4IIy+tgYVa5llZUZAKrMgvoKRTpXwrIx0sx5pSb
	 H7cEHG2jeYOKIPfVyvZBhgGmEPluTO8rcFxQyC5cEtbnviudG++krmCgggsEc1ffmRZKg
	 /sVJ1fW+4vbrB1u4ehl31TBztAuIbkn6oH+RYyBorz5uG3X4hAsVfCtFwXzHq0oCJHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T4B9xw5/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5D2606A31B;
	Fri, 23 Oct 2026 16:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T4B9xw5/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383E41F01825;
	Fri, 23 Oct 2026 16:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773942;
	bh=EnGdlOIK/ppaSuLQ5eGYGo3xMlf4eA6KG821GY2LaGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T4B9xw5/+5/OdOPJWEXlDtwTL4deftqp31Lpz0ZRhhF6uXCu+yS6XTimhf9L8sauC
	 5YbbVF8g/ubdijZ6qhn370VZiLG1xi3wIJm0WdAKtntxMTxWZ9umw0RwgkPek17VyW
	 vCbL9wdgwNoyRXCdvWsmE+aBoQ6yMbs7wQs5quHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Barbosa <debarbos@redhat.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/193] printk: Postpone kthread startup
Date: Fri, 23 Oct 2026 18:35:46 +0200
Message-ID: <20261023163715.836894399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dffdbbfa4a005..d555d05ffa8d4 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3819,7 +3819,7 @@ static int __init printk_set_kthreads_ready(void)
 
 	return 0;
 }
-early_initcall(printk_set_kthreads_ready);
+subsys_initcall(printk_set_kthreads_ready);
 #endif /* CONFIG_PRINTK */
 
 static int __read_mostly keep_bootcon;
-- 
2.53.0



