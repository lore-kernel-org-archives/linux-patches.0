Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53014DF59;
	Wed,  5 Feb 2025 15:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767945; cv=none; b=J0cbPKdH/QjIuZO7GkboZKkyBoxwszJzcFUjYX8nXVLGdbp85687aL2eqPujwvcD82IR47OmpKqYDF8uS2xbJ7/1Ckh4IOxv2figBnsUyjjSnqdE/HWUkf+1a9Vpc7GXKpcWS17bWIvjLOBxVIqAmfqMa92rxQ8RY84HH/cDkn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767945; c=relaxed/simple;
	bh=gn/Wyfc2ikI4wwwkrfF/g6zj+3U/1V9C8xYTYRYOfLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxiJSrrDuOWhXbkQ3gDLbwSHXLb5VP5AsJW2TgBs/cl/9oqGlsRhA27U1VqsCDQmQLfBnp4bwBoRmRxejD4RGpdXvbWqKPMqxjO/SnYIINc6FUoQPw3RfrHL6fmRcy5psCuP40+QvoAJiDYpUgDrhsx2OllqEM1ouLsBp2mQpfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYLP+Akj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYLP+Akj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0FCC4CED1;
	Wed,  5 Feb 2025 15:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767943;
	bh=gn/Wyfc2ikI4wwwkrfF/g6zj+3U/1V9C8xYTYRYOfLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYLP+AkjCOAnnpmPfleKWqndlZGX09kTLIqH6RBZFuYNiPTnDNY7quNAbXCfW4Vav
	 aowfw+tub5LCACvjSFDmteqCr0d3wZav7WNttbil+l0NevPWuEmfLEldM2aaKYX04k
	 9cPQi5p2HoqXIZ5Hl7r35v9fvusIFuaCwlaDHQhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Petr Vorel <pvorel@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 533/590] kconfig: fix memory leak in sym_warn_unmet_dep()
Date: Wed,  5 Feb 2025 14:44:48 +0100
Message-ID: <20250205134515.658096971@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a3af93aaaf32a..453721e66c4eb 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -376,6 +376,7 @@ static void sym_warn_unmet_dep(const struct symbol *sym)
 			       "  Selected by [m]:\n");
 
 	fputs(str_get(&gs), stderr);
+	str_free(&gs);
 	sym_warnings++;
 }
 
-- 
2.39.5



