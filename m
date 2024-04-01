Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5944438DE5;
	Mon,  1 Apr 2024 17:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991192; cv=none; b=BGJmJbSRH0j5m+H3kBGw43L+wmZJKl0nZax7fRIH3XKKW1MJh3wK1ZLyt7pYMMDepDt6kLdYDMIIkGJDiWcPCRvrfu1TW5OnZr52CGdpFtEJztvOiEECY77/XveQI1ShjNdkxGKsOLQnnNk5YCG8bAsi7z7c0kM9M241/FCGF6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991192; c=relaxed/simple;
	bh=boNGyxLP+ccP8pzeDF25naNb/w1of8WQWDm01K+Uc6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8FTd45OcPPHhqUohT70m71z/gitmgAajjp4/C15ROdJF+LDH4/oaB0R1jM2ozlsBEZ6RPtFterepRZhf02i0G4zuKW+REdeF4uUdXTcqhZcCTeUSUnBrReHkVcKRy4kfi7UyGSqKVy79Hd686O2lG3LfEONX66NV9HblhpUPy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uROaSiNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uROaSiNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BD8C433C7;
	Mon,  1 Apr 2024 17:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991192;
	bh=boNGyxLP+ccP8pzeDF25naNb/w1of8WQWDm01K+Uc6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uROaSiNapupSsVTr4dTfW6ZMYYmdEOxuVeIdLsbBk1OOU9y675tZbE2eavdXamRIN
	 h1+mNXRmaiMV6oP4IVov67xhb0lvdAtoTEv0nyIZLNyzPFVqc15k6KM2CHls/Eqod4
	 iL6sXRt1ZsRgueHZ1St2/v6PdKLCj/wFtCINpVfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Zhang <zzqq0103.hey@gmail.com>,
	Jinghao Jia <jinghao7@illinois.edu>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/272] kprobes/x86: Use copy_from_kernel_nofault() to read from unsafe address
Date: Mon,  1 Apr 2024 17:46:21 +0200
Message-ID: <20240401152536.849568705@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 4e51653d5d871f40f1bd5cf95cc7f2d8b33d063b ]

Read from an unsafe address with copy_from_kernel_nofault() in
arch_adjust_kprobe_addr() because this function is used before checking
the address is in text or not. Syzcaller bot found a bug and reported
the case if user specifies inaccessible data area,
arch_adjust_kprobe_addr() will cause a kernel panic.

[ mingo: Clarified the comment. ]

Fixes: cc66bb914578 ("x86/ibt,kprobes: Cure sym+0 equals fentry woes")
Reported-by: Qiang Zhang <zzqq0103.hey@gmail.com>
Tested-by: Jinghao Jia <jinghao7@illinois.edu>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/171042945004.154897.2221804961882915806.stgit@devnote2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 6120f25b0d5cc..991f00c817e6c 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -301,7 +301,16 @@ static int can_probe(unsigned long paddr)
 kprobe_opcode_t *arch_adjust_kprobe_addr(unsigned long addr, unsigned long offset,
 					 bool *on_func_entry)
 {
-	if (is_endbr(*(u32 *)addr)) {
+	u32 insn;
+
+	/*
+	 * Since 'addr' is not guaranteed to be safe to access, use
+	 * copy_from_kernel_nofault() to read the instruction:
+	 */
+	if (copy_from_kernel_nofault(&insn, (void *)addr, sizeof(u32)))
+		return NULL;
+
+	if (is_endbr(insn)) {
 		*on_func_entry = !offset || offset == 4;
 		if (*on_func_entry)
 			offset = 4;
-- 
2.43.0



