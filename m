Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C12C17ADE1;
	Sun,  1 Sep 2024 16:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209541; cv=none; b=IVp3CbHBALCw77Jjk5o9MkRcSntBH4+YbXPc5KlstxlSXlv9ADUfTzkOtzWONbcVJcNSs7UY1NqPYuTbMH+TgbutW30DQuEr3IB0Ac1Fs+NbZwg0vtZyjoFN1Lk3pSExPhfsKQtZgiOsh3Obhda4VTR3KHyUy+BZ8mvpCPyV4l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209541; c=relaxed/simple;
	bh=4OplOvx/23KUCPHYsPoaLSB5jBwy5JBiI1/xGqnQ+3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iB02WQlonI/nHpxW/SerDjm++lVtbn+HC/3gBE3+0qHsrX7C0ROKZ9cC0CG3mLBJdhJEilNFh2/tKl+MxtN2PyunF7RdTTOR+zjtTG98VNvStdL/FW3hU/ILduuPEsXpgN+APvyBqouPZ1RgL1DngsqH9YRmAbE4bjzMqbNsH7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmkaUMkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmkaUMkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6941C4CEC3;
	Sun,  1 Sep 2024 16:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209541;
	bh=4OplOvx/23KUCPHYsPoaLSB5jBwy5JBiI1/xGqnQ+3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xmkaUMkqzb+R8QFWmUyUVlpVHfsn2Gx48U2KGjDko6bLL6rXMglEYiXxzmqKtN49A
	 bcjAY/7f5SEYM8h9OIMDUQmEnaHT81KYzErtbEswnxo2AvtnUSZsR3Wat5WYDM6Nxr
	 IBHUif5g+eMkmve0InY4acvi9nHTszq0+zs/PCWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/151] parisc: Use irq_enter_rcu() to fix warning at kernel/context_tracking.c:367
Date: Sun,  1 Sep 2024 18:17:01 +0200
Message-ID: <20240901160816.412918744@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2762e8540672e..5e3b9be45de92 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -520,7 +520,7 @@ void do_cpu_irq_mask(struct pt_regs *regs)
 
 	old_regs = set_irq_regs(regs);
 	local_irq_disable();
-	irq_enter();
+	irq_enter_rcu();
 
 	eirr_val = mfctl(23) & cpu_eiem & per_cpu(local_ack_eiem, cpu);
 	if (!eirr_val)
@@ -555,7 +555,7 @@ void do_cpu_irq_mask(struct pt_regs *regs)
 #endif /* CONFIG_IRQSTACKS */
 
  out:
-	irq_exit();
+	irq_exit_rcu();
 	set_irq_regs(old_regs);
 	return;
 
-- 
2.43.0



