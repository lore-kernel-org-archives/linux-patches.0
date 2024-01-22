Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E9F76908;
	Tue, 23 Jan 2024 02:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975497; cv=none; b=ezq3CpI4b0m4apIUmthp80mexpA9+p8dyU0ri+kaYO7/pSO91sR2vGaSIxN57t4ZUPa0Je0Z/veDmbD0Zr8XnqagJs5pn9gS5SYgI31YGryandElLnMjMZB5cf1hB9g3DJkXfRgHeSplb8DMVzCScAVfwsM1f2f5fKLzo9c6n4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975497; c=relaxed/simple;
	bh=ggJ5nGFoUqqxI1vhcYh4ZI9rT90RKij07svmrGVtH3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHKlUq40/8IDqPhSlXuqcJvPLH1Wy0xW92hDOD+OmouhacLPvBfMdS7BiWnr/HKMrT+vIiD5LEjViJ48nrsrABG1wcdEDiTsUzuB9IWv5877yJ4hRvPN8VfaF8rF/J4oj/KekOc6cvHzr0+STCYlv3TuX9pAXUuyjHuNuQsCLB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYmIdJ/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYmIdJ/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFBEC433F1;
	Tue, 23 Jan 2024 02:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975497;
	bh=ggJ5nGFoUqqxI1vhcYh4ZI9rT90RKij07svmrGVtH3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYmIdJ/1GXqR3CRrSdyX+K5n/unNr4AI07GyOGf2qX3Aas1uAXRW70v0b9dq0xXSq
	 Z/6hS2f10T6Yg4ihHCyFwp5xUENdXWSoOqU7U0pDetPhW4Ezj2WA6et4I0KK3jG35b
	 vDIivKK9F2o9LcQc2YeMXhS2MiDwPxkJIbDHhDWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 452/583] riscv: Fix set_direct_map_default_noflush() to reset _PAGE_EXEC
Date: Mon, 22 Jan 2024 15:58:23 -0800
Message-ID: <20240122235825.801065882@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit b8b2711336f03ece539de61479d6ffc44fb603d3 ]

When resetting the linear mapping permissions, we must make sure that we
clear the X bit so that do not end up with WX mappings (since we set
PAGE_KERNEL).

Fixes: 395a21ff859c ("riscv: add ARCH_HAS_SET_DIRECT_MAP support")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20231213134027.155327-3-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/pageattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index fc5fc4f785c4..e703a9b59fc3 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -378,7 +378,7 @@ int set_direct_map_invalid_noflush(struct page *page)
 int set_direct_map_default_noflush(struct page *page)
 {
 	return __set_memory((unsigned long)page_address(page), 1,
-			    PAGE_KERNEL, __pgprot(0));
+			    PAGE_KERNEL, __pgprot(_PAGE_EXEC));
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-- 
2.43.0



