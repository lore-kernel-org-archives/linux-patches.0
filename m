Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5492980C7;
	Wed, 23 Apr 2025 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422262; cv=none; b=cBPbx/9ZZIungeICCivsCd7nUWs+ExDyVdRkfQlwBdlO4kxeHdEg84MgC9wr64XcevFslcnE35N32bQt+MN5D+cvqP6+bKQy8HwLTjEOIJ3ovgCyS+r3SUn6N485ZzXZbO6g0hS8/MAO5hQhc5bM7Ao3hmEe0LhoYR0MP26aoYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422262; c=relaxed/simple;
	bh=ZAXQg4uC2mGYSeq1PfD1XEf5KyxD7qvQFD5sg+gFe8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OA/ik6kud4ZHYrEAOtea935lrxVgpzo6kxvIVL0XPQiwQiq7vdb3vVibd+34uE8t+tM4As9Scb9T30qgEGOPUZ6J266bdntzlxgQjYTuag7XPHLdh4MdkuxSIX/SNgFCGMhcELTz87UTYbQ1U7Z8DeEnKl9rc6a43ao3CK+Nze0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4998dv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4998dv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D505EC4CEE3;
	Wed, 23 Apr 2025 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422262;
	bh=ZAXQg4uC2mGYSeq1PfD1XEf5KyxD7qvQFD5sg+gFe8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4998dv64BToVZ0riQ9LqRa44XhkfmmFLnes5GQPnAgENr3vXkEMdBdh2OIOvZjQG
	 LpHubZaafNa0k4aK70BcMUfW57hFbGCyQBV0Q1H0cEUYiMDWFTpFsqTn8jxDkJrIQY
	 UpHnS/XlycSYFk7Vd5Sau5AKSanQD8iBEJADT5cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.1 266/291] x86/pvh: Call C code via the kernel virtual mapping
Date: Wed, 23 Apr 2025 16:44:15 +0200
Message-ID: <20250423142635.294020231@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit e8fbc0d9cab6c1ee6403f42c0991b0c1d5dbc092 upstream.

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
[ Stable context update ]
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/platform/pvh/head.S |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/platform/pvh/head.S
+++ b/arch/x86/platform/pvh/head.S
@@ -100,7 +100,12 @@ SYM_CODE_START_LOCAL(pvh_start_xen)
 	xor %edx, %edx
 	wrmsr
 
-	call xen_prepare_pvh
+	/* Call xen_prepare_pvh() via the kernel virtual mapping */
+	leaq xen_prepare_pvh(%rip), %rax
+	subq phys_base(%rip), %rax
+	addq $__START_KERNEL_map, %rax
+	ANNOTATE_RETPOLINE_SAFE
+	call *%rax
 
 	/* startup_64 expects boot_params in %rsi. */
 	mov $_pa(pvh_bootparams), %rsi


