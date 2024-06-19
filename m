Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116B082871;
	Wed, 19 Jun 2024 13:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802276; cv=none; b=Eq6jQ4WCnDxAFmE3N4KoLfyiKuVAi6Ph9maSK9CugRKI+xX1cxkS1d1Z9O7TFkuRmCxl+oG0y+pjy2S9opNC17z16guCjL7ifSZPQm2MMpcDPiCqxoByEAshBobLUe8YSpIZY3K+txwrUcMmQ1Lo7nrg+CYPG6SJNx3hUZN9UgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802276; c=relaxed/simple;
	bh=7ebgyCdSMz/rOvswYGi3KH/ihu73mcNiccgmb2LnK4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crvr67meoCVJI16nJ0hqcXpJHbprFwDgr3IlRWCQdycSavcie/MqqpJ394aJWvnsDpFEW1Slyp20hV0YNgPBBQpLAVeFckUmGrlXkWbNeyQHPIZPbSSdORaos7dX33cGy6nHxTXXcN1/qwlCbGZpxhabv20zYY9peCE+UgfFdYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iY2xhoaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iY2xhoaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8659BC2BBFC;
	Wed, 19 Jun 2024 13:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802275;
	bh=7ebgyCdSMz/rOvswYGi3KH/ihu73mcNiccgmb2LnK4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iY2xhoaMwrXKdwuT8Zv/R+s1RXMP2O793nO1qu2oMGOum0VVjhsN4LKrwYZaC1FR1
	 HDLpOEQ/DZYxQP1o0ZMu6FzhQQ3Mum7lMHLKzv/+oKILMsV1aTGNhHsq1l5G1zXASB
	 y45dIUm42CLY4NVfpDQTQEDPE6yhUUlpQ7ddMhHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/267] modpost: do not warn about missing MODULE_DESCRIPTION() for vmlinux.o
Date: Wed, 19 Jun 2024 14:54:52 +0200
Message-ID: <20240619125611.758953879@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
index 269bd79bcd9ad..828d5cc367169 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1684,10 +1684,11 @@ static void read_symbols(const char *modname)
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



