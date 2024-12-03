Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948141F8907;
	Tue,  3 Dec 2024 15:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240076; cv=none; b=jj5Dhwr03j3WLRoGUJwAY9WtWmOLE75nUMdZ3OWClTJwoWQZLkVGEMaSdoQ9P5KkUmklfiaXKJ9tH4PtzjAGpEt/0Oyb73cl02dCn9F3HdZDSK3tJr3YQPzyLWmDAkOMH/3gmWos3wZ3jpUef69lHxqcsVmBI1sQ7xZSdNFAVKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240076; c=relaxed/simple;
	bh=b7ONXl88BlyZevUL1zbxgfBiIt4XkCEdtJZKQ1umO6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOWJb79huwmD5c/UWKzM5sLV7R10mQ+/ms+DGKFVt84Son/LOptFimPJv85pLWpsikI4NDadaox5lhGC4HwwK6WdeCgfBvjum1wFk2q/cfYZqdE93x030J5yjSo5fiJGyS/L630Lg4Y4PJzAgkRt8Y49vl49Iw/PgnwKvUs9kmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLaq7hMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLaq7hMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1961CC4CECF;
	Tue,  3 Dec 2024 15:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240076;
	bh=b7ONXl88BlyZevUL1zbxgfBiIt4XkCEdtJZKQ1umO6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLaq7hMFiFvt+onTIlus3ja6y95nw/08ftNdmcmaWpT9JMH1fbk4n071Fm76Q7/Tl
	 V/wtNgmnk5T5y04RHhpfS3uPNe4OoEt/IFXrlDq/u6yCjyJX3h/VvDaOIhbxzmKm7n
	 qMpOak1cDzZPfTnkoPwLGYJ5FNpa4RVwPQufuz+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/826] x86/pvh: Call C code via the kernel virtual mapping
Date: Tue,  3 Dec 2024 15:35:42 +0100
Message-ID: <20241203144744.049989549@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 64fca49cd88ff..ce4fd8d33da46 100644
--- a/arch/x86/platform/pvh/head.S
+++ b/arch/x86/platform/pvh/head.S
@@ -172,7 +172,14 @@ SYM_CODE_START_LOCAL(pvh_start_xen)
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



