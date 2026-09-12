Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB71271464;
	Sat, 12 Sep 2026 08:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202154; cv=none; b=GF4lNPYZxFY+S7sWLhB0k1hjjfC0CURTSOHhZzl57W4SJWOgO38LNJrJJFDZ8048TWU3RN3TMRQ2Emh0aX2c6T5fTaN8c6jtUspaDd8mMueYxR6/zsFAJl6vgb3rXxP8mcEECffTCx0xaEuaBhfdBMjnd7QlY/r9o8BN//FK3Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202154; c=relaxed/simple;
	bh=Z29spksNc1k9BJSFXvF/j4I8EEWfSpyiWtu3tEKHWkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVxBy4KGlbGJyRLtybQdpD2bz2jZS1jx9Q+fLxsJjJRPKKfBRCDcDdFRKQ1fDSq7Ak69uPmXkM3PAMbZnVlWdBjayA+vL3HTtlUrKbg41EkdQt0kiIH/scM6pIBX4Cur5fQ6kGglWhcxDjnrPmsOSHYcvyYxplegLmeQCiO2lwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igDvxNvV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igDvxNvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1D91F000FF;
	Sat, 12 Sep 2026 08:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202153;
	bh=qHOIw446XO9A1TMQDZOQiV56B4EKG+1NuxaFADTKhIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igDvxNvVwdxo+04XCfhRn1xdww580dxu7nVzWDifa9pWcKo+AL6PSq40VoEbjn4Ws
	 zrl3f+hg3wv0olKKZvRR6eQBzR+4pNapmqC5guinX0zuid9n5IOxahXgYc2+vyBsXL
	 A3xKBsE9V4RTgd+sbuFfnYpsEAeaw22lyqiwtrSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robertus Diawan Chris <robertusdchris@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1101/1815] modpost: prevent leak when early return no suffix .o in read_symbols()
Date: Sat, 12 Sep 2026 08:47:31 +0200
Message-ID: <20260912065714.864834328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 027944fe35b47..91b35eec69a8b 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1592,14 +1592,14 @@ static void read_symbols(const char *modname)
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



