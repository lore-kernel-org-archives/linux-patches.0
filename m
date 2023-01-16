Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AC146B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A90DC433EF;
	Mon, 16 Jan 2023 16:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885611;
	bh=VQG2A0tN62AWabydY8b2hsHvQDQINRdtNid1RP0hI1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrGWVhZH9jTcCDRC8wvx87vjAPEg+FuALE+HKRMXE7/Vmnj2SWXp1pIjGixd8lBK8
	 WTbQv/Y3C+IqU3DBbCxwKriO7l1jWE7PaRoRQgOPlubK8/OffmPggK0ync+XHer/Vd
	 qeq/CMJPzT4Gi4gwm8oZkE2V0GRrOlLap4QqPMD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Hicks <tyhicks@linux.microsoft.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/658] ima: Rename internal filter rule functions
Date: Mon, 16 Jan 2023 16:43:25 +0100
Message-Id: <20230116154914.854597313@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tyler Hicks <tyhicks@linux.microsoft.com>

[ Upstream commit b8867eedcf76caef8ae6412da97cd9abfd092ff8 ]

Rename IMA's internal filter rule functions from security_filter_rule_*()
to ima_filter_rule_*(). This avoids polluting the security_* namespace,
which is typically reserved for general security subsystem
infrastructure.

Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Suggested-by: Casey Schaufler <casey@schaufler-ca.com>
[zohar@linux.ibm.com: reword using the term "filter", not "audit"]
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Stable-dep-of: c7423dbdbc9e ("ima: Handle -ESTALE returned by ima_filter_rule_match()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima.h        | 16 +++++++--------
 security/integrity/ima/ima_policy.c | 30 +++++++++++++----------------
 2 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 5fae6cfe8d91..146154e333e6 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -361,24 +361,24 @@ static inline void ima_free_modsig(struct modsig *modsig)
 /* LSM based policy rules require audit */
 #ifdef CONFIG_IMA_LSM_RULES
 
-#define security_filter_rule_init security_audit_rule_init
-#define security_filter_rule_free security_audit_rule_free
-#define security_filter_rule_match security_audit_rule_match
+#define ima_filter_rule_init security_audit_rule_init
+#define ima_filter_rule_free security_audit_rule_free
+#define ima_filter_rule_match security_audit_rule_match
 
 #else
 
-static inline int security_filter_rule_init(u32 field, u32 op, char *rulestr,
-					    void **lsmrule)
+static inline int ima_filter_rule_init(u32 field, u32 op, char *rulestr,
+				       void **lsmrule)
 {
 	return -EINVAL;
 }
 
-static inline void security_filter_rule_free(void *lsmrule)
+static inline void ima_filter_rule_free(void *lsmrule)
 {
 }
 
-static inline int security_filter_rule_match(u32 secid, u32 field, u32 op,
-					     void *lsmrule)
+static inline int ima_filter_rule_match(u32 secid, u32 field, u32 op,
+					void *lsmrule)
 {
 	return -EINVAL;
 }
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 14aef74d3588..6cd2f663643c 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -254,7 +254,7 @@ static void ima_lsm_free_rule(struct ima_rule_entry *entry)
 	int i;
 
 	for (i = 0; i < MAX_LSM_RULES; i++) {
-		security_filter_rule_free(entry->lsm[i].rule);
+		ima_filter_rule_free(entry->lsm[i].rule);
 		kfree(entry->lsm[i].args_p);
 	}
 	kfree(entry);
@@ -286,10 +286,9 @@ static struct ima_rule_entry *ima_lsm_copy_rule(struct ima_rule_entry *entry)
 		if (!nentry->lsm[i].args_p)
 			goto out_err;
 
-		security_filter_rule_init(nentry->lsm[i].type,
-					  Audit_equal,
-					  nentry->lsm[i].args_p,
-					  &nentry->lsm[i].rule);
+		ima_filter_rule_init(nentry->lsm[i].type, Audit_equal,
+				     nentry->lsm[i].args_p,
+				     &nentry->lsm[i].rule);
 		if (!nentry->lsm[i].rule)
 			pr_warn("rule for LSM \'%s\' is undefined\n",
 				(char *)entry->lsm[i].args_p);
@@ -425,18 +424,16 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 		case LSM_OBJ_ROLE:
 		case LSM_OBJ_TYPE:
 			security_inode_getsecid(inode, &osid);
-			rc = security_filter_rule_match(osid,
-							rule->lsm[i].type,
-							Audit_equal,
-							rule->lsm[i].rule);
+			rc = ima_filter_rule_match(osid, rule->lsm[i].type,
+						   Audit_equal,
+						   rule->lsm[i].rule);
 			break;
 		case LSM_SUBJ_USER:
 		case LSM_SUBJ_ROLE:
 		case LSM_SUBJ_TYPE:
-			rc = security_filter_rule_match(secid,
-							rule->lsm[i].type,
-							Audit_equal,
-							rule->lsm[i].rule);
+			rc = ima_filter_rule_match(secid, rule->lsm[i].type,
+						   Audit_equal,
+						   rule->lsm[i].rule);
 		default:
 			break;
 		}
@@ -821,10 +818,9 @@ static int ima_lsm_rule_init(struct ima_rule_entry *entry,
 		return -ENOMEM;
 
 	entry->lsm[lsm_rule].type = audit_type;
-	result = security_filter_rule_init(entry->lsm[lsm_rule].type,
-					   Audit_equal,
-					   entry->lsm[lsm_rule].args_p,
-					   &entry->lsm[lsm_rule].rule);
+	result = ima_filter_rule_init(entry->lsm[lsm_rule].type, Audit_equal,
+				      entry->lsm[lsm_rule].args_p,
+				      &entry->lsm[lsm_rule].rule);
 	if (!entry->lsm[lsm_rule].rule) {
 		pr_warn("rule for LSM \'%s\' is undefined\n",
 			(char *)entry->lsm[lsm_rule].args_p);
-- 
2.35.1



