Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3496222DFF3;
	Mon, 10 Mar 2025 17:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629158; cv=none; b=YmRymFSZszPw++QgCiJa+iabnYbqYcxa7ukkmz5IKxlpdjvhRdLEOpQr3Wqm5YVTHpTszaA25TxkontgHd0yQGxhfsCfs3pduXBECyEQD17eodxYkj16WD0UuxORwV3eW5oXams2FqgYQiyDy36RXjm84SEO0cSsxNMpj8gR6YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629158; c=relaxed/simple;
	bh=pBV6A4blk8ovIqAM/9bXQwLZriWO9JPqGI/ssu6pSVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ct8yZw+JiVHi9voY2P9n/nkSnq+4wWHz9zapZjHIUB8aJb2CzZ1iP5E0RQcjAg5DUlzfSSLQB8WxsHDdeKLWzXMqHl+bkTVFZAs4jH3LSrkTJ7YEGxXZ3VAK8F9eUt7XMFS5p/maVRasLpNhB73A+BRdlvHNorsOTO3lj7FTYaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txw5Xkt3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txw5Xkt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B241FC4CEE5;
	Mon, 10 Mar 2025 17:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629158;
	bh=pBV6A4blk8ovIqAM/9bXQwLZriWO9JPqGI/ssu6pSVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txw5Xkt3bySC4z8NxTn0pJzXoQWOQIQ/x6NO02I/cnIqo30Vgr7u1RO9lcy9B3T/7
	 H1+tZBbNZt82CZ5tqkqXuOhqjLZMg/+KjXLahFiKZ52oD2rZ7z4xXSWZWn4Q1SS+dx
	 St0O16tlxfV2D8VhXLNEi53Y9MAV3vSDP46mSCPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/620] kconfig: remove unused code for S_DEF_AUTO in conf_read_simple()
Date: Mon, 10 Mar 2025 18:00:26 +0100
Message-ID: <20250310170552.727561284@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 80160aee01ff6..8349f6ecd9dc7 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -444,20 +444,15 @@ int conf_read_simple(const char *name, int def)
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



