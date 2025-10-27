Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C44306D37;
	Mon, 27 Oct 2025 19:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591971; cv=none; b=Rl06xI9WVI8BgU0zk+N86G3ng5ejlfM5ItdhQW7wPx7ud61b6pRnvdEeoZrRFQzeCK9ubne7fm66uFYX8GiB6MGl1ilKVhZlddK4wlQJWutZ8a2eMXheLppsz/bABz1bUcrnJ+YRC1Z1ybo/9tcQJcW8kGP49hQTyToYi8caGXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591971; c=relaxed/simple;
	bh=hJhZuK7xKEDbf3LKo+zPJJtJgINNHdIibCvJzYaGAaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fy0kfA3SdHpMCYXUeTNE8Mr6lPAo5mFwlzSCUqfL3BQ80JNoqOqDhrQ5aO0uMbY8gC3EzZ76j/w4JFn5U7PoRqkoa5tKhGnKoTZKd1JgkBjWc/H3i5URSm8NRbfgEKB7kKfh97G2EEw4Ys2fNm0Kx5YKhMdWDbTgar49E/9fnSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fl3E1hji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fl3E1hji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCC9C4CEF1;
	Mon, 27 Oct 2025 19:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591971;
	bh=hJhZuK7xKEDbf3LKo+zPJJtJgINNHdIibCvJzYaGAaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fl3E1hjiCk0RQ09EcogwPqGHShB8ttBHeFPrwFS8JVIGkm5M4bPzMOBXAscSPqWw4
	 E7y3xHL8unxL1d7QAsOjcKurTm963jzJ2cJ9ornIr0qnl+H+zMfj9Xcfk3qLbDY7yd
	 boxVRQ2MCERa9uHEGiyl1VtdNs6OqKnsGKog2Msc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabian Vogt <fvogt@suse.de>,
	Marvin Friedrich <marvin.friedrich@suse.com>,
	Guo Ren <guoren@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/123] riscv: kprobes: Fix probe address validation
Date: Mon, 27 Oct 2025 19:35:12 +0100
Message-ID: <20251027183447.260043916@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabian Vogt <fvogt@suse.de>

[ Upstream commit 9e68bd803fac49274fde914466fd3b07c4d602c8 ]

When adding a kprobe such as "p:probe/tcp_sendmsg _text+15392192",
arch_check_kprobe would start iterating all instructions starting from
_text until the probed address. Not only is this very inefficient, but
literal values in there (e.g. left by function patching) are
misinterpreted in a way that causes a desync.

Fix this by doing it like x86: start the iteration at the closest
preceding symbol instead of the given starting point.

Fixes: 87f48c7ccc73 ("riscv: kprobe: Fixup kernel panic when probing an illegal position")
Signed-off-by: Fabian Vogt <fvogt@suse.de>
Signed-off-by: Marvin Friedrich <marvin.friedrich@suse.com>
Acked-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/6191817.lOV4Wx5bFT@fvogt-thinkpad
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/probes/kprobes.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/probes/kprobes.c b/arch/riscv/kernel/probes/kprobes.c
index 7548b1d62509c..5251f18278017 100644
--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -48,10 +48,15 @@ static void __kprobes arch_simulate_insn(struct kprobe *p, struct pt_regs *regs)
 	post_kprobe_handler(p, kcb, regs);
 }
 
-static bool __kprobes arch_check_kprobe(struct kprobe *p)
+static bool __kprobes arch_check_kprobe(unsigned long addr)
 {
-	unsigned long tmp  = (unsigned long)p->addr - p->offset;
-	unsigned long addr = (unsigned long)p->addr;
+	unsigned long tmp, offset;
+
+	/* start iterating at the closest preceding symbol */
+	if (!kallsyms_lookup_size_offset(addr, NULL, &offset))
+		return false;
+
+	tmp = addr - offset;
 
 	while (tmp <= addr) {
 		if (tmp == addr)
@@ -70,7 +75,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	if ((unsigned long)insn & 0x1)
 		return -EILSEQ;
 
-	if (!arch_check_kprobe(p))
+	if (!arch_check_kprobe((unsigned long)p->addr))
 		return -EILSEQ;
 
 	/* copy instruction */
-- 
2.51.0



