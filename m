Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BBD4973B4;
	Thu, 17 Sep 2026 17:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665462; cv=none; b=NQReoXqEKMFq6ZqsUEp8AA01H4Wh7CYueYGrZ2+WrTHQQst54gHsuy2haarQ6IBgHxpJLgo+g6QsfmAY6VbhVgUdhkw2iyIDriCmh+AYL2Ctlb3apJ1+cmwuUW3PekTc/bdOZPVsQEONdzVJa7aoNAzx/LVhQkVLjPibaa9tEYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665462; c=relaxed/simple;
	bh=JC/9rs01IEzkycIj8W2VzaGo3CjCtduquG9hHhUeJUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTUmKeMnYbZTO5qfVJeKQD5inCiNST0liyjCwoMqONL/FfKtPxsIMVKnjOxnilmgrttfWFTfFjf87U42psTmnd3Da3weaDdDbZsE+fmGWU8MMCvyMPxZ6XD6fAxe3YVf8l8l1sFsy7IcIT630uzEjTlw7azS7/csBlMsx4TIikQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2FRakP2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2FRakP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDDB1F000FF;
	Thu, 17 Sep 2026 17:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665461;
	bh=61/1x7cjDJfgxR+2SMe3HxJLR7xjhHiEc+6zm8H5mkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2FRakP2zZdDb1gNc/CaM8uvxcAy+yOdnIerXl6S7Tx5ywb3N2I0DynnG8jNuV0xG
	 JuIO8W6EKW+cSi4v7rw6nE3Tc+qr9V0aEX5S/st9w7YHQnG0faf4NYNaMIrf5SlYNo
	 xHkJL3ywcN01s8+5Z7wdHfFtiGGXslZk1vFvOVzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0712/1250] printk/nbcon: Change nbcon_irq_work to IRQ_WORK_LAZY
Date: Thu, 17 Sep 2026 16:08:27 +0100
Message-ID: <20260917151611.194724111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 560f4deda32785e260056200f8bb911c475c5b88 ]

Change the nbcon_irq_work to be IRQ_WORK_LAZY, thus not raising
an IRQ upon irq_work queuing. The irq_work is then handled on the
next kernel tick. This additional delay is acceptable because
nbcon_irq_work is only responsible for non-emergency deferred
printing, which is delayed anyway. This has the benefit of not
needing to raise an IRQ for each printk() call.

On a side note, the Tegra20 and Tegra30 platforms can hang if an
irq_work IRQ is raised while entering cpuidle states. This problem
was reproducible by calling printk() while entering cpuidle. So
this change also provides a workaround for these platforms (as long
as they are not running tickless).

Link: https://lore.kernel.org/lkml/f3757a75-0ba1-4558-bf57-f19ab7e59a4c@nvidia.com
Fixes: 76f258bf3f2a ("printk: nbcon: Introduce printer kthreads")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260901093245.344455-3-john.ogness@linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/nbcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk/nbcon.c b/kernel/printk/nbcon.c
index 730d14f6cbc58..9c1e8ec04c556 100644
--- a/kernel/printk/nbcon.c
+++ b/kernel/printk/nbcon.c
@@ -1705,7 +1705,7 @@ bool nbcon_alloc(struct console *con)
 		return false;
 
 	rcuwait_init(&con->rcuwait);
-	init_irq_work(&con->irq_work, nbcon_irq_work);
+	con->irq_work = IRQ_WORK_INIT_LAZY(nbcon_irq_work);
 	atomic_long_set(&ACCESS_PRIVATE(con, nbcon_prev_seq), -1UL);
 	nbcon_state_set(con, &state);
 
-- 
2.53.0



