Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A64C46AA96;
	Tue, 21 Jul 2026 15:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648253; cv=none; b=Lv066avlSi1YjYC91RuJrb+AxIkgwJQMimjIncbvgZ/9X6a7gHVVe75MpiruHy/B4/nsm51LV/fSeZMu82OOgNLIATGZMjheowrwyCQvLeWOfBBIR26lyFuXBnUDOKt3rpTV+jxWGYLD1J3LKnwX7XqcIGjLYV5AG5Ds9OLLSuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648253; c=relaxed/simple;
	bh=RySK7ugPywYmaZ/mUPwkJK23XY/2X2c5mvP6q8v8qCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPB518/cOltnNFwTFK5CK9vCEzg2Na9tl4k7p6ygJF9FJQQmubQD97lNQsdfoMkB76fjUaGdNylvgu7vEfrlkGC1B6dSBRzwzjVJLaZU+k020n4EqpOy4R18gSz5cMLY93kwB5FHRTyMGzeUMRYmNFX1QuhRzphqorIT/0SRui4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIYZuwAk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIYZuwAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BDF1F00A3A;
	Tue, 21 Jul 2026 15:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648251;
	bh=c6NYwqWLOYgwn8v+4iKPgdYixzr6gUqcd2UZ7WUWm9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wIYZuwAkojIu0gIri42spwp3zKQxpv+lodfB0XsJuefWlwdpJIMBzFE8ZwHtlS9Uf
	 ckPqljFXV7MPcv+/RhPdaDObhFKg9W/edLZDLY400YbqhpXAQzPAy7IrqTkjghawXN
	 wVSoV2vf4Q3/58oGUm8XCY05hJw2NahPnOBzRyV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0127/2077] objtool/klp: Fix relocation conversion failures for R_X86_64_NONE
Date: Tue, 21 Jul 2026 16:56:40 +0200
Message-ID: <20260721152555.691081781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 3787e82a4e3a0a04aeb5543580ee90bed3a36e55 ]

Objtool has some hacks which NOP out certain calls/jumps and replace
their relocations with R_X86_64_NONE.  The klp-diff relocation
extraction code will error out when trying to copy these relocations due
to their negative addend, which would only makes sense for a PC-relative
branch instruction.  Just ignore them.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-diff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 61abf5ceb650e4..ef038f13366678 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1020,6 +1020,9 @@ static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
  */
 static int convert_reloc_sym(struct elf *elf, struct reloc *reloc)
 {
+	if (reloc_type(reloc) == R_NONE)
+		return 1;
+
 	if (is_reloc_allowed(reloc))
 		return 0;
 
-- 
2.53.0



