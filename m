Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0301E04BA;
	Wed, 19 Feb 2025 09:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956870; cv=none; b=L831YUBC4TARdMe8QVcHwbVs6XM0y5aMPgwK/pn09A8h6pVt0YXpXlgJPj7yN5kcG84vBquu2Zu8ObzvLUl/sq/vrhIolCWWgQlauFW12vZIQc5/d1iXpWYp4U5b5ucjAiveRuXxjGar4g8sQxbzONIUwpRln20sFVhcNRPuOdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956870; c=relaxed/simple;
	bh=TITM9H5TPFMfV9aPcEoCwolX0nmkr2iHoFbrm7EQnMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHm9Lu8p1O4xVJr5M9JiR6OwsRQqzKBJ1VFQpa2kihuB1SVI4FlMdDXWd93N/1oi3eczAJ+BC56DtN0N8kaYnmLhtVd1JaLmuP9iJ9vsJjGldhnqYLd+Wtn+oRisKk46Ioc9DrQvQCcMG/Cgnrd4OaIGwwM2o2UmL53+cOZCRk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHoYPDOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHoYPDOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8739DC4CED1;
	Wed, 19 Feb 2025 09:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956869;
	bh=TITM9H5TPFMfV9aPcEoCwolX0nmkr2iHoFbrm7EQnMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHoYPDOyO0AS0uCUjeiktNR9WUSU07XrfIsOxJb3iDL/XH7OxDTF9QXeYnR9IAdXc
	 BHYyWQXh3uYkXaCBJ5j4pTcVQLnCIntZSy0ZpyJueZMLiDp4+jLKOhzS8QRA6c0wdz
	 KTo6ABWP+5FYSXVTNJ7fmpFq7joFOqgDsTfHDcGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 329/578] x86/xen: fix xen_hypercall_hvm() to not clobber %rbx
Date: Wed, 19 Feb 2025 09:25:33 +0100
Message-ID: <20250219082705.951771352@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1cf94caa7600c..565708675b2f2 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -110,8 +110,8 @@ SYM_FUNC_START(xen_hypercall_hvm)
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



