Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623389;
	b=DqfTRblcdJpI18htYPFYHN2USWblvMe/iMmueZFxBrKxH8iv5MgOMh//3kCGG4BUKBPu
	 cSr+NwDDeuapqHrluA66i7otkjy9sfswff0KqBlYMtzOXBSIWulsaYJNzoO8ueGI3PbkJ
	 UClGZlkxOgzyCPvUK3mzlC/TsAWNXXgzBgbsdXNco3hpawu+j5UtCJ8s4Rxsi8VcFSr9P
	 hQnGOtXD6HjHEAOGe25yzpdwdZp+M8+0S+ua1vB+gum5drAEM46Mqa7lmYcMM16Tb4STX
	 9dwB8Naq0f31p2HxQGdSkquzQc1/JJxmndyCJQz+Q5xIvaGh9pwCwkSNovVC1/H6Zvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Prl99R43nd2Uc+Kir1Wpy/J8Wj4077e0CWRbO1Yk3DY=;
	b=0VW0+tj+3mKSPTGlBggE0O0JfqMUGqEHHlP7jQhxWBQpw1AqVtYoJOcaHQxG6/OmEtGb
	 IfeNywau4Luvr9zFq2wR2RpTutAapSFKVWMaRpLKAcnR1xYIgOFwITQW9TS61donQEJJs
	 tVx/Bse8vdtW6fAYueS7NRZuwgW42dXSHtkJz7qDp6gXclYytvitZA3Ba/37qIdUNxDa+
	 zdhfLfRWXiIlHzaQYYu1ig6iA6iGyMOyWt8up0tV6MgXvrGbRJhtYUSmC7iqTNY4Y4F/k
	 nqssySdRCFb/Z3WiMBvxPKGi5P+zan8aMV5AL+EH3UIqXLXdtHv87NRC2YpKhZGW+jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1aEtOpB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F9B606A326;
	Wed, 25 Nov 2026 16:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1aEtOpB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE2E1F000C0;
	Wed, 25 Nov 2026 16:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623389;
	bh=Prl99R43nd2Uc+Kir1Wpy/J8Wj4077e0CWRbO1Yk3DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1aEtOpBKdnQaq0kPS+9yHuaCIBf9KE8fJTm0aw4xB3rQtdNrGs+m0g6ucba+rpea
	 H0shdzcfMu9hGUd8IMDB/p6YKfRYPMzHGRJYrDH1B1qX88meJkG5A4BKR+v1Klp6JF
	 iGnjOZpYY5Ae6rFYM4bExjyIkeAZWnJ45pRZWwzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 844/990] smb: client: hold the inode across cifs_oplock_break()
Date: Wed, 25 Nov 2026 15:36:51 +0100
Message-ID: <20261125143841.802693325@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit fce78321f1b59531cf6fc94860550db1db8dec55 upstream.

cifs_oplock_break() drops the handle reference in the middle of the
handler and keeps using cinode afterwards, to send the break
acknowledgment and again in cifs_done_oplock_break().  The reference
cifs_queue_oplock_break() takes is the only pin: the handle holds the
dentry and the dentry is what keeps the inode alive.

When that put is the last reference, the dput() in
cifsFileInfo_put_final() kills an unhashed dentry, drops the last
i_count and evicts the inode, so the rest of the handler runs on an
object whose free is only RCU-deferred.  An unhashed dentry that a
handle still references is an ordinary state: unlinking an open file
leaves the dentry that way, and so does the dcache teardown at unmount.

Take a reference on the inode for the lifetime of the handler and drop
it once the break has been reported.  This also covers the
cifs_get_tlink() failure path, where the put is followed directly by
the out label.

Fixes: b98749cac4a6 ("CIFS: keep FileInfo handle live during oplock break")
Fixes: 23b26f4408ac ("smb: client: avoid leaking refcount when cifs_sb_tlink() fails")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3284,6 +3284,14 @@ void cifs_oplock_break(struct work_struc
 	__u64 persistent_fid, volatile_fid;
 	__u16 net_fid;
 
+	/*
+	 * Dropping the handle reference below also drops the dentry
+	 * reference that pins this inode, and cinode is still needed to
+	 * acknowledge the break and to report it as complete.  Hold the inode
+	 * until that is done.
+	 */
+	ihold(inode);
+
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
 
@@ -3359,6 +3367,7 @@ oplock_break_ack:
 	cifs_put_tlink(tlink);
 out:
 	cifs_done_oplock_break(cinode);
+	iput(inode);
 }
 
 static int cifs_swap_activate(struct swap_info_struct *sis,


