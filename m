Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F57749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C9BC433EF;
	Thu, 12 Jan 2023 14:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532342;
	bh=pwChACz15408BrxxBbVySZ6FjhFLXRJpakzaCXuuH9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7xb7wlfO9L4hd436vku0pNOfJiAzA12cjoa140KdMbAt9tZQMObGm7ef4ILNFY4y
	 wZHSjimBsSU1ERMptC5ZH2lznIL4gAEQOI89jkPKy3dAp7zD8nlXFrJbsZ+emZd39H
	 OGgOmS2+DwCSyD5HTbNtHnGbh3QNjq9HaCBLyhJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GUO Zihua <guozihua@huawei.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/783] ima: Handle -ESTALE returned by ima_filter_rule_match()
Date: Thu, 12 Jan 2023 14:47:26 +0100
Message-Id: <20230112135530.332393957@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: GUO Zihua <guozihua@huawei.com>

[ Upstream commit c7423dbdbc9ecef7fff5239d144cad4b9887f4de ]

IMA relies on the blocking LSM policy notifier callback to update the
LSM based IMA policy rules.

When SELinux update its policies, IMA would be notified and starts
updating all its lsm rules one-by-one. During this time, -ESTALE would
be returned by ima_filter_rule_match() if it is called with a LSM rule
that has not yet been updated. In ima_match_rules(), -ESTALE is not
handled, and the LSM rule is considered a match, causing extra files
to be measured by IMA.

Fix it by re-initializing a temporary rule if -ESTALE is returned by
ima_filter_rule_match(). The origin rule in the rule list would be
updated by the LSM policy notifier callback.

Fixes: b16942455193 ("ima: use the lsm policy update notifier")
Signed-off-by: GUO Zihua <guozihua@huawei.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_policy.c | 41 ++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 4c937ff2e4dd..a83ce111cf50 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -503,6 +503,9 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 			    const char *keyring)
 {
 	int i;
+	bool result = false;
+	struct ima_rule_entry *lsm_rule = rule;
+	bool rule_reinitialized = false;
 
 	if (func == KEY_CHECK) {
 		return (rule->flags & IMA_FUNC) && (rule->func == func) &&
@@ -545,35 +548,55 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 		int rc = 0;
 		u32 osid;
 
-		if (!rule->lsm[i].rule) {
-			if (!rule->lsm[i].args_p)
+		if (!lsm_rule->lsm[i].rule) {
+			if (!lsm_rule->lsm[i].args_p)
 				continue;
 			else
 				return false;
 		}
+
+retry:
 		switch (i) {
 		case LSM_OBJ_USER:
 		case LSM_OBJ_ROLE:
 		case LSM_OBJ_TYPE:
 			security_inode_getsecid(inode, &osid);
-			rc = ima_filter_rule_match(osid, rule->lsm[i].type,
+			rc = ima_filter_rule_match(osid, lsm_rule->lsm[i].type,
 						   Audit_equal,
-						   rule->lsm[i].rule);
+						   lsm_rule->lsm[i].rule);
 			break;
 		case LSM_SUBJ_USER:
 		case LSM_SUBJ_ROLE:
 		case LSM_SUBJ_TYPE:
-			rc = ima_filter_rule_match(secid, rule->lsm[i].type,
+			rc = ima_filter_rule_match(secid, lsm_rule->lsm[i].type,
 						   Audit_equal,
-						   rule->lsm[i].rule);
+						   lsm_rule->lsm[i].rule);
 			break;
 		default:
 			break;
 		}
-		if (!rc)
-			return false;
+
+		if (rc == -ESTALE && !rule_reinitialized) {
+			lsm_rule = ima_lsm_copy_rule(rule);
+			if (lsm_rule) {
+				rule_reinitialized = true;
+				goto retry;
+			}
+		}
+		if (!rc) {
+			result = false;
+			goto out;
+		}
 	}
-	return true;
+	result = true;
+
+out:
+	if (rule_reinitialized) {
+		for (i = 0; i < MAX_LSM_RULES; i++)
+			ima_filter_rule_free(lsm_rule->lsm[i].rule);
+		kfree(lsm_rule);
+	}
+	return result;
 }
 
 /*
-- 
2.35.1



