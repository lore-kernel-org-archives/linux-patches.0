Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3B9142E99;
	Thu, 13 Jun 2024 11:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278669; cv=none; b=Z3bGRX29mNsS4AqA2cLTSiav5BVG5XufWTCkum9PNJhVrXOxd16i6b+kXqXWDL1jZCHL0enYTL1CIJunM0CYI2AhhxOaTLc9guI2FPnE3dvjcvub4Y3DCliMBM+MC0QM6LCAlHbJ3QWZ52F2PSUSoqpLnmsPUfmMKUp2cyaQgRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278669; c=relaxed/simple;
	bh=fiMsHTu0UlzqMpNRjCu9bWHpb3l2arsbnIlBKi0Hguc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8bJRpxx9AXy4xk/5LoYus7rLi/75QpEFTqDdnbrsGLsfpV1BRMtsw0QU+0gYp7LXTQBYr7kBg/Io8GIQoCEuql1N2fSVR2yrTQUeOmFheVEQDEJZWv6+CFAmO06e/b8RqWuw8YxMgC2arcCAIwGRLoSE09WxQG/ea1ZJMBZK5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5Rp9VAb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5Rp9VAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4E1C4AF4D;
	Thu, 13 Jun 2024 11:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278669;
	bh=fiMsHTu0UlzqMpNRjCu9bWHpb3l2arsbnIlBKi0Hguc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5Rp9VAbC2KIfJ7DeYV8IdQeIxnUMw07GAG3D/3RJEP2MOli6Wwa3OBI/C+G0/FHe
	 bf2v1mR3JP8LdWOkY+Z++9q7ALsORX82K9ywN6J6bLk5xArmlfr/oSf/g6wv+eRGPO
	 REkrXoYClkCR3zI/6RnufsLvFpVcPerxZrcrI0pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixiong Wei <weiguixiong@bytedance.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/213] x86/boot: Ignore relocations in .notes sections in walk_relocs() too
Date: Thu, 13 Jun 2024 13:31:18 +0200
Message-ID: <20240613113229.161833451@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index c7f1d1759c855..7470d88ae6311 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -672,6 +672,15 @@ static void walk_relocs(int (*process)(struct section *sec, Elf_Rel *rel,
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



