Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCAE1F462D;
	Mon, 18 Aug 2025 13:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522069; cv=none; b=c6GJTEQQjG1EIfT0/zCrmBWijsOpPIZdeAgJeEN2RsXapAqeuJ3L0UfvXwYqZFWyABOGqCDt4sJcb/ZM9+rI0a+jLj4kH0tVGUcGw2hBJK1CE65ZQky6O96JGwlYR6BpXlhMX2lMUEz7uKM8QQHHcp2xlcQAVZ6FL756h/gaz3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522069; c=relaxed/simple;
	bh=0JAkrPQGnCcWX6PZ1qeMT5FQwRYhYvHogsGhnV9Q4Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBfBReDlqAIt1+rPUjdMJSbDMGNYm4u/m0ixlb/22ZYnWof3F5SU7ww9zEemGqVtulEM8/W5V+k3kOKGJsBxgCCnGuwa93jqXcbcuhF3Gfn2uZOucsEjt0xJAAlwU3DNsTTpilaOOjqsxy8+K87YYF1Cg1ndm3bfxlzHwHNAD+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUinkF2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUinkF2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D61C4CEEB;
	Mon, 18 Aug 2025 13:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522069;
	bh=0JAkrPQGnCcWX6PZ1qeMT5FQwRYhYvHogsGhnV9Q4Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUinkF2zpQgBo38ejXRIIMJQ0VRiOEO4KLqT/RR+fj6ElSZYUqz4Yv7a5hdip82sU
	 4T19FiII0XWfGuVSsrzxvymCxC2mimS49gfRpUB8xLGH88MOw/p5dwm1HcCSQVMULr
	 RDSCvkvgH/J7wD2dZhY0fn2hxFkgqv+cAfg3RQBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/444] s390/early: Copy last breaking event address to pt_regs
Date: Mon, 18 Aug 2025 14:43:51 +0200
Message-ID: <20250818124456.547278709@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 7cf636c99b257c1b4b12066ab34fd5f06e8d892f ]

In case of an early crash the early program check handler also prints the
last breaking event address which is contained within the pt_regs
structure. However it is not initialized, and therefore a more or less
random value is printed in case of a crash.

Copy the last breaking event address from lowcore to pt_regs in case of an
early program check to address this. This also makes it easier to analyze
early crashes.

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/early.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 62f8f5a750a3..0c054e2d1e03 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -183,6 +183,7 @@ void __init __do_early_pgm_check(struct pt_regs *regs)
 
 	regs->int_code = lc->pgm_int_code;
 	regs->int_parm_long = lc->trans_exc_code;
+	regs->last_break = lc->pgm_last_break;
 	ip = __rewind_psw(regs->psw, regs->int_code >> 16);
 
 	/* Monitor Event? Might be a warning */
-- 
2.39.5



