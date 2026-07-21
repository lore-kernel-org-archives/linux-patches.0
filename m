Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1AA3E1729;
	Tue, 21 Jul 2026 17:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653559; cv=none; b=BrDJ101BvZtzlBycPnJmWeRzl4ImlHd35DgfzbcWaqmln6LaI0eYojHOPjDLgl6NIj0R1NFm/+wV/r5oOEfyDYLv/s11mD87Dr2e/wHa7lSIlbysany2z+YYiomzO3ALPo0NUZ9pUcFZ07PRAN0BeOCekia1L500wbD/BEMtcYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653559; c=relaxed/simple;
	bh=pKS/g4ra8CS2tHedxaYOfrMFpLsn5zrUetdX/ZLxP0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVLTQhthBNZgmtqqNHAo4jkUBmgpqiWRNWkZjnYV9bNulNImVuBvHXMuHPghrJpDim15ui9Wn39pYjdBjZpLTGdhGuiohEZEXYPhKXslkzGNf8MqvudfQFr8YHVp+0U37oLduIP4nuoOAlgG/6F4d91R0KwTCXqs90hWqjkMzqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3qWfuQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3qWfuQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCD51F000E9;
	Tue, 21 Jul 2026 17:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653557;
	bh=/AYqgYD7InAB9x9yuOEkz+eBsERwAT4g9sZxFtMU1pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y3qWfuQL83YPufeJarmDX2rJndJYjdUb0F98WL31eviVnSswNT2g49qc6mwEsF7Fh
	 X+VlI0g/DPpyVKmdVaNCBPIhLdYkEikdrHggbsLPcu0SjzKBuEDK3uQFitp6xPnESE
	 DTieKaD0KLBA+tV6mD8/VDjZEHI+ePayXu7wVYu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1371/2077] afs: Fix double netfs initialisation in afs_root_iget()
Date: Tue, 21 Jul 2026 17:17:24 +0200
Message-ID: <20260721152625.153163351@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 733a984a4ee7345325e47efb505eebfe67b299bc ]

Fix afs_root_iget() to leave initialisation of the netfs_inode part of the
afs_vnode to afs_inode_init_from_status().

Fixes: bc899ee1c898 ("netfs: Add a netfs inode context")
Closes: https://sashiko.dev/#/patchset/20260609081738.770127-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-5-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 3f48458694baa5..a88995629d728e 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -566,7 +566,6 @@ struct inode *afs_root_iget(struct super_block *sb, struct key *key)
 
 	vnode = AFS_FS_I(inode);
 	vnode->cb_v_check = atomic_read(&as->volume->cb_v_break);
-	afs_set_netfs_context(vnode);
 
 	op = afs_alloc_operation(key, as->volume);
 	if (IS_ERR(op)) {
-- 
2.53.0



