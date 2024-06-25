Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7B312EBEA;
	Tue, 25 Jun 2024 09:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308636; cv=none; b=R2y+h/Fe2qyj646NiMP15J2LVBkmGxjB8WmQoo3lQpTzdCVTjCySzxu6zVYXXTzCuXphOjzn0eTaQQSQZ+1VoRWF00m8s6xto7KeBiPUmuNQ5621F1T8yJPc/RnDJqSaOJiZw2bQl93xcejV9nP2ST7JlrTPO+xoxeiPjuhKBo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308636; c=relaxed/simple;
	bh=sJn2e+UXYqTI22mzv94YtHWJCI8soNkWVtMBNrpiM6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmBNjvO+b3ty0ONZrJQ+oTl+eATPiSAeZQviVnO5mMhqqID3xWmelUZrVhYljdyQUKEQAsSVkfIEy3NqZU14IEuJCYVnykuP2ho3lNdK4HUY29wfhRe26U085aL+LBGJPbYu/Zn6NIumY9vbdQHMVIyKvxoBIQQeyYQyyPriCEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2D+KintP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2D+KintP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3EFC32781;
	Tue, 25 Jun 2024 09:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308636;
	bh=sJn2e+UXYqTI22mzv94YtHWJCI8soNkWVtMBNrpiM6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2D+KintP5O+jfT3ZFcLvYambD2whSAqYZPRBPDNB4e6/aSb8uV+NH94u2sIZYgeEb
	 nIYZlie1fA1qS5OQsYbaP6q9VjbkZubGiXEFuFiRZVNqA8EuRT5GHVFh50xe83Xcwz
	 14l3Rc7dN3/b6AQdxa97tIOAnis90ia9WoEtHR5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Li <lihui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.9 188/250] LoongArch: Fix watchpoint setting error
Date: Tue, 25 Jun 2024 11:32:26 +0200
Message-ID: <20240625085555.268576140@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Li <lihui@loongson.cn>

commit f63a47b34b140ed1ca39d7e4bd4f1cdc617fc316 upstream.

In the current code, when debugging the following code using gdb,
"invalid argument ..." message will be displayed.

lihui@bogon:~$ cat test.c
  #include <stdio.h>
  int a = 0;
  int main()
  {
	a = 1;
	return 0;
  }
lihui@bogon:~$ gcc -g test.c -o test
lihui@bogon:~$ gdb test
...
(gdb) watch a
Hardware watchpoint 1: a
(gdb) r
...
Invalid argument setting hardware debug registers

There are mainly two types of issues.

1. Some incorrect judgment condition existed in user_watch_state
   argument parsing, causing -EINVAL to be returned.

When setting up a watchpoint, gdb uses the ptrace interface,
ptrace(PTRACE_SETREGSET, tid, NT_LOONGARCH_HW_WATCH, (void *) &iov)).
Register values in user_watch_state as follows:

  addr[0] = 0x0, mask[0] = 0x0, ctrl[0] = 0x0
  addr[1] = 0x0, mask[1] = 0x0, ctrl[1] = 0x0
  addr[2] = 0x0, mask[2] = 0x0, ctrl[2] = 0x0
  addr[3] = 0x0, mask[3] = 0x0, ctrl[3] = 0x0
  addr[4] = 0x0, mask[4] = 0x0, ctrl[4] = 0x0
  addr[5] = 0x0, mask[5] = 0x0, ctrl[5] = 0x0
  addr[6] = 0x0, mask[6] = 0x0, ctrl[6] = 0x0
  addr[7] = 0x12000803c, mask[7] = 0x0, ctrl[7] = 0x610

In arch_bp_generic_fields(), return -EINVAL when ctrl.len is
LOONGARCH_BREAKPOINT_LEN_8(0b00). So delete the incorrect judgment here.

In ptrace_hbp_fill_attr_ctrl(), when note_type is NT_LOONGARCH_HW_WATCH
and ctrl[0] == 0x0, if ((type & HW_BREAKPOINT_RW) != type) will return
-EINVAL. Here ctrl.type should be set based on note_type, and unnecessary
judgments can be removed.

2. The watchpoint argument was not set correctly due to unnecessary
   offset and alignment_mask.

Modify ptrace_hbp_fill_attr_ctrl() and hw_breakpoint_arch_parse(), which
ensure the watchpont argument is set correctly.

All changes according to the LoongArch Reference Manual:
https://loongson.github.io/LoongArch-Documentation/LoongArch-Vol1-EN.html#control-and-status-registers-related-to-watchpoints

Cc: stable@vger.kernel.org
Signed-off-by: Hui Li <lihui@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/hw_breakpoint.h |    2 -
 arch/loongarch/kernel/hw_breakpoint.c      |   19 ++++-------------
 arch/loongarch/kernel/ptrace.c             |   32 +++++++++++++----------------
 3 files changed, 21 insertions(+), 32 deletions(-)

--- a/arch/loongarch/include/asm/hw_breakpoint.h
+++ b/arch/loongarch/include/asm/hw_breakpoint.h
@@ -101,7 +101,7 @@ struct perf_event;
 struct perf_event_attr;
 
 extern int arch_bp_generic_fields(struct arch_hw_breakpoint_ctrl ctrl,
-				  int *gen_len, int *gen_type, int *offset);
+				  int *gen_len, int *gen_type);
 extern int arch_check_bp_in_kernelspace(struct arch_hw_breakpoint *hw);
 extern int hw_breakpoint_arch_parse(struct perf_event *bp,
 				    const struct perf_event_attr *attr,
--- a/arch/loongarch/kernel/hw_breakpoint.c
+++ b/arch/loongarch/kernel/hw_breakpoint.c
@@ -283,7 +283,7 @@ int arch_check_bp_in_kernelspace(struct
  * to generic breakpoint descriptions.
  */
 int arch_bp_generic_fields(struct arch_hw_breakpoint_ctrl ctrl,
-			   int *gen_len, int *gen_type, int *offset)
+			   int *gen_len, int *gen_type)
 {
 	/* Type */
 	switch (ctrl.type) {
@@ -303,11 +303,6 @@ int arch_bp_generic_fields(struct arch_h
 		return -EINVAL;
 	}
 
-	if (!ctrl.len)
-		return -EINVAL;
-
-	*offset = __ffs(ctrl.len);
-
 	/* Len */
 	switch (ctrl.len) {
 	case LOONGARCH_BREAKPOINT_LEN_1:
@@ -386,21 +381,17 @@ int hw_breakpoint_arch_parse(struct perf
 			     struct arch_hw_breakpoint *hw)
 {
 	int ret;
-	u64 alignment_mask, offset;
+	u64 alignment_mask;
 
 	/* Build the arch_hw_breakpoint. */
 	ret = arch_build_bp_info(bp, attr, hw);
 	if (ret)
 		return ret;
 
-	if (hw->ctrl.type != LOONGARCH_BREAKPOINT_EXECUTE)
-		alignment_mask = 0x7;
-	else
+	if (hw->ctrl.type == LOONGARCH_BREAKPOINT_EXECUTE) {
 		alignment_mask = 0x3;
-	offset = hw->address & alignment_mask;
-
-	hw->address &= ~alignment_mask;
-	hw->ctrl.len <<= offset;
+		hw->address &= ~alignment_mask;
+	}
 
 	return 0;
 }
--- a/arch/loongarch/kernel/ptrace.c
+++ b/arch/loongarch/kernel/ptrace.c
@@ -494,28 +494,14 @@ static int ptrace_hbp_fill_attr_ctrl(uns
 				     struct arch_hw_breakpoint_ctrl ctrl,
 				     struct perf_event_attr *attr)
 {
-	int err, len, type, offset;
+	int err, len, type;
 
-	err = arch_bp_generic_fields(ctrl, &len, &type, &offset);
+	err = arch_bp_generic_fields(ctrl, &len, &type);
 	if (err)
 		return err;
 
-	switch (note_type) {
-	case NT_LOONGARCH_HW_BREAK:
-		if ((type & HW_BREAKPOINT_X) != type)
-			return -EINVAL;
-		break;
-	case NT_LOONGARCH_HW_WATCH:
-		if ((type & HW_BREAKPOINT_RW) != type)
-			return -EINVAL;
-		break;
-	default:
-		return -EINVAL;
-	}
-
 	attr->bp_len	= len;
 	attr->bp_type	= type;
-	attr->bp_addr	+= offset;
 
 	return 0;
 }
@@ -609,7 +595,19 @@ static int ptrace_hbp_set_ctrl(unsigned
 		return PTR_ERR(bp);
 
 	attr = bp->attr;
-	decode_ctrl_reg(uctrl, &ctrl);
+
+	switch (note_type) {
+	case NT_LOONGARCH_HW_BREAK:
+		ctrl.type = LOONGARCH_BREAKPOINT_EXECUTE;
+		ctrl.len = LOONGARCH_BREAKPOINT_LEN_4;
+		break;
+	case NT_LOONGARCH_HW_WATCH:
+		decode_ctrl_reg(uctrl, &ctrl);
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	err = ptrace_hbp_fill_attr_ctrl(note_type, ctrl, &attr);
 	if (err)
 		return err;


