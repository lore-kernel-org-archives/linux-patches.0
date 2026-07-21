Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6938C46D08C;
	Tue, 21 Jul 2026 19:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663295; cv=none; b=nhdqqK2SehSWePQzrn7NBeEDBSF5j+caSFwXNZc0WksypRy79o6JZGtkNPk9te4LuzIcpVva42F3pIHya56wEl/XtksRsJn0sFEwMCXQtFUWosvI2Yv4t7Z8Adrg5NxmKjBnLnDyMipFH6WwQKg6hU4GCQf6m0C6MK9qxfc1E3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663295; c=relaxed/simple;
	bh=jMsxGcZiJ2gmRKIuoFiGt3oRqb6KzQ807oXUn8TFzRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEtYpNsj+4+w3oABr4lqGU0OEr51GuNLw03XkN5F7w4QpDCXkVb92cVbRZ41Rkz+LsQQgIo/f2kF+T1PbFcafTVqDNBMw2wgN/hC7kc+1J+giOKT2Tw4l1uPHPAY8jhA60SQ+1aml9tHjMk3KWGEyMzVNV4Xrs9Nmn4noadrAAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iT75lPMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iT75lPMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BFE1F000E9;
	Tue, 21 Jul 2026 19:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663287;
	bh=3TqYh0Hqr2EpG8inuFbfWcr+3bms5Y+92/gfFGRV0pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iT75lPMbrdz9i7MYsVULVFkPbyIEnNMuagn+P8fBfiA1m6e+lYmQJ6t65dJZfbYeb
	 tgPs9a+y1/b2I6rtEWZnooKMoUeWmxub6FNHElHIPf1iSwRe0gMeWSmrjRawzYj9iq
	 Fh1+dEDpG/CTLCYOrFD1RcBawBx/Kt68nhQYVRes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0739/1276] afs: Fix missing NULL pointer check in afs_break_some_callbacks()
Date: Tue, 21 Jul 2026 17:19:42 +0200
Message-ID: <20260721152502.618554124@linuxfoundation.org>
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

[ Upstream commit 794a01110390c1b76f59ece773fb0fbfd89c6f5c ]

Fix afs_break_some_callbacks() to check to see if afs_lookup_volume_rcu()
returned NULL (e.g. the specified volume is unknown).

Fixes: 8230fd8217b7 ("afs: Make callback processing more efficient.")
Closes: https://sashiko.dev/#/patchset/20260609081738.770127-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-16-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/callback.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index 462b10fa46e1aa..4ddc2d666dfb0b 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -220,7 +220,11 @@ static void afs_break_some_callbacks(struct afs_server *server,
 
 	rcu_read_lock();
 	volume = afs_lookup_volume_rcu(server->cell, vid);
-	if (cbb->fid.vnode == 0 && cbb->fid.unique == 0) {
+	if (!volume) {
+		/* Ignore breaks on unknown volumes. */
+		rcu_read_unlock();
+		*_count = 0;
+	} else if (cbb->fid.vnode == 0 && cbb->fid.unique == 0) {
 		afs_break_volume_callback(server, volume);
 		*_count -= 1;
 		if (*_count)
-- 
2.53.0



