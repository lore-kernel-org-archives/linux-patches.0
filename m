Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E872222B2;
	Mon,  9 Feb 2026 14:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648156; cv=none; b=cjALro26tAzPbEtU5hf8dEwdOj7zgK/czmq0M/eLXlbhc8qkR/Opgw4tW66HuoP/oqfgw8IiiPCVWJTApoElHrvMIKcRhPivtglsyQwrvlaGn7G0kHzMK73gKOfcI2Zb3sMjd8D9hUobxuHLovb5I5VQmBlr3vGL0HXh9AvQAww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648156; c=relaxed/simple;
	bh=Rn221z5Qv4On0+IRUjmbUm458ER6do++s9VFihAFBj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaWYOROW02XdZqO/apD/ycndPaMR9J04p6P4MoAC5a5Qf6h5xEY22uGiBE9Djm+f86WkePq3E/dJKYQ1WunOnloPa6hU9dtAuvb0+osLcxSzF1vQBc0Mfl1VSKOQ6Q01/rgh138bhdC+4K4kBTCeeMOzb4WFDOJph0PfHQgDkTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B27yrz6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B27yrz6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9C0C116C6;
	Mon,  9 Feb 2026 14:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648156;
	bh=Rn221z5Qv4On0+IRUjmbUm458ER6do++s9VFihAFBj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B27yrz6LIAdnjBOHNSnib7ez2K7OyUApdqiC2t3/YeI/EUpu0iSMo5sW/9GktcdNe
	 kudscdcJdty/JKWTW+HsgAZaKy+JygYZXzqfLU9k2NP5zqFsUAyBByh7uJ+tp7VfgY
	 aOr30cKLJHCv/pj47NM2NXkdZpNK0Ln3fiTxTUa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/69] LoongArch: Set correct protection_map[] for VM_NONE/VM_SHARED
Date: Mon,  9 Feb 2026 15:23:51 +0100
Message-ID: <20260209142302.761834371@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 72685a48eaf08..09a9209f2139c 100644
--- a/arch/loongarch/mm/cache.c
+++ b/arch/loongarch/mm/cache.c
@@ -161,8 +161,8 @@ void cpu_cache_init(void)
 
 static const pgprot_t protection_map[16] = {
 	[VM_NONE]					= __pgprot(_CACHE_CC | _PAGE_USER |
-								   _PAGE_PROTNONE | _PAGE_NO_EXEC |
-								   _PAGE_NO_READ),
+								   _PAGE_NO_EXEC | _PAGE_NO_READ |
+								   (_PAGE_PROTNONE ? : _PAGE_PRESENT)),
 	[VM_READ]					= __pgprot(_CACHE_CC | _PAGE_VALID |
 								   _PAGE_USER | _PAGE_PRESENT |
 								   _PAGE_NO_EXEC),
@@ -181,8 +181,8 @@ static const pgprot_t protection_map[16] = {
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



