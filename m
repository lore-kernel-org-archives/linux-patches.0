Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F0C7E792;
	Wed,  5 Feb 2025 14:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766424; cv=none; b=fkX5EUjAS3EfU6+oebgcbphbLYlZeOGQrKuqN04hwAANYIG88xw0odSBXkNt5QbVc36Rj5epnf9RzwG8uKzg34+BusD5o1sPqf/Dsai5NFEqR8BeCexbyrBvodvimODWtUWa1e0dyveJN1Vhnbq80lyD/SdkJpcQP4aUxA1CF9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766424; c=relaxed/simple;
	bh=UCqMD/40fdd7/m4TplarNNJMIqx9QOafQG/cOw4wR0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RoGzCvxcWX4565veU/TIHfayDLr1Qf3s8pgZf+iUOsOaJUyQ1d/psgiR6uCs+bdEF8EnPbmOTlKkLcKrnybwKRdXPT9sU2CHesTgn/uhifvhb48gnFyZsDLDKoLNe9Nm5INWqBApTjPEQazGEOmkGyGENR8/OyjWuukX7YMlpS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ni2/Adl/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ni2/Adl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF2BC4CED6;
	Wed,  5 Feb 2025 14:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766423;
	bh=UCqMD/40fdd7/m4TplarNNJMIqx9QOafQG/cOw4wR0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ni2/Adl/Ur95spa6lMwozlLUECDTLkFFMxLphtOOdH9eoaJ2gf2OuolLaXSv7uTYp
	 zldXbGh2gzrSlo1/lT4XyZQEdK9GY++6oAmZUjhG0gGDCYx95PSedS+dD9EydX16WP
	 yj9pTsz0bccvl1Ele812xxqMhTgRjahM2pL1IJZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 361/393] kconfig: remove unused code for S_DEF_AUTO in conf_read_simple()
Date: Wed,  5 Feb 2025 14:44:40 +0100
Message-ID: <20250205134434.114094961@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 92d4fe0a48f1ab6cf20143dd0b376f4fe842854b ]

The 'else' arm here is unreachable in practical use cases.

include/config/auto.conf does not include "# CONFIG_... is not set"
line unless it is manually hacked.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: a409fc1463d6 ("kconfig: fix memory leak in sym_warn_unmet_dep()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/confdata.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 8694ab1e04067..21a65ffe7c3db 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -442,20 +442,15 @@ int conf_read_simple(const char *name, int def)
 			*p++ = 0;
 			if (strncmp(p, "is not set", 10))
 				continue;
-			if (def == S_DEF_USER) {
-				sym = sym_find(line + 2 + strlen(CONFIG_));
-				if (!sym) {
-					if (warn_unknown)
-						conf_warning("unknown symbol: %s",
-							     line + 2 + strlen(CONFIG_));
 
-					conf_set_changed(true);
-					continue;
-				}
-			} else {
-				sym = sym_lookup(line + 2 + strlen(CONFIG_), 0);
-				if (sym->type == S_UNKNOWN)
-					sym->type = S_BOOLEAN;
+			sym = sym_find(line + 2 + strlen(CONFIG_));
+			if (!sym) {
+				if (warn_unknown)
+					conf_warning("unknown symbol: %s",
+						     line + 2 + strlen(CONFIG_));
+
+				conf_set_changed(true);
+				continue;
 			}
 			if (sym->flags & def_flags) {
 				conf_warning("override: reassigning to symbol %s", sym->name);
-- 
2.39.5



