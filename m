Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C740F14658D;
	Thu, 13 Feb 2025 15:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460303; cv=none; b=IXi2mhhbgQq93untK5pSvBZTwDy5DdGp1V9fwoYBxdMxx4aXS89htqL5E4q/F0X9Q93uheOFmj2ud1Df7Nli6wRAGiRKqP0PPc2puGYwZFoDH0kvSF10JaZMODeWcwC9dm2LLKdL+ZuCwdXdc4ly7q5DGjFRXxiXs0TKcay2V0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460303; c=relaxed/simple;
	bh=czvBI46oVVLAkgGE5whCvgzrP/AI4BCzcTDYG0CGx/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5c6feLyNCwBqGJgVkEen/cOWyKu50qlLuNjcEZkYu+MjTI1l5J8OTvIRWIfq0yakG1+rIrNaO+G3vXKwOruo2zGmSeDxMhkCi+SR6wtafPognsfcrBlKsjamrRe9v1GWLHvG0TCPZlH+zt6G9zuk9BssKFMyk+cvdS5tiQiZL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gS3Xv4GS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gS3Xv4GS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C30C4CED1;
	Thu, 13 Feb 2025 15:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460303;
	bh=czvBI46oVVLAkgGE5whCvgzrP/AI4BCzcTDYG0CGx/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gS3Xv4GSSG5xUl6fqgFo3KdwiRJ197P74L43aPgSW1RaZ4UDoayE/65Ca46pBizwi
	 /tFrNe4UFNvUIXX+oB7bcnCLi8v1y+V6Zx8xjZFUfDhmRMdn/F9KaHjSrqPun6SZLF
	 zOy0nbx1Hf27HfNI8L5JqBu6UhDkCvrQ5k81aUKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/273] x86/xen: fix xen_hypercall_hvm() to not clobber %rbx
Date: Thu, 13 Feb 2025 15:27:26 +0100
Message-ID: <20250213142410.273187901@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 98a5cfd2320966f40fe049a9855f8787f0126825 ]

xen_hypercall_hvm(), which is used when running as a Xen PVH guest at
most only once during early boot, is clobbering %rbx. Depending on
whether the caller relies on %rbx to be preserved across the call or
not, this clobbering might result in an early crash of the system.

This can be avoided by using an already saved register instead of %rbx.

Fixes: b4845bb63838 ("x86/xen: add central hypercall functions")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/xen-head.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 4fd814321ed02..9ecdde17c4e1e 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -117,8 +117,8 @@ SYM_FUNC_START(xen_hypercall_hvm)
 	pop %ebx
 	pop %eax
 #else
-	lea xen_hypercall_amd(%rip), %rbx
-	cmp %rax, %rbx
+	lea xen_hypercall_amd(%rip), %rcx
+	cmp %rax, %rcx
 #ifdef CONFIG_FRAME_POINTER
 	pop %rax	/* Dummy pop. */
 #endif
-- 
2.39.5



