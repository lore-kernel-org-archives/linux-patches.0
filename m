Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7B03AB5B8;
	Mon, 17 Aug 2026 14:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975243; cv=none; b=VT/rk4Qkarn/SBVeHutYeC+3fuVEV2JEEFPa9NIRLmofNphC9fbqjGyo5tuTCQIn2aw0sVhOw1/kxOozwyqVfk9ZtUPFw1EsyTUAaMfl95eShv7d2vfEEMZBJJRUYoDHVZbiSwVgnQab5J7MlJzSpmM09GV1jVPGEGZro0UsN1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975243; c=relaxed/simple;
	bh=/hIdeFUyxGMsMv7+2QtMbThR2hdppA2tHocXtnpeKk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoFqFAQ/zZoL7lh4QPm0fEQ6jFZ4QdGdcYe1fcPqrqag7Tgf6LEcOskiaUUTLZ6MkkdA7pPou2IMWhx4JFD2iD/h3lSIckomQAXDTg/a0iF0tjPYbDa5mq8xYlvrwaO77eM4lQnRXLhT+MadU3ySFE2568ItDrkPjGO1BT7YvLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vco5he7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vco5he7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D95A1F000E9;
	Mon, 17 Aug 2026 14:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975241;
	bh=o6xJIEuKpK3/+ID8PVwd3SET4LTC2upQwOlgzoAJmeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vco5he7OTL8u720WQtW61GfakuFk0m+CVBoSXQBZuKtQz7oEUasjcI5deNWPpu+l3
	 DEKT+2BHqBSyo+8Xfs/MzwWkbziuh3ao23nqQ2nQSx2nE0F2FL2MbIcC4XLAzd81xb
	 gsLXadeA7s9YNCebO+3wkMOXAgACMH9+SGG2fvEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Rik van Riel <riel@surriel.com>,
	stable@kernel.org
Subject: [PATCH 6.18 212/250] x86/CPU: Add a tlbi= cmdline switch
Date: Mon, 17 Aug 2026 15:32:53 +0200
Message-ID: <20260817132545.213276653@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

commit abe7c8b09bd72a9c726016257c6281f129b4c02d upstream.

With the recently found INVLPGB / TLBSYNC issue, there has been some
interest in disabling INVLPGB-based TLB flushing, in order to rule out
that CPU issue as a cause of userspace crashes.

Add a kernel command line option to control the TLB flushing behavior.

If the need arises, we will add a "tlbi=broadcast" for the case when TLB
invalidation broadcasts need to be explicitly selected, but this is not
needed now yet.

  [ bp: Rewrite commit message, move to cpu/common.c, add documentation. ]

Fixes: 767ae437a32d ("x86/mm: Add INVLPGB feature and Kconfig entry")
Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20260729204341.3eb0b5ea@fangorn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    4 ++++
 arch/x86/kernel/cpu/common.c                    |   10 ++++++++++
 2 files changed, 14 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -7339,6 +7339,10 @@
 			See Documentation/admin-guide/mm/transhuge.rst for more
 			details.
 
+	tlbi=		[X86-64]
+			Format: {ipi}
+			ipi: switch to IPI-based TLB flushing
+
 	topology=	[S390,EARLY]
 			Format: {off | on}
 			Specify if the kernel should make use of the cpu
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2622,3 +2622,13 @@ void __init arch_cpu_finalize_init(void)
 	 */
 	mem_encrypt_init();
 }
+
+/* Control TLB flushing methods */
+static int __init tlbi_setup(char *str)
+{
+	if (!strcmp(str, "ipi"))
+		setup_clear_cpu_cap(X86_FEATURE_INVLPGB);
+
+	return 1;
+}
+__setup("tlbi=", tlbi_setup);


