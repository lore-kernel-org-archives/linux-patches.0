Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE9E3A63EC;
	Mon,  4 May 2026 13:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902917; cv=none; b=Z2xFmU2EYwkVRE57eFMcfz2pe04I1YWb+YekZ4R/aShTT1nhruVUBILf6HV0jndX6pSu9nDdB6IRfgx7CaKTHz7OOp2knvxFk5tNd70N19nmGUUtmgjRqaautQPvvi0LtHoZORPWhyQxtFyhm/FVo82MHqCu0jS5hNsZMjw6GSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902917; c=relaxed/simple;
	bh=iLurAsBczsoUQWTCATv2fvgu+E5vNH7Jy2kPdEebSPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJ4MohpDEaedYloJdtRpFzLiv4w6AYtRjIA5ivM45i/770z87SKM77vd3vzdO79AnhJa8FrxC6VtY1KFEWVOHda6MpJp6czgBl+EMiz8MouL39W7OHtZGbZtPotrvy7vb/MwXVKu5MR+L8pDSFBSnlrcxdUepUiknGZLTNRlFGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9U8HmmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9U8HmmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93ABC2BCB8;
	Mon,  4 May 2026 13:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902917;
	bh=iLurAsBczsoUQWTCATv2fvgu+E5vNH7Jy2kPdEebSPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9U8HmmP22OrPM/Ee6yb+psmYD0L4zLBnHoCqmxUkoHqcEDp2WTBO2XQlMuu1fo7N
	 bg5BY/Gy2/Q3vBOY+yI/smfBLUAkRczYv9noVvWnR1Vopx+ZydccNNLDSKDYsLJOUG
	 NhxqIKFotFqk3E39seXv66SsmyIaQGpmm5Y7Ck3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.0 008/307] LoongArch: Add spectre boundry for syscall dispatch table
Date: Mon,  4 May 2026 15:48:13 +0200
Message-ID: <20260504135143.140535423@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 0c965d2784fbbd7f8e3b96d875c9cfdf7c00da3d upstream.

The LoongArch syscall number is directly controlled by userspace, but
does not have a array_index_nospec() boundry to prevent access past the
syscall function pointer tables.

Cc: stable@vger.kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/syscall.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kernel/syscall.c
+++ b/arch/loongarch/kernel/syscall.c
@@ -9,6 +9,7 @@
 #include <linux/entry-common.h>
 #include <linux/errno.h>
 #include <linux/linkage.h>
+#include <linux/nospec.h>
 #include <linux/objtool.h>
 #include <linux/randomize_kstack.h>
 #include <linux/syscalls.h>
@@ -74,7 +75,7 @@ void noinstr __no_stack_protector do_sys
 	add_random_kstack_offset();
 
 	if (nr < NR_syscalls) {
-		syscall_fn = sys_call_table[nr];
+		syscall_fn = sys_call_table[array_index_nospec(nr, NR_syscalls)];
 		regs->regs[4] = syscall_fn(regs->orig_a0, regs->regs[5], regs->regs[6],
 					   regs->regs[7], regs->regs[8], regs->regs[9]);
 	}


