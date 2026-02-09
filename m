Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108A627CCF2;
	Mon,  9 Feb 2026 14:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647406; cv=none; b=Ztx5//hiSzGYk6J8N4OySHLnHmyPRbkC08NWiBx20IZIXDSmlQ/6mlPu3Fd8Rt+Kqnb1Ca3Tk+0Yf4On330Hdm7KC/1VmxGyWKn43xrHxZpSVjbpN9mRW6oZUQssuw2B7cP7dxXj0F3CGfrvdZpkigc/ml7nJg/baSNQZHlskUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647406; c=relaxed/simple;
	bh=Je/14fp4lNk3pniclcHEsIfzR/CUQXKFnE7yBIe+zG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DubE+aJnGem2DBzuDeXfjW0OrouegxVx5Wr+3iMXwYK08hDOZXTw8v2a/McgeNBeiVh2C2XgUCJKDDieM65flRBdXqcv7lwbObcydmjfHNJp830N2TaqwpoOUNcdxJ0zFdf4gQw5PekwppXXXK1MLt7MkNzBFAU6IlDk3AeE8bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5MTAzEN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5MTAzEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB78C116C6;
	Mon,  9 Feb 2026 14:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647405;
	bh=Je/14fp4lNk3pniclcHEsIfzR/CUQXKFnE7yBIe+zG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5MTAzENpjBwcIBN1e6aPHB+PqUpUCd4swdGCty9zuuikbFbwmIYUfGaSQ69wPiiM
	 cTt0rrKmHWzp1I2L44CPfZTJKzs0qCZY4/GFjNOcAsaQyzeKSWTIprc7VNfa2CWI2W
	 UymNngjsPSJWdkbIpfjqDbv3cN5nfV1Mk74VW6iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/175] LoongArch: Set correct protection_map[] for VM_NONE/VM_SHARED
Date: Mon,  9 Feb 2026 15:22:09 +0100
Message-ID: <20260209142322.482877980@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit d5be446948b379f1d1a8e7bc6656d13f44c5c7b1 ]

For 32BIT platform _PAGE_PROTNONE is 0, so set a VMA to be VM_NONE or
VM_SHARED will make pages non-present, then cause Oops with kernel page
fault.

Fix it by set correct protection_map[] for VM_NONE/VM_SHARED, replacing
_PAGE_PROTNONE with _PAGE_PRESENT.

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/mm/cache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/mm/cache.c b/arch/loongarch/mm/cache.c
index 6be04d36ca076..496916845ff76 100644
--- a/arch/loongarch/mm/cache.c
+++ b/arch/loongarch/mm/cache.c
@@ -160,8 +160,8 @@ void cpu_cache_init(void)
 
 static const pgprot_t protection_map[16] = {
 	[VM_NONE]					= __pgprot(_CACHE_CC | _PAGE_USER |
-								   _PAGE_PROTNONE | _PAGE_NO_EXEC |
-								   _PAGE_NO_READ),
+								   _PAGE_NO_EXEC | _PAGE_NO_READ |
+								   (_PAGE_PROTNONE ? : _PAGE_PRESENT)),
 	[VM_READ]					= __pgprot(_CACHE_CC | _PAGE_VALID |
 								   _PAGE_USER | _PAGE_PRESENT |
 								   _PAGE_NO_EXEC),
@@ -180,8 +180,8 @@ static const pgprot_t protection_map[16] = {
 	[VM_EXEC | VM_WRITE | VM_READ]			= __pgprot(_CACHE_CC | _PAGE_VALID |
 								   _PAGE_USER | _PAGE_PRESENT),
 	[VM_SHARED]					= __pgprot(_CACHE_CC | _PAGE_USER |
-								   _PAGE_PROTNONE | _PAGE_NO_EXEC |
-								   _PAGE_NO_READ),
+								   _PAGE_NO_EXEC | _PAGE_NO_READ |
+								   (_PAGE_PROTNONE ? : _PAGE_PRESENT)),
 	[VM_SHARED | VM_READ]				= __pgprot(_CACHE_CC | _PAGE_VALID |
 								   _PAGE_USER | _PAGE_PRESENT |
 								   _PAGE_NO_EXEC),
-- 
2.51.0



