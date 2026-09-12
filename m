Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6845221FD4;
	Sat, 12 Sep 2026 15:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226494; cv=none; b=bXI5XFcA8nfVGwRAHZGmqt/hu/2ctbvNwtdOTM8qvKgBxqlUA1WhlLF92g2YUtMWWXvfrZwlFY0mgrHRwfLUnAtfOvNNeMLL7B98X80kpzSbwX1pAqdZhcqPzY7QgtTztgrzzadHCLhNvyNAfG24BjscU3qx00t5N4btEithkt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226494; c=relaxed/simple;
	bh=fNJjFZsc3o8tzUCbDGkYyv254u0oE1QcQx8h5+vHpWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbFxkAKzlyRN6sITfMXIAPqv2yJtkoQrRMuS6qEkOsOgb4xI3Rf50ABuNRV67oy+lQKk5KvARZlSNPVawdypshxilFUNQWSPRfNW/XEv+Sv7IJV2ptOdSCDbLfnJNSzu9reowp4cLleeeG0Mv80DFOoomCOX7yb1NYZTPUlq4Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GclVrKvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GclVrKvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51571F000FF;
	Sat, 12 Sep 2026 15:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226492;
	bh=TZE2ALyHr0QH9DRpbUDvQkINrTSQAarwXV+AuHfGkQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GclVrKvyqLR4pbE8cN8KH1iT+tQJDoHMk7p1CQhgrIQ0xnuqvqvvOHSUEgGlmYHR5
	 ESsg+NFGan6yiJ+kq2hIBz6oeqDlcF8G2M+Lz/2eMQqK2HlaMlpVKHWufh3c16+eCr
	 97W0PA+tZ7g5zea6QchLlwkoyd10rmy+bPJ8FKRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Hallyn <serge@hallyn.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1370/1424] apparmor: Replace sprintf/strcpy with scnprintf/strscpy in aa_policy_init
Date: Sat, 12 Sep 2026 09:03:22 +0200
Message-ID: <20260912065637.942606124@linuxfoundation.org>
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
index cd569fbbfe36d..ced4c7bed817a 100644
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -448,19 +448,17 @@ bool aa_policy_init(struct aa_policy *policy, const char *prefix,
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



