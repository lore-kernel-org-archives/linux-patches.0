Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF6032A3C9;
	Tue, 16 Jun 2026 17:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632135; cv=none; b=MAQ1k2Ty6jZmbnWgy5+zRO7fBQNd2xxv22OyjDMA0rPE23G7kEgHDc88Tx4d46RmeYAqgMPE+UUWVRVZL8xdeZsAgFr5R7caouGE1iYAe344RUTQccRV8Utw76ExGTnHHecb0U5T0lOD9cAwojhewsZJ900CGW90Dr8zA8ixMNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632135; c=relaxed/simple;
	bh=GA0Di/tzcpFAdhyiXH7YWkmnJjrO16EdYWyBBJyJ4/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZ6wGpMbxQfeMApSjwmVDb0bEvyLjKqPIOKS5Eq3PxiZTYH5vXnOPnNfpfWul/BBTFe841cOcEiLdJuRp3xNmaVh468Ey+boBaTWvn9p+QWVXgRFoSinjQ3jaC601sb2kuhAQufo4+tK9/OQkEYVr+fq9iG+56urCDF5piyzpNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvHv9CLO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvHv9CLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE081F00A3A;
	Tue, 16 Jun 2026 17:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632134;
	bh=EHTDeZElCiVyvRJ825ycGCIVTLxgVgw8vI67p8XANT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vvHv9CLOpVrqcJEEySnC0cDHhlENi/SEC3MPW0/75p8iNN7ZSOcsqMx9WW0XvCBQD
	 hPHa8KXFYVu/8ByNONX/zIZGKI+b2wvX2/dhcNfeRNLVmKCmzLe9ZPlOhOu/wzoWFn
	 erbjkagOxIM46FOKFt/a8BS3hNMAkZ515/ZTnIqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 336/522] LoongArch: Add spectre boundry for syscall dispatch table
Date: Tue, 16 Jun 2026 20:28:03 +0530
Message-ID: <20260616145141.540830242@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 0c965d2784fbbd7f8e3b96d875c9cfdf7c00da3d ]

The LoongArch syscall number is directly controlled by userspace, but
does not have a array_index_nospec() boundry to prevent access past the
syscall function pointer tables.

Cc: stable@vger.kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
 
@@ -54,7 +55,7 @@ void noinstr do_syscall(struct pt_regs *
 	nr = syscall_enter_from_user_mode(regs, nr);
 
 	if (nr < NR_syscalls) {
-		syscall_fn = sys_call_table[nr];
+		syscall_fn = sys_call_table[array_index_nospec(nr, NR_syscalls)];
 		regs->regs[4] = syscall_fn(regs->orig_a0, regs->regs[5], regs->regs[6],
 					   regs->regs[7], regs->regs[8], regs->regs[9]);
 	}


