Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044FD3A9D94;
	Tue, 16 Jun 2026 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622291; cv=none; b=VfgygvC4+sxaxwQXQ9LTmI6Md87H/HkbW2e+KB3IGkRwH0R2xlTVQOluWDRVjJW34c0x5uMgmPkUObJtJy9hb0+HO6qC3HWGsumoDGi6ZUEU4UTPB45+vIM5o5NEaJ8x0BBYPYsxrzL96Ge2y7meKY+uEzh2j8VrbAdfHhD0WlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622291; c=relaxed/simple;
	bh=O0Hp2o5apN0c7qqaU468VgCZHkGGjkQ+xiDP9n0Cybc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDXgRVPpX+4ohCbD2gQnl108ne6pI/RtmZB62EO2T4SdmehI41pFnZhQSqCoSYANjmpXjUVk6LWokZL9/N4/6cprS8Js+3anrPsjziI6ng3aAnSETcOKtxH7PC1x24MZU7H1YpDVhzlQOJ8t1aGm8UInsyB0eF1u/ssFqXU45XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdgvHZm/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdgvHZm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2D61F000E9;
	Tue, 16 Jun 2026 15:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622289;
	bh=1Hk9aFlJqDUCGPn1D2+7RZkauU3n7iLICLHNE3sMSzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdgvHZm/2rkRjZG+8/mNQ32upuDReLNDwr9isHTjXmZmiBS5n3UIfP3d5/TQo42Px
	 5PNZongsRYZCQRAwicNkWX0jEhMQsVrXZBVX07Yds2Vy5Jufd9Trf4DDlaz1glPrEJ
	 2H7UJ0jFm2ddWF5hdobZn467IaBavL1xiu/a1Kak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/325] ARM: group is_permission_fault() with is_translation_fault()
Date: Tue, 16 Jun 2026 20:26:38 +0530
Message-ID: <20260616145057.943692202@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
index 2bc828a1940c05..f87f353e5a8b0a 100644
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
@@ -225,19 +238,6 @@ void do_bad_area(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 }
 
 #ifdef CONFIG_MMU
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
 #ifdef CONFIG_CPU_TTBR0_PAN
 static inline bool ttbr0_usermode_access_allowed(struct pt_regs *regs)
 {
-- 
2.53.0



