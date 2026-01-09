Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6AA33B6F0;
	Fri,  9 Jan 2026 12:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961259; cv=none; b=n4Gt269U6aL6JEUN5Ez6EcucY/WbqwWjjdCJIwfBTaKneJCgwpFGhafV2ditT7unV1zHBXyxobFaRABnL3wSsmgsU7WN5rzXBi52gtbXWmfG8bIcPK1259qWyBK8IE7juB+E+PYbSYlcaKQEhg+4x8MelN25m9+nESHh0ZT+v0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961259; c=relaxed/simple;
	bh=x6AXOFH6tikA0icU2ZdXYbi9fSZsvyPz3w4Kck+Y0sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmPLHP5mOhgrc8iyq0m24CSMIGFjyuVA2VKGz77wM5caGfQAvvkavmaVa+wajOL9Bk5eyyvccUpSSYY/t2wLc2evURmTYyFpuVAw5XovldASRrHP8IU+v3MGaC89F3gikBcXjVPwyUnKdcgaZDhecb5k9XmjIMS/65a4dw4erbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGNkr1PN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGNkr1PN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A311BC4CEF1;
	Fri,  9 Jan 2026 12:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961259;
	bh=x6AXOFH6tikA0icU2ZdXYbi9fSZsvyPz3w4Kck+Y0sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGNkr1PNZSrG/aUjijtkcglQgZEuYVjY4+ZlWt/aqxi4p6HysW1wz1VcjONV8mqiW
	 rFJaCk0xsIj70h35Rvjtq1GvnqSSlZHJMg71N43EPOjzJUZcOKdkvrzJXI8hsDegko
	 8uGuR4cD1IMsRGOCRtxEGLrbkpkUk5oRBs6YfmoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 673/737] LoongArch: Refactor register restoration in ftrace_common_return
Date: Fri,  9 Jan 2026 12:43:32 +0100
Message-ID: <20260109112159.367499336@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Chenghao Duan <duanchenghao@kylinos.cn>

commit 45cb47c628dfbd1994c619f3eac271a780602826 upstream.

Refactor the register restoration sequence in the ftrace_common_return
function to clearly distinguish between the logic of normal returns and
direct call returns in function tracing scenarios. The logic is as
follows:

1. In the case of a normal return, the execution flow returns to the
traced function, and ftrace must ensure that the register data is
consistent with the state when the function was entered.

ra = parent return address; t0 = traced function return address.

2. In the case of a direct call return, the execution flow jumps to the
custom trampoline function, and ftrace must ensure that the register
data is consistent with the state when ftrace was entered.

ra = traced function return address; t0 = parent return address.

Cc: stable@vger.kernel.org
Fixes: 9cdc3b6a299c ("LoongArch: ftrace: Add direct call support")
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/mcount_dyn.S |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/arch/loongarch/kernel/mcount_dyn.S
+++ b/arch/loongarch/kernel/mcount_dyn.S
@@ -93,7 +93,6 @@ SYM_INNER_LABEL(ftrace_graph_call, SYM_L
  * at the callsite, so there is no need to restore the T series regs.
  */
 ftrace_common_return:
-	PTR_L		ra, sp, PT_R1
 	PTR_L		a0, sp, PT_R4
 	PTR_L		a1, sp, PT_R5
 	PTR_L		a2, sp, PT_R6
@@ -103,12 +102,17 @@ ftrace_common_return:
 	PTR_L		a6, sp, PT_R10
 	PTR_L		a7, sp, PT_R11
 	PTR_L		fp, sp, PT_R22
-	PTR_L		t0, sp, PT_ERA
 	PTR_L		t1, sp, PT_R13
-	PTR_ADDI	sp, sp, PT_SIZE
 	bnez		t1, .Ldirect
+
+	PTR_L		ra, sp, PT_R1
+	PTR_L		t0, sp, PT_ERA
+	PTR_ADDI	sp, sp, PT_SIZE
 	jr		t0
 .Ldirect:
+	PTR_L		t0, sp, PT_R1
+	PTR_L		ra, sp, PT_ERA
+	PTR_ADDI	sp, sp, PT_SIZE
 	jr		t1
 SYM_CODE_END(ftrace_common)
 
@@ -155,6 +159,8 @@ SYM_CODE_END(return_to_handler)
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 SYM_CODE_START(ftrace_stub_direct_tramp)
-	jr		t0
+	move		t1, ra
+	move		ra, t0
+	jr		t1
 SYM_CODE_END(ftrace_stub_direct_tramp)
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */


