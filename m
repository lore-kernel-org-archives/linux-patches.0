Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E304AF17A;
	Mon, 31 Aug 2026 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184158; cv=none; b=qBqy0czbSjFHCIsfuZpWcb3ddG+TQ8Yd/ZdbrenoKF61DGFrpl7ruOEe7iKAsMMJ7suTyG1UwsZ2MtRK0SFNZ1m6YMQ4UmrGLvBXt9RRqNYD+4VQFyp7rOxumpYB+FXM3afMIAhAbQ1134cEoyPSqP/9DBZtR0GSUl1HxijKdvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184158; c=relaxed/simple;
	bh=VFiICGeFoEZM86vw7YipREWQcAPiIQuRqASHao4SHNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CV5dRgMKq0/wdgi9DX3/XQCohyYFc90H9FbQeMqXfHGgTKyQnG1zyYWEra+3E3Ykno1RrzZo9GHCicosB3BE/eYh39mPgE/egBivZ+u6VPGyc3PvZ8yrHJYvC5s1TfA82Y7U+xB9q04iD0A3xcvJtKTnMGFGai/ok4gh7I66uow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIePm5hc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIePm5hc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948C71F00A3D;
	Mon, 31 Aug 2026 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184156;
	bh=ZU4IN55dXPbez02gvT6c0U5NpO1GFYVvPgYTZn/ZKoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VIePm5hcd+sOJWsXlY0FUgiWyAt8rhRiHmRw/oCfZr4KHpVkMfu4WE5xoIbMMa2aL
	 LoJpPbeRlW7VEVj5bp4YwMfgh8sOFBI3+Rxay5QDn/FZpDUy7PsuL60VVeqX/lV+sZ
	 MXEhDAdbcuRXvyPmuOJpvDCFcrhmV/evBaczSPN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Paul Moore <paul@paul-moore.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 10/99] selinux: make more use of str_read() when loading the policy
Date: Mon, 31 Aug 2026 15:33:39 +0200
Message-ID: <20260831133400.332337930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Göttsche <cgzones@googlemail.com>

[ Upstream commit 01c2253a0fbdccb58cd79d4ff9ab39964bfb4474 ]

Simplify the call sites, and enable future string validation in a single
place.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
[PM: subject tweak]
Signed-off-by: Paul Moore <paul@paul-moore.com>
(cherry picked from commit 01c2253a0fbdccb58cd79d4ff9ab39964bfb4474)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/ss/conditional.c | 10 ++--------
 security/selinux/ss/policydb.c    | 22 ++++++++--------------
 security/selinux/ss/policydb.h    |  2 ++
 3 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/security/selinux/ss/conditional.c b/security/selinux/ss/conditional.c
index 244dc82791133..f8a21d10ff929 100644
--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -230,17 +230,11 @@ int cond_read_bool(struct policydb *p, struct symtab *s, struct policy_file *fp)
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
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 449458edec732..db200b7518fc7 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1107,7 +1107,7 @@ static int context_read_and_validate(struct context *c, struct policydb *p,
  * binary representation file.
  */
 
-static int str_read(char **strp, gfp_t flags, struct policy_file *fp, u32 len)
+int str_read(char **strp, gfp_t flags, struct policy_file *fp, u32 len)
 {
 	int rc;
 	char *str;
@@ -2499,24 +2499,18 @@ int policydb_read(struct policydb *p, struct policy_file *fp)
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
diff --git a/security/selinux/ss/policydb.h b/security/selinux/ss/policydb.h
index e7a6f1a6c1461..d95a3941f327c 100644
--- a/security/selinux/ss/policydb.h
+++ b/security/selinux/ss/policydb.h
@@ -386,6 +386,8 @@ static inline char *sym_name(struct policydb *p, unsigned int sym_num,
 	return p->sym_val_to_name[sym_num][element_nr];
 }
 
+extern int str_read(char **strp, gfp_t flags, struct policy_file *fp, u32 len);
+
 extern u16 string_to_security_class(struct policydb *p, const char *name);
 extern u32 string_to_av_perm(struct policydb *p, u16 tclass, const char *name);
 
-- 
2.53.0



