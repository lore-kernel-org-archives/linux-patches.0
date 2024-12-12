Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04E9223C7A;
	Thu, 12 Dec 2024 16:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020883; cv=none; b=Z9SCHCnSGH7uiJvjO5Yh4GMGVlfwnSXhF/KGTU784FRGMi55wN1UH/+s/XttCgIgVXDsj+HJZwyAWpnHbN8MGry21iQGxBeVbKitvhibsGkzLCz8pabeENoPikVM3KKrqiadgP/tahf6i24ni4Aje5PGYc3NiaAy3IIThuRT0yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020883; c=relaxed/simple;
	bh=HphD5u/5pNAzWWqTlcfOmRLO1bealntrUiStxgsmOXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLzfGxxN50L/R2s54Ziz6hujAgY2UiAWpSemISi5gnsUmJtat6MrfUgkvOd7NPHhb0+srts95wnecBlnJW6g3OzhrOvl8yH7/FRuDajIUOlARzlFblkPUqAWM/sTmNvaRsS6doAzix5u/FUtzRtPSgvTYEUr6uKvPxdtWJdALS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zi/JEnwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zi/JEnwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40758C4CECE;
	Thu, 12 Dec 2024 16:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020882;
	bh=HphD5u/5pNAzWWqTlcfOmRLO1bealntrUiStxgsmOXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zi/JEnwj9ZyMYErnNBHcZNvDB9sNIbst/loJScNY07oiv1NzerM8NfstOe5zVTWH9
	 JbaSEQWyjskgIg4RrTHuTTPZF33dKHwxWoM5HqD9s6n8yx4I92/ixKWaiBVTY4cs8F
	 lxS9pU6F6O+Fa/pWg6ALC6Bf47XEQV3YVyti/t2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sathvika Vasireddy <sv@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 556/772] powerpc/vdso: Skip objtool from running on VDSO files
Date: Thu, 12 Dec 2024 15:58:21 +0100
Message-ID: <20241212144412.942968747@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Sathvika Vasireddy <sv@linux.ibm.com>

[ Upstream commit d0160bd5d389da247fb5affb6a35ea393d22fedb ]

Do not run objtool on VDSO files, by using OBJECT_FILES_NON_STANDARD.

Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sathvika Vasireddy <sv@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221114175754.1131267-8-sv@linux.ibm.com
Stable-dep-of: d677ce521334 ("powerpc/vdso: Drop -mstack-protector-guard flags in 32-bit files with clang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vdso/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
index a2e7b0ce5b191..6a977b0d8ffc3 100644
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -102,3 +102,5 @@ quiet_cmd_vdso64ld_and_check = VDSO64L $@
       cmd_vdso64ld_and_check = $(VDSOCC) $(c_flags) $(CC64FLAGS) -o $@ -Wl,-T$(filter %.lds,$^) $(filter %.o,$^) -z noexecstack ; $(cmd_vdso_check)
 quiet_cmd_vdso64as = VDSO64A $@
       cmd_vdso64as = $(VDSOCC) $(a_flags) $(CC64FLAGS) $(AS64FLAGS) -c -o $@ $<
+
+OBJECT_FILES_NON_STANDARD := y
-- 
2.43.0



