Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA22A23BD06;
	Sat, 12 Sep 2026 14:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224769; cv=none; b=lihiWdH1xQsrXqgEskKZ3CUNM2cXJZsGqMJZuxxsULObzcm2UFH4A2xKKzP6VHQUfEfgoGIbnzG5pfJWAgCpEUV+9k5wDKPTiWOldmHzrxZ5gRKiYLMFEQ9foauXVWeP2gd79cJLuxKOMN0925GZoO6xhNMmyiXv0Gr0u/PYlPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224769; c=relaxed/simple;
	bh=DoFysneken/ZgZzgViyW1FS65gjKa75qWWsJow2Om+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYPXknZ5y37fwepxJWD/+IagPj+QhNJQqZHQ1wkuel4P/pKMk7qW3Tjxehs7dsNCKKW6jtQy5ykqmBtPIcDJPZqAWMx6p4aGO0uIuua7339RN30i72XYlCPApL+zZVuE25mVDoybOeysrBLoYVHKNYuJqUjpFJOjj7MxCex5fX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiA9LQ2I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiA9LQ2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3001F000FF;
	Sat, 12 Sep 2026 14:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224768;
	bh=Dd6uY3encz9lKojH1/9s99VFl/KcyFIaA6sLfYJFaLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JiA9LQ2I0oRD5fBHkAEuWupZO0A2omYzWfQlazfy8hbp/N5ZSdDwRm2l7iHB7uXZw
	 YAoTyHG6QT+nEChdyw/XT+2zIeXbk4ypj9igMSH3ml8YAZPE837IswCOVft4/ksZRW
	 Q6IDJgV169AzwPd42r3epQ1Vbm33xkmpn1YyfjnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robertus Diawan Chris <robertusdchris@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1062/1424] modpost: prevent leak when early return no suffix .o in read_symbols()
Date: Sat, 12 Sep 2026 08:58:14 +0200
Message-ID: <20260912065631.087016674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 96a6e68730981..cfcf2c1bb5ece 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1632,14 +1632,14 @@ static void read_symbols(const char *modname)
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



