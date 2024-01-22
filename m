Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DFD3A8F4;
	Tue, 23 Jan 2024 00:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969870; cv=none; b=Xkzt6ndpoWkWSx4gS6zQ5TGZrx7c0EQXw55vcn5tGOacWmE3cOrcIEJAZdUCkyYQpMLpmobBcrqTej9mtqDnEBAUEOzNcMWFlP5as/X1eelv/g83p3CFHvsN6d5OPt2JztPjk4VKT7C6uLB4Tq/OhN2wL1f+v0po+50uQzukzXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969870; c=relaxed/simple;
	bh=21tyZEPijBbq5A9B6w06fnm6aDPrF+SEVsfzMx+MdRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvB25ykeeNTk1rAE+lATGBcYRnowAZ1F8LE3eBn11fHsN8vGAoJUH5EDtNDOrht3LNOSzyVwdM6IMr4mLNkOmS3k7jdGP2RHIapmno02scGJ36nXGB8u0CsYnJFKC77ePQI0NV+3cCPRmDzJI0TFc36Ltk6LfOG0j0heu7XianM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fs6yt8gR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fs6yt8gR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB59C433F1;
	Tue, 23 Jan 2024 00:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969870;
	bh=21tyZEPijBbq5A9B6w06fnm6aDPrF+SEVsfzMx+MdRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fs6yt8gRbp5M1Ed672h/fZfb8H3BcAMyTHHDBushdAuoAS/m/N1RX5DISS1fI7qRw
	 Lmh7U0/XPjMS1+/q7k29yNOfJClpeop34/u43nNXu0J6Ll2/+VSO68Jp79QQTVB21n
	 38pE2ihi34Uq4D+VJCK1mV/HUca+AI215toIeSjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 497/641] riscv: Fix set_direct_map_default_noflush() to reset _PAGE_EXEC
Date: Mon, 22 Jan 2024 15:56:41 -0800
Message-ID: <20240122235833.615885340@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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
index 96cbda683936..01398fee5cf8 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -383,7 +383,7 @@ int set_direct_map_invalid_noflush(struct page *page)
 int set_direct_map_default_noflush(struct page *page)
 {
 	return __set_memory((unsigned long)page_address(page), 1,
-			    PAGE_KERNEL, __pgprot(0));
+			    PAGE_KERNEL, __pgprot(_PAGE_EXEC));
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-- 
2.43.0



