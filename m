Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E0A248881;
	Wed, 25 Feb 2026 01:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983610; cv=none; b=KeXzgcAakMN9ZWkDKtIs1H+3zfOybJNGfxe/OsZVbYrHOJvuD1RF0vYeXvq+nE1vyIrctQa186wDPDgPHigodKlhDHj+9IrnSqTh0qayBeyCkrcR7A3fHmoYTICloxXaRb1McowkiNK6eWMPyke4kyfUtEOKz5IRVj6wrjaU/2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983610; c=relaxed/simple;
	bh=z34LJmPJJ2Tsn9kcL7MMc0x21DL8NaugKrHyN3ZIOVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtN8tP5NwdRfjjVabhTDLGjuEMhPRmRJ8bS9UFQBu65mTLvLRGjkbPgr5/i+e07UKo0Mbp6GSiGr/winf4x05eDImX4LqGjnEpNw8Lw7keu1jOEbCnQJSyMkH1Th3AP3gzSjhN2UajgjomKhU5petOKHuIjaXdQSTTITwzZVo5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRne+H7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRne+H7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC32C116D0;
	Wed, 25 Feb 2026 01:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983610;
	bh=z34LJmPJJ2Tsn9kcL7MMc0x21DL8NaugKrHyN3ZIOVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRne+H7GlRetP1xzYMLJq/bU0pberjHx1ePkKNO7J2o7hd0DW9NCAsLJaWfG2YrZv
	 lngNWtqFAC3I18fWAC1XeObZR6+LjTi9IoASUulzttLpJ6orP4iDRLpWPldRqAoFPK
	 +cOhh2AU6myKVoRiyhfBJfBd222Nv7h3xlovbIOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 705/781] apparmor: fix aa_label to return state from compount and component match
Date: Tue, 24 Feb 2026 17:23:34 -0800
Message-ID: <20260225012417.042132239@linuxfoundation.org>
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

[ Upstream commit 9058798652c8bc0584ed1fb0766a1015046c06e8 ]

aa-label_match is not correctly returning the state in all cases.
The only reason this didn't cause a error is that all callers currently
ignore the return value.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202602020631.wXgZosyU-lkp@intel.com/
Fixes: a4c9efa4dbad6 ("apparmor: make label_match return a consistent value")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 1d3fa5c28d97f..dd6c58f595ba8 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1334,7 +1334,7 @@ static int label_compound_match(struct aa_profile *profile,
  * @request: permissions to request
  * @perms: an initialized perms struct to add accumulation to
  *
- * Returns: 0 on success else ERROR
+ * Returns: the state the match finished in, may be the none matching state
  *
  * For the label A//&B//&C this does the perm match for each of A and B and C
  * @perms should be preinitialized with allperms OR a previous permission
@@ -1362,7 +1362,7 @@ static int label_components_match(struct aa_profile *profile,
 	}
 
 	/* no subcomponents visible - no change in perms */
-	return 0;
+	return state;
 
 next:
 	tmp = *aa_lookup_perms(rules->policy, state);
@@ -1378,13 +1378,13 @@ static int label_components_match(struct aa_profile *profile,
 	}
 
 	if ((perms->allow & request) != request)
-		return -EACCES;
+		return DFA_NOMATCH;
 
-	return 0;
+	return state;
 
 fail:
 	*perms = nullperms;
-	return -EACCES;
+	return DFA_NOMATCH;
 }
 
 /**
@@ -1406,7 +1406,7 @@ int aa_label_match(struct aa_profile *profile, struct aa_ruleset *rules,
 	aa_state_t tmp = label_compound_match(profile, rules, label, state, subns,
 					request, perms);
 	if ((perms->allow & request) == request)
-		return 0;
+		return tmp;
 
 	/* failed compound_match try component matches */
 	*perms = allperms;
-- 
2.51.0



