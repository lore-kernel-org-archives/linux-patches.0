Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C3B380FC7;
	Thu, 20 Aug 2026 15:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239467; cv=none; b=C+sD0supIxMyQbZKlqXrmruA6KPFKZkVoVgN6ggoSG0TZ2C7FuPEgmqEk0Be6EqX7TbUaEa5PW0W4y0SXiVEK8xTJwW3cybVZDqaX5PySacPSI5L4Yi9t+qV5VVssRmT81lOPRXLaMj8rrRFdRNr3IY/LOn6Do7uiqtAdfpmMiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239467; c=relaxed/simple;
	bh=4XVq4zzr6s4rC4JfZlbjsdfD/Jf6awb6kzgPNT8l8VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txPR0nImLuE3cN4ZsP1Nh/Nq1Iih/Mplp5D3rJhnAwMA51e368QMK23w8GQlRsVa8TP5JZ0shfljk/gayKdcg0nP4QwOWRbD0LM0vQDH5MBtnhnzuzhiHGJ2TWPSsO4gvztRFky+z9bHHx0Y/ba+8qxubnXf6L7dhOEWnPCDA6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAUqb8SL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAUqb8SL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BB61F000E9;
	Thu, 20 Aug 2026 15:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239465;
	bh=EjwlgpaffHm7BXvf8IeefahH/ZOFJoe/9gcjGJgJOK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JAUqb8SLCELsLIKI1pccdOeuGR3TczaFYIIklg1K4/mqihttVyLBmDO+Ti10e5bHt
	 YzWeUswQNxRcKx0whOJEAeZPmsfPkQSsO2YtjGbfSMYzxpfNzA2gq4q3A23CiN9nRB
	 0kM02CbxSVO+sp1vvdmc6KyUhOpFIo9waxCuEeck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.12 019/220] selinux: reject an unclaimed class value in security_get_classes()
Date: Thu, 20 Aug 2026 16:53:29 +0200
Message-ID: <20260820145224.081554571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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
@@ -3367,6 +3367,7 @@ int security_get_classes(struct selinux_
 			 char ***classes, u32 *nclasses)
 {
 	struct policydb *policydb;
+	u32 i;
 	int rc;
 
 	policydb = &policy->policydb;
@@ -3379,16 +3380,29 @@ int security_get_classes(struct selinux_
 
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


