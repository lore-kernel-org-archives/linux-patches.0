Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C88342FCBC;
	Tue, 21 Jul 2026 19:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663230; cv=none; b=dE0PDEVfTK78pEECJY49jTPlFzFpeEcI3EvwkxHyMnJJ32N50aECcmAQvwtJTLOK9tJvcvRFKPkXzFvB4pr2W9ovQHGeSN3WfIoAJTkOGRM0/pgoWUiVrAxgXAeuE533s+UEHzHOIwik0jPcsqQAsVvu21fJBUz0gwnRpJ8KeLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663230; c=relaxed/simple;
	bh=0FVTuKYXmUi7nto2afBV1iHefJfMqGo4+g5RcDdCjfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFdNIrVVFHvcH+lv1u+r9js/DaUC/PpFgSarhQj6RjGdnRmiuroUJauTxNJ8oq5+F8qGq9WYYF7nfkOaVZlCH4kasSC3JQ+Yy+T4hDSlbYxOK3pU+8CIi511B7OhOElKxsxSIwQIuIW6CgqNm+3WM3Dx+xTwa/Tzf/+ujApNqNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zeUtxzkk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeUtxzkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A7D1F000E9;
	Tue, 21 Jul 2026 19:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663228;
	bh=0WoF4MuxRLs3//e1V31iSXpvmX/KWHc21O9ijZHNuGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zeUtxzkkW6udxtJIh4PoqXi8TXtnudf+Gvfk6dREgyCtvWW9V+Nor4IZfetHtwQyl
	 O0Fx23ijjAruzmUFev9dpdJWV3WUiaj7mt+pgjcCaN+E6guShzhc6B1lwmd7xVm/GY
	 sN/WxaXEpEHcEu8ep0NgvY1QQItTl38xERwTXJlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hillf Danton <hdanton@sina.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0737/1276] afs: Fix misplaced inc of net->cells_outstanding
Date: Tue, 21 Jul 2026 17:19:40 +0200
Message-ID: <20260721152502.573879673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit c9c3b615a462a4023bd148f02c564e175ed10502 ]

Fix net->cells_outstanding being incremented before the check for failure
of idr_alloc_cyclic(), leaving the count incremented on error.

Fixes: 88c853c3f5c0 ("afs: Fix cell refcounting by splitting the usage counter")
Reported-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-12-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index c2e44cd2eb96cb..1fb1f97d720e0d 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -203,11 +203,11 @@ static struct afs_cell *afs_alloc_cell(struct afs_net *net,
 	cell->dns_source = vllist->source;
 	cell->dns_status = vllist->status;
 	smp_store_release(&cell->dns_lookup_count, 1); /* vs source/status */
-	atomic_inc(&net->cells_outstanding);
 	ret = idr_alloc_cyclic(&net->cells_dyn_ino, cell,
 			       2, INT_MAX / 2, GFP_KERNEL);
 	if (ret < 0)
 		goto error;
+	atomic_inc(&net->cells_outstanding);
 	cell->dynroot_ino = ret;
 	cell->debug_id = atomic_inc_return(&cell_debug_id);
 
-- 
2.53.0



