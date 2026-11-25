Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620344;
	b=BqmCobnFK0G+6opuu6l1QR5O+RsGKmSISkdSGH8+hXmyDg2oQMR/drTYFXb1tlR7FDmX
	 ahfBhTkcd68ZXywBpNh5aMfGiDnBEIh/uWYine6xj2o/J8XzlZtuxAHr5m2hpT8DLjORP
	 KB4rJN19gGAAh45STRu1faxgBBl0Uwy2h7j7VECdhJVgbQa0uD0SwRV4PVA4pXc/+f3lc
	 gK8ELOsu+9CquIbCdCf4dI0UW6N7GOb2LLlEfAVE2YvujrgHu2RnozyOHEYHWUMxXOl6w
	 zmhvQ8Fe6RJMyfDvFXN5ZAropV4fXVBAMMHrQRUZblghdfLyJTtQ//x76PTjihzhPHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C8HunEYicyW/vY2iTNT1sZxJoeygMimx/KiqbxcCx3U=;
	b=0rBv3el4QzJWeWDmqcTRlV5LsCbaW/G8nKsLRQW4Y1KIzvSooGapZDWSfdoe2HTunF7t
	 rr77k/6yWruJohDJSHZlDVUsjJc2zKAnpLfGMuNJnws/QUwoEjlOXJH1JqNO/CWQVCa9k
	 r6OJmSy1uKIqljFzxoJNv5rz6G4wLcJRQh34xjituWJE54uqanrjV2a/HGciEspcuq6p+
	 QXy7DziOjxO24CJAdzVgtcC41qnp5htf19AZBhAEZKR3pBk/gzlwZiEvm6EP4gWAsZAV4
	 zgRGFHue6c4FGrxRM18bbWPE7qeA2vJcTifrHyt2/B56ut+M5c+8fKON2f4aVAiFlrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vE7WVZdZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DED606A321;
	Wed, 25 Nov 2026 15:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vE7WVZdZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED161F000D4;
	Wed, 25 Nov 2026 15:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620344;
	bh=C8HunEYicyW/vY2iTNT1sZxJoeygMimx/KiqbxcCx3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vE7WVZdZ051uJSkd85hr9WlszdvVoqdQcjuVSAEYd6+pyPaXt5M4qzEt6CwSld1dm
	 O0/sAtgmVqzqlyLCd8xQ4jNy7XISlEozkNwlNzz30eOcHLf8POy7GzX76uAanv8Y8/
	 BoeEqYQL9h/GqJ5oQPyz36txrxctVRqnHdiryT/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0841/1005] smb: client: hold the inode across cifs_oplock_break()
Date: Wed, 25 Nov 2026 15:36:19 +0100
Message-ID: <20261125143841.416645763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3401,6 +3401,14 @@ void cifs_oplock_break(struct work_struc
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
 
@@ -3488,6 +3496,7 @@ oplock_break_ack:
 	cifs_put_tlink(tlink);
 out:
 	cifs_done_oplock_break(cinode);
+	iput(inode);
 }
 
 #ifdef CONFIG_SWAP


