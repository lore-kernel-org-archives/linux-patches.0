Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFC18F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1353C433C8;
	Sun, 16 Jul 2023 20:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539173;
	bh=We2kocMXluKFKpdPMw84G6zb1nTOESd3rMKf2L8O7ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZb3MU2qp25dRiLCDmfGlhATCCjbd9N0pJ/sYWCBCh9VGXIvQ/SRXJhPWo7cXb0/h
	 N4oxj6WzvrwGcS3/NQE5EaNHKwLqombifjXpQ+zZf7lEthzjNLVmEE2x5FsNaWxiaZ
	 zz3xmFLbphwqYWm4qvJtl5TQx+HAoNPMbGeEDyus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Jon Tourville <jontourville@me.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 713/800] apparmor: fix profile verification and enable it
Date: Sun, 16 Jul 2023 21:49:26 +0200
Message-ID: <20230716195005.679990547@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 6f442d42c0d89876994a4a135eadf82b0e6ff6e4 ]

The transition table size was not being set by compat mappings
resulting in the profile verification code not being run. Unfortunately
the checks were also buggy not being correctly updated from the old
accept perms, to the new layout.

Also indicate to userspace that the kernel has the permstable verification
fixes.

BugLink: http://bugs.launchpad.net/bugs/2017903
Fixes: 670f31774ab6 ("apparmor: verify permission table indexes")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Reviewed-by: Jon Tourville <jontourville@me.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_compat.c | 18 ++++++++++------
 security/apparmor/policy_unpack.c | 34 ++++++++++++++-----------------
 2 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/security/apparmor/policy_compat.c b/security/apparmor/policy_compat.c
index 6fa185ce8d9dc..0cb02da8a3193 100644
--- a/security/apparmor/policy_compat.c
+++ b/security/apparmor/policy_compat.c
@@ -146,7 +146,8 @@ static struct aa_perms compute_fperms_other(struct aa_dfa *dfa,
  *
  * Returns: remapped perm table
  */
-static struct aa_perms *compute_fperms(struct aa_dfa *dfa)
+static struct aa_perms *compute_fperms(struct aa_dfa *dfa,
+				       u32 *size)
 {
 	aa_state_t state;
 	unsigned int state_count;
@@ -159,6 +160,7 @@ static struct aa_perms *compute_fperms(struct aa_dfa *dfa)
 	table = kvcalloc(state_count * 2, sizeof(struct aa_perms), GFP_KERNEL);
 	if (!table)
 		return NULL;
+	*size = state_count * 2;
 
 	for (state = 0; state < state_count; state++) {
 		table[state * 2] = compute_fperms_user(dfa, state);
@@ -168,7 +170,8 @@ static struct aa_perms *compute_fperms(struct aa_dfa *dfa)
 	return table;
 }
 
-static struct aa_perms *compute_xmatch_perms(struct aa_dfa *xmatch)
+static struct aa_perms *compute_xmatch_perms(struct aa_dfa *xmatch,
+				      u32 *size)
 {
 	struct aa_perms *perms;
 	int state;
@@ -181,6 +184,7 @@ static struct aa_perms *compute_xmatch_perms(struct aa_dfa *xmatch)
 	perms = kvcalloc(state_count, sizeof(struct aa_perms), GFP_KERNEL);
 	if (!perms)
 		return NULL;
+	*size = state_count;
 
 	/* zero init so skip the trap state (state == 0) */
 	for (state = 1; state < state_count; state++)
@@ -241,7 +245,8 @@ static struct aa_perms compute_perms_entry(struct aa_dfa *dfa,
 	return perms;
 }
 
-static struct aa_perms *compute_perms(struct aa_dfa *dfa, u32 version)
+static struct aa_perms *compute_perms(struct aa_dfa *dfa, u32 version,
+				      u32 *size)
 {
 	unsigned int state;
 	unsigned int state_count;
@@ -254,6 +259,7 @@ static struct aa_perms *compute_perms(struct aa_dfa *dfa, u32 version)
 	table = kvcalloc(state_count, sizeof(struct aa_perms), GFP_KERNEL);
 	if (!table)
 		return NULL;
+	*size = state_count;
 
 	/* zero init so skip the trap state (state == 0) */
 	for (state = 1; state < state_count; state++)
@@ -288,7 +294,7 @@ static void remap_dfa_accept(struct aa_dfa *dfa, unsigned int factor)
 /* TODO: merge different dfa mappings into single map_policy fn */
 int aa_compat_map_xmatch(struct aa_policydb *policy)
 {
-	policy->perms = compute_xmatch_perms(policy->dfa);
+	policy->perms = compute_xmatch_perms(policy->dfa, &policy->size);
 	if (!policy->perms)
 		return -ENOMEM;
 
@@ -299,7 +305,7 @@ int aa_compat_map_xmatch(struct aa_policydb *policy)
 
 int aa_compat_map_policy(struct aa_policydb *policy, u32 version)
 {
-	policy->perms = compute_perms(policy->dfa, version);
+	policy->perms = compute_perms(policy->dfa, version, &policy->size);
 	if (!policy->perms)
 		return -ENOMEM;
 
@@ -310,7 +316,7 @@ int aa_compat_map_policy(struct aa_policydb *policy, u32 version)
 
 int aa_compat_map_file(struct aa_policydb *policy)
 {
-	policy->perms = compute_fperms(policy->dfa);
+	policy->perms = compute_fperms(policy->dfa, &policy->size);
 	if (!policy->perms)
 		return -ENOMEM;
 
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index d50774a16494f..bc9f436d49cca 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1164,22 +1164,16 @@ static int verify_header(struct aa_ext *e, int required, const char **ns)
 	return 0;
 }
 
-static bool verify_xindex(int xindex, int table_size)
-{
-	int index, xtype;
-	xtype = xindex & AA_X_TYPE_MASK;
-	index = xindex & AA_X_INDEX_MASK;
-	if (xtype == AA_X_TABLE && index >= table_size)
-		return false;
-	return true;
-}
-
-/* verify dfa xindexes are in range of transition tables */
-static bool verify_dfa_xindex(struct aa_dfa *dfa, int table_size)
+/**
+ * verify_dfa_accept_xindex - verify accept indexes are in range of perms table
+ * @dfa: the dfa to check accept indexes are in range
+ * table_size: the permission table size the indexes should be within
+ */
+static bool verify_dfa_accept_index(struct aa_dfa *dfa, int table_size)
 {
 	int i;
 	for (i = 0; i < dfa->tables[YYTD_ID_ACCEPT]->td_lolen; i++) {
-		if (!verify_xindex(ACCEPT_TABLE(dfa)[i], table_size))
+		if (ACCEPT_TABLE(dfa)[i] >= table_size)
 			return false;
 	}
 	return true;
@@ -1216,11 +1210,13 @@ static bool verify_perms(struct aa_policydb *pdb)
 		if (!verify_perm(&pdb->perms[i]))
 			return false;
 		/* verify indexes into str table */
-		if (pdb->perms[i].xindex >= pdb->trans.size)
+		if ((pdb->perms[i].xindex & AA_X_TYPE_MASK) == AA_X_TABLE &&
+		    (pdb->perms[i].xindex & AA_X_INDEX_MASK) >= pdb->trans.size)
 			return false;
-		if (pdb->perms[i].tag >= pdb->trans.size)
+		if (pdb->perms[i].tag && pdb->perms[i].tag >= pdb->trans.size)
 			return false;
-		if (pdb->perms[i].label >= pdb->trans.size)
+		if (pdb->perms[i].label &&
+		    pdb->perms[i].label >= pdb->trans.size)
 			return false;
 	}
 
@@ -1242,10 +1238,10 @@ static int verify_profile(struct aa_profile *profile)
 	if (!rules)
 		return 0;
 
-	if ((rules->file.dfa && !verify_dfa_xindex(rules->file.dfa,
-						  rules->file.trans.size)) ||
+	if ((rules->file.dfa && !verify_dfa_accept_index(rules->file.dfa,
+							 rules->file.size)) ||
 	    (rules->policy.dfa &&
-	     !verify_dfa_xindex(rules->policy.dfa, rules->policy.trans.size))) {
+	     !verify_dfa_accept_index(rules->policy.dfa, rules->policy.size))) {
 		audit_iface(profile, NULL, NULL,
 			    "Unpack: Invalid named transition", NULL, -EPROTO);
 		return -EPROTO;
-- 
2.39.2



