Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F58B30FC15;
	Tue, 11 Nov 2025 01:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825236; cv=none; b=pv1Tt1s4tgCGG4UtLsPzZuVCJkv0fwVwNa3+mk1iFtbpm44TXz6IlhaT6aIG4ByEANRzfVh9U7MMfxY69uKjnyVPAyYian8TbN9/0BPrpGwetULgmnDAEOYMAc7tF0ptt5L/Q0kwuqWL9CRb+fNmm0w8R/Dzn0aVvvGLGupPFHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825236; c=relaxed/simple;
	bh=bWsidbBnZcYnGPiScsdAyEL23XNOVxRlQ6YHOzGH6DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uo6i+IXSYymq9WidH/W8ic//NWCN9KkAawprSpuVbUrgiuXL7hKRHNEXFM7Y8GJc+ubKondbSQmf9Uij0IyUu7+v5xw1dC7uRtUDjUktzqrEGchR0ivyXxnp8WBuy8xQLD20bKvlkR3CVQ8/0/cAbf4wERkIZZSWkG+mCYZKQjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=en5ZwcjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="en5ZwcjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EB8C116D0;
	Tue, 11 Nov 2025 01:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825236;
	bh=bWsidbBnZcYnGPiScsdAyEL23XNOVxRlQ6YHOzGH6DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=en5ZwcjM1XxKpr5p6Iwvbz1i8gcI4q97CSdYFr4dRZmSgr2nbp+63NM/tF41+mHVv
	 jfAqWy5EIU6mbON3fH8IJYlJe+HzA+tsUdzfd1MXYxBVgjyC/DLzm9tnpUMZSNqkeA
	 kEzXJiCSTRwTf8nnQd+2Upq28qB50D1HaojzjQcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 719/849] LoongArch: Handle new atomic instructions for probes
Date: Tue, 11 Nov 2025 09:44:49 +0900
Message-ID: <20251111004553.817119615@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit db740f5689e61f2e75b73e5c8e7c985a3b4bc045 ]

The atomic instructions sc.q, llacq.{w/d}, screl.{w/d} were newly added
in the LoongArch Reference Manual v1.10, it is necessary to handle them
in insns_not_supported() to avoid putting a breakpoint in the middle of
a ll/sc atomic sequence, otherwise it will loop forever for kprobes and
uprobes.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/inst.h |  5 +++++
 arch/loongarch/kernel/inst.c      | 12 ++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/loongarch/include/asm/inst.h b/arch/loongarch/include/asm/inst.h
index 277d2140676b6..55e64a12a124a 100644
--- a/arch/loongarch/include/asm/inst.h
+++ b/arch/loongarch/include/asm/inst.h
@@ -77,6 +77,10 @@ enum reg2_op {
 	iocsrwrh_op     = 0x19205,
 	iocsrwrw_op     = 0x19206,
 	iocsrwrd_op     = 0x19207,
+	llacqw_op	= 0xe15e0,
+	screlw_op	= 0xe15e1,
+	llacqd_op	= 0xe15e2,
+	screld_op	= 0xe15e3,
 };
 
 enum reg2i5_op {
@@ -189,6 +193,7 @@ enum reg3_op {
 	fldxd_op	= 0x7068,
 	fstxs_op	= 0x7070,
 	fstxd_op	= 0x7078,
+	scq_op		= 0x70ae,
 	amswapw_op	= 0x70c0,
 	amswapd_op	= 0x70c1,
 	amaddw_op	= 0x70c2,
diff --git a/arch/loongarch/kernel/inst.c b/arch/loongarch/kernel/inst.c
index 72ecfed29d55a..bf037f0c6b26c 100644
--- a/arch/loongarch/kernel/inst.c
+++ b/arch/loongarch/kernel/inst.c
@@ -141,6 +141,9 @@ bool insns_not_supported(union loongarch_instruction insn)
 	case amswapw_op ... ammindbdu_op:
 		pr_notice("atomic memory access instructions are not supported\n");
 		return true;
+	case scq_op:
+		pr_notice("sc.q instruction is not supported\n");
+		return true;
 	}
 
 	switch (insn.reg2i14_format.opcode) {
@@ -152,6 +155,15 @@ bool insns_not_supported(union loongarch_instruction insn)
 		return true;
 	}
 
+	switch (insn.reg2_format.opcode) {
+	case llacqw_op:
+	case llacqd_op:
+	case screlw_op:
+	case screld_op:
+		pr_notice("llacq and screl instructions are not supported\n");
+		return true;
+	}
+
 	switch (insn.reg1i21_format.opcode) {
 	case bceqz_op:
 		pr_notice("bceqz and bcnez instructions are not supported\n");
-- 
2.51.0



