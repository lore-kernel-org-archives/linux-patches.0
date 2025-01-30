Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E751E6DCF;
	Thu, 30 Jan 2025 14:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246871; cv=none; b=cVQWoMeMGPADaiu7KfLxRZQfM2aeNHGS1ODVuOyHBb8FpDDJ7XINXS1QhYLJ5gb1Fs5r9/zxhTffW3JoL03jrkceGRpatYCsTgMeGSwoX6c2jFtZOmVS5tlHNWPv8FGFAebHJH886LjjoO41VndCUGYtY1rDTHsksFc36JCbdFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246871; c=relaxed/simple;
	bh=A+jVknv8JDNhtnorNGW1YcxIy+N1MzAEQDgXJW8DUPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqFThDmcFIXnfay1aqzdVXXXf8bKBYg+TxbEjux4ZQ/Vu2VbPHGiQsBsYmutW4lLHIBp7ym7wLy/c3vwP3TwCx8cq1ju+D+ueO66LhfLiclSX69YCV2U6zxBw1DeuxPitVHxkhYprXFISTylUSJX7sJ6ED7YFHwkfyViMczwoy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwXtZGGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwXtZGGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D40C4CED2;
	Thu, 30 Jan 2025 14:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246870;
	bh=A+jVknv8JDNhtnorNGW1YcxIy+N1MzAEQDgXJW8DUPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwXtZGGA6iv2B/Q3RqNr+W3+gWnkn5EtLmQqP+SDYlO7rb9zUfUgKW0uukfVSTgmH
	 6CeUN6U0sHiMFjJWVDiBl1oZgahSTxDueE34Ysr+RsqozDO+fHQsE3xE2jPOtYOz0T
	 IwnM5vBep6H294ByP9XouxxU4vmH1RTvYTCwl148=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 5.4 81/91] signal/m68k: Use force_sigsegv(SIGSEGV) in fpsp040_die
Date: Thu, 30 Jan 2025 15:01:40 +0100
Message-ID: <20250130140136.938326443@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

commit a3616a3c02722d1edb95acc7fceade242f6553ba upstream.

In the fpsp040 code when copyin or copyout fails call
force_sigsegv(SIGSEGV) instead of do_exit(SIGSEGV).

This solves a couple of problems.  Because do_exit embeds the ptrace
stop PTRACE_EVENT_EXIT a complete stack frame needs to be present for
that to work correctly.  There is always the information needed for a
ptrace stop where get_signal is called.  So exiting with a signal
solves the ptrace issue.

Further exiting with a signal ensures that all of the threads in a
process are killed not just the thread that malfunctioned.  Which
avoids confusing userspace.

To make force_sigsegv(SIGSEGV) work in fpsp040_die modify the code to
save all of the registers and jump to ret_from_exception (which
ultimately calls get_signal) after fpsp040_die returns.

v2: Updated the branches to use gas's pseudo ops that automatically
    calculate the best branch instruction to use for the purpose.

v1: https://lkml.kernel.org/r/87a6m8kgtx.fsf_-_@disp2133
Link: https://lkml.kernel.org/r/87tukghjfs.fsf_-_@disp2133
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/fpsp040/skeleton.S |    3 ++-
 arch/m68k/kernel/traps.c     |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/m68k/fpsp040/skeleton.S
+++ b/arch/m68k/fpsp040/skeleton.S
@@ -502,7 +502,8 @@ in_ea:
 	.section .fixup,"ax"
 	.even
 1:
-	jbra	fpsp040_die
+	jbsr	fpsp040_die
+	jbra	.Lnotkern
 
 	.section __ex_table,"a"
 	.align	4
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -1155,7 +1155,7 @@ asmlinkage void set_esp0(unsigned long s
  */
 asmlinkage void fpsp040_die(void)
 {
-	do_exit(SIGSEGV);
+	force_sigsegv(SIGSEGV);
 }
 
 #ifdef CONFIG_M68KFPU_EMU


