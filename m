Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621741;
	b=jRFPHa8JW5KML3+Gy5AORN+E9OtQngTEVjxWBQ+z8yBW2PTk1+PcbIaRvHbvnhUqDB4c
	 D54bVcLU9/T0msKAQXUQpllgceBS6zNEjLsC3qvNaDfjGd1VPPxdFDpoOHjjtECGJBD0S
	 3xcfQU9trZaj2a9w7ixVuU3G6naKPXUvy1KpOazAGE+jiZUCodt3As2YGVw6M908Bbnrt
	 ZWP28WpFUWxI5aIAc8Ysq3c/P/XLkXcjdxtoiVedS9mE343z3NVLt2ppstYee4AJk1XlY
	 3gLeOPWiPSGE5EEumk9pbYgiZxtSRg+p0fUXQkwWSCt/JfnilEEimHmaRlvDkdi0IMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h8haKUn7PzPSmW9QWbCDxlib6OoeBybb8F1eu48Fylo=;
	b=kMdrNJFRUaLWHRtdcwco8oblj4z+KonrMs8MOzDIpHajhmKf0VZiTf4qfALe2D1HWxaI
	 SsijIEhu9mkqwLryrA4vrtf9X+Lkg2+Rxf2jsYIClTCT96rrNYa0BuyOWswFeQL/vbzv4
	 UB4kAsEp/Cd7V+wWlVgoTFRy/SGSA0Bf/Ws09Ga2lietJ5PzmrE+fnVQ+DonGo+W2xnrC
	 7oAmYGJWHos6rSbCPf2voEgKJppIdhnVa7bZa7QaFXI7ycGkeh2hlA26tzi8LTizBiPdw
	 Ysv1FuqpeoIuekSaE2y93SaNojkSyEj4dHyBa7v2sOskLHo6Dqvy79tQSpQjNKFfMLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SMUErLjc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95D7606A31E;
	Wed, 25 Nov 2026 15:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SMUErLjc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C536C1F000D1;
	Wed, 25 Nov 2026 15:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621741;
	bh=h8haKUn7PzPSmW9QWbCDxlib6OoeBybb8F1eu48Fylo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SMUErLjcFLRS9cbZLBszyygNmGssU/bAgx0uj0ptRIkavDm8RAqLlNWTud4Q+JCq8
	 DaJjU1iGZBLjaPx3t7B58VjpKKRx2XGZHzjFyDroX/nyKiGZSxGR3EQYg22pfaLt+r
	 cB9mdh5g+5fo0V8i5YqghvK82N1+w4EB/FZX3pz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 305/990] statx: dont leak STATX_ATTR_CHANGE_MONOTONIC in stx_attributes_mask
Date: Wed, 25 Nov 2026 15:27:52 +0100
Message-ID: <20261125143829.237116300@linuxfoundation.org>
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

[ Upstream commit 925d238324c79bcb75ad0add1d1b9d31d5f48115 ]

STATX_ATTR_CHANGE_MONOTONIC is kernel-internal. cp_statx() strips it
from stx_attributes but copies attributes_mask verbatim, so it leaks to
userland on filesystems that advertise it (nfs, ceph), e.g.
stx_attributes_mask = 0x8000000000303000 on NFS.

Add a new mask constant and apply it to both fields.

Fixes: a1175d6b1bda ("vfs: plumb i_version handling into struct kstat")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20261103-statx-v2-1-8b09aa8118ab@kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/stat.c            | 6 +++---
 include/linux/stat.h | 3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 3bc049f0bc3dd..484b61ccc1152 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -718,8 +718,7 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 	/* STATX_CHANGE_COOKIE is kernel-only for now */
 	tmp.stx_mask = stat->result_mask & ~STATX_CHANGE_COOKIE;
 	tmp.stx_blksize = stat->blksize;
-	/* STATX_ATTR_CHANGE_MONOTONIC is kernel-only for now */
-	tmp.stx_attributes = stat->attributes & ~STATX_ATTR_CHANGE_MONOTONIC;
+	tmp.stx_attributes = stat->attributes & ~STATX_ATTR_INTERNAL_MASK;
 	tmp.stx_nlink = stat->nlink;
 	tmp.stx_uid = from_kuid_munged(current_user_ns(), stat->uid);
 	tmp.stx_gid = from_kgid_munged(current_user_ns(), stat->gid);
@@ -727,7 +726,8 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 	tmp.stx_ino = stat->ino;
 	tmp.stx_size = stat->size;
 	tmp.stx_blocks = stat->blocks;
-	tmp.stx_attributes_mask = stat->attributes_mask;
+	tmp.stx_attributes_mask = stat->attributes_mask &
+				  ~STATX_ATTR_INTERNAL_MASK;
 	tmp.stx_atime.tv_sec = stat->atime.tv_sec;
 	tmp.stx_atime.tv_nsec = stat->atime.tv_nsec;
 	tmp.stx_btime.tv_sec = stat->btime.tv_sec;
diff --git a/include/linux/stat.h b/include/linux/stat.h
index e3d00e7bb26d9..3f4364808b7f0 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -69,4 +69,7 @@ struct kstat {
 /* file attribute values */
 #define STATX_ATTR_CHANGE_MONOTONIC	0x8000000000000000ULL /* version monotonically increases */
 
+/* mask of STATX_ATTR_* bits that is private to the kernel */
+#define STATX_ATTR_INTERNAL_MASK	(STATX_ATTR_CHANGE_MONOTONIC)
+
 #endif
-- 
2.53.0



