Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13C632C8B;
	Fri,  6 Dec 2024 14:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496613; cv=none; b=R0nrVotG7mP6LPkO+jo97ClDNsdOTo5M7Sg8uWy5kAvUKsCT3khmJnNorsguNX3nDcP6ahgrfKhEes/D1SgXHPE3WGAgxnv6e52AwlBzlrUszZUd+IRxlWVvQHvC3JV2WU7mrehj9z4c0YYoR3VAuH/yK82xal6eQ4Rfmq4DtfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496613; c=relaxed/simple;
	bh=jn9SRKBJlTaWw+68Inb9fKrwKoXeTjHMZfkMv4mxunM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL/JPO7DXPk/DUfFcylBX2hWG+SZmFKDrBhN0hREK+n1s1Vi4cGXlYJgya3DHsL57BhBu8Z3r/1U4wjvw9hTII7ohEQb2tsctdu4YDhL5WkSGv9IR/8jOt81rOgXngXwu2WUeLJb4K/lvRSBKCzzcms1v+Lk+/VYKr4mQuQ4Bzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xuq91LOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xuq91LOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC21C4CED1;
	Fri,  6 Dec 2024 14:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496613;
	bh=jn9SRKBJlTaWw+68Inb9fKrwKoXeTjHMZfkMv4mxunM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xuq91LOzXYy3rfYMp3nZ5F/n85c2K27m10rszKfeeSXPL4TTKpY2nHGzLLGGDQ8pZ
	 y8ZOOzmg/CqD783s6cRJHGHhOPyfVzE7rGtrdC/JckK2nWVH+7LUf4eTiaHSvNWI5h
	 y6LXCUncQvHm2J7KDg6EjZA+3yHt1dusXW0NY31Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/676] x86/pvh: Call C code via the kernel virtual mapping
Date: Fri,  6 Dec 2024 15:27:54 +0100
Message-ID: <20241206143655.501163124@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit e8fbc0d9cab6c1ee6403f42c0991b0c1d5dbc092 ]

Calling C code via a different mapping than it was linked at is
problematic, because the compiler assumes that RIP-relative and absolute
symbol references are interchangeable. GCC in particular may use
RIP-relative per-CPU variable references even when not using -fpic.

So call xen_prepare_pvh() via its kernel virtual mapping on x86_64, so
that those RIP-relative references produce the correct values. This
matches the pre-existing behavior for i386, which also invokes
xen_prepare_pvh() via the kernel virtual mapping before invoking
startup_32 with paging disabled again.

Fixes: 7243b93345f7 ("xen/pvh: Bootstrap PVH guest")
Tested-by: Jason Andryuk <jason.andryuk@amd.com>
Reviewed-by: Jason Andryuk <jason.andryuk@amd.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Message-ID: <20241009160438.3884381-8-ardb+git@google.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/pvh/head.S | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/pvh/head.S b/arch/x86/platform/pvh/head.S
index c994ea58bdf7a..008a805522245 100644
--- a/arch/x86/platform/pvh/head.S
+++ b/arch/x86/platform/pvh/head.S
@@ -107,7 +107,14 @@ SYM_CODE_START_LOCAL(pvh_start_xen)
 	movq %rbp, %rbx
 	subq $_pa(pvh_start_xen), %rbx
 	movq %rbx, phys_base(%rip)
-	call xen_prepare_pvh
+
+	/* Call xen_prepare_pvh() via the kernel virtual mapping */
+	leaq xen_prepare_pvh(%rip), %rax
+	subq phys_base(%rip), %rax
+	addq $__START_KERNEL_map, %rax
+	ANNOTATE_RETPOLINE_SAFE
+	call *%rax
+
 	/*
 	 * Clear phys_base.  __startup_64 will *add* to its value,
 	 * so reset to 0.
-- 
2.43.0



