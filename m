Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C18247CC97;
	Thu, 20 Aug 2026 16:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244338; cv=none; b=qylV0UHYPtU/fipGIfc3wF3XciS57joOhOZ8V8/E9eHCPCEF4sE0nJuv4VSiCQmCWFkQQ4QRPWmlQPZtAUI+nrPhqMul0yk9o88P54KlPoJi8W8vI75ZQxjHhfCaeTUudT1Ry5aIAn7lxN6fkS8PXNChEnjMMU4bRyeMzmnoBd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244338; c=relaxed/simple;
	bh=c805yZb5uyZsCUox/F3C5Bu185YS17BE5KBLMuSjUbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxzyOSQz0BXH7HcgVJokI34e7x1S6ZrGC7kl7F+ciNi26kSgq515tf9B1AuqTDh9r4GpOU8osAOVCKLOK3nJ8PZymtWr6bck68WaVO1L3g6gDXoWlWNdkbRYybt4P+5/RAjxWoETlQp48amXUnZpOsu9mEYPdsUgfAbb+VXsN7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWGQzHK3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWGQzHK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D591F000E9;
	Thu, 20 Aug 2026 16:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244337;
	bh=8+FoovU783GaCZW5s5Rxn08nYz6MuWsGJQsiXT+6IWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KWGQzHK337+OEY3CKVBt8UBb0aayY+/G5oX6RA0xdn2eJIL7xq8SgB7sUkopDVQnL
	 /N2HH7GliegqB1N3X2Rndpxg2QqoZkQJUwCehN9Qnxzm8nm9rFN2FiWvd+PzRC5Nz9
	 r9NL6DRMaeRYlLD1Gg0jsg0Sj+zXupQWlSsoNEy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/235] fs/resctrl: Fix double-add of pseudo-locked regions RMID to free list
Date: Thu, 20 Aug 2026 16:56:09 +0200
Message-ID: <20260820145220.477540908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2376,10 +2376,6 @@ static void rmdir_all_sub(void)
 		if (rdtgrp == &rdtgroup_default)
 			continue;
 
-		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
-		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
-			rdtgroup_pseudo_lock_remove(rdtgrp);
-
 		/*
 		 * Give any CPUs back to the default group. We cannot copy
 		 * cpu_online_mask because a CPU might have executed the
@@ -2388,7 +2384,13 @@ static void rmdir_all_sub(void)
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


