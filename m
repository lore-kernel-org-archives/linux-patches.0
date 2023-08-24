Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65147125AE
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA57DC433C9;
	Thu, 24 Aug 2023 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889361;
	bh=ht7nOcy6xebthyJBHVD71VXwrupypo62AlIe6nctxtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qd5CSmbV43Ly+LnzL6RMzGDIANjfxsovQSN2tL6ZSHCO9+4WIkrGM2bwKWWYlHsMR
	 yePV/bKZvi8qlLUASsm93X71UyXA3+elqDAsubvz6xzJp6d4I9agx8UQ/KlY0t7PIW
	 wPu/7qIvnnquxoEYv2oju/RDU330nPd6hioyVWC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo YU <tsu.yubo@gmail.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/135] riscv: uaccess: Return the number of bytes effectively not copied
Date: Thu, 24 Aug 2023 16:50:51 +0200
Message-ID: <20230824145031.630240911@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 4b05b993900dd3eba0fc83ef5c5ddc7d65d786c6 ]

It was reported that the riscv kernel hangs while executing the test
in [1].

Indeed, the test hangs when trying to write a buffer to a file. The
problem is that the riscv implementation of raw_copy_from_user() does not
return the correct number of bytes not written when an exception happens
and is fixed up, instead it always returns the initial size to copy,
even if some bytes were actually copied.

generic_perform_write() pre-faults the user pages and bails out if nothing
can be written, otherwise it will access the userspace buffer: here the
riscv implementation keeps returning it was not able to copy any byte
though the pre-faulting indicates otherwise. So generic_perform_write()
keeps retrying to access the user memory and ends up in an infinite
loop.

Note that before the commit mentioned in [1] that introduced this
regression, it worked because generic_perform_write() would bail out if
only one byte could not be written.

So fix this by returning the number of bytes effectively not written in
__asm_copy_[to|from]_user() and __clear_user(), as it is expected.

Link: https://lore.kernel.org/linux-riscv/20230309151841.bomov6hq3ybyp42a@debian/ [1]
Fixes: ebcbd75e3962 ("riscv: Fix the bug in memory access fixup code")
Reported-by: Bo YU <tsu.yubo@gmail.com>
Closes: https://lore.kernel.org/linux-riscv/20230309151841.bomov6hq3ybyp42a@debian/#t
Reported-by: Aurelien Jarno <aurelien@aurel32.net>
Closes: https://lore.kernel.org/linux-riscv/ZNOnCakhwIeue3yr@aurel32.net/
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Tested-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Link: https://lore.kernel.org/r/20230811150604.1621784-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/lib/uaccess.S | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
index 039050172d083..80866dea07418 100644
--- a/arch/riscv/lib/uaccess.S
+++ b/arch/riscv/lib/uaccess.S
@@ -19,8 +19,11 @@ ENTRY(__asm_copy_from_user)
 	li t6, SR_SUM
 	csrs CSR_STATUS, t6
 
-	/* Save for return value */
-	mv	t5, a2
+	/*
+	 * Save the terminal address which will be used to compute the number
+	 * of bytes copied in case of a fixup exception.
+	 */
+	add	t5, a0, a2
 
 	/*
 	 * Register allocation for code below:
@@ -179,7 +182,7 @@ ENTRY(__asm_copy_from_user)
 10:
 	/* Disable access to user memory */
 	csrc CSR_STATUS, t6
-	mv a0, t5
+	sub a0, t5, a0
 	ret
 ENDPROC(__asm_copy_to_user)
 ENDPROC(__asm_copy_from_user)
@@ -231,7 +234,7 @@ ENTRY(__clear_user)
 11:
 	/* Disable access to user memory */
 	csrc CSR_STATUS, t6
-	mv a0, a1
+	sub a0, a3, a0
 	ret
 ENDPROC(__clear_user)
 EXPORT_SYMBOL(__clear_user)
-- 
2.40.1



