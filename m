Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CF729CE7;
	Wed,  2 Oct 2024 13:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876889; cv=none; b=BPXp4s1CME2+VLG4+5lvoUrJCkhvrK2GxKfOkDwekcGaZmYBV7l0VlUzFQPL9uwkPjnkJRb4L/iujqoByAB/asV3MOSxvUJ3vIp5FuiAcz6MFNp66gPpKkE13EKleC1hCSg8q4tS87az95yxzyxJ8liLAmb9d6sE3tk1N2PHXwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876889; c=relaxed/simple;
	bh=XAYMLoAet4Yu5k9xLRBfeizEuyjdq2rFn0YmdTFhCrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7msgmEco9Lrwch+aQ4rkNCQukwPUDNNut4brHB0qwmWP8dhmlwU/M/7wA8cl0ud6eYXOHnp7SqWPDIkWDyZMBcI3excP7WNCsB2bagJS41cAa/gEu/YVQKXhGx9ot/L0lMZZ0HWtIEJLof6ojHNjTrFi7Rm0QFh7KbzA8SwMrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9eZ9BSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9eZ9BSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502E6C4CEC2;
	Wed,  2 Oct 2024 13:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876889;
	bh=XAYMLoAet4Yu5k9xLRBfeizEuyjdq2rFn0YmdTFhCrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9eZ9BSyr0Q+StLUOwZym3Ri/NRL9KHGXe2HRSdi4rxVyiTwtmTVUP9fIRCXnFPNV
	 K0XRVjvuiovUGA2DjU7c9TlSz+NbvRDH95taoPAQPRGVDdDLYOID1aueYPMIyLBP3V
	 rF2K4UgKdPGl5QJ0cPYdqT7hKf/kpHBBrFvJLVYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexey Gladkov (Intel)" <legion@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 6.11 563/695] x86/tdx: Fix "in-kernel MMIO" check
Date: Wed,  2 Oct 2024 14:59:21 +0200
Message-ID: <20241002125844.977230052@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/tdx/tdx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -16,6 +16,7 @@
 #include <asm/insn-eval.h>
 #include <asm/pgtable.h>
 #include <asm/set_memory.h>
+#include <asm/traps.h>
 
 /* MMIO direction */
 #define EPT_READ	0
@@ -433,6 +434,11 @@ static int handle_mmio(struct pt_regs *r
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


