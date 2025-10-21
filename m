Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C9F350A2A;
	Tue, 21 Oct 2025 19:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076667; cv=none; b=bDWLrpMn8BpRFCvenRptipYz52EvFrMw1cSmJZGQNuSRjD+UevOC+M9+0o15acqBVOfDNjPw2Xe+5aC6IsjXtnH1yz8cxZ19VXk0Awjh5YZwNsrCn/omC2Q2Rhmp/sBE0RKFgGolfCjh5p6kVJQcsqKnGgSfTq5gd2aVLWJRz5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076667; c=relaxed/simple;
	bh=Y5dMUwEgR3vjqTyfBjXhBo1Wrp0nGotSblMRwefZ0GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNYSwrAYfZpdpdc5GPehbF9lIQTN874tLtuFbeHtSk3cKZodU9FW5pTu21JJAoCqf+w5zu4iajzr55n3ZWYViqmjRAn2pdeBoU94ihkW/dDT0LhEiQIdTs6cgQKVkhyGmVMnrpR+7pPABnWY/wA035zYCw+b5r4S99WzK98BNNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLUcyI1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLUcyI1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323F3C4CEF1;
	Tue, 21 Oct 2025 19:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076667;
	bh=Y5dMUwEgR3vjqTyfBjXhBo1Wrp0nGotSblMRwefZ0GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLUcyI1G4VSnJCky9pQiUwZ36Hd/Ue411AyXIRGG13wxNNh0T37XLZgrIpmguUbtw
	 1/ChuX8KQfb3+SNrkh3ul3k/rwlHFLoXCtUwdOWNxP5vSS6/b6Ty+6wkCMW9P/UMjJ
	 nI3NM18WZiial0s6JnxngWLziqCAxutbatv/GHR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabian Vogt <fvogt@suse.de>,
	Marvin Friedrich <marvin.friedrich@suse.com>,
	Guo Ren <guoren@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/105] riscv: kprobes: Fix probe address validation
Date: Tue, 21 Oct 2025 21:51:02 +0200
Message-ID: <20251021195022.939372649@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 297427ffc4e04..8a6ea7d270188 100644
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



