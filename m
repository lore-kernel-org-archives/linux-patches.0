Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D423F1E9919;
	Thu, 20 Aug 2026 16:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243743; cv=none; b=oWOxjzieOKM8X9rhkNm/wVUJVQvpj85TQ2X9drGbOqr8BT9FqyzcqmqLgAXJnvdHJM6ohaRTaxE4Ot0lXxSSu5BEsidavPrRaTwFEW1Q5A9FmZsLu+DOtbw4MAvdnnUwK2fmLUZeRvTY7JsOoK3Y/+hJXXeJOO6ar+CUFw4v3uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243743; c=relaxed/simple;
	bh=c6r4du/5sRjFcsBG57VrpVcB5i9tz+6xF6s6rBfAyWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3wyp2aWTXh6XqaDLPveA+XpoMYl7uDgKzAjQgs5JLBCW4DsiBiOG+9j9ah8P1vGnFX/7WK0RPnwbJw/oyfX1Kj4Tz6WHo4UDVEo2wf/UD/8PQOgUackdt48rFs/xuNHPzb0njPknh9YCkS9r1l9didCBxWqDTIz8Rf30Rq7XAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jMF90lT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jMF90lT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C1B1F000E9;
	Thu, 20 Aug 2026 16:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243741;
	bh=OGluymcNy52Ff+b/tq27nfjFerrsFebk8V1bsDTUEkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1jMF90lTrrUQ6HpI2m5RE6tLGRHXXxMDkDFkgGhDxTU4RVFMqOQfo7Y9Bt+10pde1
	 Ar7Q6oVVMlFnvhQdz7xEvp6bALdmj68/Ncq90PYFporf+Ktg0SCZCYoPPQRCVC7gH5
	 Tih7byko7hmIJEGMoXdo2vXyIHrKMKl9qAmYSFvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/272] fs/resctrl: Fix double-add of pseudo-locked regions RMID to free list
Date: Thu, 20 Aug 2026 16:55:45 +0200
Message-ID: <20260820145236.151350909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit b9f089723aee892efc77c349ae47a6b452b293c4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2439,10 +2439,6 @@ static void rmdir_all_sub(void)
 		if (rdtgrp == &rdtgroup_default)
 			continue;
 
-		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
-		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
-			rdtgroup_pseudo_lock_remove(rdtgrp);
-
 		/*
 		 * Give any CPUs back to the default group. We cannot copy
 		 * cpu_online_mask because a CPU might have executed the
@@ -2451,7 +2447,13 @@ static void rmdir_all_sub(void)
 		cpumask_or(&rdtgroup_default.cpu_mask,
 			   &rdtgroup_default.cpu_mask, &rdtgrp->cpu_mask);
 
-		free_rmid(rdtgrp->mon.rmid);
+		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
+		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
+			rdtgroup_pseudo_lock_remove(rdtgrp);
+		} else {
+			/* Pseudo-locked group's RMID is freed during setup. */
+			free_rmid(rdtgrp->mon.rmid);
+		}
 
 		kernfs_remove(rdtgrp->kn);
 		list_del(&rdtgrp->rdtgroup_list);


