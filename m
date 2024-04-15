Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550F280049;
	Mon, 15 Apr 2024 14:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191803; cv=none; b=qtH4d5NhYoY5yWsqmkyDV4Za3E/oW4KeG1jK/KQYvedMeMXq28sH3CNPXTXrGmFYQ2UXZ3HV4ymmq5yJKX3+xfCCUhv7KLlz+CbcN18xZOfQs0CEvCEuVAUVpyExAc6VdJ68hsqOIGPBLeUdQ0jfghdMpXcF5EOq/wcMeD+0a9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191803; c=relaxed/simple;
	bh=51LfCQq6MQFoTopwWRpgrVlBAq89i3ugg3e1b31Effk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJrNGNA3GLsStT4X5UTj0NTqNJihSeU4WKzMTNVQwhahepDfd2zV7muPdj2hD5icdWrcCLBU7uRPnvjuHz9clUw6jhMJlCb62B6mFg38Xj15l0agAJz0zoPHSjdMNnbkj7FYXtdEL3e7x5ktcwCJ4QPrsfFRh/NNg+3mPV0P6kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/IlgENr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/IlgENr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEA6C113CC;
	Mon, 15 Apr 2024 14:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191803;
	bh=51LfCQq6MQFoTopwWRpgrVlBAq89i3ugg3e1b31Effk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/IlgENrGAxulRBI+6MYebXrlqSdN1BOGJSv3IfQmGS6FoJ8qMC34Dr1a6a8gu7ac
	 gV/GL1Tu227TIbc2Jr7NZkYPspQZkZFuKAoVOOXokWzcuY6Y9mDK0NDZDmKReirLfR
	 PkgEtuJgIPaec+OSSXn5qGFIHOLaSTejM2OV0CY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 084/122] kprobes: Fix possible use-after-free issue on kprobe registration
Date: Mon, 15 Apr 2024 16:20:49 +0200
Message-ID: <20240415141955.897520572@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1567,10 +1567,17 @@ static int check_kprobe_address_safe(str
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
@@ -1580,8 +1587,7 @@ static int check_kprobe_address_safe(str
 		goto out;
 	}
 
-	/* Check if 'p' is probing a module. */
-	*probed_mod = __module_text_address((unsigned long) p->addr);
+	/* Get module refcount and reject __init functions for loaded modules. */
 	if (*probed_mod) {
 		/*
 		 * We must hold a refcount of the probed module while updating


