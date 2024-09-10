Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A475C191F72;
	Tue, 10 Sep 2024 10:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964402; cv=none; b=gidCIs0HLvAOUj004d4bFfHqH5j6rH5eGeDggZHunnKaPpcdiWfLIvFeJpKKdlbp/og6GxNEzjq3cgZ3ISSX+Dl0KXzwS8a04d17fxaJ6bPpVeo+05u4HvL7OTCbd3f+4FIAeWFV446MJwfBG4rUbsqPtyjiKVpD43HZCOhoqi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964402; c=relaxed/simple;
	bh=J63HzORD2Oitaod1+50o1qMw6QTi5ol+Lp3V/Lkr6WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbEd1VkgozHhj5DvcqFv2MRkUatXaWnere7C+D4eslSSVvKgQSRr6svIfpYLF5NrYXfLafYQW+tJ5yxWjN/ysx+696Eorea8fy1sEdSwZtuxZHqMbeLBQpfn7mNPDA4qes6S0fm0umVEKtXplf+8OrINy5U4r7CENa/XbXkrLJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHzYyGCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHzYyGCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFE3C4CEC6;
	Tue, 10 Sep 2024 10:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964402;
	bh=J63HzORD2Oitaod1+50o1qMw6QTi5ol+Lp3V/Lkr6WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHzYyGCGEFSQgxdFmTgPl2Hc77MUCdCPEHmzdfHGBBKydk6x3o+RTNLRZgL/HriYV
	 ZeWWVcvsoyM78Qg7wbTGsjaEvBSdkhu82MRUKH2tYOG8i9pB6+etGRZ2DiMEC6/tmX
	 NzQGDf0+KJ6EN42nrxUqyMqJmIgbyF+B7MPtHECA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	"yang.zhang" <yang.zhang@hexintek.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/269] riscv: set trap vector earlier
Date: Tue, 10 Sep 2024 11:32:37 +0200
Message-ID: <20240910092614.213640041@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0097c145385f..9691fa8f2faa 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -305,6 +305,9 @@ clear_bss_done:
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



