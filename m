Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E08E256C61;
	Wed,  5 Mar 2025 18:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198775; cv=none; b=LrZGYERmwFtXHYkbVKovivEvKrnL16CDT9BVY3R7G+BHrzAuqWQFh6TKQ8aNfl+WTaaKR37LDqjU/L+l16xq0NzFDao4ImAHcRKUBc+7weNVFUbfExVhjFIFukBqfyE0hkIgjPbDqY6hA015a0uVE4kazJst+NXjrgM9HBwzCdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198775; c=relaxed/simple;
	bh=nYX7qF9oRSHpEOiWTqz7LggQw5qbHMuwScvTMe6LzH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qga87yzrUxX5aIb7St1sToJydz8LALU6XWdlJzsYp5+ZXLe2L5tuezOK/pRKdioy0Ab77MEvMCY2xqOctzv+t73QG6NjIZlpZ/KvuccRsYwl8mJoB8C+VzWp+nx4ZPVOftjwGitZIibINKX3FYLonzL36oqrgA0Mcm5x/LHd6nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiVnj7WM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiVnj7WM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0E4C4CED1;
	Wed,  5 Mar 2025 18:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198774;
	bh=nYX7qF9oRSHpEOiWTqz7LggQw5qbHMuwScvTMe6LzH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiVnj7WMOMtbNathq120UP+xjKQQiM1eNz2Rws3A3fZ1RBuUbC/lBO98LcJqufK70
	 Ct/EVB/okNAq+xqswYk6iABSnEPtG1Bs5LEkAOvwCY+pUydeH41b/gsuuNE+qq9SwB
	 /1yhm8oPba+qcTKIR4+uFc9MzCJslecUR87elp9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@suse.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.13 143/157] riscv/atomic: Do proper sign extension also for unsigned in arch_cmpxchg
Date: Wed,  5 Mar 2025 18:49:39 +0100
Message-ID: <20250305174511.048747949@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@suse.de>

commit 1898300abf3508bca152e65b36cce5bf93d7e63e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/cmpxchg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/cmpxchg.h
+++ b/arch/riscv/include/asm/cmpxchg.h
@@ -231,7 +231,7 @@
 		__arch_cmpxchg(".w", ".w" sc_sfx, ".w" cas_sfx,		\
 			       sc_prepend, sc_append,			\
 			       cas_prepend, cas_append,			\
-			       __ret, __ptr, (long), __old, __new);	\
+			       __ret, __ptr, (long)(int)(long), __old, __new);	\
 		break;							\
 	case 8:								\
 		__arch_cmpxchg(".d", ".d" sc_sfx, ".d" cas_sfx,		\


