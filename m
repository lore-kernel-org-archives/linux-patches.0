Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C82296D3B;
	Mon, 12 May 2025 17:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071760; cv=none; b=pnAtfL9kj5iJeEVylDkpTVdb3Jy2Pbpl6yOffoU8erAt0xxK8EKG4SSw1+YmW5Lhj1Qt1Q7Aj/UhHgJGgxpCz5aFmle4bh/BAQwUIbdPlf2/YLQ61t6GO+rcEOKJgX4or9ZXPpOstE0bp7ST0LsZcZy3y5wZj7R3T/3iRxeCfHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071760; c=relaxed/simple;
	bh=q3+1b0txd7fgsciqy95BM4Aj9+U7gfp+Hpbb4xJkdKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWRLIEU4DTj09FoLjwmU7qflGn3yH9qLVe5QJalAZbElniUR7xy7O6IQ6T0A8NRGNsImbyPevgFvywWzowN4c/EOLVnM3UycjYEZUVj+hD+7Uc/osdmmxS3T9H1Al0YIago/1ZCWukuaJBQChPk4yW/WPlhQsnUSW15zkCxW3Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoWwOpru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoWwOpru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C90C4CEE7;
	Mon, 12 May 2025 17:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071760;
	bh=q3+1b0txd7fgsciqy95BM4Aj9+U7gfp+Hpbb4xJkdKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoWwOpruY9rJ4mT4yy+3z8Jeg0aI7pG140afMIyYiq6k32eJQ8mGAelSiQUPiW+nV
	 8C2Kv+EwR6ON6YffexjrgmEMiMAmk1uk5WsQlQiADhn6tXcqG1oFEehhbmSyQsnKG4
	 oqVnukm07ENwk8CMaqR6XAwfFvkCiBI3iVJ5xuq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 018/197] s390/entry: Fix last breaking event handling in case of stack corruption
Date: Mon, 12 May 2025 19:37:48 +0200
Message-ID: <20250512172045.087050721@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 88e09a650d2df..ce8bac77cbc1b 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -601,7 +601,8 @@ SYM_CODE_START(stack_overflow)
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



