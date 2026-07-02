Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5538B3AC0FF;
	Thu,  2 Jul 2026 16:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010720; cv=none; b=NViNtB3dLsCmJ7KBmOLyJacre5JmVz2cLC2iR/oqxrnlYp373FxRlEqPFIT6ko0CJTdnCrO0zh1wFWniuUhMliLT/3TKus0Rg+BDExYtvU4IvPFiCxwrh5tN4RYXpmAQY4yHV3gk+01O+6+pC4Evlqjk6KD1RhekHh840K5SXz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010720; c=relaxed/simple;
	bh=rhECVQ+1SAXWHvrhQEq2WRn8/eaiKkd0QEQ9Evoj0yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1XKs0JdN5bypZbJblU2wLVHMnTTNC8EAMvD9t7ZKBMXV2AUDC8uJQAE/Ibfwvxx/9lDEwiaWXfHGby3zRtjWo5j1AxmVWimjtN95hb1UhYPAx3hN4BXqnNIy3Qdsh/XNjgLVBetJBWwTTZaInr/iXuqVuPQIhQI7me0Jd0lN24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvEk2gIM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvEk2gIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3701F000E9;
	Thu,  2 Jul 2026 16:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010719;
	bh=oZjzFT7asQaHHLLEgCAFz/DVWmgbbQJszmEbmy8vFpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YvEk2gIMzYS+lpaN5xv71hwoF5iNacUJnC4F5JF/G2WfNCrl2LviABIkYmGxd1qfl
	 PBo/pTsj1rO9IvyLHRdN4NRRm4bZmuP4zUagLPGEII0pA5p07yXT60h6ubPGKKs2H6
	 zvt72gBIIYdFIRwnBMQl9goPmlVHZj86T1utWQp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/175] ARM: group is_permission_fault() with is_translation_fault()
Date: Thu,  2 Jul 2026 18:18:33 +0200
Message-ID: <20260702155116.029400250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit dea20281ac88226615761c570c8ff7adc18e6ac2 upstream.

Group is_permission_fault() with is_translation_fault(), which is
needed to use is_permission_fault() in __do_kernel_fault(). As
this is static inline, there is no need for this to be under
CONFIG_MMU.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/fault.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index ed1a25f457e48e..879730a47c4a20 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -128,6 +128,19 @@ static inline bool is_translation_fault(unsigned int fsr)
 	return false;
 }
 
+static inline bool is_permission_fault(unsigned int fsr)
+{
+	int fs = fsr_fs(fsr);
+#ifdef CONFIG_ARM_LPAE
+	if ((fs & FS_MMU_NOLL_MASK) == FS_PERM_NOLL)
+		return true;
+#else
+	if (fs == FS_L1_PERM || fs == FS_L2_PERM)
+		return true;
+#endif
+	return false;
+}
+
 static void die_kernel_fault(const char *msg, struct mm_struct *mm,
 			     unsigned long addr, unsigned int fsr,
 			     struct pt_regs *regs)
@@ -229,19 +242,6 @@ void do_bad_area(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 #define VM_FAULT_BADMAP		((__force vm_fault_t)0x010000)
 #define VM_FAULT_BADACCESS	((__force vm_fault_t)0x020000)
 
-static inline bool is_permission_fault(unsigned int fsr)
-{
-	int fs = fsr_fs(fsr);
-#ifdef CONFIG_ARM_LPAE
-	if ((fs & FS_MMU_NOLL_MASK) == FS_PERM_NOLL)
-		return true;
-#else
-	if (fs == FS_L1_PERM || fs == FS_L2_PERM)
-		return true;
-#endif
-	return false;
-}
-
 static int __kprobes
 do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 {
-- 
2.53.0



