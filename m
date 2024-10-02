Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8341D0798;
	Wed,  2 Oct 2024 14:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880691; cv=none; b=ZHnleS18/ERYCySJYwRLhjN+lPZXO05mHtzSJ06Tdgkdigjflw1bIOmPK7G78xT7cH4vn+Pp3/xtB+htU/ZAjxV3cOCggeiq+pzRycprFkDQaD7YHaMd2BO0dGQi5l0PlAnescRiVLPrI4sB+gpgioaxBAPshBaiEocc6Fvd1OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880691; c=relaxed/simple;
	bh=TG1XoBvBfYlElvHE6XyJK5gm7E0FXnNP4wVb1Z3rtf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGZurxOhUjoU/bLyYfHJPqqDgBLnAzBZGZkKMf3pECW5n2lvCcDyEj0kAxTzx5nr1sP2zzfZnmiTLMn/yGMjnhelQ9ceSs3d0F57y47yd09wVUqR0vMEhew9ex+ZFp1m8pyq044weeeXMf/oqIITKZB6RTuLMgE5dRno1gujarA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdZ6cQBE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdZ6cQBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E370DC4CEE1;
	Wed,  2 Oct 2024 14:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880691;
	bh=TG1XoBvBfYlElvHE6XyJK5gm7E0FXnNP4wVb1Z3rtf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdZ6cQBEly+ku2qv5CCdCnUcftp45ow7/M7wR5RqxqAUhSu+AzspWT9P10BIrIFSY
	 oVkO7TzjSmti4N4o52RIxRCsBI/RQiHJsDPR7L/F7AGFhhuDQPy5ddoSMx7r2rFUtG
	 P2hhlS/+/qMOWI+WbO3iSK1A253Hgd2PNDZNXdvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexey Gladkov (Intel)" <legion@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 6.6 538/538] x86/tdx: Fix "in-kernel MMIO" check
Date: Wed,  2 Oct 2024 15:02:57 +0200
Message-ID: <20241002125813.679386044@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
@@ -14,6 +14,7 @@
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
 #include <asm/pgtable.h>
+#include <asm/traps.h>
 
 /* MMIO direction */
 #define EPT_READ	0
@@ -405,6 +406,11 @@ static int handle_mmio(struct pt_regs *r
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


