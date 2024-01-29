Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17922157E92;
	Mon, 29 Jan 2024 17:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548090; cv=none; b=Qwei4SuO3nQ4pALkGSsl/zzVON+IvrlFLNbpt2K5JHP+PWmvbr8Qcfo6InGGUS8ErIZZzvnxVjm56XDZVe2xcuhMugjuGquBaGoR5wD4K3SHenPqG1VLt9AEPiHBv7aF2HXRezKPep+8cye29oCk1PG1B4oohBvRX6iiTM1Ta38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548090; c=relaxed/simple;
	bh=RUUpKAi2oT8FJ9Y0r+OB/IKukxtp3jKAqrP+a0pA3KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/pEexO646qtOtIyM6mpnmw2NSd2P+AyTQtdMmQZo7CUdjJh0WlYkSEoFCnDpHY6ZdeI2FOICZ3fmuLRbtfVINCfWnM8rNHb+gYbPqim3JOXE5rAMdEwd3k9Z2HuOhgUOYDY764r1NuBaSXLRz3j38C3bMrLUwHagMjWfcrqKj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNcRxRFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNcRxRFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA96C433C7;
	Mon, 29 Jan 2024 17:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548089;
	bh=RUUpKAi2oT8FJ9Y0r+OB/IKukxtp3jKAqrP+a0pA3KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNcRxRFtK0Pm3GKKbPxseBBSu3fKLIDba8X0yPN8yDLQw+9kDEHhDjPfrOZ7M9a8Q
	 mE9nAUGXnxkNWTHZHrL8i1tfwGQDa9JHb+/24PgJZ0siEjtGscOz4Mo0zupQGqdimR
	 tGKsDg77LESIkReJ6EYFDzCkiDmIuGbpL4dVnRiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.7 104/346] RISC-V: selftests: cbo: Ensure asm operands match constraints
Date: Mon, 29 Jan 2024 09:02:15 -0800
Message-ID: <20240129170019.463345676@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <ajones@ventanamicro.com>

commit 0de65288d75ff96c30e216557d979fb9342c4323 upstream.

The 'i' constraint expects a constant operand, which fn and its
constant derivative MK_CBO(fn) are, but passing fn through a function
as a parameter and using a local variable for MK_CBO(fn) allow the
compiler to lose sight of that when no optimization is done. Use
a macro instead of a function and skip the local variable to ensure
the compiler uses constants, matching the asm constraints.

Reported-by: Yunhui Cui <cuiyunhui@bytedance.com>
Closes: https://lore.kernel.org/all/20240117082514.42967-1-cuiyunhui@bytedance.com
Fixes: a29e2a48afe3 ("RISC-V: selftests: Add CBO tests")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20240117130933.57514-2-ajones@ventanamicro.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/riscv/hwprobe/cbo.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/riscv/hwprobe/cbo.c
+++ b/tools/testing/selftests/riscv/hwprobe/cbo.c
@@ -36,16 +36,14 @@ static void sigill_handler(int sig, sigi
 	regs[0] += 4;
 }
 
-static void cbo_insn(char *base, int fn)
-{
-	uint32_t insn = MK_CBO(fn);
-
-	asm volatile(
-	"mv	a0, %0\n"
-	"li	a1, %1\n"
-	".4byte	%2\n"
-	: : "r" (base), "i" (fn), "i" (insn) : "a0", "a1", "memory");
-}
+#define cbo_insn(base, fn)							\
+({										\
+	asm volatile(								\
+	"mv	a0, %0\n"							\
+	"li	a1, %1\n"							\
+	".4byte	%2\n"								\
+	: : "r" (base), "i" (fn), "i" (MK_CBO(fn)) : "a0", "a1", "memory");	\
+})
 
 static void cbo_inval(char *base) { cbo_insn(base, 0); }
 static void cbo_clean(char *base) { cbo_insn(base, 1); }


