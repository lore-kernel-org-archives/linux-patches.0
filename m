Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93214350A29;
	Tue, 21 Oct 2025 20:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076887; cv=none; b=mH2aH2m+/7XkEEhEZ+IDRR+dRGAjJEdWlV2+u2CQhmYfmrf4uPy7QO3+ovIw6FXUa6Fhwm1mDA3T4R+FzYGSJnEYjd4w9qnO9k+CBn3qHeqDeNt09LXMIo+wkxNCjIaG48qRXj15ypdCAfrF/O178YYqbceYOy+QS29xfQrKkMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076887; c=relaxed/simple;
	bh=6tQhZsAt38I9AhSNH8C6Ek3jxo1o5acU/BZINzyd9bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qx070gDn81yJqxqeWLc7P+CiZ4rrmliqyFHXCsCQsV0YnS/oFFXKL+jXVjBbz+FnvVDF1tci3fkVZ9A9ZponBzOmB7aAVwyMc80sXDsK1FH53A2NCe3egYrAAnKfhYiZQFu2b8HQL9oBXxUuKCrF2od7s0RLPn1oVCjY8bjcvkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdVyDqbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdVyDqbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DC8C4CEF1;
	Tue, 21 Oct 2025 20:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076887;
	bh=6tQhZsAt38I9AhSNH8C6Ek3jxo1o5acU/BZINzyd9bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdVyDqbSOsc5qh7aY86cXQs+nIVm6wdB5RZ5zR6meCsYym+8qsXnxMugw0EklVt9o
	 d6K2lfPSi71NZV7WzlVzaO47FtuRfz0qr1bJt+bZdw5DVcg93EuvI7Fq+RP9N5EhCq
	 WLEAx5FAbEBnDS0jth/9Zz37W+1NijHU3dQ5BBfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabian Vogt <fvogt@suse.de>,
	Marvin Friedrich <marvin.friedrich@suse.com>,
	Guo Ren <guoren@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/136] riscv: kprobes: Fix probe address validation
Date: Tue, 21 Oct 2025 21:50:57 +0200
Message-ID: <20251021195037.634110509@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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
index d2dacea1aedd9..0daba93c1a81e 100644
--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -49,10 +49,15 @@ static void __kprobes arch_simulate_insn(struct kprobe *p, struct pt_regs *regs)
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
@@ -71,7 +76,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	if ((unsigned long)insn & 0x1)
 		return -EILSEQ;
 
-	if (!arch_check_kprobe(p))
+	if (!arch_check_kprobe((unsigned long)p->addr))
 		return -EILSEQ;
 
 	/* copy instruction */
-- 
2.51.0



