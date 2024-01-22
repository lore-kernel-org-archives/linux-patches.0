Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8672133416;
	Tue, 23 Jan 2024 01:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971844; cv=none; b=dfQZNU43ljP4z1BgRrII0jT2+o4vjELfh1EMp3db3r7Ua7F4TLMK0o9l844Y1EAYeFYk+Puiz4JxayMwrd0mOc2+0XKngKF2z9IrHSyUCFpZD5Vk33CsVrvNlEXoKs6fsk9pxv9t3Rjh4r5U3E2L9CoFnUrXKc7sxklMEgcJHS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971844; c=relaxed/simple;
	bh=2ShETt64QWZVqMPpdXZLvwMzFKcAcGgeDWueEUJmH7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jocAPnWrVCzbGVp+pNiEYtTYctPW4Gw/lxS0u8Y28kLcTTN9lwk1srHjElk+qyYHRI3jL0ZwhQfFGW/k+Vb4st3Vwtqmg8EO7oLPHnriespBHb7vCVHiPUIyU4K/KzNYuQPUgTc2ZI5tX+9N6fhnWYoYvkK6QJyV02zhZNs0/Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KaaAL9YE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaaAL9YE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0734C433C7;
	Tue, 23 Jan 2024 01:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971843;
	bh=2ShETt64QWZVqMPpdXZLvwMzFKcAcGgeDWueEUJmH7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaaAL9YEEvjwri+d14GlhSlnMaVKZkg69/OiQ8cV3XxXU0sMH8jSvPbki4Oc10UAH
	 XxlwL9FOwjeGGSjYi7OyvSzlOnyEFsc8eqquAfxSJRcxWOEnspUpczDbjNzMyygOua
	 29yQmLSAF2Q0gGX0491WNP5oYdu+NKJ6sfqmggUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 332/417] riscv: Fix set_direct_map_default_noflush() to reset _PAGE_EXEC
Date: Mon, 22 Jan 2024 15:58:20 -0800
Message-ID: <20240122235803.290995480@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 62a9219686cd..43a0b6b69579 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -377,7 +377,7 @@ int set_direct_map_invalid_noflush(struct page *page)
 int set_direct_map_default_noflush(struct page *page)
 {
 	return __set_memory((unsigned long)page_address(page), 1,
-			    PAGE_KERNEL, __pgprot(0));
+			    PAGE_KERNEL, __pgprot(_PAGE_EXEC));
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-- 
2.43.0



