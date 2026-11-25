Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624752;
	b=LrogzBnhBHONGTqCnoCEFkxoTthKvoLBW2UuDlxp9b6HVNJCm6LZFODqw10AUo8A8i44
	 IIyMqvC2EYg6bODIuL8ZsAX8W+FB2B702JcVQ/HLLq9jsKurxMmXqUMq4iJmqoFrk81AS
	 WWV77ghDwQzQZNPwJpv1suf4OyDwt7Ta8KvcsD5bdsqc+NsqbAgpvxHUzLezEmdLkfy8C
	 UNw4WX2YuPh2rEJ+KWcDt4qQBafxSOehMClvRGmu/pCxU7soInXkE1Oul+S0uKa6yDvDD
	 yoWJnLxv0ipSyjOPcMvUuuCprr5ABd3JWe3S/i2mFnI/gpsnIqZbT9r/wUv0R64pXbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dXw6L3HYrvYA5t0+ybuOaJd5T1GUSya2q2DDZE4JmU8=;
	b=YKIgvlNwOFLG375xYwJg4A0J9rld43qDs0QCioAf5/YBBmjvRtCT2xQTNtvEJe3iOY9G
	 ADtUb81an3iazkRQUWhiO8AOwCqylFDGHW0GNV0CSHXs5lU4so60xtHDg8DVGD3ChPtzA
	 jqGfvoLBwM+66we3ASmSgWRz2klwMQI8v/Z4XtB139+SBaPbmI3uXhN6U2DH4uCOSoj8T
	 eJruDr/FnXUuoOT87nbvNENmGJ7XenLz9LBC2iqv+5gIRmjC9Wl7crvJ7ftj88YIinMzQ
	 EmS5yRlB7C+waO3pVha2e7gJNc/kb6riyJXhQSAISOirRYAzK3ageiD4YCg+BdnbE1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cE62oZDb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E48C606A338;
	Wed, 25 Nov 2026 16:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cE62oZDb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BF11F000CA;
	Wed, 25 Nov 2026 16:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624752;
	bh=dXw6L3HYrvYA5t0+ybuOaJd5T1GUSya2q2DDZE4JmU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cE62oZDb3pb6lH+KA/itHVR2IEds4B8fxd99T48V0nxEmt5lAqnl/mHQ2NVaEA+ol
	 WCkaZlzBeYReZ5Bel+WfsxkiWHunebtAhGzfrXqMqLgDv3zlWjXSIJMbvnxO6hwiBO
	 rEQdqxa6VZJG/OeOHPyFARb1idrhiGWAUfa3Jnak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <aglo@umich.edu>,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 296/816] nfs: fix utimensat() for atime with delegated timestamps
Date: Wed, 25 Nov 2026 15:30:44 +0100
Message-ID: <20261125143856.058490447@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 28f7acecb3f82..f29c4ff16b29f 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -747,14 +747,7 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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



