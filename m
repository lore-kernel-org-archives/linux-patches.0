Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393741C5F30;
	Wed, 19 Feb 2025 08:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953969; cv=none; b=KV3MVfwmLik37d1pJ5B1EHsacEmfu2F6IpIpQZArwr68182RAxAx9JU1TFWp+xVi7DJ98mrJmQHZN6/jrorOxY7Nf0IpY95R3RvmBoTB/t+89tPFViQ6fH8+XLdBedhBNRG1gpSDYhKsnrLFxjz9oIQ015cjyn3K/iogDfSEFvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953969; c=relaxed/simple;
	bh=y5O5Fd5NYf4zCeAFxpX+BIcDZdD99W0LBav7WdLxRak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jxi+Vk3gmheHNASH42OS+/64OHU3eId3CC+wu2sNC8zyA5ppDZNjZitGhOX8/03xcRCeKh6D1TfECjFmsqVaS8XWrBbRlH/0RPb2R1GQfNnxHpuUtdIrvYRhtfAyLcBsCVgoXt/JHJp9uLp5lEyJOgEcHUi0Ba0+IsfEcATHUkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0MMy4qO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0MMy4qO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2422C4CEE7;
	Wed, 19 Feb 2025 08:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953969;
	bh=y5O5Fd5NYf4zCeAFxpX+BIcDZdD99W0LBav7WdLxRak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0MMy4qOHOMrIdIP+lsemkdcgp3K8rJo3EEd9qkfuQbmblG4RFUmabQB9jzS+YTCf
	 UCudXnsK2zYQr9iL6axcPpelHcj1VTPqtY0VVyBJVCgVwUXolw6xxsgWJBWdkFEIfQ
	 K8bSbRlbKWsRkLbO4Iz1+o8/fDNtim3sAakqm/J4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 054/274] um: add back support for FXSAVE registers
Date: Wed, 19 Feb 2025 09:25:08 +0100
Message-ID: <20250219082611.633906978@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 5298b7cffa8461009a4410f4e23f1c50ade39182 ]

It was reported that qemu may not enable the XSTATE CPU extension, which
is a requirement after commit 3f17fed21491 ("um: switch to regset API
and depend on XSTATE"). Add a fallback to use FXSAVE (FP registers on
x86_64 and XFP on i386) which is just a shorter version of the same
data. The only difference is that the XSTATE magic should not be set in
the signal frame.

Note that this still drops support for the older i386 FP register layout
as supporting this would require more backward compatibility to build a
correct signal frame.

Fixes: 3f17fed21491 ("um: switch to regset API and depend on XSTATE")
Reported-by: SeongJae Park <sj@kernel.org>
Closes: https://lore.kernel.org/r/20241203070218.240797-1-sj@kernel.org
Tested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://patch.msgid.link/20241204074827.1582917-1-benjamin@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/um/os-Linux/registers.c | 21 ++++++++++++++++++---
 arch/x86/um/signal.c             |  5 +++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/x86/um/os-Linux/registers.c b/arch/x86/um/os-Linux/registers.c
index 76eaeb93928cc..eb1cdadc8a61d 100644
--- a/arch/x86/um/os-Linux/registers.c
+++ b/arch/x86/um/os-Linux/registers.c
@@ -18,6 +18,7 @@
 #include <registers.h>
 #include <sys/mman.h>
 
+static unsigned long ptrace_regset;
 unsigned long host_fp_size;
 
 int get_fp_registers(int pid, unsigned long *regs)
@@ -27,7 +28,7 @@ int get_fp_registers(int pid, unsigned long *regs)
 		.iov_len = host_fp_size,
 	};
 
-	if (ptrace(PTRACE_GETREGSET, pid, NT_X86_XSTATE, &iov) < 0)
+	if (ptrace(PTRACE_GETREGSET, pid, ptrace_regset, &iov) < 0)
 		return -errno;
 	return 0;
 }
@@ -39,7 +40,7 @@ int put_fp_registers(int pid, unsigned long *regs)
 		.iov_len = host_fp_size,
 	};
 
-	if (ptrace(PTRACE_SETREGSET, pid, NT_X86_XSTATE, &iov) < 0)
+	if (ptrace(PTRACE_SETREGSET, pid, ptrace_regset, &iov) < 0)
 		return -errno;
 	return 0;
 }
@@ -58,9 +59,23 @@ int arch_init_registers(int pid)
 		return -ENOMEM;
 
 	/* GDB has x86_xsave_length, which uses x86_cpuid_count */
-	ret = ptrace(PTRACE_GETREGSET, pid, NT_X86_XSTATE, &iov);
+	ptrace_regset = NT_X86_XSTATE;
+	ret = ptrace(PTRACE_GETREGSET, pid, ptrace_regset, &iov);
 	if (ret)
 		ret = -errno;
+
+	if (ret == -ENODEV) {
+#ifdef CONFIG_X86_32
+		ptrace_regset = NT_PRXFPREG;
+#else
+		ptrace_regset = NT_PRFPREG;
+#endif
+		iov.iov_len = 2 * 1024 * 1024;
+		ret = ptrace(PTRACE_GETREGSET, pid, ptrace_regset, &iov);
+		if (ret)
+			ret = -errno;
+	}
+
 	munmap(iov.iov_base, 2 * 1024 * 1024);
 
 	host_fp_size = iov.iov_len;
diff --git a/arch/x86/um/signal.c b/arch/x86/um/signal.c
index 75087e85b6fdb..ea5b3bcc42456 100644
--- a/arch/x86/um/signal.c
+++ b/arch/x86/um/signal.c
@@ -187,7 +187,12 @@ static int copy_sc_to_user(struct sigcontext __user *to,
 	 * Put magic/size values for userspace. We do not bother to verify them
 	 * later on, however, userspace needs them should it try to read the
 	 * XSTATE data. And ptrace does not fill in these parts.
+	 *
+	 * Skip this if we do not have an XSTATE frame.
 	 */
+	if (host_fp_size <= sizeof(to_fp64->fpstate))
+		return 0;
+
 	BUILD_BUG_ON(sizeof(int) != FP_XSTATE_MAGIC2_SIZE);
 #ifdef CONFIG_X86_32
 	__put_user(offsetof(struct _fpstate_32, _fxsr_env) +
-- 
2.39.5



