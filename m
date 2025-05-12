Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D862566DD;
	Mon, 12 May 2025 17:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072306; cv=none; b=S1QNhyteXlAPg5QlJZOJZcIBdRLHLq2I1vUltV9NHIAZz3n0YoKaxxqxsJ95dfNCZP5gmhOUZ8eS9I6F6hRw1LoTJteDGDE8e2ZfvHFIkcJNYcLBxsPNAhsPSokZwmoRHF37BnI/SQWVfzEXoKU9UjKdb4iOUxFO0nXoVG+EZ6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072306; c=relaxed/simple;
	bh=1gad/r8W4FlMnQxi4IERDqhfUJ+N5N4R6PFPQjnWuSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYufqgxFGy7l5YHlk1dOiBTWUbp3+yPPn1c1ytC5X+eGNPDifNGSJmYY5I/VnWPrNNgbM47aqVby2Oooo/JsPL+BxXbERRYW4NomhqThFZLFYQPH95cFGVcnC2TGsJ9Y1mYOkWmwc+afbCx68Ny15ViqajwIIanRb6HJr4GJwG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZPHS30v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZPHS30v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAECC4CEE7;
	Mon, 12 May 2025 17:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072305;
	bh=1gad/r8W4FlMnQxi4IERDqhfUJ+N5N4R6PFPQjnWuSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZPHS30vDiY7fw4cMElX54S2NboyovMrMvCNuX6PdWo5bju36410LzH+qcS83B0Pi
	 3D3N8ExXCjM6WJXF2n++UMfOLITutFmLa0c834IQ67yf4xVnCzUR+u0VAxBzuflabk
	 bmcSwt92+su56R/6XqwJGLiPhmrG6UX5yPmyCfwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Nam Cao <namcao@linutronix.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 167/197] riscv: Disallow PR_GET_TAGGED_ADDR_CTRL without Supm
Date: Mon, 12 May 2025 19:40:17 +0200
Message-ID: <20250512172051.183705940@linuxfoundation.org>
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

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit 7f1c3de1370bc6a8ad5157336b258067dac0ae9c ]

When the prctl() interface for pointer masking was added, it did not
check that the pointer masking ISA extension was supported, only the
individual submodes. Userspace could still attempt to disable pointer
masking and query the pointer masking state. commit 81de1afb2dd1
("riscv: Fix kernel crash due to PR_SET_TAGGED_ADDR_CTRL") disallowed
the former, as the senvcfg write could crash on older systems.
PR_GET_TAGGED_ADDR_CTRL state does not crash, because it reads only
kernel-internal state and not senvcfg, but it should still be disallowed
for consistency.

Fixes: 09d6775f503b ("riscv: Add support for userspace pointer masking")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/r/20250507145230.2272871-1-samuel.holland@sifive.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/process.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 3db2c0c07acd0..15d8f75902f85 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -333,6 +333,9 @@ long get_tagged_addr_ctrl(struct task_struct *task)
 	struct thread_info *ti = task_thread_info(task);
 	long ret = 0;
 
+	if (!riscv_has_extension_unlikely(RISCV_ISA_EXT_SUPM))
+		return -EINVAL;
+
 	if (is_compat_thread(ti))
 		return -EINVAL;
 
-- 
2.39.5



