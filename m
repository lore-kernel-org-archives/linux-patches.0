Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060067;
	b=YvHrsSLlQjrl5dNd2qylvmL0d0foTobulayg8H82DjEBwukF6s79YnNYQcYiOgR8dn4X
	 A/SZyUDprZerrdki2EazK1qmIozGKTUXfJyHenpT5ToeTt+LXxvNz5qrWTD91vco8pvqg
	 mMYSDhmm9p+cOm3vF1MKRnX3tZ5SOtJFUdB8ZlWd/gFKAaAVoFa3sJiHEpUQh2JpHQGcP
	 yHoSX677Bfju/3mDF0/TxswhqgYG+ZEXLblrmDNrA8odNnt8F6SG/LyMhpgg+IZZaNhkp
	 baz9dXk0Uw6UWxQ0o9ENoifjWvh5Hy/xKuJjPdSy+PBonm8whmwZ2Y86ioDU+6ygJEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gOiSY2rob17O5kWzxIMZOkeKwpdqlcFNdZMq4vKrkOQ=;
	b=Y2ff233M8WUgku5W/DBryNG2iD4+HSUMnRSGODQQSI+Qjniih8GpqRRXfrKBCoc3gsYJ
	 nj58Yo9+e+Dx3WX2ym8kVE8ZaTcpOjfXv2opgUwLgx+YZb9rBxkSf0uUKcHBXWShNS+Ql
	 n+RMAd+NR9ndXyZ4SZ7xq6O2iJKOYKttOpthGXif/3QLwGnTBy1JJomQpOicU44FBYRzG
	 SVs1ZXUzIXfsdsCmREPUP+XnQHYh+AGn0an0iZWxZFQz0+g750Bqni4jsbgMF8EV3kDtG
	 He6DCvtqcqYUAhOXgL1XLPC/7JZ90Ru4Q2aCO16JiCTONfWIixm06bDRJj1hwf3EBIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QYLIjNDJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAA8606A325;
	Thu, 19 Nov 2026 03:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QYLIjNDJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5631F000C4;
	Thu, 19 Nov 2026 03:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060066;
	bh=gOiSY2rob17O5kWzxIMZOkeKwpdqlcFNdZMq4vKrkOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QYLIjNDJYmehLKSI5uRtRrxLQDpD5Tum7G/WoyuEJVEmUl2A5Ve2UtjlukIr7HGri
	 sXCCXanZ/K7ijqMHJA/veGdoJcJj12FubdB5W95agLlVeG8xFzjZNe52w9fCfn3Xdh
	 eoyEnZCIHDUZZkcvKgWalhmlHLXYZ4/DEE7AIAKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	guolingxing <guolingxing@tju.edu.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1025/1848] btrfs: prevent deleting the wrong subvolume by ID
Date: Wed, 18 Nov 2026 15:51:03 +0100
Message-ID: <20261118150000.186282654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced btrfs_root_id(dest) with dest->root_key.objectid and adapted error handling to use err and out_dput. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 16c397062809f..9d865ac974923 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3072,6 +3072,17 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 
 	inode = d_inode(dentry);
 	dest = BTRFS_I(inode)->root;
+
+	/*
+	 * A concurrent rename may have changed which subvolume the name
+	 * refers to. Verify that the resolved ID still matches the requested ID.
+	 */
+	if (destroy_v2 && (vol_args2->flags & BTRFS_SUBVOL_SPEC_BY_ID) &&
+	    dest->root_key.objectid != vol_args2->subvolid) {
+		err = -EAGAIN;
+		goto out_dput;
+	}
+
 	if (!capable(CAP_SYS_ADMIN)) {
 		/*
 		 * Regular user.  Only allow this with a special mount
-- 
2.53.0



