Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033423;
	b=Z7SMjrxGl7AS3VAUaGilJRuTs5qwuVVyDbSSCMmux6+/jl8cSbjNR7XtkWnhKEuVb015
	 EOO1XOlGtVzW6cTUfJ0pXlh3fx9TbEc3aRpyoZzUeErVimeIlDNOAbSFaSBOjFIcDvr0f
	 oqsJV8TWTVd/WloUnCd0qUTteaLOnpFXMu+Y24c0MD0KdALY9he9GwOBZJzGx0xai1K5z
	 QVlRy9sRRXxAvXCrAXXwoKL3SrM6midyogd57yUhwG9AUhdElTfGxvPNV9FKTtscMJIRB
	 cJ3zP90Za3VaNfIR1n/Djiu7JVcsHBV7c5ZQ/b+pYNSDHS5qP4MAGbLAzNkP4YB/Nhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RWbPMEa7sqkRv1/Us4aJU4J3YII5YhV+zV6mogPTkQI=;
	b=PG0S9JgKDigGJpkFHLNctRNcSM73J1ySXXJhj2IIn/iyW8oK594SNhF4IB32pjxLZTOg
	 8IaazSpDNF90QK2KuI6QXJI5z9jx//+ME2kw1O19kj5/k7JH3CVfWamo5RZwKNO02Vayz
	 tlu2euSCMBuuqAES34cxR1UY/ytD/GQm+Ohv+MZIY4TZMHm2dnFcJ++PMkT6SvLEH8TFK
	 eCchgPVZe1u7hlC4Ydv6q0jUzkMwSpC8GuhLTDyoGCH3qGRpxUkfbpSjmtj6EulieXOfb
	 aAFbCOWLAcIAOzkY9jPNYIT6N27EolaO3n+NtTL8FloYPtXHHcLgaeHHSq1tD/vaMEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rVxUh4FC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866C2606A31C;
	Wed, 18 Nov 2026 20:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rVxUh4FC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9FE1F000C4;
	Wed, 18 Nov 2026 20:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033423;
	bh=RWbPMEa7sqkRv1/Us4aJU4J3YII5YhV+zV6mogPTkQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rVxUh4FCu6Fzvw0g/slN0GsI+bBvVlRggQ3mDUjBmf51/0fgiraJI2Jw15GooKbSA
	 lrAr7jOwGk0KkzMWO8fp6vOOf1Val3ZFXUPge3/EtqLQTN5BetP+5o7Ckqh5pfYa6g
	 12vtNmfQszLd6ZXu1fvtNVjRMvMsGKpdrwKDh2SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.12 1745/1756] apparmor: mitigate parser generating large xtables
Date: Wed, 18 Nov 2026 16:04:32 +0100
Message-ID: <20261118150119.003746127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

commit aff426f35966e6e77ecfe065984344a7d834eaa9 upstream.

Some versions of the parser are generating an xtable transition per
state in the state machine, even when the state machine isn't using
the transition table.

The parser bug is triggered by
commit 2e12c5f06017 ("apparmor: add additional flags to extended permission.")

In addition to fixing this in userspace, mitigate this in the kernel
as part of the policy verification checks by detecting this situation
and adjusting to what is actually used, or if not used at all freeing
it, so we are not wasting unneeded memory on policy.

Fixes: 2e12c5f06017 ("apparmor: add additional flags to extended permission.")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/include/lib.h   |    1 +
 security/apparmor/lib.c           |   23 +++++++++++++++++++++++
 security/apparmor/policy_unpack.c |   27 +++++++++++++++++++++------
 3 files changed, 45 insertions(+), 6 deletions(-)

--- a/security/apparmor/include/lib.h
+++ b/security/apparmor/include/lib.h
@@ -123,6 +123,7 @@ struct aa_str_table {
 };
 
 void aa_free_str_table(struct aa_str_table *table);
+bool aa_resize_str_table(struct aa_str_table *t, int newsize, gfp_t gfp);
 
 struct counted_str {
 	struct kref count;
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -138,6 +138,29 @@ const char *aa_splitn_fqname(const char
 	return name;
 }
 
+bool aa_resize_str_table(struct aa_str_table *t, int newsize, gfp_t gfp)
+{
+	char **n;
+	int i;
+
+	if (t->size == newsize)
+		return true;
+	n = kcalloc(newsize, sizeof(*n), gfp);
+	if (!n)
+		return false;
+	for (i = 0; i < min(t->size, newsize); i++)
+		n[i] = t->table[i];
+	for (; i < t->size; i++)
+		kfree_sensitive(t->table[i]);
+	if (newsize > t->size)
+		memset(&n[t->size], 0, (newsize-t->size)*sizeof(*n));
+	kfree_sensitive(t->table);
+	t->table = n;
+	t->size = newsize;
+
+	return true;
+}
+
 /**
  * aa_info_message - log a none profile related status message
  * @str: message to log
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -832,8 +832,12 @@ static int unpack_pdb(struct aa_ext *e,
 	if (!pdb->dfa && pdb->trans.table)
 		aa_free_str_table(&pdb->trans);
 
-	/* TODO: move compat mapping here, requires dfa merging first */
-	/* TODO: move verify here, it has to be done after compat mappings */
+	/* TODO:
+	 * - move compat mapping here, requires dfa merging first
+	 * - move verify here, it has to be done after compat mappings
+	 * - move free of unneeded trans table here, has to be done
+	 *   after perm mapping.
+	 */
 out:
 	*policy = pdb;
 	return 0;
@@ -1272,21 +1276,32 @@ static bool verify_perm(struct aa_perms
 static bool verify_perms(struct aa_policydb *pdb)
 {
 	int i;
+	int xidx, xmax = -1;
 
 	for (i = 0; i < pdb->size; i++) {
 		if (!verify_perm(&pdb->perms[i]))
 			return false;
 		/* verify indexes into str table */
-		if ((pdb->perms[i].xindex & AA_X_TYPE_MASK) == AA_X_TABLE &&
-		    (pdb->perms[i].xindex & AA_X_INDEX_MASK) >= pdb->trans.size)
-			return false;
+		if ((pdb->perms[i].xindex & AA_X_TYPE_MASK) == AA_X_TABLE) {
+			xidx = pdb->perms[i].xindex & AA_X_INDEX_MASK;
+			if (xidx >= pdb->trans.size)
+				return false;
+			if (xmax < xidx)
+				xmax = xidx;
+		}
 		if (pdb->perms[i].tag && pdb->perms[i].tag >= pdb->trans.size)
 			return false;
 		if (pdb->perms[i].label &&
 		    pdb->perms[i].label >= pdb->trans.size)
 			return false;
 	}
-
+	/* deal with incorrectly constructed string tables */
+	if (xmax == -1) {
+		aa_free_str_table(&pdb->trans);
+	} else if (pdb->trans.size > xmax + 1) {
+		if (!aa_resize_str_table(&pdb->trans, xmax + 1, GFP_KERNEL))
+			return false;
+	}
 	return true;
 }
 


