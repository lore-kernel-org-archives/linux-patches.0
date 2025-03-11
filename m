Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3102425DD08;
	Tue, 11 Mar 2025 15:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706762; cv=none; b=c72qh2bAdvXfsR435FKyIxZkSJKZvfG+o2UOrHOD7W5EYKesxa3WO+GYKxYrl/+zSRj0OZ5mZx92dnS2FrJVc81udgM2DU40yDVLHVgf1RvtkQ+t1JxTmjTqFo4i2U2Kisi0a0fyG/FYYR7l3glg+n/iz0dfyrPpTK7MdMavT1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706762; c=relaxed/simple;
	bh=hnjVQsCIbFaXL7UCtCx+HvRK7tiX3nxeLDqpqEhuDME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMKaxHEfueiuBnRJywg9uAYBQGzB/Mq8eKyuIr4u63n++Y0tFOCZnJGUMf2gwsNucJCxLYKcev/X54Ay7FUJIyJmmcc9zB4d2TU2Qm+Avm6qBBdu8EYDR5+jm+u9hfKxRyf/sU/Mdcg73JjH9S0mBRLcQKlV/GKJ2b1M7m2ldX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNOEmg5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNOEmg5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8EFC4CEE9;
	Tue, 11 Mar 2025 15:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706762;
	bh=hnjVQsCIbFaXL7UCtCx+HvRK7tiX3nxeLDqpqEhuDME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNOEmg5yZXUco5Kt4EeVKwknAGg+FYMij5TTsqUTjBqGpA6bD8MoaW92pGMIaDUbd
	 8Ag1p+hwM56yLehAeFTBZV19EUZMCdGMgZEodBp+Mk0h/7k87ppiR+cjC83tn1xAHc
	 RlX4MK4uLZsq3L1j0EleWAHqG3xYn40h7pF2ZPOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/462] x86/xen: fix xen_hypercall_hvm() to not clobber %rbx
Date: Tue, 11 Mar 2025 15:57:05 +0100
Message-ID: <20250311145804.625513231@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 152bbe900a174..0dce73077c8cb 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -115,8 +115,8 @@ SYM_FUNC_START(xen_hypercall_hvm)
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



