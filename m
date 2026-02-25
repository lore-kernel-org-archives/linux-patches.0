Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707A72D8396;
	Wed, 25 Feb 2026 06:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002749; cv=none; b=Jdyqc0N8+jqVYSNXjIJHFc7daDsNEas4FWXFxpjcxP4FpUYNMiaSF67ipXi9QR1YEwYrmRHR8S5AzyzZAZPufHdoANXWaQnDIZ7T/985drzPwhVYRGAuADdo9bDcm2G7Dhcojhk6gZlm+J0+NsRM6oiGElGElFGJDccoaGI3+3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002749; c=relaxed/simple;
	bh=Wr+kBAcNmZgmPLrGnxRo1xJDREE4dcEH2RXGLjzvK9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1GxdksR+9J0xRpMIzo1MDzAO/ngoSuqilvrlSbYPNgY/exhKS0GDbwa25LL/Mhcfj66m4dgWCEQtexKSC2U4mPodkg9yNYE1ceVup54Q1v8sGuTrWSParMnmQnHc+RjhfuSnxc2oMFb/ErwwNojdf8ui3VJtIxfjm4IDvHcRXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uv+uO4j5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uv+uO4j5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EC9C116D0;
	Wed, 25 Feb 2026 06:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002749;
	bh=Wr+kBAcNmZgmPLrGnxRo1xJDREE4dcEH2RXGLjzvK9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uv+uO4j5dL0y98vs7GSH2Gj+VfLt9Kz/YU2dzNGTKfSuC5BsoJm4kXqlUuotKQZU5
	 opde12z9jMAWLUf3iYXK4xm+g/fQhLSoAjcSrdlWp19NF4ldZg1QIXWDp2HMwDCaBw
	 dPE4VH4iZZFoyxzOuFS8AgpLAmoaNnyfTa3RnODU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 573/641] apparmor: remove apply_modes_to_perms from label_match
Date: Tue, 24 Feb 2026 17:24:59 -0800
Message-ID: <20260225012402.402109150@linuxfoundation.org>
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

[ Upstream commit b2e27be2948f2f8c38421cd554b5fc9383215648 ]

The modes shouldn't be applied at the point of label match, it just
results in them being applied multiple times. Instead they should be
applied after which is already being done by all callers so it can
just be dropped from label_match.

Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: a4c9efa4dbad ("apparmor: make label_match return a consistent value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 913678f199c35..02ee128f53d13 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1317,7 +1317,6 @@ static int label_compound_match(struct aa_profile *profile,
 			goto fail;
 	}
 	*perms = *aa_lookup_perms(rules->policy, state);
-	aa_apply_modes_to_perms(profile, perms);
 	if ((perms->allow & request) != request)
 		return -EACCES;
 
@@ -1370,7 +1369,6 @@ static int label_components_match(struct aa_profile *profile,
 
 next:
 	tmp = *aa_lookup_perms(rules->policy, state);
-	aa_apply_modes_to_perms(profile, &tmp);
 	aa_perms_accum(perms, &tmp);
 	label_for_each_cont(i, label, tp) {
 		if (!aa_ns_visible(profile->ns, tp->ns, subns))
@@ -1379,7 +1377,6 @@ static int label_components_match(struct aa_profile *profile,
 		if (!state)
 			goto fail;
 		tmp = *aa_lookup_perms(rules->policy, state);
-		aa_apply_modes_to_perms(profile, &tmp);
 		aa_perms_accum(perms, &tmp);
 	}
 
-- 
2.51.0



