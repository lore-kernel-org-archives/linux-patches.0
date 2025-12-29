Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CB8330D26;
	Mon, 29 Dec 2025 16:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025778; cv=none; b=M55AwpOTS2uylgCn2B31y9FT7JPzpSKI4xLrxKgME1srOf1y7OVMdFuLd3f9kk6f9lMticgS1fZJ7bJID0llTJpi9/DMfgwKFkUug17VcIPHD9aXS910S+j824IUVDrGQzhcchFdxaGNf9iTwPxZTQ0g4cuou2FKlGV/joyzBVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025778; c=relaxed/simple;
	bh=xptxw9V0KQuW403WYYif1avUSGH6nK4B08throh/PnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMziVXQMFdF+fsZ82FFgzQ1Zphp5AZN7TcMiP6U47cTMXiQRr+GgnuyjOV3U0VAPix9oCEUmwOr86+VUpGG6eYSUcRRBKdJajNyoBixpxn+8oG8vd78I4G0BC3Nxd8PGthz5q34AO/335ml5Xvv+WgHr1mLN3kN0mVnS77EC/xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tD1DO0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tD1DO0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1706C4CEF7;
	Mon, 29 Dec 2025 16:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025778;
	bh=xptxw9V0KQuW403WYYif1avUSGH6nK4B08throh/PnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tD1DO0hXqBMzFnST/KlGaXDSiYbPp4Txhyv7K0ho616Ck6ghIH9U/JYRk+GqVwwS
	 a6bx3SdmHn2xcTSNqeVCXrNDQk4lFyFJlFn5p0Rgncvb3lQJldI8cl7Zf0ilnyNlCY
	 uHJPpJ+Zu5vT+tP7r8yu29620LqgrrwBBaPSNQos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiyuan Xie <xiejiyuan@vivo.com>,
	Zhichi Lin <zhichi.lin@vivo.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Will Deacon <will@kernel.org>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Marco Elver <elver@google.com>,
	Yee Lee <yee.lee@mediatek.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 333/430] scs: fix a wrong parameter in __scs_magic
Date: Mon, 29 Dec 2025 17:12:15 +0100
Message-ID: <20251229160736.581658496@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhichi Lin <zhichi.lin@vivo.com>

commit 08bd4c46d5e63b78e77f2605283874bbe868ab19 upstream.

__scs_magic() needs a 'void *' variable, but a 'struct task_struct *' is
given.  'task_scs(tsk)' is the starting address of the task's shadow call
stack, and '__scs_magic(task_scs(tsk))' is the end address of the task's
shadow call stack.  Here should be '__scs_magic(task_scs(tsk))'.

The user-visible effect of this bug is that when CONFIG_DEBUG_STACK_USAGE
is enabled, the shadow call stack usage checking function
(scs_check_usage) would scan an incorrect memory range.  This could lead
to:

1. **Inaccurate stack usage reporting**: The function would calculate
   wrong usage statistics for the shadow call stack, potentially showing
   incorrect value in kmsg.

2. **Potential kernel crash**: If the value of __scs_magic(tsk)is
   greater than that of __scs_magic(task_scs(tsk)), the for loop may
   access unmapped memory, potentially causing a kernel panic.  However,
   this scenario is unlikely because task_struct is allocated via the slab
   allocator (which typically returns lower addresses), while the shadow
   call stack returned by task_scs(tsk) is allocated via vmalloc(which
   typically returns higher addresses).

However, since this is purely a debugging feature
(CONFIG_DEBUG_STACK_USAGE), normal production systems should be not
unaffected.  The bug only impacts developers and testers who are actively
debugging stack usage with this configuration enabled.

Link: https://lkml.kernel.org/r/20251011082222.12965-1-zhichi.lin@vivo.com
Fixes: 5bbaf9d1fcb9 ("scs: Add support for stack usage debugging")
Signed-off-by: Jiyuan Xie <xiejiyuan@vivo.com>
Signed-off-by: Zhichi Lin <zhichi.lin@vivo.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yee Lee <yee.lee@mediatek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/scs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -135,7 +135,7 @@ static void scs_check_usage(struct task_
 	if (!IS_ENABLED(CONFIG_DEBUG_STACK_USAGE))
 		return;
 
-	for (p = task_scs(tsk); p < __scs_magic(tsk); ++p) {
+	for (p = task_scs(tsk); p < __scs_magic(task_scs(tsk)); ++p) {
 		if (!READ_ONCE_NOCHECK(*p))
 			break;
 		used += sizeof(*p);


