Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24F943C7AE;
	Tue, 21 Jul 2026 22:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671916; cv=none; b=TcE2rP9JiSUWX9aI+u7Y7IGuJZ+wZvFdPm1U3giXEq++ognVI59OBF70CTM1baWjp9v70cxznvTkeBZCjhOsY0ywTANl8/SAX86JVLTHjGOACqEFd8uiYMfOfaz0oasF+337jE3ZF/QOo29wSpZoirVnNK2hQ0j81eg0isDLlcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671916; c=relaxed/simple;
	bh=h/4p6b8dcqUAqRTfkztNaKdK0VFeCS6Z3+ynexLXYyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIZrmwFIJZExi5DOnkety2bVCzICKM1dtncJUvp0uXe1WPZZChp0Z0FgJKzdMDLz2dWwNN7BaVaMUh8fi/IwVgscYUI4XBJCmte79QQ9hOQv4ajtd3gacrK0Oa32gSMK503c00uopI264mM/ucTtB3JVTsqjZ2c5UdRgjM4cGoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnHZUqNV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnHZUqNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507221F000E9;
	Tue, 21 Jul 2026 22:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671914;
	bh=Ljs44xEHLoTlap7kTrBVvWXQfUhVmDYSUi6OeZ+tKBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xnHZUqNVtG/VncqK7OOwl5ilpn0xu5ZJPtSDJQxEz5ad7BKfpUpsj9SHKlhXgC8CU
	 H1t66uI1OUh3TO4r9t2t77ulVyf2lF8Yoxv7iOrE/THoyDmeuI2Ux/XpVry9e5Z+te
	 5YuVgd8TRX+r6fdU2FeENxSfKTlCbTDJnKS6xttU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 427/843] apparmor: check label build before no_new_privs test
Date: Tue, 21 Jul 2026 17:21:02 +0200
Message-ID: <20260721152415.639519601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a7b3d8e58ed83e..ec262513aedffd 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -1407,6 +1407,8 @@ int aa_change_profile(const char *fqname, int flags)
 		new = fn_label_build_in_ns(label, profile, GFP_KERNEL,
 					   aa_get_label(target),
 					   aa_get_label(&profile->label));
+		if (IS_ERR_OR_NULL(new))
+			goto build_fail;
 		/*
 		 * no new privs prevents domain transitions that would
 		 * reduce restrictions.
@@ -1424,16 +1426,8 @@ int aa_change_profile(const char *fqname, int flags)
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
@@ -1445,6 +1439,17 @@ int aa_change_profile(const char *fqname, int flags)
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



