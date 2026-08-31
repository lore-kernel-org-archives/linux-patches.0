Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBE0583AA0;
	Mon, 31 Aug 2026 13:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184200; cv=none; b=BXTX5FFAdLESOaKqsyhNQvjf6aeahjqkkZn5WtML7WNsrRDpDPwYFmf6WthHEoA8gw/T1qLJ9lslVGeE/X7Xzv5MRtbWrUMJCSgwuhFy7kcAeUMbITKNjjAHX+AdTh56rLHi7TwzWzKZjZ1yuImIB39rroDzDd9EOXKjps/rPCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184200; c=relaxed/simple;
	bh=B3t1wNh3Sg8WJU0VgzMQQ6H2XtCbrLJ1CtqSO/yBkmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bLP8u2SubQsRNIt4BTCz5AgkzTnfjNUoCa2rJNN6ERbx7EZ5Uuhkc8HCTqlhKTs5EyDgnDsdisOucFAlaou5lOzX/HCcO3h6S083jIVVHoCh3fYsFhI+VcwIsgN9szD8zjqA8kNCa4N1Gf/ErSxd4txAd6+A9sfYfJyJ2mQvWAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TEg+QCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TEg+QCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BD61F00A3F;
	Mon, 31 Aug 2026 13:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184199;
	bh=JZqqcfnE/gENfb2JVaLzpk79XeG8WsI8vVbkZY2pMes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2TEg+QCRmiaYmf+xWbUOlp29xk2QVAINaoIA1KD4tI188r0qUh/mcX+b/Q3i+dCMu
	 aiF3JTZQw4z/upfgdtrOSm/yqC3CEI6T5kBL2xTzfOkxoDMwxtro9GesIcznjui4by
	 UqG12WaxP5xgmORM5oLXk1M5kbZLo2lfrYcqHFLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Paul Moore <paul@paul-moore.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 09/99] selinux: avoid unnecessary indirection in struct level_datum
Date: Mon, 31 Aug 2026 15:33:38 +0200
Message-ID: <20260831133400.269545097@linuxfoundation.org>
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

[ Upstream commit 749153636643aaa793f14e84e864fdaf5ed0620d ]

Store the owned member of type struct mls_level directly in the parent
struct instead of an extra heap allocation.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
(cherry picked from commit 749153636643aaa793f14e84e864fdaf5ed0620d)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/ss/mls.c      |  6 +++---
 security/selinux/ss/policydb.c | 19 ++++++-------------
 security/selinux/ss/policydb.h |  2 +-
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
index 989c809d310d6..a6e49269f5351 100644
--- a/security/selinux/ss/mls.c
+++ b/security/selinux/ss/mls.c
@@ -171,7 +171,7 @@ int mls_level_isvalid(struct policydb *p, struct mls_level *l)
 	 * levdatum->level->cat and no bit in l->cat is larger than
 	 * p->p_cats.nprim.
 	 */
-	return ebitmap_contains(&levdatum->level->cat, &l->cat,
+	return ebitmap_contains(&levdatum->level.cat, &l->cat,
 				p->p_cats.nprim);
 }
 
@@ -289,7 +289,7 @@ int mls_context_to_sid(struct policydb *pol, char oldc, char *scontext,
 		levdatum = symtab_search(&pol->p_levels, sensitivity);
 		if (!levdatum)
 			return -EINVAL;
-		context->range.level[l].sens = levdatum->level->sens;
+		context->range.level[l].sens = levdatum->level.sens;
 
 		/* Extract category set. */
 		while (next_cat != NULL) {
@@ -456,7 +456,7 @@ int mls_convert_context(struct policydb *oldp, struct policydb *newp,
 
 		if (!levdatum)
 			return -EINVAL;
-		newc->range.level[l].sens = levdatum->level->sens;
+		newc->range.level[l].sens = levdatum->level.sens;
 
 		ebitmap_for_each_positive_bit(&oldc->range.level[l].cat, node,
 					      i)
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 27407cb6f18a8..449458edec732 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -296,9 +296,7 @@ static int sens_destroy(void *key, void *datum, void *p)
 	kfree(key);
 	if (datum) {
 		levdatum = datum;
-		if (levdatum->level)
-			ebitmap_destroy(&levdatum->level->cat);
-		kfree(levdatum->level);
+		ebitmap_destroy(&levdatum->level.cat);
 	}
 	kfree(datum);
 	return 0;
@@ -630,11 +628,11 @@ static int sens_index(void *key, void *datum, void *datap)
 	p = datap;
 
 	if (!levdatum->isalias) {
-		if (!levdatum->level->sens ||
-		    levdatum->level->sens > p->p_levels.nprim)
+		if (!levdatum->level.sens ||
+		    levdatum->level.sens > p->p_levels.nprim)
 			return -EINVAL;
 
-		p->sym_val_to_name[SYM_LEVELS][levdatum->level->sens - 1] = key;
+		p->sym_val_to_name[SYM_LEVELS][levdatum->level.sens - 1] = key;
 	}
 
 	return 0;
@@ -1644,12 +1642,7 @@ static int sens_read(struct policydb *p, struct symtab *s, struct policy_file *f
 	if (rc)
 		goto bad;
 
-	rc = -ENOMEM;
-	levdatum->level = kmalloc(sizeof(*levdatum->level), GFP_KERNEL);
-	if (!levdatum->level)
-		goto bad;
-
-	rc = mls_read_level(levdatum->level, fp);
+	rc = mls_read_level(&levdatum->level, fp);
 	if (rc)
 		goto bad;
 
@@ -2870,7 +2863,7 @@ static int sens_write(void *vkey, void *datum, void *ptr)
 	if (rc)
 		return rc;
 
-	rc = mls_write_level(levdatum->level, fp);
+	rc = mls_write_level(&levdatum->level, fp);
 	if (rc)
 		return rc;
 
diff --git a/security/selinux/ss/policydb.h b/security/selinux/ss/policydb.h
index e01de17e569bf..e7a6f1a6c1461 100644
--- a/security/selinux/ss/policydb.h
+++ b/security/selinux/ss/policydb.h
@@ -126,7 +126,7 @@ struct user_datum {
 
 /* Sensitivity attributes */
 struct level_datum {
-	struct mls_level *level; /* sensitivity and associated categories */
+	struct mls_level level; /* sensitivity and associated categories */
 	unsigned char isalias; /* is this sensitivity an alias for another? */
 };
 
-- 
2.53.0



