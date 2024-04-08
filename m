Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8BA6F53D;
	Mon,  8 Apr 2024 13:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582243; cv=none; b=BwpZW8iCyinHk3d3BYFZtP836zLaJS0hemORzt7uRh6kbhf4gzSqa3iivzyZI8g+fkqQ4xQa3Xm3Z5ssNOMuZtV/Vwjn+w5dah3aQk5QA/vpM2apeyijymS1e8b5o6M30zDNo4e07bB88QqSkG1H6mRbP9gZ/RWwK84CpQYYm5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582243; c=relaxed/simple;
	bh=G+Z3o+K20x1szapsqAgYdxv1J1lgGiYdcl+wWxgJBbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGzbcJB6hEZ3A2F1d9VwQaqc0rKKqFHdNghb2iCyn514Akdx5hCCMWlHSW9EacZlkArt8b0Ce3VIOA7uFO+iFf+vhGb6w7ttt5cVJHDvuVxgYobT/5W8P8HD8IEQH/ShOHn2R9gxnfhk9PnLN/YnCZ+aFRNm1w/Up+rvyFwsvQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGd4K3JW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGd4K3JW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629A2C433C7;
	Mon,  8 Apr 2024 13:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582243;
	bh=G+Z3o+K20x1szapsqAgYdxv1J1lgGiYdcl+wWxgJBbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGd4K3JW4KQLpEnn+zZtlxG+KHGLJ1HjXmbzP+E8UsXyPy4bF5uRgDBGOmblubjX7
	 7dgRnmdZoOUBKLg6HWcRIrpmoRjbUR9+2cNJ7V/Eetcsrx6/gilvzYTps6vX7gcnbU
	 nj1aTKztQeiwPcCfVBLsA2XOwEY5fhI21xOneHSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 059/273] modpost: do not make find_tosym() return NULL
Date: Mon,  8 Apr 2024 14:55:34 +0200
Message-ID: <20240408125311.132255302@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 1102f9f85bf66b1a7bd6a40afb40efbbe05dfc05 ]

As mentioned in commit 397586506c3d ("modpost: Add '.ltext' and
'.ltext.*' to TEXT_SECTIONS"), modpost can result in a segmentation
fault due to a NULL pointer dereference in default_mismatch_handler().

find_tosym() can return the original symbol pointer instead of NULL
if a better one is not found.

This fixes the reported segmentation fault.

Fixes: a23e7584ecf3 ("modpost: unify 'sym' and 'to' in default_mismatch_handler()")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 267b9a0a3abcd..6568f8177e392 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1007,6 +1007,8 @@ static Elf_Sym *find_fromsym(struct elf_info *elf, Elf_Addr addr,
 
 static Elf_Sym *find_tosym(struct elf_info *elf, Elf_Addr addr, Elf_Sym *sym)
 {
+	Elf_Sym *new_sym;
+
 	/* If the supplied symbol has a valid name, return it */
 	if (is_valid_name(elf, sym))
 		return sym;
@@ -1015,8 +1017,9 @@ static Elf_Sym *find_tosym(struct elf_info *elf, Elf_Addr addr, Elf_Sym *sym)
 	 * Strive to find a better symbol name, but the resulting name may not
 	 * match the symbol referenced in the original code.
 	 */
-	return symsearch_find_nearest(elf, addr, get_secindex(elf, sym),
-				      true, 20);
+	new_sym = symsearch_find_nearest(elf, addr, get_secindex(elf, sym),
+					 true, 20);
+	return new_sym ? new_sym : sym;
 }
 
 static bool is_executable_section(struct elf_info *elf, unsigned int secndx)
-- 
2.43.0



