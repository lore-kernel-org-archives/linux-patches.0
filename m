Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE24C1A3029;
	Tue, 21 Oct 2025 20:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077543; cv=none; b=kI5eZIpbllNkOYfYplt4AU6wc+7aB+WLeajr/DKTrvTQoBJAqeNgkED/JtiGciM3/Q3aEFl8ytsRYUUyxwThK0hiFrWX6hNU/4qqO2rKDqKz5w2jt+2U93BCN+noKeUCcQavDst3Ut00J/YMwigkgRyz60zcv3jZqlnSjk9XUQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077543; c=relaxed/simple;
	bh=/c7piBehl6FpLRrLhpRcLDtqHiGW3O1ts9ubDb8GcIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXnTK/7hYcSg5KE1AsOv2sf6bTPxkN8VPCD2nmQ6b2e0Jx5N/pLz3OO7y1fOg4VLmwhZfRAYyhFUeJPUnUUJ228JfG485y+y295UT9CAO4MPnfTBgw3SsFIW8oonXl231SQzH2wWJnZnmMsvAfzfzoyQd6EHj714ykJuKZAv3N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJoe9sVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJoe9sVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FA2C4CEF1;
	Tue, 21 Oct 2025 20:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077543;
	bh=/c7piBehl6FpLRrLhpRcLDtqHiGW3O1ts9ubDb8GcIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJoe9sVkasUqoAjslabvJqWTGglQjIfGoQNAIZ5paScTsOT6Tlmg7k0fFsKOd/6kT
	 0mgfV76glaZC9W2SmeKqdcTzqmDgEFqRnoc+Ez3mVZqt2CTrjQl9T7SmlhrGmmYhe7
	 A/lwtYMnFlx7W82dI8IDEUAeOfKyuLyqrma4H3PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabian Vogt <fvogt@suse.de>,
	Marvin Friedrich <marvin.friedrich@suse.com>,
	Guo Ren <guoren@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 094/159] riscv: kprobes: Fix probe address validation
Date: Tue, 21 Oct 2025 21:51:11 +0200
Message-ID: <20251021195045.446412368@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index c0738d6c6498a..8723390c7cad5 100644
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



