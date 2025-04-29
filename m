Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FC1233735;
	Tue, 29 Apr 2025 17:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949085; cv=none; b=gTajetTsFW+NG0bENvCDNIdN4B+aORJ3nju2W6TyvNfUDPeYR05a/YB4fYGJyoVyXSrrQuekn3zXqf3X6jyhVgf3H5gm4oPuLm3Jg66cHUn7UdEVxQZWbOl6lLoxijqQR9WbxDg4ufbMgrNdic0CpPCLTDEduPGRUhN+NCE6JWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949085; c=relaxed/simple;
	bh=uqx7ElJL6aZRHsqHKMR5gKfSNAGZL6knqWUhQEnzguI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sh1zp0ZQXPMNES6DnE2nTCHYuk9c0QIasFYsz8qlKROrIPJ6XRSYqzRvzZbpnaukhcWhY9WHsUW0i+Gb0DJ9IxEdPpwVx4uKTnWtegMK+rkkA5IJ+KFLatg7bZYcDu1XyzxRGpoKS4APBOcz430ZrWcoFGBINMbR9Be5MK2UKE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvGsJN2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvGsJN2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E189C4CEE3;
	Tue, 29 Apr 2025 17:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949085;
	bh=uqx7ElJL6aZRHsqHKMR5gKfSNAGZL6knqWUhQEnzguI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvGsJN2j8mGI6T+UT3kF8QaMaXK8S+H9gWAFpIjn4m7o/E0DVaQELVdkwY8ptv38F
	 SfdKeQllUeBSzrEXlfImyQq+QR/SuHb6lYkrEGoTPz/xakRRLi9VzBojbzNHRzY2ZT
	 PGxdIwnhQlyR/3RPyQUlk+cd2iEmPIYlJCmCyzxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 209/373] x86/pvh: Call C code via the kernel virtual mapping
Date: Tue, 29 Apr 2025 18:41:26 +0200
Message-ID: <20250429161131.760027217@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -99,7 +99,12 @@ SYM_CODE_START_LOCAL(pvh_start_xen)
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


