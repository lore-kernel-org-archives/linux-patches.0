Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621939;
	b=mbDRH7+wBe+PR/TJZcICDdvvTm5YaBPJPU9elYsE2YidOP3RhryF3tsQeKMj09KSJKK5
	 PLAD+p9y1Ou2R2Qoj45c9ojloNh/0W9cihS2GYkdU+93x423KLrbyqub/XBr0By9M2sWq
	 +6vPOBcaUzrbD9BcKEtl/o23wW3HRwuIwtmyZYWD+1dRJS74Oxzv55cuJdCUwMvVPbjLf
	 stpXSXS5kCSaVviGORjplvOVFttH/qRHIZ4K2kI8VTPQCesE7Cfy4RhB/bVEt4LdKrb6N
	 1E8lGgi2r8DKs+1VpWA3FItiHDBaiahfigzAw72lCt1jCxH9gH/223CSSBWjBVIUBuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kbi3i0O+W7NU+FYAceYnB8uw+pJJOxQ6ax6Ii8yW1IM=;
	b=m5c0WKlbQR0LheBZ2/zk4J3BE6ZVs6xcYeaZecuY0QdlVBQHJXjwh+E3mWzvHBGPhF3i
	 XXUygB9Mus1fHKCRGe7yu8rzKr6+ilUdcO2eTLweyXeO21D9Y/w43pNSCnrXuBVY42J9C
	 hfoYatysbO+Scq+wpCaW50p0M95TCqc8456tRr5eVMFHIssifB5eWglF+bCseki3Qv1ZD
	 +VcWHQ6ORatdhWdtGkEKnr5N6tg58t41lzDEHZ6No1ckXlXs9yZ/KfIUUv0yFikWDngKk
	 BYkPyyRiJ+/kZvCvBdIEizCHzpktSkEpT1x7BJdYQUSDpvdQvEl3HJN+BkfsPApL8ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ICDvVZDA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EF1606A321;
	Wed, 25 Nov 2026 15:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ICDvVZDA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0B41F000ED;
	Wed, 25 Nov 2026 15:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621938;
	bh=kbi3i0O+W7NU+FYAceYnB8uw+pJJOxQ6ax6Ii8yW1IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICDvVZDAw455mts/D4EUhp/1C/ihjLG+GWpCFK0ExRtUrOfXUF5SOl8CTaqpUfLua
	 NaLqX73N/gS6lSwnrlC5HLycnWKjUjLg6c9swC4c3+ilwLzEml1NdQ8D8va/lexLIO
	 DhXFI/k8vTJYzKeKct5uMSg0Y7PgYLB1aKZaWvW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <aglo@umich.edu>,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 380/990] nfs: fix utimensat() for atime with delegated timestamps
Date: Wed, 25 Nov 2026 15:29:07 +0100
Message-ID: <20261125143830.995297116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 16d99dce938ecbbc703843a31fb951acca46af27 ]

xfstest generic/221 is failing with delegated timestamps enabled.  When
the client holds a WRITE_ATTRS_DELEG delegation, and a userland process
does a utimensat() for only the atime, the ctime is not properly
updated. The problem is that the client tries to cache the atime update,
but there is no mtime update, so the delegated attribute update never
updates the ctime.

Delegated timestamps don't have a mechanism to update the ctime in
accordance with atime-only changes due to utimensat() and the like.
Change the client to issue an RPC in this case, so that the ctime gets
properly updated alongside the atime.

Fixes: 40f45ab3814f ("NFS: Further fixes to attribute delegation a/mtime changes")
Reported-by: Olga Kornievskaia <aglo@umich.edu>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: a38d7cc8c90f ("NFS: update ctime for atime-only UTIME_NOW requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index f74273cca3503..1edc11cd286aa 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -758,14 +758,7 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	} else if (nfs_have_delegated_atime(inode) &&
 		   attr->ia_valid & ATTR_ATIME &&
 		   !(attr->ia_valid & ATTR_MTIME)) {
-		if (attr->ia_valid & ATTR_ATIME_SET) {
-			if (uid_eq(task_uid, owner_uid)) {
-				spin_lock(&inode->i_lock);
-				nfs_set_timestamps_to_ts(inode, attr);
-				spin_unlock(&inode->i_lock);
-				attr->ia_valid &= ~(ATTR_ATIME|ATTR_ATIME_SET);
-			}
-		} else {
+		if (!(attr->ia_valid & ATTR_ATIME_SET)) {
 			nfs_update_delegated_atime(inode);
 			attr->ia_valid &= ~ATTR_ATIME;
 		}
-- 
2.53.0



