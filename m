Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585444;
	b=VmcFiNdAfYU113J6dLERS/cRcjWAjoeNI97/HD4CCG/BkxBU+JFGTP+tgfgOZ36JTA13
	 a/dscXtUzoatWoohBNiw68LgzSBSkyfpw7VElJNsJZRcLf4N2wn9nE7QwDcIki7t82A1Z
	 4IKhuSCDNSzhfhIQrUjt0sG0neJL8gEP9v+4q8c86p9BMDjA+Wegz2bGQPpo3whXCEvjB
	 yY038TX2f4xPWLhtcN7SRPseOrrzeskmL13PG+wo1u4Q3MVPwj6Kfvl26eEQYJQAhXR4o
	 6F/gjvzA7kNopiRUs1XdIUu/vSD/kEiat1a9gcY3TqQFKdE2ALjVZLqrMbKgM70Ay+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vrLPp941v/8KTxhF3cyeW2QBm0WM6bUtZ4r2G7huD5s=;
	b=4uvy2xNqb5UNYmq8P6VADa+WVm3u12HXT5TxpIDUV0jaSaq9K7AqMQR3knEbm+OEPlKt
	 ElcMYogF5Bjgn8kUC3YxEoDHF3A2UY96/hzfhdBFF+gnIRCNWbYcLffSUc0lX4khzCu9u
	 dPGEZJapMYj3ocqNXa2TX4FDn1EilTIXy/ROoOxK32Sywg2FuEGk0xAqRxXfPekwuu3i4
	 +c34Ks1NCNat6HhhHlJuySwhZ/COIo/MI50l4bf9u68wi7Xa90dMvbX+tJjMI32HFTll1
	 ECgmzygT78hS0qiEfC90G2eK7o5tUcjHvMi39P/xMNupwGrMUaPkHCDfsyB6sazWfUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DpFVGpeS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4179C606A8A8;
	Fri, 13 Nov 2026 15:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DpFVGpeS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12EC1F000C6;
	Fri, 13 Nov 2026 15:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585444;
	bh=vrLPp941v/8KTxhF3cyeW2QBm0WM6bUtZ4r2G7huD5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DpFVGpeSU9mASkeSyleuJi/vvo05FIcIX3L21cXOZzl2VImq2LR6I7mufLi74Z1kS
	 LYCX4oG4qxztqSQncMj0HyfHC11sVTlIoMyUORaanRVWX1nNHbdyrR3461VV+CmZYV
	 Y9B03jat++w2YncKqptGuhInjBRk0w0jQU+k8Q4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	guolingxing <guolingxing@tju.edu.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 097/507] btrfs: prevent deleting the wrong subvolume by ID
Date: Fri, 13 Nov 2026 10:46:41 -0500
Message-ID: <20261113153757.441399922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: guolingxing <guolingxing@tju.edu.cn>

[ Upstream commit 1960146913b31b288ed2cd607d103ee3b41681d4 ]

When deleting a subvolume by ID, btrfs_ioctl_snap_destroy() first
resolves the requested ID to a name, then looks up that name again
under the parent directory lock.

A concurrent rename can change which subvolume is associated with
the name between these operations. Since the deletion path does not
verify the ID of the resolved subvolume, it can delete a different
subvolume while leaving the requested one intact.

This was reproduced by repeatedly exchanging the names of two
subvolumes using renameat2(RENAME_EXCHANGE) while deleting one of
them by ID. The wrong subvolume was deleted in 9 out of 14 independent
tests.

Fix this by checking that the resolved subvolume ID matches the
requested ID while holding the parent directory lock. Return -EAGAIN
on a mismatch so that userspace can retry the operation instead of
being told that the requested subvolume does not exist.

Fixes: 949964c92843 ("btrfs: add new BTRFS_IOC_SNAP_DESTROY_V2 ioctl")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 905b04ad0ae45..beae9dcb5a3e6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2393,6 +2393,17 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 
 	inode = d_inode(dentry);
 	dest = BTRFS_I(inode)->root;
+
+	/*
+	 * A concurrent rename may have changed which subvolume the name
+	 * refers to. Verify that the resolved ID still matches the requested ID.
+	 */
+	if (destroy_v2 && (vol_args2->flags & BTRFS_SUBVOL_SPEC_BY_ID) &&
+	    btrfs_root_id(dest) != vol_args2->subvolid) {
+		ret = -EAGAIN;
+		goto out_end_removing;
+	}
+
 	if (!capable(CAP_SYS_ADMIN)) {
 		/*
 		 * Regular user.  Only allow this with a special mount
-- 
2.53.0



