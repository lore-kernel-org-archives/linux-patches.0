Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814EE21255B;
	Sun, 26 Oct 2025 14:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490259; cv=none; b=VUooYoy5Ww5UWYtWKXd4SFcVLr51S/HxPS84miN5evIo32uonYqJoPmBiSRd+yNRh25EutZY11S3+QTur7+xvC94x8zTQYHepTdKkN9S2gZpJQ0feUrgl9ydc+9MDS0ltuMbbtwLR7HrMORb9C7p6Jvfk3PLb4em9IZRDPxROYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490259; c=relaxed/simple;
	bh=RdRn4AWf9H2ZwExTT5bIG6sTwztawEWRHyXSixfcCgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEE1MkKAV1tTsBzWWTD+MHP8ZI7K/1QDjshgRvUCxf63GMsx6uy+1MmKc7inkoQZRAMVoFgn75Q/rwojPq2NTPjVAF5hOghzzBF6IqIUW63c8N0pfsDxwhXUjfcv9J+wc9c+gSpmsULu00A/OvHsX1jUrfhYzJiJZTYfpY0hplA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOeG6GzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOeG6GzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33567C4CEF1;
	Sun, 26 Oct 2025 14:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490259;
	bh=RdRn4AWf9H2ZwExTT5bIG6sTwztawEWRHyXSixfcCgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOeG6GzQQsZpN6uyeB9BOQ7y36l5pUnbisbTro9ux2X6Krxap+CLsn78watbteBkr
	 IEob0jM/JEw06HWE/hIQGGv6X1Y/5acVK8W1Hjoex+F/5m83HbUWriksU/ITeBTezQ
	 hbAJzLQZbRiHRHR8WD/HX4yakNeAfSx8syrlsKc8ySX12HQnk8AHV/eUgrgsxWlVns
	 Ufc08qQ/cEwelrldTSY6plz/UFi9/aWwgh7eoSijQOExfg+kkhfdtqzFXEtboiu4ih
	 cHAi0P8AttlCS0Um/hx6c2nTgjzpomDisVPywtWSXYprV3BhfkK3FwatX6/btAeIE8
	 mkiislPgKc/qQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>,
	chenhuacai@kernel.org,
	duanchenghao@kylinos.cn,
	guodongtai@kylinos.cn,
	hengqi.chen@gmail.com,
	alexandre.f.demers@gmail.com,
	tangyouling@kylinos.cn
Subject: [PATCH AUTOSEL 6.17-6.12] LoongArch: Handle new atomic instructions for probes
Date: Sun, 26 Oct 2025 10:49:05 -0400
Message-ID: <20251026144958.26750-27-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES
- `arch/loongarch/include/asm/inst.h:80-83` and
  `arch/loongarch/include/asm/inst.h:196` add the opcode definitions for
  the newly documented LL/SC variants (`llacq.{w,d}`, `screl.{w,d}`,
  `sc.q`), so the decoder can distinguish them instead of treating them
  as generic instructions.
- `arch/loongarch/kernel/inst.c:140-164` extends `insns_not_supported()`
  to reject these opcodes exactly like the earlier `ll*/sc*` pair;
  without this, the helper would return false and allow probes on them.
- Both LoongArch kprobes and uprobes rely on `insns_not_supported()`
  before planting a breakpoint (`arch/loongarch/kernel/kprobes.c:39-55`,
  `arch/loongarch/kernel/uprobes.c:19-35`). If any of the new LL/SC
  instructions slip through, the breakpoint lands in the middle of the
  load-linked/store-conditional loop, so `sc` keeps failing and the
  probed code spins forever, hanging the task or system.
- The patch is tightly scoped (new enum constants plus an extra switch
  case), keeps existing behaviour of returning `-EINVAL` to the probe
  request, and has no architectural side effects or dependencies. It
  directly prevents a hard hang that instrumentation users can hit on
  current hardware/toolchains implementing the LoongArch v1.10
  instructions.
- Because it fixes a real reliability issue with probes, with very low
  regression risk and no feature creep, it is a strong candidate for
  stable backporting.

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

