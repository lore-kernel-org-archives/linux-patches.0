Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F813161BF;
	Tue, 21 Jul 2026 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653567; cv=none; b=tgqzjjC7/ZuhBNjZ3w62GdkDvO8Mw6vbyIKy+vbZ1aZvbhLzc/vxxSxqGMf9JrT1e+mnO8W4mQ5gmnJ9hDEux/mckEOtm5tyzOqPrmUGVaMZL9bfiNWGytGHn3Z6/6w08qvWK+W7/mPW6qUg3sJCvNk3PcSLZ0HM1RFoUL8UPH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653567; c=relaxed/simple;
	bh=tAaW4TvupXqT9J4iBfAKn5Tvh8pq6S9sV7qcLsPYzvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6ObPGhr0AmWpoWFpafdSFsp9UwPRPMHEAsb+S0ta5pZvYny++pzi8rEe+54APLNjweHqI+dlSNJO5PCGcT08L6Z5MFgjRbIAFXwjdx244CRqyQ77u4/V4iVL86zlTISurz5DTXoH89zrlQkaDEyGiNZ+0LpDTjWWUyJji6dxbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xtz7Ei+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xtz7Ei+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7591F000E9;
	Tue, 21 Jul 2026 17:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653562;
	bh=IJVMA3zgj6uMKHmhhZ0ospu3n0SPqfXVJ+i8MAGSoz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xtz7Ei+7lEftjal6MD9VnqrCV2sTUrtpR1KDyI5THhdVA1zLZXFXI2HVAKDuKWc90
	 MZJ5+HQHoxP9DARs1tP2ZJVaZHxi4eaTPJsb296tXTwLKHVP6BlM3JxM3cqBInN0Zv
	 dQX8V32AThUFc368Ghzex002xnUhDTWjNXG4Uny8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1373/2077] afs: Fix directory inode initialisation order
Date: Tue, 21 Jul 2026 17:17:26 +0200
Message-ID: <20260721152625.199719615@linuxfoundation.org>
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

[ Upstream commit 35b177ef541ae8eefbfbf679c3476bc3fb1eb83c ]

Fix afs_inode_init_from_status() to call afs_set_netfs_context() before the
switch to do file type-specific initialisation because local directory
changes don't get uploaded to the server, only stored in the cache.

This requires that the file size be set before, so move that up too.

Without this, NETFS_ICTX_SINGLE_NO_UPLOAD as set on directories gets
clobbered.

Closes: https://sashiko.dev/#/patchset/20260618074903.2374756-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-7-dhowells@redhat.com
Fixes: 6dd80936618c ("afs: Use netfslib for directories")
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 54ac6ec21daf48..51c28f14884549 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -93,6 +93,10 @@ static int afs_inode_init_from_status(struct afs_operation *op,
 	inode->i_gid = make_kgid(&init_user_ns, status->group);
 	set_nlink(&vnode->netfs.inode, status->nlink);
 
+	i_size_write(inode, status->size);
+	inode_set_bytes(inode, status->size);
+	afs_set_netfs_context(vnode, status->type == AFS_FTYPE_FILE);
+
 	switch (status->type) {
 	case AFS_FTYPE_FILE:
 		inode->i_mode	= S_IFREG | (status->mode & S_IALLUGO);
@@ -133,10 +137,6 @@ static int afs_inode_init_from_status(struct afs_operation *op,
 		return afs_protocol_error(NULL, afs_eproto_file_type);
 	}
 
-	i_size_write(inode, status->size);
-	inode_set_bytes(inode, status->size);
-	afs_set_netfs_context(vnode, status->type == AFS_FTYPE_FILE);
-
 	vnode->invalid_before	= status->data_version;
 	trace_afs_set_dv(vnode, status->data_version);
 	inode_set_iversion_raw(&vnode->netfs.inode, status->data_version);
-- 
2.53.0



