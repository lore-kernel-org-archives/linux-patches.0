Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3E7225D9;
	Sun,  1 Sep 2024 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210084; cv=none; b=tQOcPOhtP3h1jIXiJ12WDvGbOwR6s1IiOJFL10XSwWLDEhcLha+xeGVrTJnRzrF4UB8Z/uhkvnxYgQyEJly0HXgKjraAu/dPx1nJV6v4CQwZXrem1PPRhdZwAlweGFNzWo2TQRJDGlYaAXUT7halD1PTy5jhvEiJXsBW3ZcKy7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210084; c=relaxed/simple;
	bh=DO0jdaCyd1Z0YYF3b+gpOd/aIa0T3k/GwM0Ii3TWpSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2A9APtDK603PCquydn3kO6fzbnLUFy4fOqCILxv8ggebuLAfU+H4MfFJHJOEsrbHBde3nCjb2+cu7itYj8Pix/o8HwPbIGsMRufg77wmknYZqGYbpipDHfiXHaDr6J+VfKw4vfezqkIWnmK9Nio4jozBUZpjmIgDgPidHewIL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXm3bWww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXm3bWww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0ECEC4CEC3;
	Sun,  1 Sep 2024 17:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210084;
	bh=DO0jdaCyd1Z0YYF3b+gpOd/aIa0T3k/GwM0Ii3TWpSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXm3bWwwnF63McN8vAEkx/rzaHWgYJ/qIE2np82FVAUpFLKMPh0NZwmBF4O8msA8C
	 e08sx2ODMDqVxMKyLJGXXofB/aKHSo7xle2qfpwHsndrnodzjZGdXMvzgv+XuoHN46
	 20HLvuw917Hcn34JY+bP9oM6vWL1XkMgcgL9gFkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/215] parisc: Use irq_enter_rcu() to fix warning at kernel/context_tracking.c:367
Date: Sun,  1 Sep 2024 18:16:36 +0200
Message-ID: <20240901160826.531858009@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit 73cb4a2d8d7e0259f94046116727084f21e4599f ]

Use irq*_rcu() functions to fix this kernel warning:

 WARNING: CPU: 0 PID: 0 at kernel/context_tracking.c:367 ct_irq_enter+0xa0/0xd0
 Modules linked in:
 CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.7.0-rc3-64bit+ #1037
 Hardware name: 9000/785/C3700

 IASQ: 0000000000000000 0000000000000000 IAOQ: 00000000412cd758 00000000412cd75c
  IIR: 03ffe01f    ISR: 0000000000000000  IOR: 0000000043c20c20
  CPU:        0   CR30: 0000000041caa000 CR31: 0000000000000000
  ORIG_R28: 0000000000000005
  IAOQ[0]: ct_irq_enter+0xa0/0xd0
  IAOQ[1]: ct_irq_enter+0xa4/0xd0
  RP(r2): irq_enter+0x34/0x68
 Backtrace:
  [<000000004034a3ec>] irq_enter+0x34/0x68
  [<000000004030dc48>] do_cpu_irq_mask+0xc0/0x450
  [<0000000040303070>] intr_return+0x0/0xc

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 5d9044e65a1a6..04127377b7be8 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -518,7 +518,7 @@ void do_cpu_irq_mask(struct pt_regs *regs)
 
 	old_regs = set_irq_regs(regs);
 	local_irq_disable();
-	irq_enter();
+	irq_enter_rcu();
 
 	eirr_val = mfctl(23) & cpu_eiem & per_cpu(local_ack_eiem, cpu);
 	if (!eirr_val)
@@ -553,7 +553,7 @@ void do_cpu_irq_mask(struct pt_regs *regs)
 #endif /* CONFIG_IRQSTACKS */
 
  out:
-	irq_exit();
+	irq_exit_rcu();
 	set_irq_regs(old_regs);
 	return;
 
-- 
2.43.0



