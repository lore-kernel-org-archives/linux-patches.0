Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F0126ED33;
	Wed, 25 Feb 2026 01:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983660; cv=none; b=b65oa4RmCp6xUbtQmsckqDXpk7P2onYjJGMAxxaV1D+i4LTaXnjjb04OWE7nuOSmmK5WvEZXMe5LIMqblAo2GpTgb/iqE9wt/1JqozoJOSy2al4FfDgEx5UQYMvXcSATAMJEIOWK0+NcLK1JBL42uNT8eiuIvhz34915Jqfbd5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983660; c=relaxed/simple;
	bh=BwbcoY09LBNlEuZ57vbpmaGg9vuGWxEif+rcY6ZFXe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZZHmZV2XOnH4bfsfaWP5zifTbc8742J1Ur3ao0h4Z8awcAOBp8Tiu649AcDbrYzS36jwkvQf7NrZYhYmaD0qIz/+bwdlIaO2PmpscqHa1E4UCQwhAgRg/NLEiIylgkg4sGGXE4dh4kzr4QFQPHWQeWy4RAqfzrBeCYkRCCN9cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C15ds4Dm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C15ds4Dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF5FC116D0;
	Wed, 25 Feb 2026 01:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983660;
	bh=BwbcoY09LBNlEuZ57vbpmaGg9vuGWxEif+rcY6ZFXe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C15ds4DmwZjHLkWW0cNdCxZT1yn9YoYGljxHzNZyKjrHjKqf01Cc9YUo1henwkOKS
	 YyDEPWhB7fXHDtxmfIg5+yEtN2kUC9FgPARZgU37kcSylXYIe+0HdxDBrQUha6bC28
	 Bx1+Wi/FUyjz8effxpEXui+Y9CpGUEsQR2YJp56M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 702/781] apparmor: make label_match return a consistent value
Date: Tue, 24 Feb 2026 17:23:31 -0800
Message-ID: <20260225012416.974274332@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit a4c9efa4dbad6dacad6e8b274e30e814c8353097 ]

compound match is inconsistent in returning a state or an integer error
this is problemati if the error is ever used as a state in the state
machine

Fixes: f1bd904175e81 ("apparmor: add the base fns() for domain labels")
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 02ee128f53d13..1d3fa5c28d97f 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1278,7 +1278,7 @@ static inline aa_state_t match_component(struct aa_profile *profile,
  * @request: permissions to request
  * @perms: perms struct to set
  *
- * Returns: 0 on success else ERROR
+ * Returns: state match stopped at or DFA_NOMATCH if aborted early
  *
  * For the label A//&B//&C this does the perm match for A//&B//&C
  * @perms should be preinitialized with allperms OR a previous permission
@@ -1305,7 +1305,7 @@ static int label_compound_match(struct aa_profile *profile,
 
 	/* no component visible */
 	*perms = allperms;
-	return 0;
+	return state;
 
 next:
 	label_for_each_cont(i, label, tp) {
@@ -1317,14 +1317,11 @@ static int label_compound_match(struct aa_profile *profile,
 			goto fail;
 	}
 	*perms = *aa_lookup_perms(rules->policy, state);
-	if ((perms->allow & request) != request)
-		return -EACCES;
-
-	return 0;
+	return state;
 
 fail:
 	*perms = nullperms;
-	return state;
+	return DFA_NOMATCH;
 }
 
 /**
@@ -1406,11 +1403,12 @@ int aa_label_match(struct aa_profile *profile, struct aa_ruleset *rules,
 		   struct aa_label *label, aa_state_t state, bool subns,
 		   u32 request, struct aa_perms *perms)
 {
-	int error = label_compound_match(profile, rules, label, state, subns,
-					 request, perms);
-	if (!error)
-		return error;
+	aa_state_t tmp = label_compound_match(profile, rules, label, state, subns,
+					request, perms);
+	if ((perms->allow & request) == request)
+		return 0;
 
+	/* failed compound_match try component matches */
 	*perms = allperms;
 	return label_components_match(profile, rules, label, state, subns,
 				      request, perms);
-- 
2.51.0



