Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCE0215764;
	Thu, 12 Dec 2024 16:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020209; cv=none; b=PCKfyAkB9IPNJy8UQ2qtfMcYuOAPKjAiMrINxFJAVL2UNFYLvJABZmpZY+pIeEf6IRZq31CKdSMJs0hNEA3LidRHFgtA6EPsHrhiIjPuI7LuduUkNOTsxnVn77/Ga7nFpu2M8I6jcMWrkJ/NfFmIRnBuwgXkgcbhzLREIW4vF2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020209; c=relaxed/simple;
	bh=SMHhaBuzvtRcHC9c4aIhDI7rWM3WscqLBOHBS6N8OxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukcgAmBaKpAEHzcMf2o/HR5cZV8vuWq2RXMC0PyhpzswWzECyRMRAY3RSycm8cKOjIRtJ5kAPyppCoHQc8YMyrtUosbt/2zwKTyhE1LgpIzAsuJogi9BhgDYXVshFlTU9S+0mdIa/oIDPJ4JbEnEtnU6M0Dfm5b0x1lvum2eVKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pll1SLtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pll1SLtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20FCC4CED0;
	Thu, 12 Dec 2024 16:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020209;
	bh=SMHhaBuzvtRcHC9c4aIhDI7rWM3WscqLBOHBS6N8OxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pll1SLtQGVqv0IFT5+q0SEZ7FpAwMFOqhUOLnXRdk2XJYbc2ywa6vioodPh4Qthdk
	 ysG0whE6N/RLIXPxJCT/Ue8zjWIBNtbenRExLryG04xjg2SyQYR5jDHo92ENGNF1bm
	 VNCWOYnWGhG0hCeMVogWVpjTpB5LkLqcwnnjXZV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 406/772] arm64: tls: Fix context-switching of tpidrro_el0 when kpti is enabled
Date: Thu, 12 Dec 2024 15:55:51 +0100
Message-ID: <20241212144406.700101541@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

commit 67ab51cbdfee02ef07fb9d7d14cc0bf6cb5a5e5c upstream.

Commit 18011eac28c7 ("arm64: tls: Avoid unconditional zeroing of
tpidrro_el0 for native tasks") tried to optimise the context switching
of tpidrro_el0 by eliding the clearing of the register when switching
to a native task with kpti enabled, on the erroneous assumption that
the kpti trampoline entry code would already have taken care of the
write.

Although the kpti trampoline does zero the register on entry from a
native task, the check in tls_thread_switch() is on the *next* task and
so we can end up leaving a stale, non-zero value in the register if the
previous task was 32-bit.

Drop the broken optimisation and zero tpidrro_el0 unconditionally when
switching to a native 64-bit task.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Fixes: 18011eac28c7 ("arm64: tls: Avoid unconditional zeroing of tpidrro_el0 for native tasks")
Signed-off-by: Will Deacon <will@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20241114095332.23391-1-will@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -426,7 +426,7 @@ static void tls_thread_switch(struct tas
 
 	if (is_compat_thread(task_thread_info(next)))
 		write_sysreg(next->thread.uw.tp_value, tpidrro_el0);
-	else if (!arm64_kernel_unmapped_at_el0())
+	else
 		write_sysreg(0, tpidrro_el0);
 
 	write_sysreg(*task_user_tls(next), tpidr_el0);


