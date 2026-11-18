Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038801;
	b=qLXJ9zP5Z3mg1ySfb7CWg/mbHE3zkiyhzGLblb31exRWMyzs2HRPKXFAUFWOfnnmljDd
	 VC1xBVB/qFpBUpZtDII0SsMexEYSlU+zHWeNQ8yYVzzic5kd3otSLEIbfLWc+U4BSgWZ7
	 s42Yb0IhMicOR1DdUZO3MVadWxqd6L/8xe4p7t7jDJtqQBPUs5cVEatoBjNS3S15mPN04
	 6RhdMWyt/QT7B7Kj4Zoe2XPALU3aU7No7jU9BSJhAeHL9XEVJA4fPPSjIiyfd7ySJo6ay
	 /QGUjX6XRPzTrMnW4kCpwHHqu8pCCh8G48g5WZr96XB0T/3vqtGUBzrfLFAgfXD82dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nHBZcseV7cXqSuuXi3g+3Qzsxv6T1dtoFg6VHw9la40=;
	b=YLSTi3AIeytgJ2p7bi1/wlxjIOMjfsCmu1K7J/F8TUoty4FlxfnU5QarG0c7ExnNNdDp
	 qrcQjoOi18tf9EoIzDbRgq6O/RVULGYQR0RSN0BeAMxmiuuDBCWu7pSsa6g2tKquqMZSF
	 4xn55sp53h3KWpiPCWIeSZr8hdLK5lsSyLpI4FrsThnM3TcLiv6b+jBPpPmdZiRcoz8sf
	 D2htqtUCS8yXc4z0SVMz9IdAgO4t1fxvqtRP8Nk/khAdk3GSbZMIJ5MAzRhNK83lbS4Yl
	 4DwzIRbfjuRd54wtAK2ZKJJ1xADTM9icaBgamLLiRQGcpk+HBihIXgAMyseGWltSYzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sfXYVDAO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6441B606A31C;
	Wed, 18 Nov 2026 21:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sfXYVDAO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F451F000C5;
	Wed, 18 Nov 2026 21:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038801;
	bh=nHBZcseV7cXqSuuXi3g+3Qzsxv6T1dtoFg6VHw9la40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfXYVDAOcL1YvqYWiX41uJILQk8CG/rtjNWBzw8J6hWnv+XJOAS6jF1W22xDXPAHM
	 KDOnz/Hs4r4OPLBT9oz2zgTSQQsK+YCnuVsBh2l8qh7LG1/Ci8+GF6W1iVQNVHjICw
	 igH7hkkmB6SjrScFxoCpVOFesG1pUQPMhYqU1zuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	guolingxing <guolingxing@tju.edu.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1870/3318] btrfs: prevent deleting the wrong subvolume by ID
Date: Wed, 18 Nov 2026 15:41:32 +0100
Message-ID: <20261118150418.051622906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the error path to use err instead of ret and out_dput instead of out_end_removing. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 54e3ec0685834..3b0c962d7a2f6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2535,6 +2535,17 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 
 	inode = d_inode(dentry);
 	dest = BTRFS_I(inode)->root;
+
+	/*
+	 * A concurrent rename may have changed which subvolume the name
+	 * refers to. Verify that the resolved ID still matches the requested ID.
+	 */
+	if (destroy_v2 && (vol_args2->flags & BTRFS_SUBVOL_SPEC_BY_ID) &&
+	    btrfs_root_id(dest) != vol_args2->subvolid) {
+		err = -EAGAIN;
+		goto out_dput;
+	}
+
 	if (!capable(CAP_SYS_ADMIN)) {
 		/*
 		 * Regular user.  Only allow this with a special mount
-- 
2.53.0



