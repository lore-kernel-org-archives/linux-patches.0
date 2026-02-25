Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210133054C7;
	Wed, 25 Feb 2026 06:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002750; cv=none; b=RVvpkHbCSLfPztha9c4/WPD3PJ317gUD2bz7RutVgOjgLufFIJ7uULrChVEFHP/d11MvHh64S/4JVbxhezWTmKG1GRuVtnKQITQk3ssyLCC5c4Nbkyw52bYp4XTnQ12XRnavyhZammjXUcIQR8O6M+l5c2xxwVj9BJwdR9mnwdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002750; c=relaxed/simple;
	bh=t8TODMmQg+Iq49OM8cdJ5F94E8ATmVzq4n65AdgLDcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6fQZzZZMMA9ffafmEhV+5Ca1zGO9InqKE3+Itz/iow09bz+qmuzsy+q82j/EE/kNFUHhLFB0IXHcuR8McBFZ2k8BcPcO3kTitec9J0X7tnvcy85l0TX8mB3b9JY1N9y3IW4MJsJbAiXS/EwAIJGcd7X2dXhK3VyQ597qCLY1Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iI5lo+GB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iI5lo+GB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CBAC116D0;
	Wed, 25 Feb 2026 06:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002750;
	bh=t8TODMmQg+Iq49OM8cdJ5F94E8ATmVzq4n65AdgLDcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iI5lo+GB0NId7YVffKgV3mqV5BvFM6IJcVbw5IvUjnpeym7kE9drjPj4iNd2qQjeK
	 jKePathRkJS9VTuMBMkfOprOG9CHV7dolZBMBFHb7eDFjtX+qlWnaYyPEzYEidz/FI
	 8YScAZb9DqCteU89a7lNlRURiQ5z7ytTJubPZv3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 574/641] apparmor: make label_match return a consistent value
Date: Tue, 24 Feb 2026 17:25:00 -0800
Message-ID: <20260225012402.426119971@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



