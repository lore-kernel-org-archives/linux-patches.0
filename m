Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCEA10E5;
	Fri,  1 Dec 2023 00:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R3dvR+S3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8E7C433C9;
	Fri,  1 Dec 2023 00:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701390156;
	bh=YPAX26SibxM0r5jIa/vln0jhsLYmjgGexdEYLWlDgpI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=R3dvR+S3gROwubVWtsYVh/+xFSRXfk66OlQ7YIUOFmebT88Pg9ulSW57azAb6z9NK
	 zLZBl3ea60wZQaOy+iXYa6Y9eSO49RvQiXhdzs722mdI8PVQwSOBTmWY6Ea5bc9eAo
	 E6nZ4e4vAYDAKjC/UWdrrHBDCrPfeizkIFhcSehTnxw5d/6yhKyCWvdOWRWCu7LjdI
	 KHNOvfOjUjp1hpm28phDHeU/9ZT8Nl616J5B4/2gy6DN9dOn+kiLDesNyuwqKfZKgP
	 c7euftU+GFEh1jF5Tke4SHYz0Xy1laDzK4A/etRBwLJQo60JM1yyLbKV4lzPJGkUyl
	 9kNkDv7BsMlYA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 17:22:33 -0700
Subject: [PATCH 2/2] s390/traps: Only define is_valid_bugaddr() under
 CONFIG_GENERIC_BUG
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-s390-missing-prototypes-v1-2-799d3cf07fb7@kernel.org>
References: <20231130-s390-missing-prototypes-v1-0-799d3cf07fb7@kernel.org>
In-Reply-To: <20231130-s390-missing-prototypes-v1-0-799d3cf07fb7@kernel.org>
To: akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, 
 agordeev@linux.ibm.com
Cc: borntraeger@linux.ibm.com, svens@linux.ibm.com, 
 linux-s390@vger.kernel.org, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1168; i=nathan@kernel.org;
 h=from:subject:message-id; bh=YPAX26SibxM0r5jIa/vln0jhsLYmjgGexdEYLWlDgpI=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZ6p5m6R7xqy5skBH7vdzsUYXtlcpZTadb/qVs2vrjW
 3ZTyK6ijlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjARp2kM/+umPHsX8NyyLs3O
 f/8FX5Vn2xtdp9S2/jjBNFU+ectJg3pGhulWqZf+fIx3bIsTLZr4ckL2lIlXdwu7qhZz+TBe3Ol
 6nR0A
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with -Wmissing-prototypes without CONFIG_GENERIC_BUG,
there is a warning about a missing prototype for is_valid_bugaddr():

  arch/s390/kernel/traps.c:46:5: warning: no previous prototype for 'is_valid_bugaddr' [-Wmissing-prototypes]
     46 | int is_valid_bugaddr(unsigned long addr)
        |     ^~~~~~~~~~~~~~~~

The prototype is only declared with CONFIG_GENERIC_BUG, so only define
the function under the same condition to clear up the warning, which
matches other architectures.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/s390/kernel/traps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 1d2aa448d103..cc3e3a01dfa5 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -43,10 +43,12 @@ static inline void __user *get_trap_ip(struct pt_regs *regs)
 	return (void __user *) (address - (regs->int_code >> 16));
 }
 
+#ifdef CONFIG_GENERIC_BUG
 int is_valid_bugaddr(unsigned long addr)
 {
 	return 1;
 }
+#endif
 
 void do_report_trap(struct pt_regs *regs, int si_signo, int si_code, char *str)
 {

-- 
2.43.0

