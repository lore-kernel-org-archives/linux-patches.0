Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9691315785;
	Mon,  4 May 2026 14:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904421; cv=none; b=inujNDsi2bEcDTp9le6804hLo1YfYTG5qGuUmTjLXfMELD7vfKtbZTyTh43XASGseKs85gw/y4TVAO3LjnFt2yrczsBIojv0vg/Bg+q7DsTXsGI7iU/i0t2puuyclfgkAiolSJ5W+svEszOOVEfJXf05aq/240SYtpAv2jlxr7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904421; c=relaxed/simple;
	bh=Vb55D8KDX81rbJ42SfwXpZbsMMk+MziybGYxO9SrLI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeCQnZGHsGATgcrpwooPF40Wba01V5dZr/0GM18+xFjM2k8rMRSJQGBizQ8Ut63gtpLOVKt3H0qAelgLkxV+BKq7uObPQZkCTYXfDzEutj9ONmCJzHv9oCvkqn3AaXIaJ2zQoIa7eS2C/316r8n1Ddh6JSD6ah8eOgNB80aQ9Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMHaaKWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMHaaKWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C8AC2BCB8;
	Mon,  4 May 2026 14:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904421;
	bh=Vb55D8KDX81rbJ42SfwXpZbsMMk+MziybGYxO9SrLI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMHaaKWzsuXmsbBx5sFOR1RU3njGX5JoY/MlklVHWgcTmdedMLx+qpoySo4AgC7za
	 aW3DM4OWXN9MVN8lEtJXMGkmcBO7j1MiBYUqPIKLSgGPEdpMT3ZoAm3XFbMl9rsRoi
	 dXh09dyg5nc71EyduYvcwie1F/6ZI5lfrXLCAKvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 008/215] LoongArch: Add spectre boundry for syscall dispatch table
Date: Mon,  4 May 2026 15:50:27 +0200
Message-ID: <20260504135130.479560272@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
@@ -61,7 +62,7 @@ void noinstr __no_stack_protector do_sys
 	add_random_kstack_offset();
 
 	if (nr < NR_syscalls) {
-		syscall_fn = sys_call_table[nr];
+		syscall_fn = sys_call_table[array_index_nospec(nr, NR_syscalls)];
 		regs->regs[4] = syscall_fn(regs->orig_a0, regs->regs[5], regs->regs[6],
 					   regs->regs[7], regs->regs[8], regs->regs[9]);
 	}


