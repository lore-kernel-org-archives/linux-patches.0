Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB90145327;
	Tue, 27 Feb 2024 14:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044067; cv=none; b=fkwXpYOQBOagvE0BQn+8GRvPafQ89uDgnnanOdDYqE3gTg51h6pgqp6aFlqs6fejGuo47UwjrTXeWL/5FXLTJUd4auebT9BX30cKs0QqNIUDk+1XjwCTrkq3w35QfZC4YwaRUF/8r+HZyTmx6VFey9cdYMRBsZpCmljc472tKlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044067; c=relaxed/simple;
	bh=r/PJJiTRgEZCDhbT8rakXImpdcoBRW/XG1fttwGRQ+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIkrN1wO9aLp2fEEc89wghyecoT6yPn3LlyY3k+IrqwL+fvmmftbgVmSphnoTpx9JQ9TONLGFVWEpv7q5ELTCr9MkpVn6m5VJ8WXtcJSlPfC3bOKQMqfeWsLmkmBDb9HMcpUQObaUUM2MJdG7qfIJdb7qLqGyPsbQwlk/vVE4wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNs4BEJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNs4BEJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E665C43390;
	Tue, 27 Feb 2024 14:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044067;
	bh=r/PJJiTRgEZCDhbT8rakXImpdcoBRW/XG1fttwGRQ+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNs4BEJH+cqOqiA+lDBhDHw2XA7RwCzZAm9IAymw+zfWEM3qs6C1G+Ng8Q7hE8CgW
	 Zm1Gbx2n9PETP2avWxd7Dd137j7ZhXeGYwsdGXlshIDGZ8y7bVH19/bNFOB4JOfVCE
	 1ImDAQTrTkrxe2K1/4CfHcBqURghICjDQZSbHc7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/122] seccomp: Invalidate seccomp mode to catch death failures
Date: Tue, 27 Feb 2024 14:26:52 +0100
Message-ID: <20240227131600.379321634@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 495ac3069a6235bfdf516812a2a9b256671bbdf9 ]

If seccomp tries to kill a process, it should never see that process
again. To enforce this proactively, switch the mode to something
impossible. If encountered: WARN, reject all syscalls, and attempt to
kill the process again even harder.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Fixes: 8112c4f140fa ("seccomp: remove 2-phase API")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/seccomp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 305f0eca163ed..0b0331346e4be 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -29,6 +29,9 @@
 #include <linux/syscalls.h>
 #include <linux/sysctl.h>
 
+/* Not exposed in headers: strictly internal use only. */
+#define SECCOMP_MODE_DEAD	(SECCOMP_MODE_FILTER + 1)
+
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
 #include <asm/syscall.h>
 #endif
@@ -795,6 +798,7 @@ static void __secure_computing_strict(int this_syscall)
 #ifdef SECCOMP_DEBUG
 	dump_stack();
 #endif
+	current->seccomp.mode = SECCOMP_MODE_DEAD;
 	seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL_THREAD, true);
 	do_exit(SIGKILL);
 }
@@ -1023,6 +1027,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	case SECCOMP_RET_KILL_THREAD:
 	case SECCOMP_RET_KILL_PROCESS:
 	default:
+		current->seccomp.mode = SECCOMP_MODE_DEAD;
 		seccomp_log(this_syscall, SIGSYS, action, true);
 		/* Dump core only if this is the last remaining thread. */
 		if (action != SECCOMP_RET_KILL_THREAD ||
@@ -1075,6 +1080,11 @@ int __secure_computing(const struct seccomp_data *sd)
 		return 0;
 	case SECCOMP_MODE_FILTER:
 		return __seccomp_filter(this_syscall, sd, false);
+	/* Surviving SECCOMP_RET_KILL_* must be proactively impossible. */
+	case SECCOMP_MODE_DEAD:
+		WARN_ON_ONCE(1);
+		do_exit(SIGKILL);
+		return -1;
 	default:
 		BUG();
 	}
-- 
2.43.0



