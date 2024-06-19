Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075BD82495;
	Wed, 19 Jun 2024 13:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803170; cv=none; b=dfn6pMmqxKZuSVgqG+9Hg8bmc9qLbwgSTvZDnyHrl0mNGqUqzHzO0TFscjbJLH+NOkzY9c87ou+1BIrQ2Rt/Scot3FC3ac65ytA+lNaONufbpse9uGRqb/Rqm5ohzG5/kbo1LE10cBMuq2vjzjpGjh0P+fx0KhKRXE5YG/Eco8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803170; c=relaxed/simple;
	bh=9Ypry8GwffCLuCOrIlexPV8+rpYiwlPRqzeBX8dA9eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqvUspi4x+MM4RKVUJXAevVnLuAGRf9yy6ziYIwaM7jt5hp6a8Jll6ql3VOhOUICHNxlhlMYQXI+3VgxLBe0B41YLGZVfCpKvOD/7aD4bQgg/80kQfTiSuvdaxHJImtgJMPTtsS3o/4tWrOcO7USvuTxHMh0Mvdpt54mDLs/LDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFl9EF60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFl9EF60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F3DC2BBFC;
	Wed, 19 Jun 2024 13:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803169;
	bh=9Ypry8GwffCLuCOrIlexPV8+rpYiwlPRqzeBX8dA9eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFl9EF60cfSslITjTvlx5/F+YpFyr0h22GiYDbWt064ID3HlcLXx2loDIXHmlWjxX
	 Vo6gRxpwV9jWpDVTHBKdMGb0FtB4XyrtyhDh2bN0OLornM2wAXPnqQmU3r9BtOO99G
	 xcdK785pob2JAWV3kWtPovN1EoKLhS7z4nbrRy+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 145/281] modpost: do not warn about missing MODULE_DESCRIPTION() for vmlinux.o
Date: Wed, 19 Jun 2024 14:55:04 +0200
Message-ID: <20240619125615.420137792@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 9185afeac2a3dcce8300a5684291a43c2838cfd6 ]

Building with W=1 incorrectly emits the following warning:

  WARNING: modpost: missing MODULE_DESCRIPTION() in vmlinux.o

This check should apply only to modules.

Fixes: 1fffe7a34c89 ("script: modpost: emit a warning when the description is missing")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 2f5b91da5afa9..c27c762e68807 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1652,10 +1652,11 @@ static void read_symbols(const char *modname)
 			namespace = get_next_modinfo(&info, "import_ns",
 						     namespace);
 		}
+
+		if (extra_warn && !get_modinfo(&info, "description"))
+			warn("missing MODULE_DESCRIPTION() in %s\n", modname);
 	}
 
-	if (extra_warn && !get_modinfo(&info, "description"))
-		warn("missing MODULE_DESCRIPTION() in %s\n", modname);
 	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
 		symname = remove_dot(info.strtab + sym->st_name);
 
-- 
2.43.0



