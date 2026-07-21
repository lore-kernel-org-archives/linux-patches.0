Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95ACB46A5E9;
	Tue, 21 Jul 2026 15:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648239; cv=none; b=uIeNAmW9XsvG5LQYRjlrLVRDRrdcBI7YMlCB0LZK/iJJg7mqD06iF68hPRQ1FC7lAGLkoYs/pVE0/5Lfz8fPYrXgj2R1CyWdAm3/Hz699vjH3dF5Yej6zQRnIPulY3AbuAcdTWQeb7Ziyh78919Af0IU08Di2vnAMlCiQ5o9k8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648239; c=relaxed/simple;
	bh=rLfyas5w0nSg5Emz2d2g+6kBabgOnYSL40FuTim7NtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfv2eRXwwYILT+LyGQBzW3pWK5FxsL3rlcJfDJwTWqBR9/Epb6Za78p2YOSYShRTlNtXhbAA2Jr8k/PcWxtMqLVD/WHYM1zKTcgQqr3IoG8DdDhV+QNK9gWb8QqYhOuOEu1hwEJJ7U6GlYUA/GybpWLmQI30cnEL4hrsoYJfANg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1L/WjRK/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1L/WjRK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD35D1F00A3A;
	Tue, 21 Jul 2026 15:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648238;
	bh=GGGz4R5IimuP0tj8FDk4pYNsrVZI1BfvrwdBO9aoGh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1L/WjRK/KJPJteY0unLva5lQhmdk2A+lSw++G3d527fVQ3RYGn1Gulzdg2HI7oXfQ
	 e5OsTrupDKOttN62czK/f2gqdHOtqiQa9Jq0qWm58QcxHgfAmPl0YPyAxn1/NtrqKq
	 x8uWJUE+Q9/u6FZJb77RNxHzL2LiMg3J133MVRcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0122/2077] objtool/klp: Fix .data..once static local non-correlation
Date: Tue, 21 Jul 2026 16:56:35 +0200
Message-ID: <20260721152555.576024618@linuxfoundation.org>
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

[ Upstream commit ff529864e738f447ff4c019956319930fc274a23 ]

While there was once a section named .data.once, it has since been
renamed to .data..once with commit dbefa1f31a91 ("Rename .data.once to
.data..once to fix resetting WARN*_ONCE").  Fix it.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-diff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index b1b068e9b4c708..cb26c1c92a74a2 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -257,7 +257,8 @@ static bool is_uncorrelated_static_local(struct symbol *sym)
 	if (!is_object_sym(sym) || !is_local_sym(sym))
 		return false;
 
-	if (!strcmp(sym->sec->name, ".data.once"))
+	/* WARN_ONCE, etc */
+	if (!strcmp(sym->sec->name, ".data..once"))
 		return true;
 
 	dot = strchr(sym->name, '.');
-- 
2.53.0



