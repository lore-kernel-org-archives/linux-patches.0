Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AD3DDAB;
	Tue, 11 Nov 2025 01:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824830; cv=none; b=BDw8IeQeHc5aeAlvniYL22cgUxHqOy8vOh1HSEa9DeG9OEilEz8Meskvgz8+lBkePcZsVe3fR9FWTeJXAQ3frJPFJCfiHJpodxrYyOZkolzdKMno/Rbg1JglbKmeRVelq/pKRkLGi+v3+E2+XgAALs8FKAHaeWa1bgEPNRpSMbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824830; c=relaxed/simple;
	bh=hTaeJkrXWbLIa8dnpeSz18k9t7iiub3LcgpuB0Yffg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMksdCrkYhY43givT6Ok/m8ZQjobR34KVjvD9Im+kBcurryYxHVkrOz/uug7Y1mys+BpHqYq6ug2yaoDQXfMXdQdQcXskyFvX0RP0uODu4drihzVbBrRlOY6JvVcnAwks0Xtkc2GvsxLw5S36VHyhGkE2NlZRlEBsr490nFs1Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzGG63Eo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzGG63Eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C404C116D0;
	Tue, 11 Nov 2025 01:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824830;
	bh=hTaeJkrXWbLIa8dnpeSz18k9t7iiub3LcgpuB0Yffg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzGG63EobJDDAXwYF2SgbW5jTKGj7rPqLhPEib41EfpyZ77s/6mAkmzb3uFysVQcM
	 u9G5TDSMrZzXwMY64erthwBkXXRC7gsPO5XCLzA3lhRcX2cZ+ccrzTYdRf66OxUJX4
	 NjFMzyq6qYp4M/FdQIfYYF+Fzj1MNxe6BY+2K0xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 482/565] LoongArch: Handle new atomic instructions for probes
Date: Tue, 11 Nov 2025 09:45:38 +0900
Message-ID: <20251111004537.767447256@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 3089785ca97e7..bec5b63e46888 100644
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
index 14d7d700bcb98..e6896a40017ea 100644
--- a/arch/loongarch/kernel/inst.c
+++ b/arch/loongarch/kernel/inst.c
@@ -139,6 +139,9 @@ bool insns_not_supported(union loongarch_instruction insn)
 	case amswapw_op ... ammindbdu_op:
 		pr_notice("atomic memory access instructions are not supported\n");
 		return true;
+	case scq_op:
+		pr_notice("sc.q instruction is not supported\n");
+		return true;
 	}
 
 	switch (insn.reg2i14_format.opcode) {
@@ -150,6 +153,15 @@ bool insns_not_supported(union loongarch_instruction insn)
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



