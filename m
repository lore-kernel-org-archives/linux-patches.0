Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D0D43E49D;
	Tue, 16 Jun 2026 15:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623157; cv=none; b=WVCk8CshzfUKIEnMVn5tU1UigrtO6tkfJ4TnvwHCm41TsQP4Qwyr8wCJUCkMivD6MSPlC5mQJlTpTYt+8W2Dh7A9jcczuZEmUlY6sMMGYEpIibR29SgVt32EKeNxILcC3uAguHTbf9Blo+2VCQz7L7WlaZZoKSZHkNHUqkU3KfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623157; c=relaxed/simple;
	bh=p3sZAr/SyrMs3Y9Zg6GT+7tgEP6TWYNkZ2ZkKxRlAE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfsLqAUFwn9OHAhhE1K9KOPnOhfafSC/5TQR1/mZvkBSJsUQFtZNgs0kZPpuB0TygfxG6cQuQqGeQFS2B2toHZNCFXlllFseM1P6T61f8c9mbL9QxkEz3inCyLf0DfxzlFCk6rl92jlsKfBlh+h5pQaAoG6cKZgZKCceg0DUTXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1f36262; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1f36262"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBB81F000E9;
	Tue, 16 Jun 2026 15:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623156;
	bh=AeRLlcAGl0vs1ujdhh33h03sMlj+PVFoMKpWPv2N/WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1f36262pXNwmOnU4ikhgmjBfF85iCsNDhyQZx3vm8Qdl93oiZgpj1xVqfUzTXfe4
	 buO+Mbv9juEhMRxNuHdiHyy5bNhzITYIn1vJFn6MxAWGg5w5sMbcn/yFj+sHf7QOTJ
	 SI1lXBQfmNpPRnSKqCg7b6ecoA9L/wPD253AyMfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Patel <ripatel@wii.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 097/378] riscv: cfi: reject unknown flags in PR_SET_CFI
Date: Tue, 16 Jun 2026 20:25:28 +0530
Message-ID: <20260616145115.399443909@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Patel <ripatel@wii.dev>

[ Upstream commit 15b4155138505669d3d43d7692459ee8ea2a86e7 ]

prctl(PR_SET_CFI,PR_CFI_BRANCH_LANDING_PADS) silently ignored
unknown control values. Only PR_CFI_{ENABLE,DISABLE,LOCK} should
be permitted.

This changes the behavior of the uABI (fails previously accepted bits
with EINVAL).

Fixes: 08ee1559052b ("prctl: cfi: change the branch landing pad prctl()s to be more descriptive")
Signed-off-by: Richard Patel <ripatel@wii.dev>
Link: https://patch.msgid.link/20260518183918.322545-1-ripatel@wii.dev
[pjw@kernel.org: change the patch description to note that although this is a uABI change, it does not break the uABI]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/usercfi.h             | 1 +
 arch/riscv/kernel/usercfi.c                  | 3 +++
 tools/testing/selftests/riscv/cfi/cfitests.c | 6 ++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index f56966edbf5c62..61ee02cee29720 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -50,6 +50,7 @@ void set_indir_lp_status(struct task_struct *task, bool enable);
 void set_indir_lp_lock(struct task_struct *task, bool lock);
 
 #define PR_SHADOW_STACK_SUPPORTED_STATUS_MASK (PR_SHADOW_STACK_ENABLE)
+#define PR_CFI_SUPPORTED_STATUS_MASK (PR_CFI_ENABLE | PR_CFI_DISABLE | PR_CFI_LOCK)
 
 #else
 
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 2c535737511dce..1ea86f21fbfa61 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -476,6 +476,9 @@ int arch_prctl_set_branch_landing_pad_state(struct task_struct *t, unsigned long
 	if (!is_user_lpad_enabled())
 		return -EINVAL;
 
+	if (state & ~PR_CFI_SUPPORTED_STATUS_MASK)
+		return -EINVAL;
+
 	/* indirect branch tracking is locked and further can't be modified by user */
 	if (is_indir_lp_locked(t))
 		return -EINVAL;
diff --git a/tools/testing/selftests/riscv/cfi/cfitests.c b/tools/testing/selftests/riscv/cfi/cfitests.c
index 39d097b6881ff2..0e3943461e7d83 100644
--- a/tools/testing/selftests/riscv/cfi/cfitests.c
+++ b/tools/testing/selftests/riscv/cfi/cfitests.c
@@ -141,6 +141,12 @@ int main(int argc, char *argv[])
 
 	ksft_print_msg("Starting risc-v tests\n");
 
+	/* Test unknown PR_CFI bits */
+	ret = my_syscall5(__NR_prctl, PR_SET_CFI, PR_CFI_BRANCH_LANDING_PADS,
+			  PR_CFI_ENABLE | 0xffff0, 0, 0);
+	if (!ret)
+		ksft_exit_fail_msg("PR_SET_CFI accepted reserved branch landing pad bits\n");
+
 	/*
 	 * Landing pad test. Not a lot of kernel changes to support landing
 	 * pads for user mode except lighting up a bit in senvcfg via a prctl.
-- 
2.53.0



