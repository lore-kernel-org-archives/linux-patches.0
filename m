Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4FA3603DE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300930; cv=none; b=U8G+kcS8VBtQ0AQudOGdB6+apMPOO/aur8o/YU9dD1xtl50e5bordrivUIh4p/491OLunAhe0k6U7T/JwXmg4cNx6Dwid/kcVUx6wZ5LjOugKYhf0O6gppVYIzGCuMJmg0OTd4sLpmIN//l1W1q67oevwLuzIV1CxOlzcTt+IyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300930; c=relaxed/simple;
	bh=LXfydIHbtyS7K6xEZPDR93d+R5QphdM5i5xDyAVm46E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATu9PFRpoEgPd7nIhA50UvHro4xos1LsjE9lDyDOh93OlOOVNKVRD/O66Ozkmruhh4BXEmd5pUw7HyOJBpks1Zs+1pLWHxsIAW+bzx3+AZWHjqfME6H9aLvwpfdEjRBfxxXKDipt8xT2OW8tPgxGk/6qFVa5xGkJVAyYZESkPD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R8nV0lIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R8nV0lIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AD4C19423;
	Sat, 28 Feb 2026 17:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300930;
	bh=LXfydIHbtyS7K6xEZPDR93d+R5QphdM5i5xDyAVm46E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8nV0lIJfD+gv2Wzh5hADF+w0W+ecUSnXCwHoQW6c3wnreAx+3UI2nqjchJrO0/u2
	 BAojY7tWht89eCYgg0Eewtex9jyjZ5cCOoHpoc4ji3lcXDN8386bh6ObkMkFrslwaV
	 Ff9F09N1vPo5OvsCdFm05tZboVTmRkmv1IOFpmEoDrCMYEBkDDZZmetsFNhxMDJMK7
	 nNF3EB5bFuPX2OfHz3/ihEV8Vr6iwC2RjdvdpC3zZvZ2JyXk/mY2HxCieRCtTUyPVU
	 dgmEgsU4UGbK35QSqfKkVI2LqAW6wPGGJs6oWCSX2fgucwCH6tFadckR5KECpBOL1d
	 7fa37AtyqaucQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 049/752] x86/xen/pvh: Enable PAE mode for 32-bit guest only when CONFIG_X86_PAE is set
Date: Sat, 28 Feb 2026 12:36:00 -0500
Message-ID: <20260228174750.1542406-49-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

[ Upstream commit db9aded979b491a24871e1621cd4e8822dbca859 ]

The PVH entry is available for 32-bit KVM guests, and 32-bit KVM guests
do not depend on CONFIG_X86_PAE. However, mk_early_pgtbl_32() builds
different pagetables depending on whether CONFIG_X86_PAE is set.
Therefore, enabling PAE mode for 32-bit KVM guests without
CONFIG_X86_PAE being set would result in a boot failure during CR3
loading.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <d09ce9a134eb9cbc16928a5b316969f8ba606b81.1768017442.git.houwenlong.hwl@antgroup.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/pvh/head.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/platform/pvh/head.S b/arch/x86/platform/pvh/head.S
index 344030c1a81d4..53ee2d53fcf8e 100644
--- a/arch/x86/platform/pvh/head.S
+++ b/arch/x86/platform/pvh/head.S
@@ -91,10 +91,12 @@ SYM_CODE_START(pvh_start_xen)
 
 	leal rva(early_stack_end)(%ebp), %esp
 
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 	/* Enable PAE mode. */
 	mov %cr4, %eax
 	orl $X86_CR4_PAE, %eax
 	mov %eax, %cr4
+#endif
 
 #ifdef CONFIG_X86_64
 	/* Enable Long mode. */
-- 
2.51.0

