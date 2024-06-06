Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A62219DF67;
	Thu,  6 Jun 2024 14:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683496; cv=none; b=UQ0hChXLv5L2l7B+fGgm91BzcDHHSllyRuR+YkpsZm4RR5BcUD+1httW1DkdQFqJQaKmbzJ0MwmBGuFRnogY0NSz6C18UuDkWaz/i2C4SWOCcon3uMOH63PxSDZYYRMfzxUAUE93txkdVf3XobsY11O23C/6eHsloHUV3ulAdNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683496; c=relaxed/simple;
	bh=Snr7mB1LymYMymSvudC1cg40CH1oHrHO7mvsoIE2cHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kx4+Fg/u7UfeL96qiFV7OypQTQsSqe5xE4WZznYhTiZJ1zsATZdgf3JWpm4nswdqYaJhZ5kJIz3znXaHv0yxABn20JgXOQYBKy7lEBxVznvm2XL3tFvO3RE00+1UaQ4wyTD2LOI5cMdhwK8AqBKcthWKoDQ9mFyny9t7DgFOimg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sfR8GPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sfR8GPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059E3C32781;
	Thu,  6 Jun 2024 14:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683496;
	bh=Snr7mB1LymYMymSvudC1cg40CH1oHrHO7mvsoIE2cHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0sfR8GPy+9aG5lapNUvAqviCjqSKBNpNL1YAVc5Zxr7FHY5iu1870IQJ3zANvZG8y
	 O8wWDg+ZJ6B85dM3MDGLoLc6aopWOyX+28/N6WV1+5ukvQB0vS5qWmZwUjXJgBAiuo
	 hsBUyji/uJ9vA1PKTQOIqASAi+p0TivFuehQ9ACY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 386/473] um: Fix the declaration of kasan_map_memory
Date: Thu,  6 Jun 2024 16:05:15 +0200
Message-ID: <20240606131712.613993056@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 6a85e34c4d07d2ec0c153067baff338ac0db55ca ]

Make it match its definition (size_t vs unsigned long). And declare
it in a shared header to fix the -Wmissing-prototypes warning, as it
is defined in the user code and called in the kernel code.

Fixes: 5b301409e8bc ("UML: add support for KASAN under x86_64")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/asm/kasan.h        | 1 -
 arch/um/include/shared/kern_util.h | 2 ++
 arch/um/os-Linux/mem.c             | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/um/include/asm/kasan.h b/arch/um/include/asm/kasan.h
index 0d6547f4ec85c..f97bb1f7b8514 100644
--- a/arch/um/include/asm/kasan.h
+++ b/arch/um/include/asm/kasan.h
@@ -24,7 +24,6 @@
 
 #ifdef CONFIG_KASAN
 void kasan_init(void);
-void kasan_map_memory(void *start, unsigned long len);
 extern int kasan_um_is_ready;
 
 #ifdef CONFIG_STATIC_LINK
diff --git a/arch/um/include/shared/kern_util.h b/arch/um/include/shared/kern_util.h
index 444bae755b16a..7372746c16875 100644
--- a/arch/um/include/shared/kern_util.h
+++ b/arch/um/include/shared/kern_util.h
@@ -67,4 +67,6 @@ extern void fatal_sigsegv(void) __attribute__ ((noreturn));
 
 void um_idle_sleep(void);
 
+void kasan_map_memory(void *start, size_t len);
+
 #endif
diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
index 8530b2e086049..c6c9495b14321 100644
--- a/arch/um/os-Linux/mem.c
+++ b/arch/um/os-Linux/mem.c
@@ -15,6 +15,7 @@
 #include <sys/vfs.h>
 #include <linux/magic.h>
 #include <init.h>
+#include <kern_util.h>
 #include <os.h>
 
 /*
-- 
2.43.0



