Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402D02ED86E;
	Thu,  3 Jul 2025 15:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555058; cv=none; b=BnJxOL0PYrLXT4RN3TQgn3mpRgYR5Zzd7wZcYY4YKl48+2vIs4MhyDwbzdoy7t2XEOCaTTjXp4VnTowT9w8x/6FGbaKiVObdTamyd4syqNhxVMcqsSujwwU9Yl7urBIIZx9ILyf/p1cQPs6RZXPzH03fuIYiJiGA2+6hUazV41U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555058; c=relaxed/simple;
	bh=uxmUyzRpzWFBJKwOhIoqx1az4Yf/2Q2Fem8rdAH+9qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SS+C9lZRGGAJllXSEeJ/r+LUxnK1N4p8HVVlE6vDE3ytypNA8g8TEUHSemahLkBwiGiUKUOMumYrXm2ixozkSn01WbhDEeQlXzDR+sL2+49o56i6NaJJE7V7syO4lSSi/Pt4qvowPDcEFkro+0EAB4rI/4BUAGTYkimwzuoGTWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZM/4dg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZM/4dg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C313BC4CEE3;
	Thu,  3 Jul 2025 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555058;
	bh=uxmUyzRpzWFBJKwOhIoqx1az4Yf/2Q2Fem8rdAH+9qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZM/4dg2BlrTOcpkSmkFAPMc8XxqW6oIrp3eSf8Favj5+X2hxDMubJLShwFmMcOp7
	 ZNsgQnC/A0bAcadXYdb+hhcdKl5XuRdlvjxXvfatN1DGyZqt+LCj0klWG5me9TUXzV
	 pDMtG0fycjOkwaOO3J5UthVc+l+LUCVcnKhY6BEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 6.15 123/263] Revert "riscv: misaligned: fix sleeping function called during misaligned access handling"
Date: Thu,  3 Jul 2025 16:40:43 +0200
Message-ID: <20250703144009.288564225@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 2f73c62d4e13df67380ff6faca39eec2bf08dd93 upstream.

This reverts commit 61a74ad25462 ("riscv: misaligned: fix sleeping function
called during misaligned access handling"). The commit addresses a sleeping
in atomic context problem, but it is not the correct fix as explained by
Clément:

"Using nofault would lead to failure to read from user memory that is paged
out for instance. This is not really acceptable, we should handle user
misaligned access even at an address that would generate a page fault."

This bug has been properly fixed by commit 453805f0a28f ("riscv:
misaligned: enable IRQs while handling misaligned accesses").

Revert this improper fix.

Link: https://lore.kernel.org/linux-riscv/b779beed-e44e-4a5e-9551-4647682b0d21@rivosinc.com/
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Fixes: 61a74ad25462 ("riscv: misaligned: fix sleeping function called during misaligned access handling")
Link: https://lore.kernel.org/r/20250620110939.1642735-1-namcao@linutronix.de
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/traps_misaligned.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -453,7 +453,7 @@ static int handle_scalar_misaligned_load
 
 	val.data_u64 = 0;
 	if (user_mode(regs)) {
-		if (copy_from_user_nofault(&val, (u8 __user *)addr, len))
+		if (copy_from_user(&val, (u8 __user *)addr, len))
 			return -1;
 	} else {
 		memcpy(&val, (u8 *)addr, len);
@@ -554,7 +554,7 @@ static int handle_scalar_misaligned_stor
 		return -EOPNOTSUPP;
 
 	if (user_mode(regs)) {
-		if (copy_to_user_nofault((u8 __user *)addr, &val, len))
+		if (copy_to_user((u8 __user *)addr, &val, len))
 			return -1;
 	} else {
 		memcpy((u8 *)addr, &val, len);


