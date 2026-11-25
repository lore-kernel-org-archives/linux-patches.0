Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625971;
	b=f85cXD+Jp4tua6Thkb3Y5uRQm4v7eNGc8Xe5s4WyVgeRNZNa8xG8rG9ixPwgtvWxEKnC
	 pp6OhdC3oIazEu+pNSwyDXWn477GHSR91c8bqxHXfqlhTCYio+Ch1elS4fnZ5J3fEx4MC
	 28Tc2IncrNkCtP07lKlcoVCdMKat7xnl4I83kIZOYjwTHlwT5GoodeVm8A4D2/rkZ4Zad
	 L/8MFn0T9JMz9StUCRBA5HBMrbsWR+Ugh+dQ7Ao7mV8zbMaufa0rqGK2ZAiuMNhcN+qHz
	 2aBLwg27QJFmh8+OCTwMWzhvVbtJlELlUchwAlW7ESO2SZxvDNICv6MfHcnel37QB2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b//PlFI4x+fEryyAIIEz4PGiJnHuBeEnar/6nd1KdW4=;
	b=2aZ2u1iRYU3ZBIQDIgU4oBGiXuu1TbLuUWLNH6L2f3vBR1WJXr2td9YbICAtHA5NKT/F
	 zKJmBreiCkXoQP2USVY9lSAl64qM8JgH+Rpl9DZdJBjXfb/13SW6IPXorl8jNZcImHLJz
	 at89/64N73qusKrIMT8ew1Q82ihWXMWEj+tProDG6Fq4n35ayC3tINiNNXa73+AT3v4I8
	 KH9BglN2HkR58739yO5a9P8OPpTLMDo770nxbbb3DvxuagZ7lOF+BAUs2tO226Gnezjg0
	 ebsunbcY4zym4Xj942UO+p42F1XizZtpMmNFwccvkZxo9yf8HH76QrNGzRUKBDdv4gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xSwO19Ln;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A96B606A31E;
	Wed, 25 Nov 2026 16:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xSwO19Ln
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0B11F000D3;
	Wed, 25 Nov 2026 16:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625971;
	bh=b//PlFI4x+fEryyAIIEz4PGiJnHuBeEnar/6nd1KdW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xSwO19LnzsAiJScg9MII0PUzqSsVDpSwInAon+6FJIYyQzsO15GSwLYJeaIrPKM4x
	 B0rP/x1wNZ89M2l+Dcxiwep+mUuwcmFH+dDKF5cYnJMasEvkRZhzB17hVDdmOIaIQo
	 1AB2PPdOQ38AliFfqff0vAcaaK70jP/FevFELwao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 688/816] smb: client: hold the inode across cifs_oplock_break()
Date: Wed, 25 Nov 2026 15:37:16 +0100
Message-ID: <20261125143905.108155774@linuxfoundation.org>
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
@@ -3188,6 +3188,14 @@ void cifs_oplock_break(struct work_struc
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
 
@@ -3263,6 +3271,7 @@ oplock_break_ack:
 	cifs_put_tlink(tlink);
 out:
 	cifs_done_oplock_break(cinode);
+	iput(inode);
 }
 
 static int cifs_swap_activate(struct swap_info_struct *sis,


