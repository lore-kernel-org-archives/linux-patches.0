Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216632;
	b=UMpxJqaMVRgclyBPSd7nsi+KIcPo+s3k4SlGFqTPDoo2cZXKed+Qb4y+i8RDxRunJAge
	 A4fp6qxNpl03N+xvQiMCJJxlA9Wt+r61Jnedb0Ov15FwQy3K7RC9TH1EQ81j7XP2uRYZd
	 xzOjnKvGI4i6apn6XYyRfIUDHdzLgUd7DqxSYav+9eOvd1+cAd3G0DSHh8OvFUVbH4/CY
	 1gqhE2iDHvWOwAJzxbnsVYc8Tpvr1/mcpwvl/LU6V0EvXrGweldoXBexagJL2Sa0Cz7a0
	 V3ymjDi42vOs0zfI/tmklwBBywO4x/+laTicTBvgetF3t5fGD5cjQPCfgbQoYp4HQPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=idi84Qplnk5MgsS7L4YxfbT9IugDBYNu730qrMoXYLE=;
	b=dopEPRrWPfq0Ld2ZWJhMZS30BeGxAC3saePpQX/Beft5wq+mIic5e676q16g276+eksp
	 KNsg203mL1wnIGXCIxY7fmWHfgaB20W0+s2xK8nvpbOpfofqzfuFuJvzrDcU4KxSB1aFh
	 onnYS27h2SMeSlZoLPkSDE3zg+vrH1Q+0i8n081+bEIuWxV8U+Td2CoG1qgC0uminK5t0
	 i8hrD5wzPd0+KO9hWIEGcg6oZkd4qMx/s83dspkK2tCqd8A8wobQVKfrq8wTNfmxzTP5Y
	 J/YW8E2k9d1irZSMeXL9t5k2USpS5lkV/gVqXOmxu+P8jf/qgbPQ6nlnCCizT2NO26Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eognOa52;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B767C606A31A;
	Wed, 28 Oct 2026 19:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eognOa52
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99161F01825;
	Wed, 28 Oct 2026 19:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216631;
	bh=idi84Qplnk5MgsS7L4YxfbT9IugDBYNu730qrMoXYLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eognOa52Sy+kwxFPhtZlRw8qUgrzKmSbYZlSWSQa4nLRM931a7/6HQwIL9eKG/aH5
	 MUafEm5sHpd6Pl3W8NjZYcIeh2qDopgsMi842eHDE+mavX2bWd2MagRuD1QcAyqMGF
	 iFJDZWaBQZHGxmOGRKUW2bYWkA5ymI9MDuTunnxU=
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
Subject: [PATCH 6.1 1624/1887] fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()
Date: Wed, 28 Oct 2026 18:02:00 +0100
Message-ID: <20261028170536.423520021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 1100747ffebf7..6de03440d66ae 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2068,20 +2068,23 @@ void rdtgroup_kn_unlock(struct kernfs_node *kn)
 {
 	struct rdtgroup *rdtgrp = kernfs_to_rdtgroup(kn);
 
+	bool needs_free;
+
 	if (!rdtgrp)
 		return;
 
+	needs_free = atomic_dec_and_test(&rdtgrp->waitcount) &&
+		     (rdtgrp->flags & RDT_DELETED);
+
 	mutex_unlock(&rdtgroup_mutex);
 
-	if (atomic_dec_and_test(&rdtgrp->waitcount) &&
-	    (rdtgrp->flags & RDT_DELETED)) {
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



