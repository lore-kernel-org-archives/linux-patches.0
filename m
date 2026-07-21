Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286CA430CF4;
	Tue, 21 Jul 2026 19:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662688; cv=none; b=eQOcgaXmHbfviyXZh1XxV60yPPyaWoTMWHgG1587rqCSsx4s2aHTc6PFfdtz8IJowhm4ieT2WWLWS1ApwTJUbW9qasLi/nKrK6t1+JO13+bLs7wlv6aSlsqMuVGdA/A+Cvz/61goX0R3k0ypKQ84Cp3+EFecatA3YDb9VpnApHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662688; c=relaxed/simple;
	bh=TsXDYdpi3TwC0NF1nQXI6QfGRbFcSBCXDEJ4Ztnbpc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUXovHG+HXHbdbiV4YoLhrKIopwaSVB5ODwV/gCrOzeJwZOc6vSrOGyN7kn640kW3lFhstE+6/0EWqI25XoGFviShaYuNCq1+Eqe2MunivlcWkXqJFyx9x78spYCf/ML2u25d/37EBz8tB+mFImMu2gJNCGYmgCf10BRIBVjTIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPjRYWc1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPjRYWc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022C11F00A3A;
	Tue, 21 Jul 2026 19:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662684;
	bh=ksROzjN9OcR3J9XQJFPif689C4v2UmDqurmGpZbnUoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sPjRYWc1nQTQYh2sqJaIsf0Mn5A+uDlb53SkjK7vLKrcvo54BDbVHH68BgjBKrORf
	 R+FmQN6ElrN+KcM5j0sjGF9S6sJLLPWAcGCSfYrBY+rYGm7GAgO10QNd08jE0FiEcK
	 0qskDyzFFSfd5FC1RDJSoYIRyZwnKSoPWsmQumsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0537/1276] apparmor: check label build before no_new_privs test
Date: Tue, 21 Jul 2026 17:16:20 +0200
Message-ID: <20260721152458.139120928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit a58cafd38b46fb1a2220e2fbbcfe291ea75fa147 ]

aa_change_profile() builds a replacement label with
fn_label_build_in_scope() before the no_new_privs subset check. The build
helper can fail and return NULL or an ERR_PTR, but the result was passed
to aa_label_is_unconfined_subset() before the existing IS_ERR_OR_NULL()
check.

Reuse the existing target-label build failure handling immediately after
the build. This preserves the current audit handling while preventing the
subset helper from dereferencing an invalid label.

Fixes: e00b02bb6ac2a ("apparmor: move change_profile mediation to using labels")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/domain.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index fbfb1d48dc88f2..3ae50f8675e23c 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -1471,6 +1471,8 @@ int aa_change_profile(const char *fqname, int flags)
 		new = fn_label_build_in_ns(label, profile, GFP_KERNEL,
 					   aa_get_label(target),
 					   aa_get_label(&profile->label));
+		if (IS_ERR_OR_NULL(new))
+			goto build_fail;
 		/*
 		 * no new privs prevents domain transitions that would
 		 * reduce restrictions.
@@ -1488,16 +1490,8 @@ int aa_change_profile(const char *fqname, int flags)
 		/* only transition profiles in the current ns */
 		if (stack)
 			new = aa_label_merge(label, target, GFP_KERNEL);
-		if (IS_ERR_OR_NULL(new)) {
-			info = "failed to build target label";
-			if (!new)
-				error = -ENOMEM;
-			else
-				error = PTR_ERR(new);
-			new = NULL;
-			perms.allow = 0;
-			goto audit;
-		}
+		if (IS_ERR_OR_NULL(new))
+			goto build_fail;
 		error = aa_replace_current_label(new);
 	} else {
 		if (new) {
@@ -1509,6 +1503,17 @@ int aa_change_profile(const char *fqname, int flags)
 		aa_set_current_onexec(target, stack);
 	}
 
+	goto audit;
+
+build_fail:
+	info = "failed to build target label";
+	if (!new)
+		error = -ENOMEM;
+	else
+		error = PTR_ERR(new);
+	new = NULL;
+	perms.allow = 0;
+
 audit:
 	error = fn_for_each_in_ns(label, profile,
 			aa_audit_file(subj_cred,
-- 
2.53.0



