Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2C38288F;
	Mon,  8 Apr 2024 13:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582145; cv=none; b=IRaRAKFYvUEGgWzlSAcKSZDuCNKV2Hig+XL/e+R00Jmt4T2FQFFBUDiHZBF4uB303onRkrv8ZLmyBXYKtVMcejstR5u2sOs2v/JT94ZLNsmqP8TwJ/omFSH5bH5lpwVLbxbEOECN2GoATwSyxAGSe1eMTwdtgB6XfdEXAmaEq5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582145; c=relaxed/simple;
	bh=R4QumElQl1MSMfpAULPWXr7ITfBh02mhWDpPzYjrGxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKuvErgLmSHtkUH15IFjc8EEebxNd/f8jg2U27upsbbPXGAX8HU4j0A47PrjYcWfeH8kcGbOcQu9dTrhf3wqpbwN2haOmdAbn+wDpKrnVt25J6+SdiqiBCCs6ql64C+/zFiCJI3d8EMPeQvjSEjMUwzji7J/ZUih1PyMIOPnLqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAJSkHX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAJSkHX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FABC433C7;
	Mon,  8 Apr 2024 13:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582145;
	bh=R4QumElQl1MSMfpAULPWXr7ITfBh02mhWDpPzYjrGxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nAJSkHX8pPgv4ifNFT6Pjxi8B4wN6CbEHt027mmSFQqktPH3Uyc/W17urFNKkGggX
	 m/qVL58nOVU77v4qSgJpqLRbVtAbzr+gIbzdjXUb7VBRhTz3TnsJDkfgy10jMnueqr
	 MKdFIHUnmxgVtpUh5awEpM7xUibqKaJsVYxR4hWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/252] modpost: do not make find_tosym() return NULL
Date: Mon,  8 Apr 2024 14:56:06 +0200
Message-ID: <20240408125308.717477656@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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
index 66589fb4e9aef..7d53942445d75 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1052,6 +1052,8 @@ static Elf_Sym *find_fromsym(struct elf_info *elf, Elf_Addr addr,
 
 static Elf_Sym *find_tosym(struct elf_info *elf, Elf_Addr addr, Elf_Sym *sym)
 {
+	Elf_Sym *new_sym;
+
 	/* If the supplied symbol has a valid name, return it */
 	if (is_valid_name(elf, sym))
 		return sym;
@@ -1060,8 +1062,9 @@ static Elf_Sym *find_tosym(struct elf_info *elf, Elf_Addr addr, Elf_Sym *sym)
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



