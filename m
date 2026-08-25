Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0AB3FAE19;
	Tue, 25 Aug 2026 13:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665820; cv=none; b=n/P3++voBitMS9z/wffBHF2iFJsQotkgOvjdiF6L/xfrFw4rB9jve9jz5i740BEodESfF7TnPYDbBK+mGltCFJuHrmwfY2llcdMyjGhnHVMMWVS/mXxSJkgmPUzW8EVhkLoA8RB6eq3c2AZbv3+LoWsDmnlo+5yXnHxQR0nZOLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665820; c=relaxed/simple;
	bh=4/zTQzC/4bslbcWt7DqQ1LIdSkQzE50vbZa69bnfT28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IvcOwdr6n3GXRCjrrSwzNiTGiNYKX1PRrNl6IWHl7hUe2vCU5Fz47jdtU/7yW8KU+bDDn7izwKFLxZfDG+0sSz3qKlwK9vjsO0ZfsnC4pYVRKyPE+VCSukspVr84juwlRA2jX9ZrPw4buekKAbMpKxzVJoMGAo3CVctYZfGP6rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STu0RNDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STu0RNDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7BA1F00A3F;
	Tue, 25 Aug 2026 13:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665819;
	bh=UnYnNQ25ocaYAianSt0hVBOSHt6eCy76MH092tiyafM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STu0RNDBWElaX5D+iAEAaKt+Hsst11AjFuY9zGyk6PhMVeFfTEbFwy1dB8ky6gD+H
	 sQ8NEMaYgq62IEqsFR3YJHiqzVfioqjyotwn2qHlWi9WQm/8QXJwoVsq19emKpxdDu
	 fN7bzembPUmld3DWgjtbZBK4Y53nJ8oOyTMzfeuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 77/87] selinux: make more use of str_read() when loading the policy
Date: Tue, 25 Aug 2026 15:26:40 +0200
Message-ID: <20260825132544.851834238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Göttsche <cgzones@googlemail.com>

[ Upstream commit 01c2253a0fbdccb58cd79d4ff9ab39964bfb4474 ]

Simplify the call sites, and enable future string validation in a single
place.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
[PM: subject tweak]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Stable-dep-of: b98a8ac50775 ("selinux: require a class's permission values to cover its permission count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/conditional.c |   10 ++--------
 security/selinux/ss/policydb.c    |   22 ++++++++--------------
 security/selinux/ss/policydb.h    |    2 ++
 3 files changed, 12 insertions(+), 22 deletions(-)

--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -229,17 +229,11 @@ int cond_read_bool(struct policydb *p, s
 		goto err;
 
 	len = le32_to_cpu(buf[2]);
-	if (((len == 0) || (len == (u32)-1)))
-		goto err;
 
-	rc = -ENOMEM;
-	key = kmalloc(len + 1, GFP_KERNEL);
-	if (!key)
-		goto err;
-	rc = next_entry(key, fp, len);
+	rc = str_read(&key, GFP_KERNEL, fp, len);
 	if (rc)
 		goto err;
-	key[len] = '\0';
+
 	rc = symtab_insert(s, key, booldatum);
 	if (rc)
 		goto err;
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1079,7 +1079,7 @@ out:
  * binary representation file.
  */
 
-static int str_read(char **strp, gfp_t flags, struct policy_file *fp, u32 len)
+int str_read(char **strp, gfp_t flags, struct policy_file *fp, u32 len)
 {
 	int rc;
 	char *str;
@@ -2466,24 +2466,18 @@ int policydb_read(struct policydb *p, st
 		goto bad;
 	}
 
-	rc = -ENOMEM;
-	policydb_str = kmalloc(len + 1, GFP_KERNEL);
-	if (!policydb_str) {
-		pr_err("SELinux:  unable to allocate memory for policydb "
-		       "string of length %d\n",
-		       len);
-		goto bad;
-	}
-
-	rc = next_entry(policydb_str, fp, len);
+	rc = str_read(&policydb_str, GFP_KERNEL, fp, len);
 	if (rc) {
-		pr_err("SELinux:  truncated policydb string identifier\n");
-		kfree(policydb_str);
+		if (rc == -ENOMEM) {
+			pr_err("SELinux:  unable to allocate memory for policydb string of length %d\n",
+			       len);
+		} else {
+			pr_err("SELinux:  truncated policydb string identifier\n");
+		}
 		goto bad;
 	}
 
 	rc = -EINVAL;
-	policydb_str[len] = '\0';
 	if (strcmp(policydb_str, POLICYDB_STRING)) {
 		pr_err("SELinux:  policydb string %s does not match "
 		       "my string %s\n",
--- a/security/selinux/ss/policydb.h
+++ b/security/selinux/ss/policydb.h
@@ -386,6 +386,8 @@ static inline char *sym_name(struct poli
 	return p->sym_val_to_name[sym_num][element_nr];
 }
 
+extern int str_read(char **strp, gfp_t flags, struct policy_file *fp, u32 len);
+
 extern u16 string_to_security_class(struct policydb *p, const char *name);
 extern u32 string_to_av_perm(struct policydb *p, u16 tclass, const char *name);
 


