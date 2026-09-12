Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CB637DEBF;
	Sat, 12 Sep 2026 11:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212604; cv=none; b=ADPrtdTOLtU7uj6yK+ZwD7qOESNtGM/OPyGQPCf5WOKgI+Zsa/S6tn29/EvXAiQ9avn6f+1iYJfAu8eS5elJ5o0QNoJIvkZNfJqIM0fUhw0yKVzcOd/ZB5OnN2RJE/P4IHHo1FdrxsnjCdO+D8nSB2gPc9eIRAAl574EDhrMC2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212604; c=relaxed/simple;
	bh=FsxZgrdliLS1REAnTXeJoMvkvw3y6dSqFdsFkT4nA0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lO4/ZczS9pa7O1fXylWDNohuo+2EZYFgH9a4SwV3wHENfF6spzQRyfWexeTBaZzAxPSAOsf7TsyT3j2yCyKv3i+m/D9LJlhrbDHwcWsxHm6gIi5MJcB+I9g2S1CpMhD//jDRLDxAfUdqpJsJvWowDXZ3FZZ0E7KD2TW5PvYw/7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=davK/8hI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="davK/8hI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3514B1F000FF;
	Sat, 12 Sep 2026 11:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212602;
	bh=U6xGr7qRbi6cHy5DVpn9Q+zu4n42xpxkN75bDtSFFiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=davK/8hI10WeNbgLAWa0U4WRo+IuV1DbSVZA1s8h753d8InWmr2l5nLiPtoxhCP9w
	 0st4XiYWWRgPyFp523PSUy97F5poUvxDq0TQRMUtpED/ektEV/oISLiaZptjQHwagQ
	 FM1j2cmHSE9i4zhF2eBYvUpuygphNkBCwmOlkyQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Hallyn <serge@hallyn.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1428/1518] apparmor: Replace sprintf/strcpy with scnprintf/strscpy in aa_policy_init
Date: Sat, 12 Sep 2026 08:59:57 +0200
Message-ID: <20260912065655.854425285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 82dbb97ad4065..acf7f5189beca 100644
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -478,19 +478,17 @@ bool aa_policy_init(struct aa_policy *policy, const char *prefix,
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



