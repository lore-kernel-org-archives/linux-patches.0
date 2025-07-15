Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D57A2E11D3;
	Tue, 15 Jul 2025 13:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585772; cv=none; b=JX3u0clhwjR4aDgwjyfb+88N5m0TTrrVs/3kmcT1Qx1rjpUrqwpL2Y4TccVNpiHMHuQneEkY3hgzrFMHLRS9L05QjGX3m4shK17znZSHT/QPvVOdZXC19YlbR7f/V4kjXSkbHLVyyIwa0iN1uVwpKj2ggZLG9ko0tuZ6y+MnUj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585772; c=relaxed/simple;
	bh=0PVpjAh6clYMjCrGvbY3cQdPhkwtVsdykG05PRNOZes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7o1smQl85Yhwx82k70wEQj+CS4o0evmXhlB7mTAaE4ZWzMXkrXNgVHXJnzZcCTPJpVuFlg5mkwca4dt/IOb19IfmwtFM3dlkLgaIVC6RlarUL4balPBriWaae38t3BeXyfQrmIQxmxh+XA49uQOiaUFhcW2u0q1uTOA30mG2N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pM89mwT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pM89mwT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734CFC4CEE3;
	Tue, 15 Jul 2025 13:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585771;
	bh=0PVpjAh6clYMjCrGvbY3cQdPhkwtVsdykG05PRNOZes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pM89mwT6HCwAbzXJbQI4SyXj74oqQzU5D1/LzGrxrOEaXdSyuE8GQltGloOOSVQOO
	 PscA3WcQXpTYKo7ygMmacbzjFdCVlN39mT6s/qsEvDNF5lXEkQ+xRxhaOIJA5aT4bj
	 q3HOmbfMgQ7sBqXcMvyDNK7cbkzUT9ZyC+CwQmXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Fangrui Song <i@maskray.me>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/163] riscv: vdso: Exclude .rodata from the PT_DYNAMIC segment
Date: Tue, 15 Jul 2025 15:13:42 +0200
Message-ID: <20250715130815.018083740@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

From: Fangrui Song <i@maskray.me>

[ Upstream commit e0eb1b6b0cd29ca7793c501d5960fd36ba11f110 ]

.rodata is implicitly included in the PT_DYNAMIC segment due to
inheriting the segment of the preceding .dynamic section (in both GNU ld
and LLD).  When the .rodata section's size is not a multiple of 16
bytes on riscv64, llvm-readelf will report a "PT_DYNAMIC dynamic table
is invalid" warning.  Note: in the presence of the .dynamic section, GNU
readelf and llvm-readelf's -d option decodes the dynamic section using
the section.

This issue arose after commit 8f8c1ff879fab60f80f3a7aec3000f47e5b03ba9
("riscv: vdso.lds.S: remove hardcoded 0x800 .text start addr"), which
placed .rodata directly after .dynamic by removing .eh_frame.

This patch resolves the implicit inclusion into PT_DYNAMIC by explicitly
specifying the :text output section phdr.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2093
Signed-off-by: Fangrui Song <i@maskray.me>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20250602-riscv-vdso-v1-1-0620cf63cff0@maskray.me
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vdso/vdso.lds.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/vdso.lds.S
index cbe2a179331d2..99e51f7755393 100644
--- a/arch/riscv/kernel/vdso/vdso.lds.S
+++ b/arch/riscv/kernel/vdso/vdso.lds.S
@@ -31,7 +31,7 @@ SECTIONS
 		*(.data .data.* .gnu.linkonce.d.*)
 		*(.dynbss)
 		*(.bss .bss.* .gnu.linkonce.b.*)
-	}
+	}						:text
 
 	.note		: { *(.note.*) }		:text	:note
 
-- 
2.39.5



