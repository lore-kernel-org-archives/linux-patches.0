Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2149947141A;
	Thu, 20 Aug 2026 17:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247402; cv=none; b=e9rSqjUQJM/PF7NVZ1EPkQTxH7wrX0cpnNvrs2MNThV/aPoEZqjgQN0Ni8Br5e/SgmX0tcnqAHZMjnNm5/NG4Xdg0WEP0LPJDeVeOoPprlW2kVYGwtaWa+eqAZ6tfkGAlkLk/e0fV8wc9O2aLnDR8ECSOJ6DodfbA++bWYtdGsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247402; c=relaxed/simple;
	bh=8Eljjfz5jlfvByySGnsFDgCrvxbWqCluU8K9rnQ0Hi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aP4ct7Zn0j5S/WQKuD6m01Dq7204NM3q3lC8wctwMPNaMUjvHYbi+Uj5Yu5qqr38NQNnCXEKnOGzl4iPcuKR2Ks9zxYTCMvD/zUn0RiAGs9PPXxBkVE3QcjYX5zK9ZORj1Wgm+1vojezRufXZ0NX+Cy6AoGVxV4gJ67UoJDn2CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owRVrnDx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owRVrnDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C58E1F000E9;
	Thu, 20 Aug 2026 17:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247400;
	bh=EL1vZI0rDWbJxdpTBpzhbPC3Q1pF1nVc/ZE5VZxrvII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=owRVrnDx3/NcsDFxA+GOz/q0WgyxfKkMd4A8Suw+irTn++h8HAuR4lRalM4P5CRA/
	 xxYNPAsMLuhqLDzKm11Vydfyl8zD0RL8Uu03z1AEirtAH2vznmoHiY4Xb0aoajoO6i
	 /JAbxTKFxPWat9UBstRTZSeO1n0Qz1eEit75kb4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 005/166] selinux: require every boolean value to be defined
Date: Thu, 20 Aug 2026 16:54:24 +0200
Message-ID: <20260820145211.358475685@linuxfoundation.org>
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
@@ -715,6 +715,7 @@ static inline void symtab_hash_eval(stru
 static int policydb_index(struct policydb *p)
 {
 	int i, rc;
+	u32 v;
 
 	if (p->mls_enabled)
 		pr_debug("SELinux:  %d users, %d roles, %d types, %d bools, %d sens, %d cats\n",
@@ -770,6 +771,24 @@ static int policydb_index(struct policyd
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


