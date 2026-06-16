Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5A435AC3E;
	Tue, 16 Jun 2026 18:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635205; cv=none; b=GmxfOGYTtzNdVZzRVUatQu45MmD66J8zbn2H6xWomdplgCQmAFVf3E/llOa03yxgxQiPjiRJPy2KrQuLQbS7KM9q+Nv+ABFrp0/wBTrEMfatqvZzFLVCGs5BC84kCPdXWxvC3fcJBOSeIrEUy+gztrHcxedL8rYmFf5fqPqa57I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635205; c=relaxed/simple;
	bh=5CYeveyBZkRywgC6/A9NXOOKQ66VnBi6cdrh8MabaeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amD2yfhkmcdDApIzY3olyc/VT4y4EWJgk1t1e71gY9GMqDQQYryKCHX4X/koGyPbrh9cf/toFcRNynbmiP8ULcp91VwlYFdg8X+dDFCbYeEhQVkccLvCbvA769ILUxAeJsNXD9dJIsNX8BoehbCCsNvdZmqcmjJc2HlBCyAdjKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vr5TtiUS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vr5TtiUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1458A1F000E9;
	Tue, 16 Jun 2026 18:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635204;
	bh=C1WSx5N8jyawHxz67lnG7YBmDx8hIDMjgUbzLcDfrVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vr5TtiUSIfqXHJAhVWCFtFsfDwIjCcvbLw9jZqFoyrDisgr3v7zrCUbwzLFkSPVeY
	 f3z2bUq5wK618V7ui4Fm+N+KEhFEQZgk9OtU7hZb+UrE8KPuN20E0Ishsx60SOvQRd
	 7yV+Ue/tfWhpU1ioS5eOXmS4qQYRXvzwyif9QkGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Ben Hutchings <benh@debian.org>
Subject: [PATCH 5.15 411/411] x86/CPU/AMD: Move the Zen3 BTC_NO detection to the Zen3 init function
Date: Tue, 16 Jun 2026 20:30:49 +0530
Message-ID: <20260616145122.972422457@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Borislav Petkov (AMD) <bp@alien8.de>

commit affc66cb96f865b3763a8e18add52e133d864f04 upstream.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: http://lore.kernel.org/r/20231120104152.13740-4-bp@alien8.de
Stable-dep-of: 7c81ad8e8bc2 ("x86/CPU/AMD: Rename init_amd_zn() to init_amd_zen_common()")
[bwh: Adjusted to apply after backports of the above commit which actually
 depended on this]
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1111,14 +1111,6 @@ static void init_amd_zen1(struct cpuinfo
 		/* Erratum 1076: CPB feature bit not being set in CPUID. */
 		if (!cpu_has(c, X86_FEATURE_CPB))
 			set_cpu_cap(c, X86_FEATURE_CPB);
-
-		/*
-		 * Zen3 (Fam19 model < 0x10) parts are not susceptible to
-		 * Branch Type Confusion, but predate the allocation of the
-		 * BTC_NO bit.
-		 */
-		if (c->x86 == 0x19 && !cpu_has(c, X86_FEATURE_BTC_NO))
-			set_cpu_cap(c, X86_FEATURE_BTC_NO);
 	}
 
 	pr_notice_once("AMD Zen1 FPDSS bug detected, enabling mitigation.\n");
@@ -1178,6 +1170,16 @@ static void init_amd_zen2(struct cpuinfo
 static void init_amd_zen3(struct cpuinfo_x86 *c)
 {
 	init_amd_zen_common();
+
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR)) {
+		/*
+		 * Zen3 (Fam19 model < 0x10) parts are not susceptible to
+		 * Branch Type Confusion, but predate the allocation of the
+		 * BTC_NO bit.
+		 */
+		if (!cpu_has(c, X86_FEATURE_BTC_NO))
+			set_cpu_cap(c, X86_FEATURE_BTC_NO);
+	}
 }
 
 static void init_amd_zen4(struct cpuinfo_x86 *c)


