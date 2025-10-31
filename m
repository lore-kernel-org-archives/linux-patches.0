Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798DC21FF25;
	Fri, 31 Oct 2025 14:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919429; cv=none; b=qAS12qu8xmbxIrrbLII8e1Ks0XqcfQG/3NkdCg58CVNxTQ4CaqEkRbuvBxIUoNwlfbg7QxkIx4qC5WcJjSLB98XP4bswnSJnPS97pq21IWlHYYyi8k243JyhCEFSGFJ8sekB3uvJLB3ZgfKnrT8bzhgMLZT1JoD0PCp5XTz06o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919429; c=relaxed/simple;
	bh=btwj2KJbr31QF1GrZNeVSsLTE8QSzprMl8Zg7L7dwVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5xjaHZl1JuDD3CQX0lAmcQg+ftGbsIHZblMCaw0D09n9ZFdl9QjQssJAG9F0+6K/bqCmCRHVLv32IHBEN7Urpbezz9cnhRwxv6uQbtnB5d+BINi4Dys5EpCPT9HMEk9qBK831aHC9ayEHSX5kI+km5frMmDiTsWelgLpDXklOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfgN486e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfgN486e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C523DC4CEF8;
	Fri, 31 Oct 2025 14:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919428;
	bh=btwj2KJbr31QF1GrZNeVSsLTE8QSzprMl8Zg7L7dwVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfgN486eT/KPdGMqrQpWXbqfOfdak+ZskQ7mPm0ACJ3ZV1mtRm2x2t86GwjZdS3p5
	 kzWz6ZiV38vwFSEBVbOl/mEo92Tm0qT3/47I5v9OUKuH5WqDtFNr76AZ8aWw7G27I/
	 g82at2ZD4XtF9hdUDCNETt7Oh3jZfgIYXxLCtAmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 07/40] seccomp: passthrough uprobe systemcall without filtering
Date: Fri, 31 Oct 2025 15:01:00 +0100
Message-ID: <20251031140044.121985399@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 89d1d8434d246c96309a6068dfcf9e36dc61227b ]

Adding uprobe as another exception to the seccomp filter alongside
with the uretprobe syscall.

Same as the uretprobe the uprobe syscall is installed by kernel as
replacement for the breakpoint exception and is limited to x86_64
arch and isn't expected to ever be supported in i386.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kees Cook <kees@kernel.org>
Link: https://lore.kernel.org/r/20250720112133.244369-21-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/seccomp.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 267b00005eaf2..1eac0d2b8ecbe 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -733,6 +733,26 @@ seccomp_prepare_user_filter(const char __user *user_filter)
 }
 
 #ifdef SECCOMP_ARCH_NATIVE
+static bool seccomp_uprobe_exception(struct seccomp_data *sd)
+{
+#if defined __NR_uretprobe || defined __NR_uprobe
+#ifdef SECCOMP_ARCH_COMPAT
+	if (sd->arch == SECCOMP_ARCH_NATIVE)
+#endif
+	{
+#ifdef __NR_uretprobe
+		if (sd->nr == __NR_uretprobe)
+			return true;
+#endif
+#ifdef __NR_uprobe
+		if (sd->nr == __NR_uprobe)
+			return true;
+#endif
+	}
+#endif
+	return false;
+}
+
 /**
  * seccomp_is_const_allow - check if filter is constant allow with given data
  * @fprog: The BPF programs
@@ -750,13 +770,8 @@ static bool seccomp_is_const_allow(struct sock_fprog_kern *fprog,
 		return false;
 
 	/* Our single exception to filtering. */
-#ifdef __NR_uretprobe
-#ifdef SECCOMP_ARCH_COMPAT
-	if (sd->arch == SECCOMP_ARCH_NATIVE)
-#endif
-		if (sd->nr == __NR_uretprobe)
-			return true;
-#endif
+	if (seccomp_uprobe_exception(sd))
+		return true;
 
 	for (pc = 0; pc < fprog->len; pc++) {
 		struct sock_filter *insn = &fprog->filter[pc];
@@ -1034,6 +1049,9 @@ static const int mode1_syscalls[] = {
 	__NR_seccomp_read, __NR_seccomp_write, __NR_seccomp_exit, __NR_seccomp_sigreturn,
 #ifdef __NR_uretprobe
 	__NR_uretprobe,
+#endif
+#ifdef __NR_uprobe
+	__NR_uprobe,
 #endif
 	-1, /* negative terminated */
 };
-- 
2.51.0



