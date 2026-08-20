Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB31360EF6;
	Thu, 20 Aug 2026 15:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238057; cv=none; b=n9C/yeF1yot3pn9Il+Q8HCLxcDGAna+3d5rYpMi4GiYfEDo9NxW2XoTmMZE9Nd4v2jDO8tMcTckq3z3LQJFd/KKcIFP1yp8W15neTNx3ppO4JQcJ8cSYc7cCZdgOPgtxi2QkEsEhf0skMn0L02boPFNG0bLarAdIvBz+jFCk8Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238057; c=relaxed/simple;
	bh=jNbNtTh+gK2RfzqBaGt7BZEpABO8l60sIc82k7zE75w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVr5HwXGKaXwQgnN6dTlSzTJTVEV6xVaYBotuK8O+uvS9se0ZJowhnNn3qtgImaoa7cM2lhT4mMQ//U6k3wd7o6U8egmH6FHps1HaH7F/3lPkAmfVB5w+skit2LW4aCGDZI8Mt2v8HwPlnjQVfPoycHciaB5/C0SKhptaovl9TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGUQDsM3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGUQDsM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5861F000E9;
	Thu, 20 Aug 2026 15:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238055;
	bh=YOgWofllrX3sshLaKf0P+V7xFJ+xaG8zmI0fGuYgRtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGUQDsM3Gc2I9NdEZe1B2aqNdtGNVUHTmqDdwV9UU/tTF9Nm3EcMcWLXO8hy6I5ux
	 p+bdGe46PPSA36mnzF96p3xeiZlLn2W2YLkjvNsYbGI8/i5qrqiZytcZ5mOiuPIutt
	 YdPwXs3BcZdCubt5Rp1S/fW/yPJTkmFhIPr+jlUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.1 005/228] selinux: reject an unclaimed class value in security_get_classes()
Date: Thu, 20 Aug 2026 16:52:27 +0200
Message-ID: <20260820145244.628864298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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
@@ -3303,6 +3303,7 @@ int security_get_classes(struct selinux_
 			 char ***classes, u32 *nclasses)
 {
 	struct policydb *policydb;
+	u32 i;
 	int rc;
 
 	policydb = &policy->policydb;
@@ -3315,16 +3316,29 @@ int security_get_classes(struct selinux_
 
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


