Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7662222B4;
	Thu, 13 Feb 2025 14:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457475; cv=none; b=eZI1k9c1saho47lbAHyyQXLHfBGe05XDKFXykU7H2uYnY/xGlUbLmg6rFzSD6dpjaJD54quvy0E5bF46fKtGSfx3DY4/U2jz8Do9S4BPGBUniJFYLQ0fsYxTC41OyvzcVzvi5SYNSb+h23KlOam3yB3otRlzC/obaX4jJIsfpA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457475; c=relaxed/simple;
	bh=nRg4TB+gt1Paw/R8iTG2v9VXUyMFQCVkqrirk2fd+WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjiHtsU8MSRZvygiVa0fnW0jTSCFAuXuK1mtIbKTma+3DXmRA69fLi9ol3Z94bqCpjR3XWar2eQaT644+jn+AMjkA/shmKR4WbvZudZ+/oUYZWYCWGbfbdPJw+iSYZXi4wf2v2+Dqy9FlniTVlBazu7+j9VPkTNzODC28HUPoYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zk5q/Fm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zk5q/Fm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1767C4CEEA;
	Thu, 13 Feb 2025 14:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457475;
	bh=nRg4TB+gt1Paw/R8iTG2v9VXUyMFQCVkqrirk2fd+WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zk5q/Fm+BWm8kwZsoFGc8Rp+53367iEF7sEAGGrweSukSF7rk9ZqsK/WIEJlai964
	 J4gqnJC8TvqW3RZUd1M5nW1AH9OtDtSXcN3wbb8BFm3+6xrtlh0NsH2wSiFh7YKo3N
	 YODJEtvZM+Q06SQMtWwSsvTScXKJ8nlBaraOnw2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/422] x86/xen: fix xen_hypercall_hvm() to not clobber %rbx
Date: Thu, 13 Feb 2025 15:24:29 +0100
Message-ID: <20250213142441.182066261@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 721a57700a3b0..ce96877c3c4fe 100644
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



