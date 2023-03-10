Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278F4848C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E9FC433D2;
	Fri, 10 Mar 2023 14:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458253;
	bh=yWm6hsqQELgHClgSBvhUJuTrumvEabHNGbSjEUAGQNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhaihD1G0Gj4lZnT4GHjCKSNCMOqj9kD/DDcO//lrzgezEEODd92XarOAEzSxPOih
	 hYr8OyLbEWJfP97SOVGveOo4JBkHTvb7xk71PlANgJJduM+7r8YgNQ2wTjVmv0ROk0
	 x92NjGLSNty00Fefz61tGw+IvxnbL9XBRJNV+Acw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 215/252] x86: um: vdso: Add %rcx and %r11 to the syscall clobber list
Date: Fri, 10 Mar 2023 14:39:45 +0100
Message-Id: <20230310133725.653184420@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

[ Upstream commit 5541992e512de8c9133110809f767bd1b54ee10d ]

The 'syscall' instruction clobbers '%rcx' and '%r11', but they are not
listed in the inline Assembly that performs the syscall instruction.

No real bug is found. It wasn't buggy by luck because '%rcx' and '%r11'
are caller-saved registers, and not used in the functions, and the
functions are never inlined.

Add them to the clobber list for code correctness.

Fixes: f1c2bb8b9964ed31de988910f8b1cfb586d30091 ("um: implement a x86_64 vDSO")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/um/vdso/um_vdso.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/um/vdso/um_vdso.c b/arch/x86/um/vdso/um_vdso.c
index 7c441b59d3752..be99ff25c5039 100644
--- a/arch/x86/um/vdso/um_vdso.c
+++ b/arch/x86/um/vdso/um_vdso.c
@@ -20,8 +20,10 @@ int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
 	long ret;
 
-	asm("syscall" : "=a" (ret) :
-		"0" (__NR_clock_gettime), "D" (clock), "S" (ts) : "memory");
+	asm("syscall"
+		: "=a" (ret)
+		: "0" (__NR_clock_gettime), "D" (clock), "S" (ts)
+		: "rcx", "r11", "memory");
 
 	return ret;
 }
@@ -32,8 +34,10 @@ int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	long ret;
 
-	asm("syscall" : "=a" (ret) :
-		"0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
+	asm("syscall"
+		: "=a" (ret)
+		: "0" (__NR_gettimeofday), "D" (tv), "S" (tz)
+		: "rcx", "r11", "memory");
 
 	return ret;
 }
-- 
2.39.2



