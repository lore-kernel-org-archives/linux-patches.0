Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000178F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B05C433C7;
	Sun, 16 Jul 2023 20:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538643;
	bh=4XPIYxeO2UNBFFtY/YNNZKCxp/tjvlsJGvtUBzpYs4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BiTOhJcs4V0FXYRdRb6Mb8R6Tu3bmWfhKm5OY98O0sfz6b7hj8EDMPlJELfAD4Gkr
	 cd9GPROc7REyB33yg3dNKIraV9ZZe15/wk1isRxhMM2EL0rQKO6M6r9NoadtonW7QE
	 K+QkAP97UAcGvKTni5xY9dwNCjSbrAh6AZSsuEOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Jon Tourville <jontourville@me.com>
Subject: [PATCH 6.4 523/800] apparmor: fix: kzalloc perms tables for shared dfas
Date: Sun, 16 Jul 2023 21:46:16 +0200
Message-ID: <20230716195001.240993832@linuxfoundation.org>
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

commit ec6851ae0ab4587e610e260ddda75f92f3389f91 upstream.

Currently the permstables of the shared dfas are not shared, and need
to be allocated and copied. In the future this should be addressed
with a larger rework on dfa and pdb ref counts and structure sharing.

BugLink: http://bugs.launchpad.net/bugs/2017903
Fixes: 217af7e2f4de ("apparmor: refactor profile rules and attachments")
Cc: stable@vger.kernel.org
Signed-off-by: John Johansen <john.johansen@canonical.com>
Reviewed-by: Jon Tourville <jontourville@me.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy.c        |   13 +++++++++++++
 security/apparmor/policy_unpack.c |   26 ++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 4 deletions(-)

--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -591,7 +591,15 @@ struct aa_profile *aa_alloc_null(struct
 	profile->label.flags |= FLAG_NULL;
 	rules = list_first_entry(&profile->rules, typeof(*rules), list);
 	rules->file.dfa = aa_get_dfa(nulldfa);
+	rules->file.perms = kcalloc(2, sizeof(struct aa_perms), GFP_KERNEL);
+	if (!rules->file.perms)
+		goto fail;
+	rules->file.size = 2;
 	rules->policy.dfa = aa_get_dfa(nulldfa);
+	rules->policy.perms = kcalloc(2, sizeof(struct aa_perms), GFP_KERNEL);
+	if (!rules->policy.perms)
+		goto fail;
+	rules->policy.size = 2;
 
 	if (parent) {
 		profile->path_flags = parent->path_flags;
@@ -602,6 +610,11 @@ struct aa_profile *aa_alloc_null(struct
 	}
 
 	return profile;
+
+fail:
+	aa_free_profile(profile);
+
+	return NULL;
 }
 
 /**
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -988,9 +988,14 @@ static struct aa_profile *unpack_profile
 			info = "failed to remap policydb permission table";
 			goto fail;
 		}
-	} else
+	} else {
 		rules->policy.dfa = aa_get_dfa(nulldfa);
-
+		rules->policy.perms = kcalloc(2, sizeof(struct aa_perms),
+					      GFP_KERNEL);
+		if (!rules->policy.perms)
+			goto fail;
+		rules->policy.size = 2;
+	}
 	/* get file rules */
 	error = unpack_pdb(e, &rules->file, false, true, &info);
 	if (error) {
@@ -1005,9 +1010,22 @@ static struct aa_profile *unpack_profile
 		   rules->policy.start[AA_CLASS_FILE]) {
 		rules->file.dfa = aa_get_dfa(rules->policy.dfa);
 		rules->file.start[AA_CLASS_FILE] = rules->policy.start[AA_CLASS_FILE];
-	} else
+		rules->file.perms = kcalloc(rules->policy.size,
+					    sizeof(struct aa_perms),
+					    GFP_KERNEL);
+		if (!rules->file.perms)
+			goto fail;
+		memcpy(rules->file.perms, rules->policy.perms,
+		       rules->policy.size * sizeof(struct aa_perms));
+		rules->file.size = rules->policy.size;
+	} else {
 		rules->file.dfa = aa_get_dfa(nulldfa);
-
+		rules->file.perms = kcalloc(2, sizeof(struct aa_perms),
+					    GFP_KERNEL);
+		if (!rules->file.perms)
+			goto fail;
+		rules->file.size = 2;
+	}
 	error = -EPROTO;
 	if (aa_unpack_nameX(e, AA_STRUCT, "data")) {
 		info = "out of memory";


