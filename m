Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28DC46C4D6;
	Tue, 21 Jul 2026 18:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658059; cv=none; b=ImLkQQxZT7Z3D0jDd5LGdInns5QGgvMby4Guj+syFylDT8W4kSBDPAr9zmIfs0DIVGjXPXg5I3TqPr5cfaexpK10t256Lmzcjp621lJnsV5uibHWhVc2U3oppQZfrFACwMSO+bHfy6xBCME9Xb4qD5xCloAnSPNpC8JUK0bINMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658059; c=relaxed/simple;
	bh=O23IgMNHcCfW43CAusw6ROTR1QC3IeBegC1an961yjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLDbgW9l8PMVyJEaQHZrUk6o79A7YbUiO84TwbR8dKwit9ifiibuDVqN8+RhxRMYjkycXmxzECubZ+aM468xiJlqkn7rgO5ATIQigVhOw77yV8PVk1qCcNc0ejXYz6P3VK3fiGD6dt79ZhPM4G1gGhDLlZr0olbXqykM+CEoeX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIN1xppV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIN1xppV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C531F000E9;
	Tue, 21 Jul 2026 18:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658058;
	bh=3EgYcNO843BEs4GdkgERrboDIso4w+coaca7ppkHHJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIN1xppViyPIkQ2+19LUO9J+qGtm4y7QhcAd01Xbrq71kDlZ1Wv53RHtqrohlMSNy
	 Fp5U0Pqv6lgsM1dMBG976dZ/n8NiZanxsLo1gqFFkFp3rt+ORyxu1nfq31FvHGHZMO
	 Pyk76AI2cREAvxOYUDaHXWR8LWjXkX7IebQotMm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1000/1611] afs: Fix double netfs initialisation in afs_root_iget()
Date: Tue, 21 Jul 2026 17:18:36 +0200
Message-ID: <20260721152537.887062717@linuxfoundation.org>
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
index e1cb17b8579139..4890fd00b3a94f 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -643,7 +643,6 @@ struct inode *afs_root_iget(struct super_block *sb, struct key *key)
 
 	vnode = AFS_FS_I(inode);
 	vnode->cb_v_check = atomic_read(&as->volume->cb_v_break);
-	afs_set_netfs_context(vnode);
 
 	op = afs_alloc_operation(key, as->volume);
 	if (IS_ERR(op)) {
-- 
2.53.0



