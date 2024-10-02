Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC6B1D097D;
	Wed,  2 Oct 2024 14:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878987; cv=none; b=JyLLZVJOampoq4EL5F2krZa7KePwKs0VkSlguCwuF0is4KGoK4uLpTR/3WMG1oVZyQ9hg3hoTnWTG7aR9N3uY2eN0j30NI1LBt7xFMFBrwY6LZ2RWpFb90AyexLkcn3TVFl/8o61F6hO9u1Ad/EaF08FxDZcl0bkJmcFuIJ8/xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878987; c=relaxed/simple;
	bh=qVwByCmo/a4NNxSTpjJSmQmTcpWl66G37Btiky4GS9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjAJjt4y61yL1jlvQj4UMDHMdcuVKzWzmJcygF/7AV3RSqpGrJJ0H3U7GYt9lCbVTaoqFrIzc/MuQgj7v31a+Q4GGoDomurrlly89BBs6JntNaCg7FcnwzigS5fr3XSABXXM1rTj/NG8znlK6T9wIwZ8XzY+D7JwepxfFY05HDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Edw1o2I1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Edw1o2I1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAC4C4CEC2;
	Wed,  2 Oct 2024 14:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878987;
	bh=qVwByCmo/a4NNxSTpjJSmQmTcpWl66G37Btiky4GS9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Edw1o2I1Y7rRevnUDTtZcRfzz/S6ivDNJ1wcgtamaVd6Ib0HrWJQQyX2VJ4GZQGDJ
	 2IXC8QZNULtXQTKsBskCA8hILjKerzYCrPxwRCyt555hagMRvG7ua+bBOiHF8HYx36
	 vVUPwA2LHD9GKfB3KRP3ppu0jenpxuQ8Ofb8BCUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexey Gladkov (Intel)" <legion@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 600/634] x86/tdx: Fix "in-kernel MMIO" check
Date: Wed,  2 Oct 2024 15:01:40 +0200
Message-ID: <20241002125834.799529278@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Gladkov (Intel) <legion@kernel.org>

[ Upstream commit d4fc4d01471528da8a9797a065982e05090e1d81 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/coco/tdx/tdx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index da8b66dce0da5..327c45c5013fe 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -16,6 +16,7 @@
 #include <asm/insn-eval.h>
 #include <asm/pgtable.h>
 #include <asm/set_memory.h>
+#include <asm/traps.h>
 
 /* MMIO direction */
 #define EPT_READ	0
@@ -433,6 +434,11 @@ static int handle_mmio(struct pt_regs *regs, struct ve_info *ve)
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
-- 
2.43.0



