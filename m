Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A20F1A187A;
	Thu,  6 Jun 2024 14:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683188; cv=none; b=je6u2FpiMTlB9X5u8RMyPE3n9sUZ14nCrLNUpWM2G9IJbPcHfbBMNX3gSRkeERH9MlCCmosnn0y4A/NbKe5LJOTV1cYDUw+shuHtzu5YqX4WW7gOL4zuereq4wgTevd5786GNjfY+pdUMDO8PdDL9j9Ga2p7FOCq3A+G+PmLZL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683188; c=relaxed/simple;
	bh=BxXGsT+MbPtesKAk7HYa7KQ7KFmyVnGg4Oa0bUDSTbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R43E89kM2IhyD9NYccvy7on586KmjxR/eCrxjlzqURdMJUIRBXSmMJWm4PLCLm8bPTbS8iI/qBj6eaM1kjHRy61BLrPgORRWe2GONCG8nSCl6i55Ubae36PQ9vBuKc/i7zALZ0TTD1PfCqmmmbn0O8SPis4cXGu9k10xuKNvhjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2O3vEb89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2O3vEb89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652DAC2BD10;
	Thu,  6 Jun 2024 14:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683188;
	bh=BxXGsT+MbPtesKAk7HYa7KQ7KFmyVnGg4Oa0bUDSTbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2O3vEb89NmXHVoIw9Qe9lVMV1DHuwpR5mnsdMtV/SeMiNUjmyI1WNUNWzuBx09yEu
	 /cEXPdSXI0OEVKA6Y7hEVAO+tdgeAMFjruG1kIc6ypHgepehlJqYTroL5DMgTAAKqA
	 6MqUXMGM+IJ4p2/Q5uBLsyqzKXXpGZWYJxol9CgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixiong Wei <weiguixiong@bytedance.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/744] x86/boot: Ignore relocations in .notes sections in walk_relocs() too
Date: Thu,  6 Jun 2024 15:56:44 +0200
Message-ID: <20240606131736.659603699@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Guixiong Wei <weiguixiong@bytedance.com>

[ Upstream commit 76e9762d66373354b45c33b60e9a53ef2a3c5ff2 ]

Commit:

  aaa8736370db ("x86, relocs: Ignore relocations in .notes section")

... only started ignoring the .notes sections in print_absolute_relocs(),
but the same logic should also by applied in walk_relocs() to avoid
such relocations.

[ mingo: Fixed various typos in the changelog, removed extra curly braces from the code. ]

Fixes: aaa8736370db ("x86, relocs: Ignore relocations in .notes section")
Fixes: 5ead97c84fa7 ("xen: Core Xen implementation")
Fixes: da1a679cde9b ("Add /sys/kernel/notes")
Signed-off-by: Guixiong Wei <weiguixiong@bytedance.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20240317150547.24910-1-weiguixiong@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/tools/relocs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index e7013283640f5..a2cfd19c11eea 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -746,6 +746,15 @@ static void walk_relocs(int (*process)(struct section *sec, Elf_Rel *rel,
 		if (!(sec_applies->shdr.sh_flags & SHF_ALLOC)) {
 			continue;
 		}
+
+		/*
+		 * Do not perform relocations in .notes sections; any
+		 * values there are meant for pre-boot consumption (e.g.
+		 * startup_xen).
+		 */
+		if (sec_applies->shdr.sh_type == SHT_NOTE)
+			continue;
+
 		sh_symtab = sec_symtab->symtab;
 		sym_strtab = sec_symtab->link->strtab;
 		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf_Rel); j++) {
-- 
2.43.0



