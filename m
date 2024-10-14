Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C86F1D0784;
	Mon, 14 Oct 2024 15:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919744; cv=none; b=FMHJpPI9NNbG7AGiZixmcLcaPQJ8nFmHrTfyZ9BYcsAKzZ6QXR2IbggFbEyG3vTFpz5UcinvPfi/7Z2cKLABB1pHtOa5/W/TBnozevUzfA9jEnR+8L47hOsTVAuwsYF9pGmiL1B+25Q0XwNDvZtYhgwtsIjuGq9S+82nFY2uSOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919744; c=relaxed/simple;
	bh=sBlaIpzAzhZg1bHyYVOohAzd0AUVADwIASwo1/RLoRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H08L1E2oIihCE0g1mrk/iVVCeWk45iSDkpknyHj9/fukeOXF7475GTOPZUs4RB9S6zvPo3fBvk3iKrWFqGyXxi661qVFAmznIv/TmyZVwZKbmJWIXZ5FVOpvlwUCHfGuY/2exgspwZVcWLEvRuQpM5hddSNJ2Lo4OC8DUtFuu5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIyugNJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIyugNJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E56AC4CEC3;
	Mon, 14 Oct 2024 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919744;
	bh=sBlaIpzAzhZg1bHyYVOohAzd0AUVADwIASwo1/RLoRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIyugNJyNQ1oYjYKZdQU88kysUOFgC6jOpDTl41QaXL96l+Eo5ggWOdMGRFUx0sGb
	 e0xUSzhzP7QfOXgNEEz608JNZsu60krbdpIwEXAPNRhlP/5b5x/xPHeTsAXsXuENFu
	 aDxR7Zvqxg/QVhLp1F0mffG90o2NtZgB75FOvn/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 694/798] s390/traps: Handle early warnings gracefully
Date: Mon, 14 Oct 2024 16:20:48 +0200
Message-ID: <20241014141245.334099965@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 3c4d0ae0671827f4b536cc2d26f8b9c54584ccc5 ]

Add missing warning handling to the early program check handler. This
way a warning is printed to the console as soon as the early console
is setup, and the kernel continues to boot.

Before this change a disabled wait psw was loaded instead and the
machine was silently stopped without giving an idea about what
happened.

Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/early.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index b3cb256ec6692..1dcdce60b89c7 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -151,8 +151,21 @@ static __init void setup_topology(void)
 
 void __do_early_pgm_check(struct pt_regs *regs)
 {
-	if (!fixup_exception(regs))
-		disabled_wait();
+	struct lowcore *lc = get_lowcore();
+	unsigned long ip;
+
+	regs->int_code = lc->pgm_int_code;
+	regs->int_parm_long = lc->trans_exc_code;
+	ip = __rewind_psw(regs->psw, regs->int_code >> 16);
+
+	/* Monitor Event? Might be a warning */
+	if ((regs->int_code & PGM_INT_CODE_MASK) == 0x40) {
+		if (report_bug(ip, regs) == BUG_TRAP_TYPE_WARN)
+			return;
+	}
+	if (fixup_exception(regs))
+		return;
+	disabled_wait();
 }
 
 static noinline __init void setup_lowcore_early(void)
-- 
2.43.0



