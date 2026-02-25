Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4983D26FD93;
	Wed, 25 Feb 2026 01:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983659; cv=none; b=urTdId2wQ1vQcPne4GmK5qsr796Cfy9AxlroCnuCUIEgRAzb0+KNdiwaKNxBc6BvtxwkBMtqNMLTsEL4ivlW7Asb8agg6Qv7gQKwVUI4GXbaA/djGYArbb1WX7395fv6NI/GtE4imf3e+Es1lubhhY1PG7C+m8MwIqnDG5B907A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983659; c=relaxed/simple;
	bh=Kl5BNgfvMibn1ohYbR3YL0k+N3Cr4HkgWckLJTeyePk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOX3fLdd7gFo0njK789zyl0Ownsj0SgVeDslkKQoRvRfgrtFEyRE0fzcGFPmWyWVe7IWIXvpvOD9KkDeOXYnf9w+Kw46/Fpp8jkr9jKyaoj6D22thP785eQUshV+NsdvvaRIqk5gY/QmHOmY2aC34B0dihv2wJdlG2MrSbrBzJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKRcE/FO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKRcE/FO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00516C116D0;
	Wed, 25 Feb 2026 01:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983659;
	bh=Kl5BNgfvMibn1ohYbR3YL0k+N3Cr4HkgWckLJTeyePk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKRcE/FOnopG4kqGOQaf4043jVDWPRinC5+tc+1Nlh8y1vv9Bzn6mMBDIe4ZdG+Pk
	 jXGOO7AamQPW7xeg4LHJUJtjHGCP99CtpY73UblGiRKNAIdeM3kOWv/YdOgJ+gcd3M
	 +VT6eLcbmOuycxAepAdYYI5NsdNP5V9JjDI/fpQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 701/781] apparmor: remove apply_modes_to_perms from label_match
Date: Tue, 24 Feb 2026 17:23:30 -0800
Message-ID: <20260225012416.950138844@linuxfoundation.org>
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



