Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBF5191F89;
	Tue, 10 Sep 2024 10:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963726; cv=none; b=aIp/TG6qiisiikTWTpMSfr2bZau9IUGWigFVHQQ9Jeic7nAwT/L3NoMNufNmapgg/r5xD+CCjJqogCe6OON408g7/T/Rgmke3v9VlSwz2sIRky7UYNaB7iQNQUtVNNwt63vRCtSK/ZP4F+0sjrFaNRaZ5aBuudThEkSlq1UyBL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963726; c=relaxed/simple;
	bh=UJvC1N5rWgJzlm9X/FisgdyKB6kd0dM9OdLeB0uHCJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nINBstsKL7Wyo6OgWALlScstYFWDodkvcmkGzKvQHdbTGt7r2bwkvA9MHarxztyfsKTfW14tsu6+lbG5bwMfTI1wH1+1ms2vK/rbBsQwQslCXdytWfrP55HwF17QTFfwZfWXe6OVyzbGR0HDN58QreET4zEC7+q/54WZyv2PtsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFAUYRPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFAUYRPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EAFC4CEC6;
	Tue, 10 Sep 2024 10:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963726;
	bh=UJvC1N5rWgJzlm9X/FisgdyKB6kd0dM9OdLeB0uHCJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFAUYRPkeT+9FvbtBcuckSQBdU1MW3CIzDf/8si79XexkSla8cKZgc4cdAhAYD2+F
	 Ic/2yqgIlBWpIOLrNrPNLJ6aGg8SagKvir11AJvE+8PfTS7olsb4iodY+TRlyT7h9Y
	 QEffUDLsq3IXq+vmYtj4QyYOm7Kknk2TFltEGXj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	"yang.zhang" <yang.zhang@hexintek.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/214] riscv: set trap vector earlier
Date: Tue, 10 Sep 2024 11:32:58 +0200
Message-ID: <20240910092605.107281306@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4c3c7592b6fc..a89c59fb08ba 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -309,6 +309,9 @@ clear_bss_done:
 #else
 	mv a0, s1
 #endif /* CONFIG_BUILTIN_DTB */
+	/* Set trap vector to spin forever to help debug */
+	la a3, .Lsecondary_park
+	csrw CSR_TVEC, a3
 	call setup_vm
 #ifdef CONFIG_MMU
 	la a0, early_pg_dir
-- 
2.43.0



