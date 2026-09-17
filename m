Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C16E397928;
	Thu, 17 Sep 2026 18:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668980; cv=none; b=grJ2kKbflfFD/fvdCQ/cTGLAkiszXuWzB1V5XFx425Xb5j+UxAYhXeprOp53Csi81JPKuRubX/thA7ImzEQ7t4Bfn48fn3aFYKlKFiPpdLtLA2Z/kRrmddEKSiqPnellqtx7j6PpbyFwOX5IVVrdH+xzCRCgDmYPFov/MoGo8Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668980; c=relaxed/simple;
	bh=jTuO2uCfm95xRpHDsCmd8GSGe5XgwT6tIqg5Xzrb4vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csWJL7BTDBtEDdFBI94+oWu3dRwLWegoHzrWp2UU9kt+OhmAhIryF8bV5mswIsXn250ki0JVdFgV/dry5LJbZeKExxnT3wgKZ5YzMs5mcvRQY8c9OVIekUMs7chvHj4bCLKrXKtpW8G93Xf0jXp84ust0mnSAfAFVFbfK6A7K10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wivLV9VK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wivLV9VK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5891F000FF;
	Thu, 17 Sep 2026 18:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668979;
	bh=/aWrEtbYHhaOWiRzc6vuPhpizMy8e9rjB+TVbvzm12w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wivLV9VKY9+a51QC7yUMW59v4Lo/irZHbVa1TGJQj8LpnXN/oiZIOACYRCn6vehwf
	 Y4nGISbHWvawA68v5sED8wcKTmvvUZ4dVjcUnlb3FHQE4Q61sXC9RVHJgS24e2mdci
	 PEy9KhXB80/RXQMphaSGBc8SHlZc/vqfBQPYzH1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0605/1102] printk/nbcon: Change nbcon_irq_work to IRQ_WORK_LAZY
Date: Thu, 17 Sep 2026 16:09:08 +0100
Message-ID: <20260917151555.205290827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 7b4dcb09ce998..df7769c4fb0f2 100644
--- a/kernel/printk/nbcon.c
+++ b/kernel/printk/nbcon.c
@@ -1695,7 +1695,7 @@ bool nbcon_alloc(struct console *con)
 		return false;
 
 	rcuwait_init(&con->rcuwait);
-	init_irq_work(&con->irq_work, nbcon_irq_work);
+	con->irq_work = IRQ_WORK_INIT_LAZY(nbcon_irq_work);
 	atomic_long_set(&ACCESS_PRIVATE(con, nbcon_prev_seq), -1UL);
 	nbcon_state_set(con, &state);
 
-- 
2.53.0



