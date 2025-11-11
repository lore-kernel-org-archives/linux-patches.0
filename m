Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1948A1F5F6;
	Tue, 11 Nov 2025 01:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822906; cv=none; b=brMdx2EWhlClRj3OGInRTeSPS+OWLOfasX4PcmS4wv4W5DxHrGaowYYQbS7nBGu4VOEPt45x7LfXHOiou/THGYMDgEwypDO/b8wSH0tJ5CSD7gycKg4x9JyfHpbP9zoJSTU06otqwRaLKTn6/Po+oXNrDfMP6uCEE/3UMT7ScHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822906; c=relaxed/simple;
	bh=4t8juJKLHsb7xZZox482NC8Lyd/1I8UHLYTpZINsag8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfXytX847uBWAsPsIGwNxfY/DfeqSFasVXj1RSmrkQewxps1+UA8Yemrpb1xEHm3sTNKS4stzzfHtO4O2OjaMNDfi2kmTwm2N2sp6ig3swqAk+7/73suKw+46sgOwpCWBh6Pe0TCZ7kP7ROKWW6oOYo97W/v6oUBDDaBWzkHRm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=US70JhTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="US70JhTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EE9C16AAE;
	Tue, 11 Nov 2025 01:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822906;
	bh=4t8juJKLHsb7xZZox482NC8Lyd/1I8UHLYTpZINsag8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=US70JhTkLOKWOQeSyCHmLcB5O5WQBfRvHXlkFUDR/ChzBFLK4qPe1UqlLod/MIBxX
	 +DwugHrXSsgdAOy13DQT+7UDckNuXsQ4L5ssafLXpOWM069ns9vDlDuPZ+6Iu+EkPr
	 94pfUqru/RGEe7o+N4NETFi/34hFAWyj0O2QOcpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Zhao <phoenix500526@163.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/565] libbpf: Fix USDT SIB argument handling causing unrecognized register error
Date: Tue, 11 Nov 2025 09:39:20 +0900
Message-ID: <20251111004529.296989361@linuxfoundation.org>
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

From: Jiawei Zhao <phoenix500526@163.com>

[ Upstream commit 758acb9ccfdbf854b55abaceaf1f3f229cde3d19 ]

On x86-64, USDT arguments can be specified using Scale-Index-Base (SIB)
addressing, e.g. "1@-96(%rbp,%rax,8)". The current USDT implementation
in libbpf cannot parse this format, causing `bpf_program__attach_usdt()`
to fail with -ENOENT (unrecognized register).

This patch fixes this by implementing the necessary changes:
- add correct handling for SIB-addressed arguments in `bpf_usdt_arg`.
- add adaptive support to `__bpf_usdt_arg_type` and
  `__bpf_usdt_arg_spec` to represent SIB addressing parameters.

Signed-off-by: Jiawei Zhao <phoenix500526@163.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250827053128.1301287-2-phoenix500526@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/usdt.bpf.h | 44 ++++++++++++++++++++++++++--
 tools/lib/bpf/usdt.c     | 62 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 99 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/usdt.bpf.h b/tools/lib/bpf/usdt.bpf.h
index b811f754939f0..3e59a7704534b 100644
--- a/tools/lib/bpf/usdt.bpf.h
+++ b/tools/lib/bpf/usdt.bpf.h
@@ -34,13 +34,32 @@ enum __bpf_usdt_arg_type {
 	BPF_USDT_ARG_CONST,
 	BPF_USDT_ARG_REG,
 	BPF_USDT_ARG_REG_DEREF,
+	BPF_USDT_ARG_SIB,
 };
 
+/*
+ * This struct layout is designed specifically to be backwards/forward
+ * compatible between libbpf versions for ARG_CONST, ARG_REG, and
+ * ARG_REG_DEREF modes. ARG_SIB requires libbpf v1.7+.
+ */
 struct __bpf_usdt_arg_spec {
 	/* u64 scalar interpreted depending on arg_type, see below */
 	__u64 val_off;
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
 	/* arg location case, see bpf_usdt_arg() for details */
-	enum __bpf_usdt_arg_type arg_type;
+	enum __bpf_usdt_arg_type arg_type: 8;
+	/* index register offset within struct pt_regs */
+	__u16 idx_reg_off: 12;
+	/* scale factor for index register (1, 2, 4, or 8) */
+	__u16 scale_bitshift: 4;
+	/* reserved for future use, keeps reg_off offset stable */
+	__u8 __reserved: 8;
+#else
+	__u8 __reserved: 8;
+	__u16 idx_reg_off: 12;
+	__u16 scale_bitshift: 4;
+	enum __bpf_usdt_arg_type arg_type: 8;
+#endif
 	/* offset of referenced register within struct pt_regs */
 	short reg_off;
 	/* whether arg should be interpreted as signed value */
@@ -117,7 +136,7 @@ int bpf_usdt_arg(struct pt_regs *ctx, __u64 arg_num, long *res)
 {
 	struct __bpf_usdt_spec *spec;
 	struct __bpf_usdt_arg_spec *arg_spec;
-	unsigned long val;
+	unsigned long val, idx;
 	int err, spec_id;
 
 	*res = 0;
@@ -170,6 +189,27 @@ int bpf_usdt_arg(struct pt_regs *ctx, __u64 arg_num, long *res)
 			return err;
 #if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
 		val >>= arg_spec->arg_bitshift;
+#endif
+		break;
+	case BPF_USDT_ARG_SIB:
+		/* Arg is in memory addressed by SIB (Scale-Index-Base) mode
+		 * (e.g., "-1@-96(%rbp,%rax,8)" in USDT arg spec). We first
+		 * fetch the base register contents and the index register
+		 * contents from pt_regs. Then we calculate the final address
+		 * as base + (index * scale) + offset, and do a user-space
+		 * probe read to fetch the argument value.
+		 */
+		err = bpf_probe_read_kernel(&val, sizeof(val), (void *)ctx + arg_spec->reg_off);
+		if (err)
+			return err;
+		err = bpf_probe_read_kernel(&idx, sizeof(idx), (void *)ctx + arg_spec->idx_reg_off);
+		if (err)
+			return err;
+		err = bpf_probe_read_user(&val, sizeof(val), (void *)(val + (idx << arg_spec->scale_bitshift) + arg_spec->val_off));
+		if (err)
+			return err;
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+		val >>= arg_spec->arg_bitshift;
 #endif
 		break;
 	default:
diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index 6ff28e7bf5e3d..76e7c5bf0cb2d 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -199,12 +199,23 @@ enum usdt_arg_type {
 	USDT_ARG_CONST,
 	USDT_ARG_REG,
 	USDT_ARG_REG_DEREF,
+	USDT_ARG_SIB,
 };
 
 /* should match exactly struct __bpf_usdt_arg_spec from usdt.bpf.h */
 struct usdt_arg_spec {
 	__u64 val_off;
-	enum usdt_arg_type arg_type;
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	enum usdt_arg_type arg_type: 8;
+	__u16	idx_reg_off: 12;
+	__u16	scale_bitshift: 4;
+	__u8 __reserved: 8;     /* keep reg_off offset stable */
+#else
+	__u8 __reserved: 8;     /* keep reg_off offset stable */
+	__u16	idx_reg_off: 12;
+	__u16	scale_bitshift: 4;
+	enum usdt_arg_type arg_type: 8;
+#endif
 	short reg_off;
 	bool arg_signed;
 	char arg_bitshift;
@@ -1281,11 +1292,51 @@ static int calc_pt_regs_off(const char *reg_name)
 
 static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg, int *arg_sz)
 {
-	char reg_name[16];
-	int len, reg_off;
-	long off;
+	char reg_name[16] = {0}, idx_reg_name[16] = {0};
+	int len, reg_off, idx_reg_off, scale = 1;
+	long off = 0;
+
+	if (sscanf(arg_str, " %d @ %ld ( %%%15[^,] , %%%15[^,] , %d ) %n",
+		   arg_sz, &off, reg_name, idx_reg_name, &scale, &len) == 5 ||
+		sscanf(arg_str, " %d @ ( %%%15[^,] , %%%15[^,] , %d ) %n",
+		       arg_sz, reg_name, idx_reg_name, &scale, &len) == 4 ||
+		sscanf(arg_str, " %d @ %ld ( %%%15[^,] , %%%15[^)] ) %n",
+		       arg_sz, &off, reg_name, idx_reg_name, &len) == 4 ||
+		sscanf(arg_str, " %d @ ( %%%15[^,] , %%%15[^)] ) %n",
+		       arg_sz, reg_name, idx_reg_name, &len) == 3
+		) {
+		/*
+		 * Scale Index Base case:
+		 * 1@-96(%rbp,%rax,8)
+		 * 1@(%rbp,%rax,8)
+		 * 1@-96(%rbp,%rax)
+		 * 1@(%rbp,%rax)
+		 */
+		arg->arg_type = USDT_ARG_SIB;
+		arg->val_off = off;
 
-	if (sscanf(arg_str, " %d @ %ld ( %%%15[^)] ) %n", arg_sz, &off, reg_name, &len) == 3) {
+		reg_off = calc_pt_regs_off(reg_name);
+		if (reg_off < 0)
+			return reg_off;
+		arg->reg_off = reg_off;
+
+		idx_reg_off = calc_pt_regs_off(idx_reg_name);
+		if (idx_reg_off < 0)
+			return idx_reg_off;
+		arg->idx_reg_off = idx_reg_off;
+
+		/* validate scale factor and set fields directly */
+		switch (scale) {
+		case 1: arg->scale_bitshift = 0; break;
+		case 2: arg->scale_bitshift = 1; break;
+		case 4: arg->scale_bitshift = 2; break;
+		case 8: arg->scale_bitshift = 3; break;
+		default:
+			pr_warn("usdt: invalid SIB scale %d, expected 1, 2, 4, 8\n", scale);
+			return -EINVAL;
+		}
+	} else if (sscanf(arg_str, " %d @ %ld ( %%%15[^)] ) %n",
+				arg_sz, &off, reg_name, &len) == 3) {
 		/* Memory dereference case, e.g., -4@-20(%rbp) */
 		arg->arg_type = USDT_ARG_REG_DEREF;
 		arg->val_off = off;
@@ -1304,6 +1355,7 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
 	} else if (sscanf(arg_str, " %d @ %%%15s %n", arg_sz, reg_name, &len) == 2) {
 		/* Register read case, e.g., -4@%eax */
 		arg->arg_type = USDT_ARG_REG;
+		/* register read has no memory offset */
 		arg->val_off = 0;
 
 		reg_off = calc_pt_regs_off(reg_name);
-- 
2.51.0



