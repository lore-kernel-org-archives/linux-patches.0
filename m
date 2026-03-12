Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A24401A29;
	Thu, 12 Mar 2026 20:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345931; cv=none; b=eLE1h2lShBsYoO6bGN4vMLTyMJZ57zIIX8Z6PI6hFJ7RCDC86n3gRsLiR5VJ4KlCQervEgSUQnuuN/k2JAuRkAGSriR0PdY0WkOXxnAFfYfDSYwmUXoZOvcdh+57fL9TzYHaIAhue8+oWi/ztwduUp9a558DGdt47kzmx/RdgPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345931; c=relaxed/simple;
	bh=mv+xTpqjAG9pcIO+00ucmj3N71KJpXvueJQ6SCQCRo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G243P7d1M76cO6XkYx8wY4k4SXXGLpuymy1e80oh1YZraZucpO2OK+eyXkprTmFYRwiPufJv6SDSUt7ELU+0+ezC34HIBsRK2CrOxjejh/Absp+hDMSUe1QpktqO993Q1Qii+RgPQfQOp5SD4DFvKOtJHhvbl9y4WAoa5a6OrzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2wnM5fj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2wnM5fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3752C19425;
	Thu, 12 Mar 2026 20:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773345931;
	bh=mv+xTpqjAG9pcIO+00ucmj3N71KJpXvueJQ6SCQCRo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2wnM5fjf+DP/G1OikkNnFmKq9xACZTt9EL2XaRKRhQxRCAePrOB2XDMZ2IxeP/2u
	 eLxaf0IVp0myRADzK4g9hY2NdDR+DruNrSGFbffOLFkErP4V4kt9rd0PSasGcbkyo7
	 F2rzbVAn9GwplhlP3oZHP6ubCmAay8MBpeBFedYE=
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
Subject: [PATCH 6.18 05/13] apparmor: replace recursive profile removal with iterative approach
Date: Thu, 12 Mar 2026 21:03:46 +0100
Message-ID: <20260312200326.444366074@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312200326.246396673@linuxfoundation.org>
References: <20260312200326.246396673@linuxfoundation.org>
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


