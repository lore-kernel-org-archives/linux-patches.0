Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432B123AB86;
	Thu,  3 Jul 2025 14:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554125; cv=none; b=bXXcd6pi0srra768flrTkaXT8oNhMWtEyK3JszqlSSzRErnrGIOVWle1NOHyqgM0d093APfcQt2Fq4MQgc3ksvhirOiOkQKtws8T3w8HxL7nt/KxJTMknS/gcNCBZj8qXRU0xoYnZJJLkP3gTGVblbZU/C7MmPieCzV448wQY2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554125; c=relaxed/simple;
	bh=T/jUc8ugZxQVd63Ek6YpknsXMWvbybaInTh6spL9AgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k5FLPHguc2EE9Nbt6TNrzSfzwXlj9RgABU+UzFn/ZhomXxs3ZjZQmJlWWmrJoY1nX44hnAqfwLQZ5PkRFl+RAMfON1upqCLoPNf1m8QD7EpPg90sdaZzs8/D8nPfikHyG2ofwB7T3f9z8oKktCQXoti64cy6tSrX+kZgtwGgyyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVCvwpBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVCvwpBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A0BC4CEE3;
	Thu,  3 Jul 2025 14:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554125;
	bh=T/jUc8ugZxQVd63Ek6YpknsXMWvbybaInTh6spL9AgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVCvwpBOpSe+S41c/sjomDkxOleQA9VD0sxGA9rKh8wE0eL70Y/bBpGYU+kkzUgvh
	 ztYK3fer0WN6bLEc01DCACA3ATkx3jcF1KkdBk1QnbvZ1LfMUWKSFdy6HLfw+vxAHO
	 m2b8bQ22j2fBLs8x7WjEqelEAW0Y8/BtBuIwq6/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 6.12 087/218] Revert "riscv: misaligned: fix sleeping function called during misaligned access handling"
Date: Thu,  3 Jul 2025 16:40:35 +0200
Message-ID: <20250703143959.419550251@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -429,7 +429,7 @@ int handle_misaligned_load(struct pt_reg
 
 	val.data_u64 = 0;
 	if (user_mode(regs)) {
-		if (copy_from_user_nofault(&val, (u8 __user *)addr, len))
+		if (copy_from_user(&val, (u8 __user *)addr, len))
 			return -1;
 	} else {
 		memcpy(&val, (u8 *)addr, len);
@@ -530,7 +530,7 @@ int handle_misaligned_store(struct pt_re
 		return -EOPNOTSUPP;
 
 	if (user_mode(regs)) {
-		if (copy_to_user_nofault((u8 __user *)addr, &val, len))
+		if (copy_to_user((u8 __user *)addr, &val, len))
 			return -1;
 	} else {
 		memcpy((u8 *)addr, &val, len);


