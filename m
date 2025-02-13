Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860F02A1D1;
	Thu, 13 Feb 2025 15:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459126; cv=none; b=SmveMtJE8ox0OC/IWCLEMHebwrUHXeyii2TkJCtgXkRmeDE5XQWcCSDocatdL1cId4nq7ej9PPSu5dleWmF4whICW+u1TVUhK/oVbOCMLK9oCnHcggQnIUYfu1mtMiSyKUK0PEna34IuGv0YWjsLZnfX5xaTOMk3kOVf2DBtAlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459126; c=relaxed/simple;
	bh=ionIXGVWu3FVammF9dFoQ0lDLa2QHsjRYG40XQwOMGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWA3jDWXK/cwLgTPKmOIGC2PgCItze4RgDTarb88ATYXPRJsyMfuBbTUK6vvNXo50iSxS5B3kyCScJSkceETk9A3r8+1Z2MDv7f+lm7ihhah/wMORJcXzXkall4Q1mgxP2F6c2hcsdqcub2oxvxuDv7ZjU6hpDjmVtyTFn96mAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGSeccau; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGSeccau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DA5C4CED1;
	Thu, 13 Feb 2025 15:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459126;
	bh=ionIXGVWu3FVammF9dFoQ0lDLa2QHsjRYG40XQwOMGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGSeccauuVE0Z3QCv2CMYXhm1hsUojssvTOLQRPjtoMwrteyy9SBlhe7/0Xvx3pTE
	 LsBvwOPVpGxbgcBik2cc0RI0+I4XnXF2J8/8DsnXoeoVkEn7Lp/k6e7y7OO/XTjPA1
	 eHCpriIr3ae8bUNsw4s42dQtoA76aErtaiofDR6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 133/443] x86/xen: fix xen_hypercall_hvm() to not clobber %rbx
Date: Thu, 13 Feb 2025 15:24:58 +0100
Message-ID: <20250213142445.738692761@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 9252652afe596..72f28d66e0e52 100644
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



