Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5B58F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8EDC433C8;
	Sun, 16 Jul 2023 20:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539170;
	bh=NTRnj0rNMB9BgkMjzqlZtrZR3ppqfWKqKjeQjVNJMhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbV7B4nUV/cpUkNLWI4/fKHBHdFC2MAk2ELoHnyqKP3VLhzy1QfmIxcBX4nqAgoU+
	 SbxTix2kkKnsYtOtz9HHwjYcWC0kFkS70CsyjU4cmkqo+XwxCUsMynxh5yV8h4HiWr
	 PVVDOYI6c18N2qXpY1Ejzk6YLLvYQQxZ2s1jvG+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Jon Tourville <jontourville@me.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 712/800] apparmor: fix policy_compat permission remap with extended permissions
Date: Sun, 16 Jul 2023 21:49:25 +0200
Message-ID: <20230716195005.656597281@linuxfoundation.org>
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

[ Upstream commit 0bac2002b397fda7c9ea81ee0b06a02242958107 ]

If the extended permission table is present we should not be attempting
to do a compat_permission remap as the compat_permissions are not
stored in the dfa accept states.

Fixes: fd1b2b95a211 ("apparmor: add the ability for policy to specify a permission table")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Reviewed-by: Jon Tourville <jontourville@me.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 72aac376d3ed7..d50774a16494f 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -860,10 +860,12 @@ static struct aa_profile *unpack_profile(struct aa_ext *e, char **ns_name)
 		}
 		profile->attach.xmatch_len = tmp;
 		profile->attach.xmatch.start[AA_CLASS_XMATCH] = DFA_START;
-		error = aa_compat_map_xmatch(&profile->attach.xmatch);
-		if (error) {
-			info = "failed to convert xmatch permission table";
-			goto fail;
+		if (!profile->attach.xmatch.perms) {
+			error = aa_compat_map_xmatch(&profile->attach.xmatch);
+			if (error) {
+				info = "failed to convert xmatch permission table";
+				goto fail;
+			}
 		}
 	}
 
@@ -983,10 +985,13 @@ static struct aa_profile *unpack_profile(struct aa_ext *e, char **ns_name)
 				      AA_CLASS_FILE);
 		if (!aa_unpack_nameX(e, AA_STRUCTEND, NULL))
 			goto fail;
-		error = aa_compat_map_policy(&rules->policy, e->version);
-		if (error) {
-			info = "failed to remap policydb permission table";
-			goto fail;
+		if (!rules->policy.perms) {
+			error = aa_compat_map_policy(&rules->policy,
+						     e->version);
+			if (error) {
+				info = "failed to remap policydb permission table";
+				goto fail;
+			}
 		}
 	} else {
 		rules->policy.dfa = aa_get_dfa(nulldfa);
@@ -1001,10 +1006,12 @@ static struct aa_profile *unpack_profile(struct aa_ext *e, char **ns_name)
 	if (error) {
 		goto fail;
 	} else if (rules->file.dfa) {
-		error = aa_compat_map_file(&rules->file);
-		if (error) {
-			info = "failed to remap file permission table";
-			goto fail;
+		if (!rules->file.perms) {
+			error = aa_compat_map_file(&rules->file);
+			if (error) {
+				info = "failed to remap file permission table";
+				goto fail;
+			}
 		}
 	} else if (rules->policy.dfa &&
 		   rules->policy.start[AA_CLASS_FILE]) {
-- 
2.39.2



