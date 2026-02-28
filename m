Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557E739B95A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302548; cv=none; b=XQU+aWVEdYvoMJ/korsOfMiYzHEhfsgDLYMnq6eLKnqlu1HbUdBWWzgXuMESbGEoyI4Ud9jt5nBDZ9a1GmP40owkTkn2vGN2fry7xuEyD/KtCKIV4q9agEotTRKIwLzzDx3bYUOD+ChJvAhlJ7ZIvMWvx00S/fLzQHx+m5s3qGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302548; c=relaxed/simple;
	bh=mAxOZJcZS3GneMlQjIRke1siAa5SjrZIlBLyfg1N+4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TFdmkeOaox0uo5wlVrmfR9xjcrdZoqIkngK3mwN+UuhGWB/u4tfanNrJeuyRw9fbNooGZ8qvg/hOcAuKf7ell8jdYVa5c+ipV+VpDfdhIndog0N71M0YJdJM33kFnZkLjAU6kRfT1/kO44ab+dZxQxa3xw13RhSGlQ0fqcXfWbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y2lCsTLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y2lCsTLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94A8C116D0;
	Sat, 28 Feb 2026 18:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302548;
	bh=mAxOZJcZS3GneMlQjIRke1siAa5SjrZIlBLyfg1N+4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2lCsTLHOfjMgl9+kccs/n/aHSUJ5HvFMqP0t+iz3uuvKwvcUDw+Q+BLoZzl5muCp
	 mMXdh0uPyYUHENU7/1AA2MTK31DTKnTGY9u6UJqjl118D6ygLcgFSVrj9SP7raUBGP
	 6WH/JSo8/utrvG8A+GG68BznHHLB91QNCeqSEtPYqqJPAZVKU2mhDZkA0a2FTCqFop
	 gjuchdm1Aju3uDAvqBTF2AG3kd2wgzISjT3ghEaqo2Jh6herAosORwyahDiypebZZT
	 oVliuHMq2RMO61vuIYT+6hYFI1nx7FPtElyiOh/ku2JidusK//FMgX0GCQ5Wq8Dd16
	 IpPUgjRoIWGUA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/164] smack: /smack/doi: accept previously used values
Date: Sat, 28 Feb 2026 13:13:10 -0500
Message-ID: <20260228181505.1600663-51-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit 33d589ed60ae433b483761987b85e0d24e54584e ]

Writing to /smack/doi a value that has ever been
written there in the past disables networking for
non-ambient labels.
E.g.

    # cat /smack/doi
    3
    # netlabelctl -p cipso list
    Configured CIPSO mappings (1)
     DOI value : 3
       mapping type : PASS_THROUGH
    # netlabelctl -p map list
    Configured NetLabel domain mappings (3)
     domain: "_" (IPv4)
       protocol: UNLABELED
     domain: DEFAULT (IPv4)
       protocol: CIPSO, DOI = 3
     domain: DEFAULT (IPv6)
       protocol: UNLABELED

    # cat /smack/ambient
    _
    # cat /proc/$$/attr/smack/current
    _
    # ping -c1 10.1.95.12
    64 bytes from 10.1.95.12: icmp_seq=1 ttl=64 time=0.964 ms
    # echo foo >/proc/$$/attr/smack/current
    # ping -c1 10.1.95.12
    64 bytes from 10.1.95.12: icmp_seq=1 ttl=64 time=0.956 ms
    unknown option 86

    # echo 4 >/smack/doi
    # echo 3 >/smack/doi
!>  [  214.050395] smk_cipso_doi:691 cipso add rc = -17
    # echo 3 >/smack/doi
!>  [  249.402261] smk_cipso_doi:678 remove rc = -2
!>  [  249.402261] smk_cipso_doi:691 cipso add rc = -17

    # ping -c1 10.1.95.12
!!> ping: 10.1.95.12: Address family for hostname not supported

    # echo _ >/proc/$$/attr/smack/current
    # ping -c1 10.1.95.12
    64 bytes from 10.1.95.12: icmp_seq=1 ttl=64 time=0.617 ms

This happens because Smack keeps decommissioned DOIs,
fails to re-add them, and consequently refuses to add
the “default” domain map:

    # netlabelctl -p cipso list
    Configured CIPSO mappings (2)
     DOI value : 3
       mapping type : PASS_THROUGH
     DOI value : 4
       mapping type : PASS_THROUGH
    # netlabelctl -p map list
    Configured NetLabel domain mappings (2)
     domain: "_" (IPv4)
       protocol: UNLABELED
!>  (no ipv4 map for default domain here)
     domain: DEFAULT (IPv6)
       protocol: UNLABELED

Fix by clearing decommissioned DOI definitions and
serializing concurrent DOI updates with a new lock.

Also:
- allow /smack/doi to live unconfigured, since
  adding a map (netlbl_cfg_cipsov4_map_add) may fail.
  CIPSO_V4_DOI_UNKNOWN(0) indicates the unconfigured DOI
- add new DOI before removing the old default map,
  so the old map remains if the add fails

(2008-02-04, Casey Schaufler)
Fixes: e114e473771c ("Smack: Simplified Mandatory Access Control Kernel")

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 71 +++++++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 26 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index c0811defd2086..0e05b45052615 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -67,6 +67,7 @@ enum smk_inos {
 static DEFINE_MUTEX(smack_cipso_lock);
 static DEFINE_MUTEX(smack_ambient_lock);
 static DEFINE_MUTEX(smk_net4addr_lock);
+static DEFINE_MUTEX(smk_cipso_doi_lock);
 #if IS_ENABLED(CONFIG_IPV6)
 static DEFINE_MUTEX(smk_net6addr_lock);
 #endif /* CONFIG_IPV6 */
@@ -138,7 +139,7 @@ struct smack_parsed_rule {
 	int			smk_access2;
 };
 
-static u32 smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
+static u32 smk_cipso_doi_value = CIPSO_V4_DOI_UNKNOWN;
 
 /*
  * Values for parsing cipso rules
@@ -678,43 +679,60 @@ static const struct file_operations smk_load_ops = {
 };
 
 /**
- * smk_cipso_doi - initialize the CIPSO domain
+ * smk_cipso_doi - set netlabel maps
+ * @ndoi: new value for our CIPSO DOI
+ * @gfp_flags: kmalloc allocation context
  */
-static void smk_cipso_doi(void)
+static int
+smk_cipso_doi(u32 ndoi, gfp_t gfp_flags)
 {
-	int rc;
+	int rc = 0;
 	struct cipso_v4_doi *doip;
 	struct netlbl_audit nai;
 
-	smk_netlabel_audit_set(&nai);
+	mutex_lock(&smk_cipso_doi_lock);
 
-	rc = netlbl_cfg_map_del(NULL, PF_INET, NULL, NULL, &nai);
-	if (rc != 0)
-		printk(KERN_WARNING "%s:%d remove rc = %d\n",
-		       __func__, __LINE__, rc);
+	if (smk_cipso_doi_value == ndoi)
+		goto clr_doi_lock;
+
+	smk_netlabel_audit_set(&nai);
 
-	doip = kmalloc(sizeof(struct cipso_v4_doi), GFP_KERNEL | __GFP_NOFAIL);
+	doip = kmalloc(sizeof(struct cipso_v4_doi), gfp_flags);
+	if (!doip) {
+		rc = -ENOMEM;
+		goto clr_doi_lock;
+	}
 	doip->map.std = NULL;
-	doip->doi = smk_cipso_doi_value;
+	doip->doi = ndoi;
 	doip->type = CIPSO_V4_MAP_PASS;
 	doip->tags[0] = CIPSO_V4_TAG_RBITMAP;
 	for (rc = 1; rc < CIPSO_V4_TAG_MAXCNT; rc++)
 		doip->tags[rc] = CIPSO_V4_TAG_INVALID;
 
 	rc = netlbl_cfg_cipsov4_add(doip, &nai);
-	if (rc != 0) {
-		printk(KERN_WARNING "%s:%d cipso add rc = %d\n",
-		       __func__, __LINE__, rc);
+	if (rc) {
 		kfree(doip);
-		return;
+		goto clr_doi_lock;
 	}
-	rc = netlbl_cfg_cipsov4_map_add(doip->doi, NULL, NULL, NULL, &nai);
-	if (rc != 0) {
-		printk(KERN_WARNING "%s:%d map add rc = %d\n",
-		       __func__, __LINE__, rc);
-		netlbl_cfg_cipsov4_del(doip->doi, &nai);
-		return;
+
+	if (smk_cipso_doi_value != CIPSO_V4_DOI_UNKNOWN) {
+		rc = netlbl_cfg_map_del(NULL, PF_INET, NULL, NULL, &nai);
+		if (rc && rc != -ENOENT)
+			goto clr_ndoi_def;
+
+		netlbl_cfg_cipsov4_del(smk_cipso_doi_value, &nai);
 	}
+
+	rc = netlbl_cfg_cipsov4_map_add(ndoi, NULL, NULL, NULL, &nai);
+	if (rc) {
+		smk_cipso_doi_value = CIPSO_V4_DOI_UNKNOWN; // no default map
+clr_ndoi_def:	netlbl_cfg_cipsov4_del(ndoi, &nai);
+	} else
+		smk_cipso_doi_value = ndoi;
+
+clr_doi_lock:
+	mutex_unlock(&smk_cipso_doi_lock);
+	return rc;
 }
 
 /**
@@ -1617,11 +1635,8 @@ static ssize_t smk_write_doi(struct file *file, const char __user *buf,
 
 	if (u == CIPSO_V4_DOI_UNKNOWN || u > U32_MAX)
 		return -EINVAL;
-	smk_cipso_doi_value = u;
-
-	smk_cipso_doi();
 
-	return count;
+	return smk_cipso_doi(u, GFP_KERNEL) ? : count;
 }
 
 static const struct file_operations smk_doi_ops = {
@@ -2998,6 +3013,7 @@ static int __init init_smk_fs(void)
 {
 	int err;
 	int rc;
+	struct netlbl_audit nai;
 
 	if (smack_enabled == 0)
 		return 0;
@@ -3016,7 +3032,10 @@ static int __init init_smk_fs(void)
 		}
 	}
 
-	smk_cipso_doi();
+	smk_netlabel_audit_set(&nai);
+	(void) netlbl_cfg_map_del(NULL, PF_INET, NULL, NULL, &nai);
+	(void) smk_cipso_doi(SMACK_CIPSO_DOI_DEFAULT,
+			     GFP_KERNEL | __GFP_NOFAIL);
 	smk_unlbl_ambient(NULL);
 
 	rc = smack_populate_secattr(&smack_known_floor);
-- 
2.51.0

