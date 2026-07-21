Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7BA47012C;
	Tue, 21 Jul 2026 19:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660603; cv=none; b=AZ9+bTvvFMI0wPD4KOGUF+xXUu2a9uiWz3AM+ztrFN5XZZdYE9VygoR71N9y5nduV4uKaDqsDeuFGf90+9XfVTf5/+fP23uQQNODfWT2Ga8luJT4vLEpWhOuwsx3mnmoEwA09w30O+Yl88zPzcVQbehC733w6eoUP9aMitlv9pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660603; c=relaxed/simple;
	bh=sCeSlGeXDZXHCXXqyxJgwbbxKrOKnVauKuQuE59f2vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkEJSC26ZLF4uHujypCN25CK3CgI/GkTaiKgZKmUSX2JAmU9bFOMsPBfgJMvaQQbYBYLpR0J8WJsv1TjpiOB6dCO+KWcenhH5j7uuuu0Db/RVxi6Ng+/OKApMN6VnpA2dz897smsKOJ6ZWxHy8tO5RV/YVYBn2uTLLbyiwXzlRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJC4NAyN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJC4NAyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC3C1F000E9;
	Tue, 21 Jul 2026 19:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660600;
	bh=SAiyQWODTY/DKvA1q8CSAzWlwxL3FXsKjDAuC/JtiNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJC4NAyN0S7VJrPyEn1nvX5KL/tqA16XEbfYnvzqpUk3D8ZEDF4lbE5m6FgOmIPog
	 20OzMymTZynnUBGzo0SoqCV+J2LYP2SPlMpyHBM3v/XfTYZQ+upAKzsd16UnsJNUv0
	 Gr5uRR80iHDEM+gNgbOlVpnoCxc20MTmG+It+b2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1040/2077] apparmor: check label build before no_new_privs test
Date: Tue, 21 Jul 2026 17:11:53 +0200
Message-ID: <20260721152617.343795960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index f02bf770f63854..6748ac74b060bd 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -1527,6 +1527,8 @@ int aa_change_profile(const char *fqname, int flags)
 		new = fn_label_build_in_scope(label, profile, GFP_KERNEL,
 					   aa_get_label(target),
 					   aa_get_label(&profile->label));
+		if (IS_ERR_OR_NULL(new))
+			goto build_fail;
 		/*
 		 * no new privs prevents domain transitions that would
 		 * reduce restrictions.
@@ -1545,16 +1547,8 @@ int aa_change_profile(const char *fqname, int flags)
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
@@ -1566,6 +1560,17 @@ int aa_change_profile(const char *fqname, int flags)
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
 	error = fn_for_each_in_scope(label, profile,
 			aa_audit_file(subj_cred,
-- 
2.53.0



