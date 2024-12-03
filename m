Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636721F4283;
	Tue,  3 Dec 2024 14:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236794; cv=none; b=UF6TxwrwanrYo49Umm9Za+ImS+A/pgT1uOBKua+qyyr0apBYdDjCk2FbXoLFMduFgZJhuCRbJbA+2/0vu8e/Zo9Qvp3ynKt3AId9LBGAVs3higdlOxXuKGAIAVhjabbfvtKoqzrmtETY6vlP9643p3kzrIKfANUD3Q59C46wQp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236794; c=relaxed/simple;
	bh=Gk3ddVKFmnPTjhTSbvEag7eYErC/J4SQGaRFbh4CZtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRsPzPpVvMCY/53VdHxtvqjq7Tt5HzmtaOdoFxyA3yJw6IS2fijbQy32rg2xhGTqKV8CAMn3Et1ToJQMV0iznTxhrJ5zeRLGav8GVzuI6V6gpbWT5Ni3PNdwZ1lJ6LukStGM0HyzuNdO6jc7JCsQ7BgUc1FAiL8y4B3As+mAdjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOBIrxLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOBIrxLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BF7C4CED6;
	Tue,  3 Dec 2024 14:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236793;
	bh=Gk3ddVKFmnPTjhTSbvEag7eYErC/J4SQGaRFbh4CZtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOBIrxLmHrksf8zSkN2ONECTG1v9dCoEk9HVoohtZVouavmZy3SkcDSKtZ+Z4b/5s
	 bOksAgv7stKbcuQitpICr/FpznAr+yfE7IjZFsTJQbLjbXrDqGVYH0EJ2M7+ehIHui
	 jSlD4NWbO/bhh9VHYZsi2CzcRpnmL6500pnbNx3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 4.19 119/138] arm64: tls: Fix context-switching of tpidrro_el0 when kpti is enabled
Date: Tue,  3 Dec 2024 15:32:28 +0100
Message-ID: <20241203141928.118385921@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -382,7 +382,7 @@ static void tls_thread_switch(struct tas
 
 	if (is_compat_thread(task_thread_info(next)))
 		write_sysreg(next->thread.uw.tp_value, tpidrro_el0);
-	else if (!arm64_kernel_unmapped_at_el0())
+	else
 		write_sysreg(0, tpidrro_el0);
 
 	write_sysreg(*task_user_tls(next), tpidr_el0);


