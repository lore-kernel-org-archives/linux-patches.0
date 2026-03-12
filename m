Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CD22C17A0;
	Thu, 12 Mar 2026 20:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345883; cv=none; b=iM+HFkvS9veoDdp8bCFjlKKckb47biXhmkoKHWDLzro1FMCpKIkxDrKQMnTml3ge1BCBNzhzc6B/X1LuZJx1y59Y4kZ3FHH2k6ssK+8bSNsimcj4/TL++SmWlMPxZm2dey0A7a8+lvWcm0sKepbxuNInIxI4LPFgDmgnClHZcJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345883; c=relaxed/simple;
	bh=MZx/VAsg5G8EqIXprDzJ6VtnHDUBVDe5RNP+lbduWEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fh8ZOlsj1NBMiadvBySq/Fd/L/eIamIRdb00yhOHdGHGLCNxTNJbp7LEdxJ6OM+MfaRvNODiLRu2aBDTtPEHeT6dj88nBzkVBRp29+cIdDlXKExDoKhBy5F60ETe6Ivbt0JYf1InECyP1LibvL8TRLCh12vAUvY5srK2eOVPzvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtL2GA9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtL2GA9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F94C4CEF7;
	Thu, 12 Mar 2026 20:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773345883;
	bh=MZx/VAsg5G8EqIXprDzJ6VtnHDUBVDe5RNP+lbduWEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtL2GA9S3RdtkH4SHX038UntU0nMUzNQ+wVQBOIAxm7TUtRwdFPYBk7OPUsOfeSJb
	 m8mGIN8smJn2vH6s2OxeRgwocQeHYIGm4oeZOFQ2fjsyEylPIh6R7JkaoU9SOHnSn0
	 qPoktRFSzoehW11XXfZPciyi5CEjWSUzNctLDj3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.19 05/13] apparmor: replace recursive profile removal with iterative approach
Date: Thu, 12 Mar 2026 21:03:37 +0100
Message-ID: <20260312200321.872596384@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312200321.671986598@linuxfoundation.org>
References: <20260312200321.671986598@linuxfoundation.org>
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

From: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>

commit ab09264660f9de5d05d1ef4e225aa447c63a8747 upstream.

The profile removal code uses recursion when removing nested profiles,
which can lead to kernel stack exhaustion and system crashes.

Reproducer:
  $ pf='a'; for ((i=0; i<1024; i++)); do
      echo -e "profile $pf { \n }" | apparmor_parser -K -a;
      pf="$pf//x";
  done
  $ echo -n a > /sys/kernel/security/apparmor/.remove

Replace the recursive __aa_profile_list_release() approach with an
iterative approach in __remove_profile(). The function repeatedly
finds and removes leaf profiles until the entire subtree is removed,
maintaining the same removal semantic without recursion.

Fixes: c88d4c7b049e ("AppArmor: core policy routines")
Reported-by: Qualys Security Advisory <qsa@qualys.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -183,19 +183,43 @@ static void __list_remove_profile(struct
 }
 
 /**
- * __remove_profile - remove old profile, and children
- * @profile: profile to be replaced  (NOT NULL)
+ * __remove_profile - remove profile, and children
+ * @profile: profile to be removed  (NOT NULL)
  *
  * Requires: namespace list lock be held, or list not be shared
  */
 static void __remove_profile(struct aa_profile *profile)
 {
+	struct aa_profile *curr, *to_remove;
+
 	AA_BUG(!profile);
 	AA_BUG(!profile->ns);
 	AA_BUG(!mutex_is_locked(&profile->ns->lock));
 
 	/* release any children lists first */
-	__aa_profile_list_release(&profile->base.profiles);
+	if (!list_empty(&profile->base.profiles)) {
+		curr = list_first_entry(&profile->base.profiles, struct aa_profile, base.list);
+
+		while (curr != profile) {
+
+			while (!list_empty(&curr->base.profiles))
+				curr = list_first_entry(&curr->base.profiles,
+							struct aa_profile, base.list);
+
+			to_remove = curr;
+			if (!list_is_last(&to_remove->base.list,
+					  &aa_deref_parent(curr)->base.profiles))
+				curr = list_next_entry(to_remove, base.list);
+			else
+				curr = aa_deref_parent(curr);
+
+			/* released by free_profile */
+			aa_label_remove(&to_remove->label);
+			__aafs_profile_rmdir(to_remove);
+			__list_remove_profile(to_remove);
+		}
+	}
+
 	/* released by free_profile */
 	aa_label_remove(&profile->label);
 	__aafs_profile_rmdir(profile);


