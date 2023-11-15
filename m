Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F01A3DBBF
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxT2bw0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F005C433C8;
	Wed, 15 Nov 2023 19:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076793;
	bh=ga4+0RJaU1HcWqu5H6VdVP7YrqORA2yaikhGFDXMvhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxT2bw0E2zPUEvmu5e+eteG7x78XAXR+TzVKHh07xJNeHF4m1vF+rZ1qXWNcvRXCm
	 R7VoWSfx45CXcQF8Sp8EcarIj6G0Tc8DzETq2OL9J8yIVEGFAPNYhWxaTT95Z50cHi
	 uW+Uwb8RbDWPXheNVidY4SEMyzMO+xoM08DRVL+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@fb.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/603] x86/nmi: Fix out-of-order NMI nesting checks & false positive warning
Date: Wed, 15 Nov 2023 14:09:33 -0500
Message-ID: <20231115191615.127377651@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit f44075ecafb726830e63d33fbca29413149eeeb8 ]

The ->idt_seq and ->recv_jiffies variables added by:

  1a3ea611fc10 ("x86/nmi: Accumulate NMI-progress evidence in exc_nmi()")

... place the exit-time check of the bottom bit of ->idt_seq after the
this_cpu_dec_return() that re-enables NMI nesting.  This can result in
the following sequence of events on a given CPU in kernels built with
CONFIG_NMI_CHECK_CPU=y:

  o   An NMI arrives, and ->idt_seq is incremented to an odd number.
      In addition, nmi_state is set to NMI_EXECUTING==1.

  o   The NMI is processed.

  o   The this_cpu_dec_return(nmi_state) zeroes nmi_state and returns
      NMI_EXECUTING==1, thus opting out of the "goto nmi_restart".

  o   Another NMI arrives and ->idt_seq is incremented to an even
      number, triggering the warning.  But all is just fine, at least
      assuming we don't get so many closely spaced NMIs that the stack
      overflows or some such.

Experience on the fleet indicates that the MTBF of this false positive
is about 70 years.  Or, for those who are not quite that patient, the
MTBF appears to be about one per week per 4,000 systems.

Fix this false-positive warning by moving the "nmi_restart" label before
the initial ->idt_seq increment/check and moving the this_cpu_dec_return()
to follow the final ->idt_seq increment/check.  This way, all nested NMIs
that get past the NMI_NOT_RUNNING check get a clean ->idt_seq slate.
And if they don't get past that check, they will set nmi_state to
NMI_LATCHED, which will cause the this_cpu_dec_return(nmi_state)
to restart.

Fixes: 1a3ea611fc10 ("x86/nmi: Accumulate NMI-progress evidence in exc_nmi()")
Reported-by: Chris Mason <clm@fb.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: https://lore.kernel.org/r/0cbff831-6e3d-431c-9830-ee65ee7787ff@paulmck-laptop
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/nmi.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index a0c551846b35f..4766b6bed4439 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -507,12 +507,13 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 	}
 	this_cpu_write(nmi_state, NMI_EXECUTING);
 	this_cpu_write(nmi_cr2, read_cr2());
+
+nmi_restart:
 	if (IS_ENABLED(CONFIG_NMI_CHECK_CPU)) {
 		WRITE_ONCE(nsp->idt_seq, nsp->idt_seq + 1);
 		WARN_ON_ONCE(!(nsp->idt_seq & 0x1));
 		WRITE_ONCE(nsp->recv_jiffies, jiffies);
 	}
-nmi_restart:
 
 	/*
 	 * Needs to happen before DR7 is accessed, because the hypervisor can
@@ -548,16 +549,16 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 
 	if (unlikely(this_cpu_read(nmi_cr2) != read_cr2()))
 		write_cr2(this_cpu_read(nmi_cr2));
-	if (this_cpu_dec_return(nmi_state))
-		goto nmi_restart;
-
-	if (user_mode(regs))
-		mds_user_clear_cpu_buffers();
 	if (IS_ENABLED(CONFIG_NMI_CHECK_CPU)) {
 		WRITE_ONCE(nsp->idt_seq, nsp->idt_seq + 1);
 		WARN_ON_ONCE(nsp->idt_seq & 0x1);
 		WRITE_ONCE(nsp->recv_jiffies, jiffies);
 	}
+	if (this_cpu_dec_return(nmi_state))
+		goto nmi_restart;
+
+	if (user_mode(regs))
+		mds_user_clear_cpu_buffers();
 }
 
 #if IS_ENABLED(CONFIG_KVM_INTEL)
-- 
2.42.0



