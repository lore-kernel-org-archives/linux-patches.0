Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2745E126BFF;
	Thu,  3 Jul 2025 14:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554491; cv=none; b=nfXi0XE/rpfaIXYjJExBXFfa2/gaNhutXxE6FjoikqOHTJeg/MWiSjJ59/lNQqdSNVDojePfP0hD41YegoOf7aJcLqqzZzSbrWZaYHZpFh7rzRBL9WzcpJiPLJ7qvwZ1gFrFaPhtnroJRI+aEXFj0rHZPyddUVkRzYhuXAeCKPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554491; c=relaxed/simple;
	bh=ZpMLf2c3EED1Kf8ZwmYk7cv0sH7nYKyG1Tz9r2pJKwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmF09mD2idTY3o2xh7438OzNtUvp4GiI4DKZGFmb9mGNdAUM1qjGI7GHA8A4rf29hLYQxhAIvfRVhtbkIt7K2qO7RNMZdcVpKbZVrbHxVyG4DTK63H9PI5F6DG3AaETLhaoZi88TLk54Zkh5Imle0lekUKtO73FHaHeDtjx4psU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/DgW6m8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/DgW6m8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05CDC4CEE3;
	Thu,  3 Jul 2025 14:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554491;
	bh=ZpMLf2c3EED1Kf8ZwmYk7cv0sH7nYKyG1Tz9r2pJKwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/DgW6m8xkjwrwiJ5LY75Ib3vFyE+WeWr7bF0sHdZCe7SZlfsDTx3XczACS4//3fC
	 mZpQYbDONWMfmw06lDKvWA5u8fQnlNorD/R1R/fZb4v0addlOZUwiU3z0TiQCk/wFY
	 GE8G6faEY66hZabihmPykyGuIds9Ny8tlJDjiwgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@suse.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/218] riscv/atomic: Do proper sign extension also for unsigned in arch_cmpxchg
Date: Thu,  3 Jul 2025 16:42:33 +0200
Message-ID: <20250703144004.418576365@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 1898300abf3508bca152e65b36cce5bf93d7e63e ]

Sign extend also an unsigned compare value to match what lr.w is doing.
Otherwise try_cmpxchg may spuriously return true when used on a u32 value
that has the sign bit set, as it happens often in inode_set_ctime_current.

Do this in three conversion steps.  The first conversion to long is needed
to avoid a -Wpointer-to-int-cast warning when arch_cmpxchg is used with a
pointer type.  Then convert to int and back to long to always sign extend
the 32-bit value to 64-bit.

Fixes: 6c58f25e6938 ("riscv/atomic: Fix sign extension for RV64I")
Signed-off-by: Andreas Schwab <schwab@suse.de>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Tested-by: Xi Ruoyao <xry111@xry111.site>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/mvmed0k4prh.fsf@suse.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/cmpxchg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/cmpxchg.h b/arch/riscv/include/asm/cmpxchg.h
index ebbce134917cc..6efa95ad033ab 100644
--- a/arch/riscv/include/asm/cmpxchg.h
+++ b/arch/riscv/include/asm/cmpxchg.h
@@ -169,7 +169,7 @@
 		break;							\
 	case 4:								\
 		__arch_cmpxchg(".w", ".w" sc_sfx, prepend, append,	\
-				__ret, __ptr, (long), __old, __new);	\
+				__ret, __ptr, (long)(int)(long), __old, __new);	\
 		break;							\
 	case 8:								\
 		__arch_cmpxchg(".d", ".d" sc_sfx, prepend, append,	\
-- 
2.39.5



