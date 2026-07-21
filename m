Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74EC3B3C0A;
	Tue, 21 Jul 2026 20:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666589; cv=none; b=nQwqYxnvS7cAKq8FlU/CVPt/jcJ7nGWcLn6546gm1MWGQarFgDUAEy2eoFPtpXYTZC8EH1UnIfefnQUH4hpf6cOq9RnGd6LkfnY12diO1UdvBWrLMw0RyvLwKDHms7wNjCmgwktVCdh3qlFgltxSLMm8cLbRciPlmNakJ5solak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666589; c=relaxed/simple;
	bh=GfPdD0bmpbn8lfT9zQI6o8O8Xg/70xYxb8ie7yoj6yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBVZxCCIiQDK/K99/6gwS602EnPyZCNqB1ARa4+vvqu0Q0OEbtJlwByw//fuYCjuM2TGShn6iMv9BVguXP0Y0UouRx7MRxScTARDI7lIPO+C7IXFD7dcYDb8cF0vh6HYG9BgCbIB8pg/UpRtlspdw6vuJH20YWSJsaGkGZ03/uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnR0gR9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnR0gR9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335351F000E9;
	Tue, 21 Jul 2026 20:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666588;
	bh=jb0aRIZlQ17AlzNqzQdB8BPokd3Vc2L34gRVn9qNl1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnR0gR9ZyfnprUn3GpaFDZOD15vbXVE1v1I9GziJgEckCByKp+6dxc4iIaxF1dxKm
	 GAhaZ2O2UjjmUsOjsWavlEkfph6YaRpKKzVQG6OXqnmaBXPBwNkAny3R746i3DKtIS
	 b0ZodCw88BtAPGmrU7TKKrzeyO0nf1ljj/Opp2a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0697/1266] apparmor: check label build before no_new_privs test
Date: Tue, 21 Jul 2026 17:18:54 +0200
Message-ID: <20260721152457.455665292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index d6500ec4f6b636..7162088629c531 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -1440,6 +1440,8 @@ int aa_change_profile(const char *fqname, int flags)
 		new = fn_label_build_in_ns(label, profile, GFP_KERNEL,
 					   aa_get_label(target),
 					   aa_get_label(&profile->label));
+		if (IS_ERR_OR_NULL(new))
+			goto build_fail;
 		/*
 		 * no new privs prevents domain transitions that would
 		 * reduce restrictions.
@@ -1457,16 +1459,8 @@ int aa_change_profile(const char *fqname, int flags)
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
@@ -1478,6 +1472,17 @@ int aa_change_profile(const char *fqname, int flags)
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
 			aa_audit_file(subj_cred,
-- 
2.53.0



