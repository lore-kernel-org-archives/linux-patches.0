Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D373307492;
	Thu, 20 Aug 2026 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247410; cv=none; b=lTh2YxnQop0rR7+QqtLlmJwWiAIgH8Jh6Tefk813sw1H7pW83HwpfgBHFf39S4sfJDJH7vdmXkaj/QOamOvizh7qGX56ZgD/hSVJOfBuvxQfiCQM/SEddvS4hIzoCSqTEXypJo0O1QhLQiW6kKB3qQN3eMTPTuarYid+0kGKiiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247410; c=relaxed/simple;
	bh=Mn90stEmXLi4D7xAHd1FFSTgQkbxuclnfv/wjh1UaZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0rXhAVsaaXqjPVHMPHcx8joPlHAdo5xiZ4V6WYFS1X/EEl23bOcADvxzckMNalR1+V/1/ydOfblz6rtC0K+Wo31D9f0BQeEa0btH11wcFsqFklB8CyF5m3IstzOAV0VgaoO0dADu1UgydrhcCZbaGdQlMQL9JCqVLfg9nWD2yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmWwi699; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmWwi699"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985A61F000E9;
	Thu, 20 Aug 2026 17:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247409;
	bh=m85/85iFwwjBv471B6rifslAfWeHadQO1HG03A11roM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmWwi699enCwglYQKvzzgae/iW20BWK7VH9l6GHry9czRFUqfR0GYlfSAetKG9tOT
	 R0A8fy8SOVbCjbRAb+0SBlyd4uvXhIqCZACqG0D0+y3A8ygw2iBDLdb/XcARfgJk4h
	 jzYAFEm2MrU4WFCnM2NKSzxozsnktaq6dwpBdbtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 008/166] selinux: reject an unclaimed class value in security_get_classes()
Date: Thu, 20 Aug 2026 16:54:27 +0200
Message-ID: <20260820145211.444978560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 22b05fec62c0fe9864cfceb52f7d0f3a34d9b1dd upstream.

security_get_classes() sizes an array by p_classes.nprim and fills it at
value - 1, so a class value the policy never defines leaves a NULL.
sel_make_classes() passes every entry to sel_make_dir(), reaching the same
d_alloc_name() dereference as the permission array. The class symbol table
is allowed to be sparse (policydb_class_isvalid() exists to absorb that),
but this getter builds its own array straight from the hash table and has
no such predicate.

Fail the lookup when a value went unclaimed instead of handing out the
NULL. Conforming policies define every class they declare and are
unaffected.

Cc: stable@vger.kernel.org
Fixes: 55fcf09b3fe4 ("selinux: add support for querying object classes and permissions from the running policy")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/services.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -3349,6 +3349,7 @@ int security_get_classes(struct selinux_
 			 char ***classes, u32 *nclasses)
 {
 	struct policydb *policydb;
+	u32 i;
 	int rc;
 
 	policydb = &policy->policydb;
@@ -3361,16 +3362,29 @@ int security_get_classes(struct selinux_
 
 	rc = hashtab_map(&policydb->p_classes.table, get_classes_callback,
 			 *classes);
-	if (rc) {
-		u32 i;
+	if (rc)
+		goto err;
 
-		for (i = 0; i < *nclasses; i++)
-			kfree((*classes)[i]);
-		kfree(*classes);
+	/*
+	 * The class symtab may be sparse, which policydb_class_isvalid() exists
+	 * to absorb; the callback fills this array by value, so an unclaimed
+	 * one leaves a NULL that sel_make_classes() hands to sel_make_dir().
+	 */
+	for (i = 0; i < *nclasses; i++) {
+		if (!(*classes)[i]) {
+			rc = -EINVAL;
+			goto err;
+		}
 	}
 
 out:
 	return rc;
+
+err:
+	for (i = 0; i < *nclasses; i++)
+		kfree((*classes)[i]);
+	kfree(*classes);
+	return rc;
 }
 
 static int get_permissions_callback(void *k, void *d, void *args)


