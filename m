Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739371F03D9;
	Tue, 21 Jul 2026 22:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673865; cv=none; b=MOy0ul9EybeZ0F9g4JtkVvYEd6mT00PUFuO+hsT6kiYeQdslXZTDMUlbrb8MGmJ14zZ60EXz/lP9TUjP572kPfOopUH96lwfQ06AvvxvJm8hU5lfo7vNFpJ3MlPiHOvaUw6VJfjgI4lQ6lIsjyQ4V7m/sAXIp9q4gooh1gVKsws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673865; c=relaxed/simple;
	bh=1ut4KNFihatVec+WUFUxPSlnyN89cIb2x2Trhs8dCGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRIaD4V8wKH05KEUnzadmbot/J3dEOcNyo1BjmRCdHqRqK5LHTu1fk52vC8z4I7q+l33NTYmj9BUlZZ1mzQ+cLyOCbrYehE+L0S2d+Sd5sJ6PJly9+LwUUduO4Nej3+sWF2Bmw6alkSLfPPbBs79wf5GpriXfZOGAOLuFqjUuuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05MDOvjh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05MDOvjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C4F1F000E9;
	Tue, 21 Jul 2026 22:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673864;
	bh=LaN4C70HCvQj5ePW4jCPXFR1hzJxct3fmCEPUExi0G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=05MDOvjhxFeP7DZCq1vXEWOqNSrXxnSNdw6cKCDFFzr4MQy0LKlT2HzflyJm5zNN2
	 QEASv5RMU61kP3bUrTt9hiDsl6W6NrOEZQ7gzZAMFcRojCq2Wj3y5wYqfwEPROOYfg
	 ydv1NfwKz6axpLzUvK+my6KoDvaTcfpaZ9D9eGyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 325/699] apparmor: check label build before no_new_privs test
Date: Tue, 21 Jul 2026 17:21:24 +0200
Message-ID: <20260721152403.022988627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
index 87a9e6fd7908d9..f7bf0ebc00cb8c 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -1404,6 +1404,8 @@ int aa_change_profile(const char *fqname, int flags)
 		new = fn_label_build_in_ns(label, profile, GFP_KERNEL,
 					   aa_get_label(target),
 					   aa_get_label(&profile->label));
+		if (IS_ERR_OR_NULL(new))
+			goto build_fail;
 		/*
 		 * no new privs prevents domain transitions that would
 		 * reduce restrictions.
@@ -1421,16 +1423,8 @@ int aa_change_profile(const char *fqname, int flags)
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
@@ -1442,6 +1436,17 @@ int aa_change_profile(const char *fqname, int flags)
 		error = aa_set_current_onexec(target, stack);
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
 			aa_audit_file(profile, &perms, op, request, auditname,
-- 
2.53.0



