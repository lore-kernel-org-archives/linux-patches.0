Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A116472F8B;
	Thu, 20 Aug 2026 17:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247810; cv=none; b=kFgqa6Zm41GLIRK/4sLtlbmoeOoG1O7HVlFxKAPm/gC3ub+IxqNJnhhej6iTyZz03G3UHhe7r+feb2BBjUTEEZPNoPMZusWCeieAGAQWNzj72/kw+ACug9kKrPnLIOjDLb8EsFgsT8pAYSotHjjxowvV4o6jesRfI2KK+q/fLxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247810; c=relaxed/simple;
	bh=FlsTDTCpIw6JpwF1ovR7tl2F2S8feyqliWvtz2pPw8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PD0ixUHtpdGVGXHe6tIfAYbQdjkbeiOrOw3OPfms2i+LFpqEDbCfOO07CrFeZHjvnZec3EUTbl/P6dV9HcKvD1fWxMX0SBoJI+O3MCrmkK1Tyuhel9K0wiFtqg6/VefVrsGQL4R4Q7grIUwcQIhhy4fAtjT9r9O0Fr1mNxDPxLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdybPar9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdybPar9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65961F000E9;
	Thu, 20 Aug 2026 17:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247809;
	bh=eO3V7umajNhPNk7forW2lvtPKaD6YMGFZaDP+jCqmcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdybPar9A6LsV2Hj7KA7aRzlKG8bTsroXvpusywE+rRP0yt5r3pol+BWUqZb8tM19
	 +bXJQ8TzSCLHXXAn70jZg14b4/ODKea+2X0FhzewSscN5Nw9PS44w3H+jubrhlv3I3
	 d2HygYoipIcR0zXp46O5gDxI+QmCZOFz56HnKkQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 010/303] selinux: require every boolean value to be defined
Date: Thu, 20 Aug 2026 16:52:26 +0200
Message-ID: <20260820145253.502375963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -712,6 +712,7 @@ static inline void hash_eval(struct hash
 static int policydb_index(struct policydb *p)
 {
 	int i, rc;
+	u32 v;
 
 	if (p->mls_enabled)
 		pr_debug("SELinux:  %d users, %d roles, %d types, %d bools, %d sens, %d cats\n",
@@ -769,6 +770,24 @@ static int policydb_index(struct policyd
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


