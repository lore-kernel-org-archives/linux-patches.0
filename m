Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C1C34252D;
	Sat, 12 Sep 2026 07:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198395; cv=none; b=FL+cgRzc1qQIBeBSFJz8rlaMUaW+19GFuEe6rKEUIC3SQ4aipfFnXhIYDJZqdsJDh9tMmgBqAJ8Ton8jsWhltzhWiJI3+cVKhJD1z+ByaB84muBxH5JcBv+9YDz1dP9t97xvfuopdjSio7DAY1ffTeuh2pSpvBIKt7F8jMwOBF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198395; c=relaxed/simple;
	bh=VQggUJ/bAgr1UALDBHLB0g9AhJY9NRBwvLgxJVFv3Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/CL+QMUO/KwWTkul9L8txu7Z7VB1XUKPBuMT3zADTcaVcJm9ksS2LtBMMQPR6M3ZOMqWLEaaYWvqy7vE4dacxdth8eIUXp8YF2ZhT8HPziVKUIRS+euv8AwWWn24ymKZ1XvJzFOXOTF9hYdkBkixCYjxYLThjBfFuX3pFVaLUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5+MA8Lw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5+MA8Lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9961F000FF;
	Sat, 12 Sep 2026 07:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198393;
	bh=zkMS+WFV5kWo/5CQsrmYcrVPf4tNCQXJj+QVtaAgZ5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f5+MA8LwRZjrzWUzvYBTnNKIESRNNIc2mRnr3hThgIZvsNF3d4qd6Y4D1BAdTToE1
	 nSCOGzOsqA9SU5T+tlITCb40dqXwtu9L5u3NMNueQi6EUns3phdtb/QYErZ/YrjQji
	 mDk91W+DeYwZHO6/79SxFZb5oTbsEKHBf6TfNjok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ben Horgan <ben.horgan@arm.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0372/1815] fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()
Date: Sat, 12 Sep 2026 08:35:22 +0200
Message-ID: <20260912065657.638017355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit f5bcf539484d2d604c2f2330e09487ea090b21c7 ]

A struct rdtgroup is reference counted via rdtgroup::waitcount. Callers that
need the structure to remain valid across a sleep (while waiting on acquiring
rdtgroup_mutex) take a reference with rdtgroup_kn_get() and release it with
rdtgroup_kn_put().

The release path is intended to serve as the fallback freer: if the count
drops to zero and the group has already been marked RDT_DELETED,
rdtgroup_kn_put() frees the structure.

The bulk teardown paths free_all_child_rdtgrp() and rmdir_all_sub() resulting
from a resctrl directory remove or resctrl fs unmount act as the primary
freer: they hold rdtgroup_mutex and free each rdtgroup whose waitcount is
zero, otherwise they set RDT_DELETED and leave the freeing to the last waiter.

These two freers race. rdtgroup_kn_put() commits waitcount == 0 with
atomic_dec_and_test() outside rdtgroup_mutex, then reads rdtgroup::flags.
Between those two operations a concurrent caller of free_all_child_rdtgrp()
or rmdir_all_sub() (which holds the mutex) can observe waitcount == 0 via
atomic_read(), call rdtgroup_remove(), and kfree() the structure.

The subsequent read of rdtgroup::flags in rdtgroup_kn_put() is then
a use-after-free, and the structure may even be freed twice if the freed
memory happens to satisfy the RDT_DELETED flag check.

Replace the bare atomic_dec_and_test() with atomic_dec_and_mutex_lock() so
that the decrement-to-zero takes rdtgroup_mutex before the count becomes
globally visible. The inspection of rdtgroup::flags then runs under the same
mutex held by the bulk freers, making the two paths mutually exclusive.

The common case where the count does not reach zero remains lock-free. Defer
kernfs_unbreak_active_protection() until after the mutex is dropped since
kernfs active protections functionally wrap rdtgroup_mutex. Remove resource
group, which in turn drops its kernfs reference, after kernfs protection is
restored.

  [ bp: Split the commit messsages into smaller, easier-parseable paragraphs. ]

Fixes: b8511ccc75c0 ("x86/resctrl: Fix use-after-free when deleting resource groups")
Closes: https://sashiko.dev/#/patchset/20260515193944.15114-1-tony.luck%40intel.com?part=1
Reported-by: Sashiko <sashiko-bot@kernel.org>
Assisted-by: GitHub_Copilot:gemini-3.1-pro
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/8d028bbea582dc382a4cc166b235f75bd5901aea.1783963505.git.reinette.chatre@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/resctrl/rdtgroup.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index cc9966ff6cdfb..ad280dca301e9 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2608,15 +2608,24 @@ static void rdtgroup_kn_get(struct rdtgroup *rdtgrp, struct kernfs_node *kn)
 
 static void rdtgroup_kn_put(struct rdtgroup *rdtgrp, struct kernfs_node *kn)
 {
-	if (atomic_dec_and_test(&rdtgrp->waitcount) &&
-	    (rdtgrp->flags & RDT_DELETED)) {
+	bool needs_free;
+
+	if (!atomic_dec_and_mutex_lock(&rdtgrp->waitcount, &rdtgroup_mutex)) {
+		kernfs_unbreak_active_protection(kn);
+		return;
+	}
+
+	needs_free = rdtgrp->flags & RDT_DELETED;
+
+	mutex_unlock(&rdtgroup_mutex);
+
+	kernfs_unbreak_active_protection(kn);
+
+	if (needs_free) {
 		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
 		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
 			rdtgroup_pseudo_lock_remove(rdtgrp);
-		kernfs_unbreak_active_protection(kn);
 		rdtgroup_remove(rdtgrp);
-	} else {
-		kernfs_unbreak_active_protection(kn);
 	}
 }
 
-- 
2.53.0



