Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D99E377A82;
	Thu, 20 Aug 2026 16:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243984; cv=none; b=pfqwFshsobRQtKFk4vhZ20Z7cyIM4VA+pWc+IPMzI/DMM4rd1h0j0pNdCPD9SgRimPJeZhFMaX2VfDMZgvKI0fanVuIv21KUoLTjUCedNQm0kh+KeRZfQmZhAA+2pA7f5k+h6lBnfEHLnqQKjKbb3VQvPQB2d4Aj0rpkBmR9Xp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243984; c=relaxed/simple;
	bh=neM2IOn0og+O91SWTBzoQWOd4qEoA93TBQ5NNvDAHP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hm3hT0U3KDQqbb/7ttc/ebW+QSruvkGE77NyYY2Kr3gYjwOPUTkUj/RjBMybst8S6slIARb9/SzVOWHoe9WruYULaT8kFZnzILiUBLbh7ig2rEPzugcdW6mMIx6skLDBzI6uEkAvvKjbluoFqoZRZCS8+H4PhlDmLRRYSy1Uayo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F86Q2VTL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F86Q2VTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A2E1F000E9;
	Thu, 20 Aug 2026 16:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243983;
	bh=xSfhBzEjiJcL/GAw4bRq4RkQ1PtQyna6a2MATGQEejw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F86Q2VTLR74A28Av+c/IryUuq3z0wtgEzfDD96h1mcRhE8ALVYRS+Tgdd4nvdc/4/
	 U6yjW8h7f7TTiBLMZBcV87JmbLm5wgiXIQBcJFM0Sd0XxOVJIhZfDLmsNqAMt3ejKu
	 59+OqltqHqxqlUoNgRtLC+C/tuG902dyrQBIyuRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 004/235] selinux: require every boolean value to be defined
Date: Thu, 20 Aug 2026 16:54:00 +0200
Message-ID: <20260820145216.571778224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

commit a93d37a09b863810653f93d371fb197457d59deb upstream.

p_bools.nprim comes from the policy image independently of how many
booleans follow it, and cond_index_bool() fills bool_val_to_struct[] at
value - 1, so a count larger than the values present leaves NULL entries.
Every user of that array then walks it by index and dereferences each
entry: cond_evaluate_expr() on the access-vector path,
security_get_bools() and security_get_bool_value() behind selinuxfs, and
security_set_bools(). A sparse class value is absorbed by
policydb_class_isvalid() and its siblings; booleans have no such
predicate, and no consumer that could use one.

Reject a boolean value that no boolean defines, once, where the array is
built. Conforming policies define every boolean they declare and are
unaffected.

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/policydb.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -718,6 +718,7 @@ static inline void hash_eval(struct hash
 static int policydb_index(struct policydb *p)
 {
 	int i, rc;
+	u32 v;
 
 	if (p->mls_enabled)
 		pr_debug("SELinux:  %d users, %d roles, %d types, %d bools, %d sens, %d cats\n",
@@ -775,6 +776,24 @@ static int policydb_index(struct policyd
 		if (rc)
 			goto out;
 	}
+
+	/*
+	 * A sparse class value is absorbed by policydb_class_isvalid() and
+	 * its siblings, but no such predicate exists for booleans: every
+	 * user of bool_val_to_struct[] walks it by index and dereferences
+	 * each entry -- cond_evaluate_expr(), the two getters and
+	 * security_set_bools() -- so an unclaimed one has no consumer that
+	 * can tolerate it.
+	 */
+	for (v = 0; v < p->p_bools.nprim; v++) {
+		if (!p->bool_val_to_struct[v]) {
+			pr_err("SELinux:  boolean %u is declared but not defined\n",
+			       v + 1);
+			rc = -EINVAL;
+			goto out;
+		}
+	}
+
 	rc = 0;
 out:
 	return rc;


