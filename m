Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DEDC2E0;
	Mon, 23 Jun 2025 22:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716815; cv=none; b=hT6gPEDvQZ/MywM11xxJHTNC1GkSuy9QZGsLgan+sISRrFPhexAyUDIBeeojK5s5rm+GdIcLTyaRZvyXc7cgHJ7fDbzRFk+H+xecVqClaixDv73QMXm3vFFkRrh8PrAIsdfpWo/+whqO+lLP8Ef4PIrjwFV1jAwsJxwgky0Ooqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716815; c=relaxed/simple;
	bh=yPsh4551LxyCwjVPKqflFqC2KqaO6VyENBNufYUXA5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXXvfp9DtX3BPpsGm+0rUNSvbKMb/Xoa5xjAaQ3cMczB9Dp8qAnhBy8GASPsTUMNMXWbo3FYWRAFq/oBvvTmT3k7MdfXPzIXDAgPkMOuXstz9DGf9OXex44eiJcUOq0Tu1dIvwwUjt8hO11WVs0zSWwcL7Zj4usE1O3nJfq4hWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJzGT15V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJzGT15V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE24C4CEEA;
	Mon, 23 Jun 2025 22:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716815;
	bh=yPsh4551LxyCwjVPKqflFqC2KqaO6VyENBNufYUXA5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJzGT15VZf+9ec/iWyXve2ORTvEjDgFI3bz7yyBMOB73pRCH9+z/5u+amhwu+HeD9
	 SrV4k38jDqDsuzdIkITkAgSPl8r7D1mf9Nc+qQSna8Lo4musWL9lZXUgxs5wHg8v56
	 aTiL/9fMj8qmXcm4Wzt1KV9YtBZK6Vf+ElcWT8TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.15 395/411] arm64: bpf: Only mitigate cBPF programs loaded by unprivileged users
Date: Mon, 23 Jun 2025 15:08:59 +0200
Message-ID: <20250623130643.621280039@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

[ Upstream commit f300769ead032513a68e4a02e806393402e626f8 ]

Support for eBPF programs loaded by unprivileged users is typically
disabled. This means only cBPF programs need to be mitigated for BHB.

In addition, only mitigate cBPF programs that were loaded by an
unprivileged user. Privileged users can also load the same program
via eBPF, making the mitigation pointless.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/net/bpf_jit_comp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -341,6 +341,9 @@ static void __maybe_unused build_bhb_mit
 	    arm64_get_spectre_v2_state() == SPECTRE_VULNERABLE)
 		return;
 
+	if (capable(CAP_SYS_ADMIN))
+		return;
+
 	if (supports_clearbhb(SCOPE_SYSTEM)) {
 		emit(aarch64_insn_gen_hint(AARCH64_INSN_HINT_CLEARBHB), ctx);
 		return;


