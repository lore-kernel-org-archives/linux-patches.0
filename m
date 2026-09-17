Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4D053D0C7;
	Thu, 17 Sep 2026 15:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659214; cv=none; b=Eqzabbey+Zq9nFM+hCNOwEmP/oo/2OP7QBJD4i8yKlpU1VcKcMq2bj8iIHIv4vQE1Ut7wQvkajwI3uB950s8qR8N1pPIb46+9/2/+gwVylqc34cOUbQSvAv2LGyMF/sX2Tj1EzUvfjEqLXiiGqZrm2k0NjxV7go5nmYkklKabpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659214; c=relaxed/simple;
	bh=NDqFZH6/fvOCaNT4uDFs7VHsgRoHuZ+z1v3eQcSokD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5NTwLHmTnBEwxXbX8ajgtfuJPkBo4tCAqIMasDrsD7CxViIjnqdeMD8lb9VQnj/TLU796Z6Drk3QxovUoJNSveHvxvCvooC4JetdzVPHIEZptrJ1IYszPvATb0dkz3YxIfQzGP606jiofcxnWMyZ5Dp4UOTxJheuywEsLcXuWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pac6OfMm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pac6OfMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DFA1F000FF;
	Thu, 17 Sep 2026 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659197;
	bh=Y3TD1MPN7xGzs2wOFMK0j9YYq/HhZGpKRHmbkF4ZvXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pac6OfMm9REyJQpEQ2wkgLA9hwi8ZlyNtXTXwK8VF+S65zxobf9fsKFYcW6sVAEP3
	 gyRxE8lKDaTXPLebyheEwyeOdqsSo1zDIa1O+kDHaVHyCFEUv10PHDPbC3eN47d11r
	 /548kyPBronCNexj1QXY1FQCXrOwNAzU5JPNc7yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 177/733] printk/nbcon: Change nbcon_irq_work to IRQ_WORK_LAZY
Date: Thu, 17 Sep 2026 16:08:05 +0100
Message-ID: <20260917151355.523644195@linuxfoundation.org>
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
index a5921a84a80ed..ad79e30afd647 100644
--- a/kernel/printk/nbcon.c
+++ b/kernel/printk/nbcon.c
@@ -1782,7 +1782,7 @@ bool nbcon_alloc(struct console *con)
 	}
 
 	rcuwait_init(&con->rcuwait);
-	init_irq_work(&con->irq_work, nbcon_irq_work);
+	con->irq_work = IRQ_WORK_INIT_LAZY(nbcon_irq_work);
 	atomic_long_set(&ACCESS_PRIVATE(con, nbcon_prev_seq), -1UL);
 	nbcon_state_set(con, &state);
 
-- 
2.53.0



