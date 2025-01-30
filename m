Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE211E522;
	Thu, 30 Jan 2025 14:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247227; cv=none; b=tf43GEXHkcexshW+PuGLBaV4gN0WfUkgvYEgD+q/SMewOK27EgfSbFir2n2QbCzSN/XG7lI9uYjOhuj6g0dQoNIRC6gdNr0ls5qkB02XfBE35/RJRmENsrgC/xDveJL2o18+jrDuDw7PJbBX0oUtPp1hwNSdKXXxESxRd18V8mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247227; c=relaxed/simple;
	bh=RfWQp6YgY5T580jFRwarzy1iQjNsAixE5YSab8Pw/QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZqGpBZmBfwutl2OTl14aw3lzZxNt4T++mjIPj5RYgmbRSttdByCVXHorg2HBH4gmkYV+HO04bveg4Bxv7FJQpF8hdzEBSyS44+xaVQfU9I/Lv9jCHnfCT+7WYlh2ZftEDVm6395N9DBMQyv2PU9KBlllx9DhDIhdVicKP9n2uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sv4FnvIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sv4FnvIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D79AC4CED2;
	Thu, 30 Jan 2025 14:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247227;
	bh=RfWQp6YgY5T580jFRwarzy1iQjNsAixE5YSab8Pw/QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sv4FnvIlTI8V5UrQIrM/2wnXvBCC96+kHTacpMBqwfD/mbOF9tbCt82dQYUWaKXAO
	 ebnvHeVjANTqpG7xvCiXmu6+bIpX/jgG5zz2mpYU3ukjZyTpstpW7QkiJufsFhpKRd
	 juebON8yuH89paYeArqXS2XkDxU0K27wY4teOOOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 5.10 124/133] signal/m68k: Use force_sigsegv(SIGSEGV) in fpsp040_die
Date: Thu, 30 Jan 2025 15:01:53 +0100
Message-ID: <20250130140147.523499298@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1152,7 +1152,7 @@ asmlinkage void set_esp0(unsigned long s
  */
 asmlinkage void fpsp040_die(void)
 {
-	do_exit(SIGSEGV);
+	force_sigsegv(SIGSEGV);
 }
 
 #ifdef CONFIG_M68KFPU_EMU


