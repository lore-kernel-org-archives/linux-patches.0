Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5193841A92C;
	Tue, 25 Aug 2026 13:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665817; cv=none; b=HbMvQFPj4JsNf8D8ZbH3/2GVhwI++qOz0DLAgMegVnT1muvwqIVXTZPIAh0GXGY1n1HXJx97X2hTjCeHHpQkMuRK0qkPWaLiB0oQJ9P0msp5cXdOYfauO7il8RQQpuH7pQ+6ub+H52NzKNPt/NBUtgv2ysnoPQTSlYaoDuuflOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665817; c=relaxed/simple;
	bh=pglGF4beGXttMp0mZ6F/gQEBikpRUlE75z2mQYln19w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mikbnoOBX7F/Wtkj9jMIoKmxuan8TPbuAq07Gp5hhlWfsQeeiPzuZCIoEDtecbB8ttwDtOsnb4r7xGVPhyNkwMiy8v5aPLJD5b8Cjj+OjjduqtqsGGsq41vOJUG8DznIkSl87IafeSKOQW74CBpCSPoeByqRdv9dFq4BBIp9iAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkbm1kBL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkbm1kBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C0B1F000E9;
	Tue, 25 Aug 2026 13:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665816;
	bh=If7MmMDXHOJzX5AAdPcOhb4Fq+zirbuhEd1S7POFYoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kkbm1kBL26VnaxXnponYSaVVMeGeNdlP06Kd+bLMiRTANpzxurtVS0IBxVbQZFC/M
	 knCwVJHpsGDQRixlLuCfu8Xu8rSlNthwudbrlTGUcMr/jJbhWNKQmObAyOpqHLB1YW
	 qx9VhUh+0oygDAI/ev3aBQexMWGQr7dcllfzLSp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 76/87] selinux: avoid unnecessary indirection in struct level_datum
Date: Tue, 25 Aug 2026 15:26:39 +0200
Message-ID: <20260825132544.814585856@linuxfoundation.org>
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

[ Upstream commit 749153636643aaa793f14e84e864fdaf5ed0620d ]

Store the owned member of type struct mls_level directly in the parent
struct instead of an extra heap allocation.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Stable-dep-of: b98a8ac50775 ("selinux: require a class's permission values to cover its permission count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/mls.c      |    6 +++---
 security/selinux/ss/policydb.c |   19 ++++++-------------
 security/selinux/ss/policydb.h |    2 +-
 3 files changed, 10 insertions(+), 17 deletions(-)

--- a/security/selinux/ss/mls.c
+++ b/security/selinux/ss/mls.c
@@ -174,7 +174,7 @@ int mls_level_isvalid(struct policydb *p
 	 * levdatum->level->cat and no bit in l->cat is larger than
 	 * p->p_cats.nprim.
 	 */
-	return ebitmap_contains(&levdatum->level->cat, &l->cat,
+	return ebitmap_contains(&levdatum->level.cat, &l->cat,
 				p->p_cats.nprim);
 }
 
@@ -296,7 +296,7 @@ int mls_context_to_sid(struct policydb *
 		levdatum = symtab_search(&pol->p_levels, sensitivity);
 		if (!levdatum)
 			return -EINVAL;
-		context->range.level[l].sens = levdatum->level->sens;
+		context->range.level[l].sens = levdatum->level.sens;
 
 		/* Extract category set. */
 		while (next_cat != NULL) {
@@ -466,7 +466,7 @@ int mls_convert_context(struct policydb
 
 		if (!levdatum)
 			return -EINVAL;
-		newc->range.level[l].sens = levdatum->level->sens;
+		newc->range.level[l].sens = levdatum->level.sens;
 
 		ebitmap_for_each_positive_bit(&oldc->range.level[l].cat,
 					      node, i) {
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -296,9 +296,7 @@ static int sens_destroy(void *key, void
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
@@ -636,11 +634,11 @@ static int sens_index(void *key, void *d
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
@@ -1612,12 +1610,7 @@ static int sens_read(struct policydb *p,
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
 
@@ -2835,7 +2828,7 @@ static int sens_write(void *vkey, void *
 	if (rc)
 		return rc;
 
-	rc = mls_write_level(levdatum->level, fp);
+	rc = mls_write_level(&levdatum->level, fp);
 	if (rc)
 		return rc;
 
--- a/security/selinux/ss/policydb.h
+++ b/security/selinux/ss/policydb.h
@@ -126,7 +126,7 @@ struct user_datum {
 
 /* Sensitivity attributes */
 struct level_datum {
-	struct mls_level *level; /* sensitivity and associated categories */
+	struct mls_level level; /* sensitivity and associated categories */
 	unsigned char isalias; /* is this sensitivity an alias for another? */
 };
 


