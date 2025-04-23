Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0451386DA;
	Wed, 23 Apr 2025 15:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420406; cv=none; b=gOO9Fv0PRteIgZwtcT3DhS9624XWEYphVAvBbUNc2BP88RImoVgXVIlync5ybUfgGSenmD/gNUal07CqRRceLJVVN8frdZEB7JTJAj7bKmyEot6P0sYr98ouEwwWG9Sssx4BxMBHEaPxHHrZVxhesypnHQmK+xCGKbGCSKTzkSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420406; c=relaxed/simple;
	bh=bl9Cagc7DJ+Bc2eib3ghvoo9gHYP+fJwMfoTif8BgCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljUC2zY8czHuW0mudSMTDtdo1GeUiFhuk89gZFtq2ZYXgjMlVG4BooG5NE88ifuazGuYFfiJ4jdrBjIRkNO5Vy+k5G4yoclHW7vaZUKa0MUnllX5mFm/4YXX9H9MEv5aoI6UmCW2pIh6BR6Xm3YUJ/uAALNpw9Y8c+mNDSB9Eoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSCQhF/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSCQhF/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B96C4CEE2;
	Wed, 23 Apr 2025 15:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420405;
	bh=bl9Cagc7DJ+Bc2eib3ghvoo9gHYP+fJwMfoTif8BgCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSCQhF/Xg6tBa0uG+lV/f67yoxZNmx3Hq/qHL3UdQW01pigJQdxxMhevkpUi0uEgs
	 0uy0No0CzW5pKErArhjZGwUvIUnVeBXwu++q7kCV0H0b8jwS/pL38lsU8l/NDe3OUa
	 p3styGPpccaA9bMx+Q5kr9XzJOeg830uFVIM+QOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Maxim Kochetkov <fido_max@inbox.ru>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 089/241] riscv: module: Fix out-of-bounds relocation access
Date: Wed, 23 Apr 2025 16:42:33 +0200
Message-ID: <20250423142624.217502840@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

[ Upstream commit 0b4cce68efb93e31a8e51795d696df6e379cb41c ]

The current code allows rel[j] to access one element past the end of the
relocation section. Simplify to num_relocations which is equivalent to
the existing size expression.

Fixes: 080c4324fa5e ("riscv: optimize ELF relocation function in riscv")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20250409171526.862481-1-samuel.holland@sifive.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 0ae34d79b87bd..7f6147c18033b 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -860,7 +860,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 				}
 
 				j++;
-				if (j > sechdrs[relsec].sh_size / sizeof(*rel))
+				if (j == num_relocations)
 					j = 0;
 
 			} while (j_idx != j);
-- 
2.39.5



