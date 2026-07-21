Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D959E3368A2;
	Tue, 21 Jul 2026 18:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658072; cv=none; b=MSCneniCshgZ6pvpldmaBPtbmPZzCpmBtf9upjB0GIEppP+rdwcOELBfMGu5mINWF2NWrLQhIfJUqskC4GYg52egGhbYfF+4y0LTsv7hvi5qGy6h2NVp8M0iQTvNOLBgFZrap6gpNKO0+VuLe5Km768NRxyZK6gBHFvVk3SRwzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658072; c=relaxed/simple;
	bh=q863jmrpxjC9jJXds4mTQUaohGT2XN1mpYZlBF0R2go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLutB/bqlW3a9q5lAM30m2MdcjVniT7zh/aYnV/8a9fZMKUVazj0ltRonb8YgxyrlVo6dxhu00g+srd8SLztZGLhGRAxSuu7lHc46xt74eTN5R/vfcAsMqtqjOhE62Wh4CXyGa6Kd/aKs8syR29ItYaI8U3RP2vVBBEiyvELL1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmePnDtr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmePnDtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6A01F00A3A;
	Tue, 21 Jul 2026 18:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658071;
	bh=mCK6jU6lIeFEj/yCnllWmDZDI4KG2vFQSxrF5AC4+uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WmePnDtrPMnP/N61cMa0Koli4Mjh68VwfGTCCudmmyPFLGWUWXFLIDZx9yAPmQr6P
	 iQC7FWEVwW8AbyRHK3/Z3ZXQOJfVrpq+NYnO2l9uNmNONxClzpmQChpBu5G71nR2WR
	 Ww2jCgKVojXY3RW0pfp/12+RGM+2WYtKO8fuCpTU=
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
Subject: [PATCH 6.18 1004/1611] afs: Fix misplaced inc of net->cells_outstanding
Date: Tue, 21 Jul 2026 17:18:40 +0200
Message-ID: <20260721152537.979547572@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 71c10a05cebe56..497e876301076f 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -205,11 +205,11 @@ static struct afs_cell *afs_alloc_cell(struct afs_net *net,
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



