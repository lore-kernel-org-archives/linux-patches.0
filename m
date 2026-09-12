Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149ADF4F1;
	Sat, 12 Sep 2026 16:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231995; cv=none; b=o+68EmkVawBL7wHClcwGEk8A+ohcvfFtBMGVZ1NuBmwTbAliM+PjNI2llfQUbAS+Y80ZRXZbwykxVwHX/fDIaFLir+ay52sF5023e0lEHGMrF/Jd05HPq2gsFP4tbY8KUU7+11Umc7itNPr5/gMOrEkk9Zoc0tJsgTeswmzfLtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231995; c=relaxed/simple;
	bh=Vlp2l/oNM3qrGx+fwCTtDxAIGFZRlwQOVdim/EFPCfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJJLzaOwnOgnsobCSMoH6kVKI7LQyUMntJZ/+M0iQSPotPDCfLjYAG1RZ7bWksMaaitTJxCQ58YiP22B1QJV4DwSZcyv2k5Itmi2ikzMJ8DwIYj94fcSjpTN1SRWwwKQPAlc6TH/FDj8NM1oQqHmFiom43S9YqwRc/aEJMVaQIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwPt6i81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwPt6i81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26851F000FF;
	Sat, 12 Sep 2026 16:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231994;
	bh=M8G6qwFisPOa5OELDZ3Bt09oSuN7OPJay08QmCfaWbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NwPt6i81lq7kE0wVpJXJD3qeXcTz/EIhKZFh6wMlSl9dN6W87HMmHVShcjKd5sZoD
	 1bDSLv5EnzJ0rShBJ/DQR8maCovUWsBPZRyG0ywY4k1T88eqlQzKyEgHNq1CAFGSQv
	 fhHJnsh9ogyPSWNSmt9yqbRqIjbiHLxC5a4NZ4r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Hallyn <serge@hallyn.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1113/1191] apparmor: Replace sprintf/strcpy with scnprintf/strscpy in aa_policy_init
Date: Sat, 12 Sep 2026 09:04:01 +0200
Message-ID: <20260912065613.151878092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1c72a61108d3f..cd96680c5a070 100644
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -506,19 +506,17 @@ bool aa_policy_init(struct aa_policy *policy, const char *prefix,
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



