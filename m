Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFC52D0C94;
	Sat, 12 Sep 2026 19:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241775; cv=none; b=MXEQ+ULKQgUmUjXAUGrxXweKa3knOY3StwzFBgARnvGr0IKt5Re1VAB97z8PEBxSa8bMMmNemty/szOYkwiJ1DVSSPA+JdaiRMHEvcz62TJIDOrs8rEZx078c0yeL4uE9Dr+sbfh5HPUlgagXi0c/GNH+g106k+KFcvELM7VrQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241775; c=relaxed/simple;
	bh=gETyrVMtIjD6Nvx7inT1ZWI1nCgMHClRShbe9tB/bLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPYIZ4cCDpd8wzzq4LyxdXE6BOVyo9RgFAGW2J7AoFzM7Xfw1eBnHs6yedQlBxTRcYvObhxTeuhZNAIuTQ3dQQnQDF32r5f+FigxV+7eFKqG9KLGevzb8emKt1foFTza7w26qK98dYU7J4B/xaYPA7n14cS8+AjB2CFzucKxRi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LT8LYHGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LT8LYHGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE171F00893;
	Sat, 12 Sep 2026 19:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241770;
	bh=tsonptyexRUXoC2ycWs64CTHMejo9yiN1DXl2rabgyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LT8LYHGmWSmCVN2DO3VnDxFHURWWK7h//8kMUDfo9A7lvdU3SyXA5Iuw7TcdoPFYz
	 JfoqunjwnEqp4qx5kgetKHMwA1mV8TUMSEAdMGk8uWG99K9fGsfHkwHS0pIli+VTOG
	 MciuqB58BD7f5/LQCUjvb723Jm/5PcDlK+KVy8cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Alexander Martyniuk <alexevgmart@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 205/798] selinux: reject an unclaimed class value in security_get_classes()
Date: Sat, 12 Sep 2026 08:57:13 +0200
Message-ID: <20260912065521.791411412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/ss/services.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 446df456b0f16..0f81c5946397c 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -3394,6 +3394,7 @@ int security_get_classes(struct selinux_policy *policy,
 			 char ***classes, u32 *nclasses)
 {
 	struct policydb *policydb;
+	u32 i;
 	int rc;
 
 	policydb = &policy->policydb;
@@ -3406,16 +3407,29 @@ int security_get_classes(struct selinux_policy *policy,
 
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
-- 
2.53.0



