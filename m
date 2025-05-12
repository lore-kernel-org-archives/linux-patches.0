Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F02295D97;
	Mon, 12 May 2025 17:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072661; cv=none; b=H3jk1/aXDjdIlPfaSNRODyFfAex2FYHDeJXY+QweyevGcbWAP8GGaWb23nU+iV+S5KucGHPxvGxnB234sfnE8vDBDldkdl+fYsSrelgTleTviUGloUIppG63JSgpTHKgsRNh0H6tld8xFWrB38Ug8vK9ZnZZh7f7xH2phpqzO2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072661; c=relaxed/simple;
	bh=VaWKpmvnhtEihtZH8ntp+j9gbXDbMli8JMDQ8KPW99c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKqXuywkcoC7Tey/x3SxuUIrFTfMNC5jnUOJRagXXhTQO73J2ECUM/9ew+/h6wb4EB2JGnA68+bvyUriQw2SmELnkzsFVaao84XQqENdUtuki79bMKiGwF92nmggFVdixbdoAWDDdEIRymEnp/kI0Ch/nqGvQX0uhK6AfMKCK5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRS8dmca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRS8dmca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069EEC4CEE7;
	Mon, 12 May 2025 17:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072661;
	bh=VaWKpmvnhtEihtZH8ntp+j9gbXDbMli8JMDQ8KPW99c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRS8dmca703slB21Z5Z2lBKGERmd3TBqIh1A8GlB7kvJrUeAQy8s9zScbnexmhGYs
	 5xDichHbPkxoHk44JggW1D88MulGcVvIkzIPUsyC9nIaJ1JgPvp+aMZgFWpGxtNhjb
	 G4AxrO9mnpSPCkmlIoxzlPlzS4+eGHS68BAWtzKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/184] s390/entry: Fix last breaking event handling in case of stack corruption
Date: Mon, 12 May 2025 19:43:39 +0200
Message-ID: <20250512172042.422373523@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

[ Upstream commit ae952eea6f4a7e2193f8721a5366049946e012e7 ]

In case of stack corruption stack_invalid() is called and the expectation
is that register r10 contains the last breaking event address. This
dependency is quite subtle and broke a couple of years ago without that
anybody noticed.

Fix this by getting rid of the dependency and read the last breaking event
address from lowcore.

Fixes: 56e62a737028 ("s390: convert to generic entry")
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/entry.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index a7de838f80318..669d335c87aba 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -636,7 +636,8 @@ SYM_CODE_START(stack_overflow)
 	stmg	%r0,%r7,__PT_R0(%r11)
 	stmg	%r8,%r9,__PT_PSW(%r11)
 	mvc	__PT_R8(64,%r11),0(%r14)
-	stg	%r10,__PT_ORIG_GPR2(%r11) # store last break to orig_gpr2
+	GET_LC	%r2
+	mvc	__PT_ORIG_GPR2(8,%r11),__LC_PGM_LAST_BREAK(%r2)
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	lgr	%r2,%r11		# pass pointer to pt_regs
 	jg	kernel_stack_overflow
-- 
2.39.5



