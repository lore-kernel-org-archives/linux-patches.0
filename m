Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6F15111BC;
	Mon, 31 Aug 2026 13:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183924; cv=none; b=h9z14sdJ+SlNe3lDxGXNzA0dDVY/qfhBVWmRVcA1OkzAuGOXKDyMvH5gtHBzrfzGqO2eb5dCTgJCb7C+m9Iu6PvQDvNDUb/VhTd5pBR73ImufU/yuI1paqY1P7TL7I57KXCnTw55nLlXRzi2Top8s84QkMKcPiVu/t/eQjukEpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183924; c=relaxed/simple;
	bh=JVJV+XriG2d8cgneJ7WqQvEdRgb6ZoNrxJw5uLznhjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pztCemewij8xiktGtkZwR4gQc4cIMFKzPYhZzZfhkN5JtWuAAR1Qhe9QASo5pnsuuCpQO82Sb3ja5PvHA5+Nte8AYGkRhvqKcJNHbS5cAIUSiwrh3Z+zEDkbhy2IilCvjgQztNyil0ymWxF5WWMJVAEiirYr9iwi2eXa67xu0ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2o5f/4D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2o5f/4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548451F00A3E;
	Mon, 31 Aug 2026 13:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183920;
	bh=eD3ZXV/PY4aWAcPpqvS1L3R1N0aIx4bVFVwAjJ05F54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2o5f/4DHENxVtBw+5n4sTEnFJ20G4Bv3gvXT4OQiIvPt+quLWCHkAHeuTVj0Ihxh
	 p4IKSoWaori319U8aPBaNTKmWI++L+/bDEntkG1kEdmv/lVyGtugcxnlPvRtQrGwyN
	 McTXYvEkz57DUwGNny5qdgyQWuulI4ox/ODulOdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 12/83] selinux: require a classs permission values to cover its permission count
Date: Mon, 31 Aug 2026 15:33:48 +0200
Message-ID: <20260831133359.794770393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit b98a8ac50775540f3804397ed08f61ef9910bcab ]

security_get_permissions() sizes an array by the class's permissions.nprim
and fills it at value - 1, from the inherited common's permission table and
then the class's own. A value no permission defines leaves a NULL that
sel_make_perm_files() passes to d_alloc_name(), an oops inside
sel_write_load() that strands selinux_state.policy_mutex and leaves every
later load in uninterruptible sleep; two permissions sharing a value
overwrite the first kstrdup(). Bounding each value by nprim catches
neither, and neither would a count: the symbol table is keyed on the
permission name, so duplicates pass.

Track the values each permission table claims and require them to cover
exactly what its count declares, rejecting a count no value can reach.
Conforming policies are unaffected.

Cc: stable@vger.kernel.org
Fixes: 55fcf09b3fe4 ("selinux: add support for querying object classes and permissions from the running policy")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
(cherry picked from commit b98a8ac50775540f3804397ed08f61ef9910bcab)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/ss/policydb.c | 51 ++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 5 deletions(-)

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 926dae3731a0d..483d7d54642a3 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1139,7 +1139,18 @@ int str_read(char **strp, gfp_t flags, struct policy_file *fp, u32 len)
 	return 0;
 }
 
-static int perm_read(struct policydb *p, struct symtab *s, struct policy_file *fp)
+/*
+ * Bitmap of the permission values a symtab has claimed.  Values are 1-based
+ * and bounded by SEL_VEC_MAX, the width of an access vector, so the whole set
+ * fits in a u32 and the callers reject an nprim past that width.
+ */
+static u32 perm_claimed_mask(u32 nprim)
+{
+	return nprim ? U32_MAX >> (SEL_VEC_MAX - nprim) : 0;
+}
+
+static int perm_read(struct policydb *p, struct symtab *s,
+		     struct policy_file *fp, u32 *claimed)
 {
 	char *key = NULL;
 	struct perm_datum *perdatum;
@@ -1163,6 +1174,10 @@ static int perm_read(struct policydb *p, struct symtab *s, struct policy_file *f
 	/* indexes an nprim-sized array in security_get_permissions() */
 	if (perdatum->value > s->nprim)
 		goto bad;
+	/* two permissions cannot share one slot of that array */
+	if (*claimed & (1U << (perdatum->value - 1)))
+		goto bad;
+	*claimed |= 1U << (perdatum->value - 1);
 
 	rc = str_read(&key, GFP_KERNEL, fp, len);
 	if (rc)
@@ -1183,7 +1198,7 @@ static int common_read(struct policydb *p, struct symtab *s, struct policy_file
 	char *key = NULL;
 	struct common_datum *comdatum;
 	__le32 buf[4];
-	u32 i, len, nel;
+	u32 i, len, nel, claimed = 0;
 	int rc;
 
 	comdatum = kzalloc(sizeof(*comdatum), GFP_KERNEL);
@@ -1205,17 +1220,28 @@ static int common_read(struct policydb *p, struct symtab *s, struct policy_file
 	if (rc)
 		goto bad;
 	comdatum->permissions.nprim = le32_to_cpu(buf[2]);
+	/* no permission value can reach a slot past SEL_VEC_MAX */
+	rc = -EINVAL;
+	if (comdatum->permissions.nprim > SEL_VEC_MAX)
+		goto bad;
 
 	rc = str_read(&key, GFP_KERNEL, fp, len);
 	if (rc)
 		goto bad;
 
 	for (i = 0; i < nel; i++) {
-		rc = perm_read(p, &comdatum->permissions, fp);
+		rc = perm_read(p, &comdatum->permissions, fp, &claimed);
 		if (rc)
 			goto bad;
 	}
 
+	rc = -EINVAL;
+	if (claimed != perm_claimed_mask(comdatum->permissions.nprim)) {
+		pr_err("SELinux:  common %s does not define every permission it declares\n",
+		       key);
+		goto bad;
+	}
+
 	hash_eval(&comdatum->permissions.table, "common_permissions", key);
 
 	rc = symtab_insert(s, key, comdatum);
@@ -1351,7 +1377,7 @@ static int class_read(struct policydb *p, struct symtab *s, struct policy_file *
 	char *key = NULL;
 	struct class_datum *cladatum;
 	__le32 buf[6];
-	u32 i, len, len2, ncons, nel, val;
+	u32 i, len, len2, ncons, nel, val, claimed = 0, inherited = 0;
 	int rc;
 
 	cladatum = kzalloc(sizeof(*cladatum), GFP_KERNEL);
@@ -1379,6 +1405,10 @@ static int class_read(struct policydb *p, struct symtab *s, struct policy_file *
 	if (rc)
 		goto bad;
 	cladatum->permissions.nprim = le32_to_cpu(buf[3]);
+	/* no permission value can reach a slot past SEL_VEC_MAX */
+	rc = -EINVAL;
+	if (cladatum->permissions.nprim > SEL_VEC_MAX)
+		goto bad;
 
 	ncons = le32_to_cpu(buf[5]);
 
@@ -1413,11 +1443,22 @@ static int class_read(struct policydb *p, struct symtab *s, struct policy_file *
 		}
 	}
 	for (i = 0; i < nel; i++) {
-		rc = perm_read(p, &cladatum->permissions, fp);
+		rc = perm_read(p, &cladatum->permissions, fp, &claimed);
 		if (rc)
 			goto bad;
 	}
 
+	/* the class's own permissions must claim the slots the common leaves */
+	if (cladatum->comdatum)
+		inherited = cladatum->comdatum->permissions.nprim;
+	rc = -EINVAL;
+	if (claimed != (perm_claimed_mask(cladatum->permissions.nprim) &
+			~perm_claimed_mask(inherited))) {
+		pr_err("SELinux:  class %s does not define every permission it declares\n",
+		       key);
+		goto bad;
+	}
+
 	hash_eval(&cladatum->permissions.table, "class_permissions", key);
 
 	rc = read_cons_helper(p, &cladatum->constraints, ncons, 0, fp);
-- 
2.53.0



