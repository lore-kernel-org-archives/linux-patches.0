Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B36231A2D;
	Mon, 10 Mar 2025 17:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626492; cv=none; b=e0bkYayKudBQxjecV8os8PFae82cI3uVT5Tnicn3ZKgMzz4+e4/qWGCFZIqmX3e+6sPVs9Y3b5jLtyrwN2QiJFlLTlEFthkpiyTTjs4KW0H/hrVFcdF0Gx0K1kaNQDSQqWe5Ktp/j5wB671eIieMdvJlyVdPady08kBAuGSJSt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626492; c=relaxed/simple;
	bh=p4X1MjHaqegkxzbOzWwxVO7twSPcWhxj6AYWwSiuWww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnRxMUfBH7rKboefnKCg1f5MC06e6v5kod1BbeTAQr0bxB7+/iOsZuFgRdC3hCmuAJVbK7kZ2idwoz3N9c7NTv7XJDqVAC4vAT7D6mWCQab/gMPplQa2TQHhQDmr7kz3lqeGl2SpXG48cJ9wQ1zax9nPkJ+Kcivh82fp2vQE0MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lpBOjxNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lpBOjxNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257A9C4CEE5;
	Mon, 10 Mar 2025 17:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626491;
	bh=p4X1MjHaqegkxzbOzWwxVO7twSPcWhxj6AYWwSiuWww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lpBOjxNOQfObkQhTzVuLI7V4uKFkVfK/Sy5vm9gHI6Zk2m2OCO+wQz6kSTGxYw4/o
	 C9J1saoxIrW0aV2L+aMtZmrQ/AzzwRHVPJzEDA8wgnzUJJjYxHgqAu0exNRtHg2twX
	 02zhgaua110e6ECHUZvEmnd6JUUFum+o7k+RfiWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.13 011/207] LoongArch: Convert unreachable() to BUG()
Date: Mon, 10 Mar 2025 18:03:24 +0100
Message-ID: <20250310170448.214363483@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit da64a2359092ceec4f9dea5b329d0aef20104217 upstream.

When compiling on LoongArch, there exists the following objtool warning
in arch/loongarch/kernel/machine_kexec.o:

  kexec_reboot() falls through to next function crash_shutdown_secondary()

Avoid using unreachable() as it can (and will in the absence of UBSAN)
generate fall-through code. Use BUG() so we get a "break BRK_BUG" trap
(with unreachable annotation).

Cc: stable@vger.kernel.org  # 6.12+
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/machine_kexec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -126,14 +126,14 @@ void kexec_reboot(void)
 	/* All secondary cpus go to kexec_smp_wait */
 	if (smp_processor_id() > 0) {
 		relocated_kexec_smp_wait(NULL);
-		unreachable();
+		BUG();
 	}
 #endif
 
 	do_kexec = (void *)reboot_code_buffer;
 	do_kexec(efi_boot, cmdline_ptr, systable_ptr, start_addr, first_ind_entry);
 
-	unreachable();
+	BUG();
 }
 
 


