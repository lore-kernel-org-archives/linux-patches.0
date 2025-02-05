Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B8235946;
	Wed,  5 Feb 2025 15:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768473; cv=none; b=jBziT4il/bY1L8ODy1PKbwyjqk3LzgyODzcNCCatfu0ECC8utNIUbyKjO40+98zCil6JJXCrgsRd8uXYc+3BOS4UnvPwPiSOBsVDyF14oNnaQYB1b6DhbGxxk3L+g3HiGSrcLBdetw+TrmScM4RU6IQKGYd6IDQV6dcBApV5JhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768473; c=relaxed/simple;
	bh=L07s8LBDwP9pZdrJMPwiVaY3zhWtgYtVTVLqSPfZruw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQeq4j0XLGVdcG1zh0S7naqClJGqJhSB37efys79HB7xmhYf9Qm4/xesiEBQ1Dapaj1K3f5fM1v5Rq2USEfaBsAjXwLGT4Zx0OfKq3MfYCrmdaqMyZA+6RNUKDCt4fqpKEbVhp3jN5lpB+5LyAcbMetHTQ58MggQYtMJFyApf4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBE514S2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBE514S2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABEAC4CED1;
	Wed,  5 Feb 2025 15:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768473;
	bh=L07s8LBDwP9pZdrJMPwiVaY3zhWtgYtVTVLqSPfZruw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBE514S2KW/QgaHhJZ+duq9jQeRlulPfeOWoIcAvCkHZT44ln6JwyZ2+S2gH2mMGq
	 adRVfDfSLJfWf9TYrx+SyHya4dNGEtI+d4fGfsRp7TEt1XvzGba1IYt1ipASV3543o
	 VUYbaPzsUMVncwW3l2Iw3ghqPfm/lG4swR4nv1V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Petr Vorel <pvorel@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 567/623] kconfig: fix memory leak in sym_warn_unmet_dep()
Date: Wed,  5 Feb 2025 14:45:09 +0100
Message-ID: <20250205134517.909239388@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit a409fc1463d664002ea9bf700ae4674df03de111 ]

The string allocated in sym_warn_unmet_dep() is never freed, leading
to a memory leak when an unmet dependency is detected.

Fixes: f8f69dc0b4e0 ("kconfig: make unmet dependency warnings readable")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/symbol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 89b84bf8e21fa..7beb59dec5a08 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -388,6 +388,7 @@ static void sym_warn_unmet_dep(const struct symbol *sym)
 			       "  Selected by [m]:\n");
 
 	fputs(str_get(&gs), stderr);
+	str_free(&gs);
 	sym_warnings++;
 }
 
-- 
2.39.5



