Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC3229D288;
	Sat, 12 Sep 2026 12:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217258; cv=none; b=Ewg9uEfggN+4IbmZvk87wkllRVIR139i/hakm7kZayAbDSkCm8LB6p0UG85xWfU2sdx06teN/CVkSe1tMGyloOgAFqGybYhUw1qg7O1QQqGuhQttzEy9n075UGnYPkn2Tl0kxTrRW14hug3BbuIylRe9WNalqBwkYxOgLERswtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217258; c=relaxed/simple;
	bh=tAFFtcswTGHWiMH61pR+E+GtsjlEGQ+XhGnOgCG+0WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtWWTVMdWqGFrMs7IK452tLtW72dW6rxm9laPMOZKzjMGdzzUXjD5WdY8Vvnq/JEo9XkZOapFdo3d6/LhC2Y3n12bEYZfCRQxA5lbvj3D8iS9HX+XuaiH+7sSWCXGwscDVTR5XoxeOvwbdR9x55cAMSw0Wr0cu3TsIQSaIPUOfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Al0IwI+R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Al0IwI+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4081F000FF;
	Sat, 12 Sep 2026 12:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217257;
	bh=GTsRkL/rjRIi0bigswlxmj//f+T1Zwy5/sBUQvbhcNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Al0IwI+R3Yyy2ld/46WtPnUFDkZ17wsw1yvGxJ/Mud8P9Nn+BiloQifAcouC8T27O
	 jvtHfBl6z83aIbBrIUT6wUntcu4N+LluanOXbD95mBSgAfNInFxtC2jjj+InKdC12L
	 Tv+Xo9AvRvrL9XXE/pNbc/YodQguY/BqNpHA/bmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robertus Diawan Chris <robertusdchris@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0904/1376] modpost: prevent leak when early return no suffix .o in read_symbols()
Date: Sat, 12 Sep 2026 08:55:30 +0200
Message-ID: <20260912065627.715637809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robertus Diawan Chris <robertusdchris@gmail.com>

[ Upstream commit 9a5b76027ed91680e10f90111d9cba300f96d1ab ]

The allocation for elf info symsearch and hdr from parse_elf() haven't
been released when return because of modname didn't have suffix ".o".
And it seems like the suffix ".o" check did not depends on parse_elf()
to succeed first. So, move the suffix ".o" check before checking
parse_elf() result to prevent resource leak when the modname didn't have
suffix ".o" and return early.

This is reported by Coverity Scan as "Resource leak".

Fixes: 8c9ce89c5b63 ("modpost: simplify mod->name allocation")
Signed-off-by: Robertus Diawan Chris <robertusdchris@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260624044742.144852-1-robertusdchris@gmail.com
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 07e8a4eb71d04..f17350bf3ddb4 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1567,14 +1567,14 @@ static void read_symbols(const char *modname)
 	struct elf_info info = { };
 	Elf_Sym *sym;
 
-	if (!parse_elf(&info, modname))
-		return;
-
 	if (!strends(modname, ".o")) {
 		error("%s: filename must be suffixed with .o\n", modname);
 		return;
 	}
 
+	if (!parse_elf(&info, modname))
+		return;
+
 	/* strip trailing .o */
 	mod = new_module(modname, strlen(modname) - strlen(".o"));
 
-- 
2.53.0



