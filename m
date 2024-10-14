Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58E51AB505;
	Mon, 14 Oct 2024 15:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918622; cv=none; b=oMRuVCKnRqz9oD6LdWcNDA3bBJKBCOSCTmovkjdQ4DXxRO9wl8ihirlujGdXOL2OkXl61+SsTbXV7gi+1kIKNgQjiU8BOb8MnuZuTyalc336lDVJZIfYmDNvbS/PPk30LcmkmoF22SQqOVe5QBa2kjytwiFQKNPg3xftG1LWroQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918622; c=relaxed/simple;
	bh=udYA6JsN5em/JbXA6iU/QJRfsA9opmAExJ2JbhKMv6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZgedusjkmfvnTF1BKr3qDJNtRUo2rRsRqoWFyxtVc/it+jJs0aAFvYOV1kIAjwBsFOzzYBOXJRjzeUYJj7Ap7nlZijuNAAId6ubNvVzaW0tF1WAcLS6mZx3dIS5jsBdmNxbBv3FM16yreqHTRjMn8yX7KtHz+sSB1nE3+XwhHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5GR5fA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5GR5fA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3FFC4CEC3;
	Mon, 14 Oct 2024 15:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918622;
	bh=udYA6JsN5em/JbXA6iU/QJRfsA9opmAExJ2JbhKMv6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5GR5fA2XoNe5HXVYhUEz2qaGWVhI0e+vlfnE3nYSOtxmLApbG4jXGNDzEUfJGH+u
	 ACXqoJ1KYUEuFXd/ZxUmxidSEKhlorueOPOzE4Rb3NbTWH+U4G2LX2D6SMtfJOPF0T
	 ik9T+kbFL8GpnLEGPX3OWNCE7HvWIYHZknK7IQNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexey Gladkov (Intel)" <legion@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 6.1 375/798] x86/tdx: Fix "in-kernel MMIO" check
Date: Mon, 14 Oct 2024 16:15:29 +0200
Message-ID: <20241014141232.686945401@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Alexey Gladkov (Intel) <legion@kernel.org>

commit d4fc4d01471528da8a9797a065982e05090e1d81 upstream.

TDX only supports kernel-initiated MMIO operations. The handle_mmio()
function checks if the #VE exception occurred in the kernel and rejects
the operation if it did not.

However, userspace can deceive the kernel into performing MMIO on its
behalf. For example, if userspace can point a syscall to an MMIO address,
syscall does get_user() or put_user() on it, triggering MMIO #VE. The
kernel will treat the #VE as in-kernel MMIO.

Ensure that the target MMIO address is within the kernel before decoding
instruction.

Fixes: 31d58c4e557d ("x86/tdx: Handle in-kernel MMIO")
Signed-off-by: Alexey Gladkov (Intel) <legion@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/565a804b80387970460a4ebc67c88d1380f61ad1.1726237595.git.legion%40kernel.org
Signed-off-by: Alexey Gladkov (Intel) <legion@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/tdx/tdx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -12,6 +12,7 @@
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
 #include <asm/pgtable.h>
+#include <asm/traps.h>
 
 /* TDX module Call Leaf IDs */
 #define TDX_GET_INFO			1
@@ -371,6 +372,11 @@ static int handle_mmio(struct pt_regs *r
 			return -EINVAL;
 	}
 
+	if (!fault_in_kernel_space(ve->gla)) {
+		WARN_ONCE(1, "Access to userspace address is not supported");
+		return -EINVAL;
+	}
+
 	/*
 	 * Reject EPT violation #VEs that split pages.
 	 *


