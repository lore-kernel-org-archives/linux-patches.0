Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F141C2432;
	Wed, 19 Feb 2025 09:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956608; cv=none; b=qORX0h5X+9bWBec9dvyzTns9Z8MBu413i+LpmKesSTfNKTiAjuP+NKFCIZsbKixxb0OrmSQIDw5VjTWHHc5/LrKFKJFeYU3UjViJ+wz0txrSroiS0/V5vCJbL0DRBS61r+cZqpMVb6Pq76SGMCMjECzQBDIlldlrci3gOBsr5tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956608; c=relaxed/simple;
	bh=Sueue5v1t20PB8/1UzBJHMO5Z1KgbuMQAcPt6/lWKM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExjX5cD0zidHzgYHVt4oXX35b0bDMH+GMEp/aejtyQReYJG5B6L/TzbxG4DipLZn8XvTWMWaHAtv2Kgl822DTdcl9yzHbiZr/u3+fulaGD/G1+jiJVeOvcgcCFXI9lx3JEqR73R06ZUVq/XjmoFMJDbIZFY+qjIXVYHKpVLB7II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTbo7jnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTbo7jnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43275C4CED1;
	Wed, 19 Feb 2025 09:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956608;
	bh=Sueue5v1t20PB8/1UzBJHMO5Z1KgbuMQAcPt6/lWKM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTbo7jnJjQkl+d/XwV3J67+zWg1iltEMPRKwCTLoIao8Yl53xYW90bF/mPW4TO+CX
	 DilcCjvlAN+BR/rf/E8tLXr6DNggLUnjE1FihVuEKY/iApUf04m4KOCucwiijyUHA2
	 +TbQmrVP92LwjbEO/5nkB3ulKPJl2yjJeAKzTHeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 237/578] kconfig: remove unused code for S_DEF_AUTO in conf_read_simple()
Date: Wed, 19 Feb 2025 09:24:01 +0100
Message-ID: <20250219082702.364292180@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



