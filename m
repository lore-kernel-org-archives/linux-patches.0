Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FED3AA9F4;
	Sat, 12 Sep 2026 20:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243485; cv=none; b=AapY8tdU8XxzOxHFpp90S9OI/oguVZgCuwHqCbeG4u2xQ18WpMoFXM05uK2QB9D6Aqpg8rod+mLQAeNVnwBK7gosKRReXwC7BDTlpfzVGg90wq5ezPyaxg+aazVTpzFZKKh/M3bfjXIwfV6x63N9q56nbhKM162IudnGdevGfz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243485; c=relaxed/simple;
	bh=xsf8w/yV7YhIuqT90B34n+IBDPXjy6JjYhzHeAFChzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/r7YrnKJKhFWD3diwQdSy1bLSEBvo7zoscO3pUwxhA+BLvB5GmwgOw1vA3LHvReW9HUdszWkv7002LoxWwS4APFUoGaI6hF/w4W0jBx7a6/eXeX6YkRnzU6fjx3XoufC2+cEuAThRFMsHS+nLS45wlZud8U4MWTlxLM/NmDwYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cs8Ry8aG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cs8Ry8aG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0E91F00893;
	Sat, 12 Sep 2026 20:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243479;
	bh=Qtwya6m7w7m5vYc3Pg8FALJqIGGp31veDP2TjkXDaUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cs8Ry8aG+y5vJJ6vVLAlJlLGcRU4oIz50NKgHg9aMryQYVGu9Qr9xMkdgmAAnb2mM
	 mTBzx+fCMvv+IQZRYPSb+cKyE9MMnAOYzZbm7X7rewlr6l4GoGuoPiOO5ChvhjX51a
	 fFP1N11NCP8D/m12nygJE196vOyasvVT6A5sGIp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Hallyn <serge@hallyn.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 769/798] apparmor: Replace sprintf/strcpy with scnprintf/strscpy in aa_policy_init
Date: Sat, 12 Sep 2026 09:06:37 +0200
Message-ID: <20260912065534.693884143@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit b31d3f7385fbb49681d44e7104cfa033cba4b1e8 ]

strcpy() is deprecated and sprintf() does not perform bounds checking
either. Although an overflow is unlikely, it's better to proactively
avoid it by using the safer strscpy() and scnprintf(), respectively.

Additionally, unify memory allocation for 'hname' to simplify and
improve aa_policy_init().

Closes: https://github.com/KSPP/linux/issues/88
Reviewed-by: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: 3daad923a868 ("apparmor: policy_int make sure list heads are initialized before fail path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lib.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
index fa49b81eb54ca..d393c96d732dc 100644
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -489,19 +489,17 @@ bool aa_policy_init(struct aa_policy *policy, const char *prefix,
 		    const char *name, gfp_t gfp)
 {
 	char *hname;
+	size_t hname_sz;
 
+	hname_sz = (prefix ? strlen(prefix) + 2 : 0) + strlen(name) + 1;
 	/* freed by policy_free */
-	if (prefix) {
-		hname = aa_str_alloc(strlen(prefix) + strlen(name) + 3, gfp);
-		if (hname)
-			sprintf(hname, "%s//%s", prefix, name);
-	} else {
-		hname = aa_str_alloc(strlen(name) + 1, gfp);
-		if (hname)
-			strcpy(hname, name);
-	}
+	hname = aa_str_alloc(hname_sz, gfp);
 	if (!hname)
 		return false;
+	if (prefix)
+		scnprintf(hname, hname_sz, "%s//%s", prefix, name);
+	else
+		strscpy(hname, name, hname_sz);
 	policy->hname = hname;
 	/* base.name is a substring of fqname */
 	policy->name = basename(policy->hname);
-- 
2.53.0



