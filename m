Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272867464;
	Tue, 30 Apr 2024 10:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474787; cv=none; b=F4FJimm0NMHi+5VZAb6AH791K4/qY438/o4kKzJs4lANEq0lKOeZtDenG/Td0jrfVFKGiQhNa8KaKV2Ay0fGnLUzuFP46D3v5xL5+inZ2VI7VQPWXaOilrXh95EZTJEbKalLRWpMSwWX+5qYLU9BMi1TO70vmUGc/N+SgfzHExc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474787; c=relaxed/simple;
	bh=fs7HMt1Mp9r6z7EeaDLjCa2Ay71145zeY0Ojy7ZGVGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J56nSj9gVtbVSHW7x/GnpdxB5AjZOVDM447Q/J+h60ahJlbaF7NYUbyMI1NDP62nS7u3mYVMmW4Fc2eFsyFJStf5iXlcPBvOgjRkHZqnBQxiLA2zqEaI8+sF6DfW/s67D+A9qhvZf8iyI61bKjj6IVi98sv4a6Co2El3nr6nko8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gw+YEUM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gw+YEUM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D731C2BBFC;
	Tue, 30 Apr 2024 10:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474787;
	bh=fs7HMt1Mp9r6z7EeaDLjCa2Ay71145zeY0Ojy7ZGVGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gw+YEUM+4CptynrfG1VNAMXbivZo42tBLiovGxL6kutwKO/SkHcjvr46+JcjEmK/S
	 Yg0OysxkBTgk326gppaysMB/Ll27FEB9QaqtyMDHLIO/GpDQ5YNWcs3XM1fKljFmG1
	 7uU3raLWRZA2+75kuktgykSLp9bRURn7Q2Fg4g6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.10 034/138] kprobes: Fix possible use-after-free issue on kprobe registration
Date: Tue, 30 Apr 2024 12:38:39 +0200
Message-ID: <20240430103050.435923987@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yejian <zhengyejian1@huawei.com>

commit 325f3fb551f8cd672dbbfc4cf58b14f9ee3fc9e8 upstream.

When unloading a module, its state is changing MODULE_STATE_LIVE ->
 MODULE_STATE_GOING -> MODULE_STATE_UNFORMED. Each change will take
a time. `is_module_text_address()` and `__module_text_address()`
works with MODULE_STATE_LIVE and MODULE_STATE_GOING.
If we use `is_module_text_address()` and `__module_text_address()`
separately, there is a chance that the first one is succeeded but the
next one is failed because module->state becomes MODULE_STATE_UNFORMED
between those operations.

In `check_kprobe_address_safe()`, if the second `__module_text_address()`
is failed, that is ignored because it expected a kernel_text address.
But it may have failed simply because module->state has been changed
to MODULE_STATE_UNFORMED. In this case, arm_kprobe() will try to modify
non-exist module text address (use-after-free).

To fix this problem, we should not use separated `is_module_text_address()`
and `__module_text_address()`, but use only `__module_text_address()`
once and do `try_module_get(module)` which is only available with
MODULE_STATE_LIVE.

Link: https://lore.kernel.org/all/20240410015802.265220-1-zhengyejian1@huawei.com/

Fixes: 28f6c37a2910 ("kprobes: Forbid probing on trampoline and BPF code areas")
Cc: stable@vger.kernel.org
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
[Fix conflict due to lack dependency
commit 223a76b268c9 ("kprobes: Fix coding style issues")]
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1647,10 +1647,17 @@ static int check_kprobe_address_safe(str
 	jump_label_lock();
 	preempt_disable();
 
-	/* Ensure it is not in reserved area nor out of text */
-	if (!(core_kernel_text((unsigned long) p->addr) ||
-	    is_module_text_address((unsigned long) p->addr)) ||
-	    in_gate_area_no_mm((unsigned long) p->addr) ||
+	/* Ensure the address is in a text area, and find a module if exists. */
+	*probed_mod = NULL;
+	if (!core_kernel_text((unsigned long) p->addr)) {
+		*probed_mod = __module_text_address((unsigned long) p->addr);
+		if (!(*probed_mod)) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+	/* Ensure it is not in reserved area. */
+	if (in_gate_area_no_mm((unsigned long) p->addr) ||
 	    within_kprobe_blacklist((unsigned long) p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr) ||
 	    static_call_text_reserved(p->addr, p->addr) ||
@@ -1660,8 +1667,7 @@ static int check_kprobe_address_safe(str
 		goto out;
 	}
 
-	/* Check if are we probing a module */
-	*probed_mod = __module_text_address((unsigned long) p->addr);
+	/* Get module refcount and reject __init functions for loaded modules. */
 	if (*probed_mod) {
 		/*
 		 * We must hold a refcount of the probed module while updating


