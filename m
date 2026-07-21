Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5403B776C;
	Tue, 21 Jul 2026 21:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669437; cv=none; b=M/rlkJfF0C1JLT6xLo1JXfWBssat8xsxjxLPl6eT/qeojOVfgYZnnFf0FflqeFu7SHtfTUibn6XWTP9g5Fp59uNy7Klqv9oASueE8yxsKvwONeKkKCs2VHFHb5QbNWaOLGNMMcyZmFUKQ+t+U7+JUs/UAmldZi2jiGxKTJuyeHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669437; c=relaxed/simple;
	bh=T24mauHkFd4o1CuUMsyLAG6LrQG/XIkRUd5c4AN5ayI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exXE+K2ecY44Xl+BQ70DzTTjfuwnosbkB26B4ivoKItOJ61/HhdAhZuxRBlSs18052U/LjWI9r1HBt9VpOS81VVnkpoLpW2RpR7vjAF7TOht+vpPIpiEL8Fy+KuxwBxY2iifcyrUtaTDdYO/kY4drDm9o2xVeLCmHWELzkI1FqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nc2OZUhY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nc2OZUhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A9C1F000E9;
	Tue, 21 Jul 2026 21:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669435;
	bh=+sNX9lxlFra6H3S5i09KocTI8jEYY5gcIg1X4BJFdm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nc2OZUhYR2jxwBgA0Eaosgy656R66z4fwOvgUfSIqFaccG0CplLmCLx5LhLuFMVoy
	 N74gzupyWr2NXwku62KyG5THI2RgLTazpgGlMPCyY9y8uS9XGN/Vd55H0dIafqBh83
	 JqW9JXcfmhnqcK7JUQ1l9jyF31x9irL8ZbJJ4GC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0553/1067] apparmor: check label build before no_new_privs test
Date: Tue, 21 Jul 2026 17:19:14 +0200
Message-ID: <20260721152436.980007068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index 91689d34d2811d..b4fa5abd60667c 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -1405,6 +1405,8 @@ int aa_change_profile(const char *fqname, int flags)
 		new = fn_label_build_in_ns(label, profile, GFP_KERNEL,
 					   aa_get_label(target),
 					   aa_get_label(&profile->label));
+		if (IS_ERR_OR_NULL(new))
+			goto build_fail;
 		/*
 		 * no new privs prevents domain transitions that would
 		 * reduce restrictions.
@@ -1422,16 +1424,8 @@ int aa_change_profile(const char *fqname, int flags)
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
@@ -1443,6 +1437,17 @@ int aa_change_profile(const char *fqname, int flags)
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



