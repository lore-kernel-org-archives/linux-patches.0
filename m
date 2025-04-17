Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59ADE2561A2;
	Thu, 17 Apr 2025 18:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913643; cv=none; b=G9lpksSwQIdNiC7xap6DxbAlfHs2CNzZdKtiuPK9dSEVeELaWKFZvkb4jHNSkaqThECnbHuYw5GLiLzbRfRXREPo5uW6vlyxFMsPJ1SHKUUOb7B9EFznmu9a0Vltu6RSJz/OkVoapAFqADJgbOKA65l4+lghlxRTeM1FKaWJ3RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913643; c=relaxed/simple;
	bh=7DIqei8Zn1AAYT35msUF+paRpcc0aPrOXadE5nPO1PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SUvQQ8JiPAZGv5YehsDueRIZJybavhCoUAI+FP7cioMiM8Qr/jbjJl4MgiF7B5+fECjbdYOnXLJdWibffsts5DQ1OeUIs7fddK09ZoBGtg2qxnXlZFczO++30fLzcv6ICEkPNrD5DPqjLI01/2DJTR/Wp9tmHql+bTqHPvSbEE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyZmituU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyZmituU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C28CC4CEE4;
	Thu, 17 Apr 2025 18:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913642;
	bh=7DIqei8Zn1AAYT35msUF+paRpcc0aPrOXadE5nPO1PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyZmituUL6nXff7zMDobvkF+R+jOUn+CKNMORABx5/gdGTZMtqVO4lRUrZ3hv71P9
	 4ghSBkhfVVddNGEry17zoy9Ym6r1trtPvKNeM62QWhLMUrbuyLLfbP3An6zTXHpkmR
	 9xouB3J72PPXbbil/uRhtEZ8H0EjrBAeiPKzA1co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.14 406/449] landlock: Move code to ease future backports
Date: Thu, 17 Apr 2025 19:51:34 +0200
Message-ID: <20250417175134.616668558@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit 624f177d8f62032b4f3343c289120269645cec37 upstream.

To ease backports in setup.c, let's group changes from
__lsm_ro_after_init to __ro_after_init with commit f22f9aaf6c3d
("selinux: remove the runtime disable functionality"), and the
landlock_lsmid addition with commit f3b8788cde61 ("LSM: Identify modules
by more than name").

That will help to backport the following errata.

Cc: Günther Noack <gnoack@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250318161443.279194-2-mic@digikod.net
Fixes: f3b8788cde61 ("LSM: Identify modules by more than name")
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/setup.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/security/landlock/setup.c
+++ b/security/landlock/setup.c
@@ -19,6 +19,11 @@
 
 bool landlock_initialized __ro_after_init = false;
 
+const struct lsm_id landlock_lsmid = {
+	.name = LANDLOCK_NAME,
+	.id = LSM_ID_LANDLOCK,
+};
+
 struct lsm_blob_sizes landlock_blob_sizes __ro_after_init = {
 	.lbs_cred = sizeof(struct landlock_cred_security),
 	.lbs_file = sizeof(struct landlock_file_security),
@@ -26,11 +31,6 @@ struct lsm_blob_sizes landlock_blob_size
 	.lbs_superblock = sizeof(struct landlock_superblock_security),
 };
 
-const struct lsm_id landlock_lsmid = {
-	.name = LANDLOCK_NAME,
-	.id = LSM_ID_LANDLOCK,
-};
-
 static int __init landlock_init(void)
 {
 	landlock_add_cred_hooks();


