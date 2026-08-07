Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FCE39A4C4;
	Fri,  7 Aug 2026 15:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117075; cv=none; b=fUhXWtsMANI/rC+2ibpHAu7MO2z0UAk0wQIRCqSpInPVMapKzkbKO9yNYQHglxXRqBawnmBzNzUAnMW39vrksq9vMnTeqW58rFcaWLmqqkxaXUO4xcXboMhprvfKEAkCtkTgpquwlks9rc4Lnn1aJObaV4oYKl3FXOYHSFzwi30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117075; c=relaxed/simple;
	bh=zw4KBuOIWq+vnf9oCuTbsqmYGWL/MQlT84q9iLpO630=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOqNaJ7PN33slAOJUkEhCBZ6KpSEiNiIpSEr2V5diq0kltBAEzJ5Z+KDZB7rMxjnoYPiHAttYeZuqgBxkrtfT/JvlcBVRgIcWv1Vfp2kwvcaEXyo5SxU519NVBHGH5VGnAnV2xD8KpGoeCJS3mEgKZGNmxl57H85lVKkjCi1lh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qz/Sq+/k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qz/Sq+/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2131F000E9;
	Fri,  7 Aug 2026 15:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117074;
	bh=yQt8Us6c8o0T3worKC3Y7Ei+hzy5o4ASUN05IwGrgsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qz/Sq+/k6xChdZKlnok0I/j/n5c77UxkXQvCAzUJ1Fdl5zLiCRuPWAwCFSCYMs6Dt
	 MFUJve3gdiovumHCAYj8Ar9ctD49Ok4Da85WmxhGlE0ya7RcBcMLEZJAXWbXghMHKg
	 Qc98C3zTofRpNAKFr4DhEcAkOB1YO77hxUJ1GEbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 191/438] mshv: Fix race in mshv_irqfd_deassign
Date: Fri,  7 Aug 2026 16:36:27 +0200
Message-ID: <20260807143432.102174921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

[ Upstream commit 0762262ac3e70f65b3bb843fe892f8bac1562d08 ]

mshv_irqfd_deactivate() and the hlist traversal of pt_irqfds_list
require pt->pt_irqfds_lock to be held, but mshv_irqfd_deassign()
omits it. This races with the EPOLLHUP path in mshv_irqfd_wakeup(),
which does take the lock before calling mshv_irqfd_deactivate().

Additionally, mshv_irqfd_deactivate() uses hlist_del() which poisons
the node pointers rather than resetting them. Since
mshv_irqfd_is_active() relies on hlist_unhashed() (checks pprev ==
NULL), a poisoned node still appears active. If a concurrent path calls
mshv_irqfd_deactivate() again on the same irqfd, the guard fails to
prevent a double hlist_del() on poisoned pointers.

Fix both issues:
- Add the missing spin_lock_irq/spin_unlock_irq around the list
  traversal in mshv_irqfd_deassign(), matching mshv_irqfd_release().
- Use hlist_del_init() instead of hlist_del() so the node is properly
  marked as unhashed after removal, making the is_active guard reliable.

Fixes: 621191d709b14 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Reviewed-by: Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_eventfd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/mshv_eventfd.c b/drivers/hv/mshv_eventfd.c
index 90959f639dc32..5995a62aff8d8 100644
--- a/drivers/hv/mshv_eventfd.c
+++ b/drivers/hv/mshv_eventfd.c
@@ -284,7 +284,7 @@ static void mshv_irqfd_deactivate(struct mshv_irqfd *irqfd)
 	if (!mshv_irqfd_is_active(irqfd))
 		return;
 
-	hlist_del(&irqfd->irqfd_hnode);
+	hlist_del_init(&irqfd->irqfd_hnode);
 
 	queue_work(irqfd_cleanup_wq, &irqfd->irqfd_shutdown);
 }
@@ -541,13 +541,14 @@ static int mshv_irqfd_deassign(struct mshv_partition *pt,
 	if (IS_ERR(eventfd))
 		return PTR_ERR(eventfd);
 
+	spin_lock_irq(&pt->pt_irqfds_lock);
 	hlist_for_each_entry_safe(irqfd, n, &pt->pt_irqfds_list,
 				  irqfd_hnode) {
 		if (irqfd->irqfd_eventfd_ctx == eventfd &&
 		    irqfd->irqfd_irqnum == args->gsi)
-
 			mshv_irqfd_deactivate(irqfd);
 	}
+	spin_unlock_irq(&pt->pt_irqfds_lock);
 
 	eventfd_ctx_put(eventfd);
 
-- 
2.53.0



