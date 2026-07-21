Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E6C39B4A2;
	Tue, 21 Jul 2026 17:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655194; cv=none; b=OxMB547Lcv3xSTvDbafhKyNO5RgNvoMi+23W/KJYpXUC/2SuQISTT4gvgW0667L1BcyAHZTDlCIpN2ZxS6/M4UbHy990lYJThHIQhtAA8XuLyJfXSjOmi2y5lcXIwFIUz7SavqbvCCdpWy2TmYs8JtUhxfM9jxfKoGBipRvGwTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655194; c=relaxed/simple;
	bh=bLJX8xqm7SuiH4t2O3Xdn0mZgulG+BzwcUxq2z3FN9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2z6iV5KS4BBlD458+dh/K56dW94ymX/DrHd4kNXgqLon+kXCnYZgpfjH/iRYKOkk1lsatKlOT7WIMz8tn9/bm+8TUBYsNU3e6SnvwUvcBB2eXh1r4riU1n06Vuz6cwFz76ZJWSKtkD8cdZwm1Ms5i8aPvNhT0MoTSo4VOLSTec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2HnlxXf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2HnlxXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5CC1F000E9;
	Tue, 21 Jul 2026 17:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655193;
	bh=BpBhXrQiM4MNK87CmXL1L/FkD1ARu3Qi1w0WxVOGvu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J2HnlxXferufwRh9I1zNRsVydxs4rQimYXxh2fAmnlF3vnwqXljqZKSju9Mv995rH
	 7jffoTs7NTBmyrCbR9cQDyZf6S0GkMjkMRWNLZEi7/eXS28yjY+3reblR3+djVcfaI
	 nf6H3hSE4TpenbokM4jHI04q9kumVQuefxTZnPxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 7.1 1984/2077] fs/resctrl: Fix double-add of pseudo-locked regions RMID to free list
Date: Tue, 21 Jul 2026 17:27:37 +0200
Message-ID: <20260721152639.505911547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

commit b9f089723aee892efc77c349ae47a6b452b293c4 upstream.

A pseudo-locked group's RMID is freed when it is created. On unmount
rmdir_all_sub() unconditionally frees all RMID of all groups, resulting
in a double-free of the pseudo-locked group's RMID. The consequence of this
is that the original free results in the pseudo-locked group's RMID being
added to the rmid_free_lru linked list and the second free then attempts
to add the same RMID entry to the rmid_free_lru again.

Do not double-free a pseudo-locked group's RMID.

Fixes: e0bdfe8e36f3 ("x86/intel_rdt: Support creation/removal of pseudo-locked region")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/551432dd7e624a862b8e58314c38aaba0afff3e9.1783377598.git.reinette.chatre@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/resctrl/rdtgroup.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3074,10 +3074,6 @@ static void rmdir_all_sub(void)
 		if (rdtgrp == &rdtgroup_default)
 			continue;
 
-		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
-		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
-			rdtgroup_pseudo_lock_remove(rdtgrp);
-
 		/*
 		 * Give any CPUs back to the default group. We cannot copy
 		 * cpu_online_mask because a CPU might have executed the
@@ -3088,7 +3084,13 @@ static void rmdir_all_sub(void)
 
 		rdtgroup_unassign_cntrs(rdtgrp);
 
-		free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
+		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
+		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
+			rdtgroup_pseudo_lock_remove(rdtgrp);
+		} else {
+			/* Pseudo-locked group's RMID is freed during setup. */
+			free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
+		}
 
 		kernfs_remove(rdtgrp->kn);
 		list_del(&rdtgrp->rdtgroup_list);


