Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3CF484226;
	Thu, 20 Aug 2026 17:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247310; cv=none; b=k6lzMammCdS8SzaBcJv78nlIgisMos2sO1bafODNzqme0vhBhFltugmflkA9V3qJ6WSD6H/xT4ESEIU703N/SK5fEle4lz11xI5l39/9DCHkvBbIkvn4YXJljkr1IfBYn7Ymk6JhdcENWEbTPT8CaRKT/YOFQUUlVRYu7OAV+rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247310; c=relaxed/simple;
	bh=QF/EPSzNx2y3rF5hYOCn+NTFNO3DmsQy42lXiuzrOBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/Mf+UcuNPfD7jh9+f693+HLc5D0G5Crls17j7E+XzG2Bc9Q+KZXKRD22/UXbM0X5659IjXGX6FiyWeNjjpvXrpXMg1suLno+7qrfGmFMgzoV9LO2BSpj1en8dG+kM796Ips19GQGkJt0nmEDykDkbTEaCm3bzWpaSYPGALUN6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1HGm/T1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1HGm/T1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C90E1F000E9;
	Thu, 20 Aug 2026 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247309;
	bh=jNQOlrZczIM3FeC5BzzZ6z9GzMT4K5eJNLoHpXwZb/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1HGm/T1PuOLfpCDyB2p04R7ggPiTqkM0EsWvBQQ/wSRQDvT9sd7LzHRxgHt3cLwC
	 dpIbeKeThF3I6e/7Ooz+uVKOLVSs4Htx0b8G/sCjMt7WV6U+j8OLGAonIInhLE6V4J
	 2mpP2aymfme0QsWvnaWBLlLrEb4CzhqOW5oUNUzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/220] x86/mce: Remove __mcheck_cpu_init_early()
Date: Thu, 20 Aug 2026 16:56:16 +0200
Message-ID: <20260820145229.093750107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit 9f34032ec0deef58bd0eb7475f1981adfa998648 ]

The __mcheck_cpu_init_early() function was introduced so that some
vendor-specific features are detected before the first MCA polling event done
in __mcheck_cpu_init_generic().

Currently, __mcheck_cpu_init_early() is only used on AMD-based systems and
additional code will be needed to support various system configurations.

However, the current and future vendor-specific code should be done during
vendor init. This keeps all the vendor code in a common location and
simplifies the generic init flow.

Move all the __mcheck_cpu_init_early() code into mce_amd_feature_init().

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/20250825-wip-mca-updates-v5-6-865768a2eef8@amd.com
Stable-dep-of: a213dfaa2596 ("x86/mce: Set up the polling timer before CMCI discovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/amd.c  |    4 ++++
 arch/x86/kernel/cpu/mce/core.c |   14 --------------
 2 files changed, 4 insertions(+), 14 deletions(-)

--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -674,6 +674,10 @@ void mce_amd_feature_init(struct cpuinfo
 	u32 low = 0, high = 0, address = 0;
 	int offset = -1;
 
+	mce_flags.overflow_recov = cpu_feature_enabled(X86_FEATURE_OVERFLOW_RECOV);
+	mce_flags.succor	 = cpu_feature_enabled(X86_FEATURE_SUCCOR);
+	mce_flags.smca		 = cpu_feature_enabled(X86_FEATURE_SMCA);
+	mce_flags.amd_threshold	 = 1;
 
 	for (bank = 0; bank < this_cpu_read(mce_num_banks); ++bank) {
 		if (mce_flags.smca)
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2011,19 +2011,6 @@ static int __mcheck_cpu_ancient_init(str
 	return 0;
 }
 
-/*
- * Init basic CPU features needed for early decoding of MCEs.
- */
-static void __mcheck_cpu_init_early(struct cpuinfo_x86 *c)
-{
-	if (c->x86_vendor == X86_VENDOR_AMD || c->x86_vendor == X86_VENDOR_HYGON) {
-		mce_flags.overflow_recov = !!cpu_has(c, X86_FEATURE_OVERFLOW_RECOV);
-		mce_flags.succor	 = !!cpu_has(c, X86_FEATURE_SUCCOR);
-		mce_flags.smca		 = !!cpu_has(c, X86_FEATURE_SMCA);
-		mce_flags.amd_threshold	 = 1;
-	}
-}
-
 static void mce_centaur_feature_init(struct cpuinfo_x86 *c)
 {
 	struct mca_config *cfg = &mca_cfg;
@@ -2266,7 +2253,6 @@ void mcheck_cpu_init(struct cpuinfo_x86
 
 	mca_cfg.initialized = 1;
 
-	__mcheck_cpu_init_early(c);
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_vendor(c);
 	__mcheck_cpu_init_clear_banks();


