Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24CC224F6;
	Tue, 10 Sep 2024 09:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961964; cv=none; b=eNVhx/CNTTlxy8vm+lL0JmvAtpcABC6LoneboGg9MSg3ekB/Pxyxo1PydXVm4xrj3Qdt90Za5W39MTD0OXgWxir5bbeYks9a1dEwU2c60b/C2oLtr59eLv7tbhCvjO4AR5ZADhpbBiYU6trO9Iu+k/5FuAuAnD9UBKatFt9tizI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961964; c=relaxed/simple;
	bh=D6H3CwJgfdXlIYT8ezmUcaWQqX2tdcZ3u5ZoGdfgJjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sO7XZnsMJiwWOb5r6dF8fG/Jbc2qy3i4p2rW5W9fgVoRZoFFVRMt84m0KN0ziyaPZbDJEjkOkqRxT98IjCZc7e92EId1lBmHJ9irJWw3D9PepNe6F9wm7JK/korh0K5qDGrAA5F/H2lALdrvsUKI4D/+0sXpMshyZKAnXPZxsJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1GcTHIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1GcTHIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771B5C4CEC3;
	Tue, 10 Sep 2024 09:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961963;
	bh=D6H3CwJgfdXlIYT8ezmUcaWQqX2tdcZ3u5ZoGdfgJjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1GcTHINsp8GYan1SXWsY+JkgGzku/Om5E37aVgr/YiF1/qcvG5SrsKTdaRoj7T+M
	 PRm7Cq42uuWIfNP5PKFGNQTTAyXhREzA46XVv9TQtWk9ErIiVshcuaMvLZJqZRjTVy
	 h8rMsyo/FCl5WHUT3xFGfTyGyyE5FNfKGFdEdkcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	"yang.zhang" <yang.zhang@hexintek.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 248/375] riscv: set trap vector earlier
Date: Tue, 10 Sep 2024 11:30:45 +0200
Message-ID: <20240910092630.880309367@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yang.zhang <yang.zhang@hexintek.com>

[ Upstream commit 6ad8735994b854b23c824dd6b1dd2126e893a3b4 ]

The exception vector of the booting hart is not set before enabling
the mmu and then still points to the value of the previous firmware,
typically _start. That makes it hard to debug setup_vm() when bad
things happen. So fix that by setting the exception vector earlier.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: yang.zhang <yang.zhang@hexintek.com>
Link: https://lore.kernel.org/r/20240508022445.6131-1-gaoshanliukou@163.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/head.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index a00f7523cb91..356d5397b2a2 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -305,6 +305,9 @@ SYM_CODE_START(_start_kernel)
 #else
 	mv a0, a1
 #endif /* CONFIG_BUILTIN_DTB */
+	/* Set trap vector to spin forever to help debug */
+	la a3, .Lsecondary_park
+	csrw CSR_TVEC, a3
 	call setup_vm
 #ifdef CONFIG_MMU
 	la a0, early_pg_dir
-- 
2.43.0



