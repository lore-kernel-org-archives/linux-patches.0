Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9301B3942;
	Tue,  3 Dec 2024 14:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237753; cv=none; b=gs3yLh1etESDhK9dOnBx4SGtt4ovaSCJHJBzV0fbHQoSfuugDr1/V7djRWEYlJa3G1p69/BmGqnI/MjFKfbeILO13J/eoZiB81xupJB2hyaZglbryfeYMrGRpIjUM8mJSpY9nkXTGJXyyjIXOYQeqOv8j68/kVJpTJQzD4NxxHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237753; c=relaxed/simple;
	bh=yeDM8R7rt1ZgxSIza6I8OlIbPsvmdqmeVDuH+WUEZAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l95r9rAWs2cU7xmm7t/q/dpSnDkyEoEKLMhX1Rf0xbx9pQ5ELsF4BqOW3YEXhvVxpSHBR/0U06XQzE5w12V99QR61UmebaywC/XUHOlUsLsKjxY0IcOjMsJwNvrRrf4IFhE051W+wWcjEmWTW//zCVEm87ipVLP85Rgv0GviJRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWJVFdk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWJVFdk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2311FC4CECF;
	Tue,  3 Dec 2024 14:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237752;
	bh=yeDM8R7rt1ZgxSIza6I8OlIbPsvmdqmeVDuH+WUEZAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWJVFdk2ToMZGpBUgOZ207njFROA0K/aHxWD4JPn6kM8E8N1NIX8FQnFMnKEu3Q8x
	 GsoZTDfuy+n+3VrZ2CKUi1wO7/BfjTgEGjiMBPxOj9pLSxSUJDS6EODBXJSVFLjUDb
	 qbPsWLhy/jli1ypsTv8RV6qSkbKZPmp2+/f+3zGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 060/817] x86/pvh: Call C code via the kernel virtual mapping
Date: Tue,  3 Dec 2024 15:33:52 +0100
Message-ID: <20241203143958.026399510@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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
index 3621293cd1cc2..acb39752e7ca3 100644
--- a/arch/x86/platform/pvh/head.S
+++ b/arch/x86/platform/pvh/head.S
@@ -108,7 +108,14 @@ SYM_CODE_START_LOCAL(pvh_start_xen)
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



