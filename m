Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A051F47B434;
	Tue, 16 Jun 2026 17:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629689; cv=none; b=RIe5SSsIf2XOQ35dyCKDWJGD8OX//21FMDGC6v9EGCbUlqwso8KsEHL8cJO0qf7WnmYsC/TgKhCNzDqiV6tN2y50MCvi3ocLAotjHgjy7SaKCT2QD8xO2rsSsap3AfdPOpE8VMZr3eVyR44EI8uJVX+8SH7ADF5tadbAZ64K1c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629689; c=relaxed/simple;
	bh=DDUhYVBri/u+K21x6YXpSE/fowehSqQibIHAS/OQR70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTnWEz8obqfe4ISBFhn4DbmU4L2TQPsan2owUN0XgCRJR8/cq/GE+J/BIP2pPTzkKA4Brxi/bSaE+HNCLIRZeDAyrIOeJXf3LGc9TtNn29boSOWAGM2QnUpRoDRuskBOFrPX0LnEVnymL0xDD+nf1FtlFfGQaTWcGI29AWJ97JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edRgS8pI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edRgS8pI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2281F000E9;
	Tue, 16 Jun 2026 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629688;
	bh=JOWIV6bc/rrDnW4pz6FY9/B1QgbVaF6CdCWmBW9yK+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=edRgS8pIaHyXU/APCOGQ8gOVbi5gHp1uYUMhWiXlpaORakHIzWoXkoveAe13nrH0K
	 rwXMzRkrUpojpDLiPnlvU2j00gyEtt0xkx0nunxuMDDjLO4QQb1W7gKQHvhSUpjpcN
	 FsH0F3HckqKzJzNoNSYeKx0qrFKCliH4scugvPyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yilin Zhu <zylzyl2333@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Christian Brauner <brauner@kernel.org>,
	Jeongjun Park <aha310510@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Liam Howlett <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Vasiliy Kulikov <segoon@openwall.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Oleg Nesterov <oleg@redhat.com>,
	Serge Hallyn <serge@hallyn.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 332/452] ipc/shm: serialize orphan cleanup with shm_nattch updates
Date: Tue, 16 Jun 2026 20:29:19 +0530
Message-ID: <20260616145134.803760796@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yilin Zhu <zylzyl2333@gmail.com>

commit 2e5c6f4fd4001562781e99bbfc7f1f0127187542 upstream.

shm_destroy_orphaned() walks the shm idr under shm_ids(ns).rwsem, but that
does not serialize all fields tested by shm_may_destroy().  In particular,
shm_nattch is updated while holding shm_perm.lock, and attach paths can do
that without holding the rwsem.

Do not decide that an orphaned segment is unused before taking the object
lock.  Move the shm_may_destroy() check under shm_perm.lock, matching the
other destroy paths, and unlock the segment when it no longer qualifies
for removal.

Link: https://lore.kernel.org/9d97cc1031de2d0bace0edf3a668818aa2f4eca6.1777410234.git.zylzyl2333@gmail.com
Fixes: 4c677e2eefdb ("shm: optimize locking and ipc_namespace getting")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yilin Zhu <zylzyl2333@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Serge Hallyn <sergeh@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 ipc/shm.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -415,15 +415,17 @@ static int shm_try_destroy_orphaned(int
 	 * We want to destroy segments without users and with already
 	 * exit'ed originating process.
 	 *
-	 * As shp->* are changed under rwsem, it's safe to skip shp locking.
+	 * shm_nattch can be changed under shm_perm.lock without holding the
+	 * rwsem, so take the object lock before checking shm_may_destroy().
 	 */
 	if (!list_empty(&shp->shm_clist))
 		return 0;
 
-	if (shm_may_destroy(shp)) {
-		shm_lock_by_ptr(shp);
+	shm_lock_by_ptr(shp);
+	if (shm_may_destroy(shp))
 		shm_destroy(ns, shp);
-	}
+	else
+		shm_unlock(shp);
 	return 0;
 }
 


