Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414941DEFC4;
	Tue,  8 Oct 2024 12:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389975; cv=none; b=QCYcJRajgqnDiZT0bjFI/w/Ap31Y88RqHu4fXF/3S0luM+s92eKoSsk6QoeuL5uUAf3nNCMq2FCgvnZK2Dlqa4RB/UqOcGM0F/ubLp9l7ErgABR/hJ++1+XA6yvlBy1U95FosmEfDtbCJqYTb2shCzk6EagFa1XgaWDrA4iO1lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389975; c=relaxed/simple;
	bh=tvrWH3zB01BKj5Xdch9Ybn8+RgikApBEl1OLVFqcytM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbcgephBQ0fIi+cYtldM0zEV2kvpH+TofGBvjhVZTi19UYrjnWTo4dQXbISfh5u4RHWJ2c9GCd1Hd9SYCGpDp9vzKKZLcm/EJ/x000r5HlumGuM+oJOb9zf2NiPB/QaBz+yeZbvZUP+wIZgGSvbSXQRhWcIqUX/eyV+2mo+xQNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZR4QgdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZR4QgdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCC7C4CEC7;
	Tue,  8 Oct 2024 12:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389974;
	bh=tvrWH3zB01BKj5Xdch9Ybn8+RgikApBEl1OLVFqcytM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZR4QgdIyRgiDSDaiQmFIB58dhVQRkw+ZP3dkhqdUT62h/r0+n5p4X9viQMRy4/Bp
	 P4/BJvW/RNXkDFpFklb8UDGujCdxdJk3NvYSJL5xpi9sJJC208rstTAmGpszWVI5RH
	 QLJ0T+P/q0Tz/FdJX1w2kiTIRw7AhnMTdEeXqi5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 151/482] x86/pkeys: Restore altstack access in sigreturn()
Date: Tue,  8 Oct 2024 14:03:34 +0200
Message-ID: <20241008115654.249622580@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>

[ Upstream commit d10b554919d4cc8fa8fe2e95b57ad2624728c8e4 ]

A process can disable access to the alternate signal stack by not
enabling the altstack's PKEY in the PKRU register.

Nevertheless, the kernel updates the PKRU temporarily for signal
handling. However, in sigreturn(), restore_sigcontext() will restore the
PKRU to the user-defined PKRU value.

This will cause restore_altstack() to fail with a SIGSEGV as it needs read
access to the altstack which is prohibited by the user-defined PKRU value.

Fix this by restoring altstack before restoring PKRU.

Signed-off-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20240802061318.2140081-5-aruna.ramakrishna@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/signal_64.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 8a94053c54446..ee9453891901b 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -260,13 +260,13 @@ SYSCALL_DEFINE0(rt_sigreturn)
 
 	set_current_blocked(&set);
 
-	if (!restore_sigcontext(regs, &frame->uc.uc_mcontext, uc_flags))
+	if (restore_altstack(&frame->uc.uc_stack))
 		goto badframe;
 
-	if (restore_signal_shadow_stack())
+	if (!restore_sigcontext(regs, &frame->uc.uc_mcontext, uc_flags))
 		goto badframe;
 
-	if (restore_altstack(&frame->uc.uc_stack))
+	if (restore_signal_shadow_stack())
 		goto badframe;
 
 	return regs->ax;
-- 
2.43.0



