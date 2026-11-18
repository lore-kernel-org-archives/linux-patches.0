Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054275;
	b=CaxdKEkZQ5MCSkcFj2eFH3gEeSjHCriPnBIVyy9f82alKazeQhmIfshhzxjG8oz6NqYL
	 6XLRGnElszR6lzZ6y3n8IawHC5fE7Fu8OglOH/5APpp0AzEuyw7QKh1EglUHDZqqHvcnh
	 Mg3y+hmn3VfatcQ0daCuoZx3e5wO2ZydvqftNkrXc8YMkpFf/TmmjPT8Pea4eBTEYb8M9
	 mdz7PiAdCif/KPovGLs1tF4eRwTmDj4b4dLpPm2jtilaVO/m0Hh5bevESPfIgjkC5GE0v
	 PdLb1BPQQv5Dl3TBLxZj2tha9NUSsob7Ka2IwrXx2wdo7/dLO3F/5DIJv97EUEB6gXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CWazGq7cVH4k0kvDbHX4KokFc6cEUn4Io3FNhKXpAuk=;
	b=oNzzlAqnLMeb04gkDnu18iQ4rI4yf+4mdK8pnu7JIdZ11aldmm8JLQgyLMjHbQn3F1Y3
	 fsInQkt1EvmW3c7vJXeDFDwSiqw/XA9zbn56l/wrWXlt/NpOB0sNH2jHa++cKp/wUd0dp
	 sixPNJfzb38G9d4XIWDfbgur+8BcwKjPzwdN78DcVp6iW3Ud2GRyVLd6OHa/j5YfFRnv1
	 RxhwcgBjdnYFO9UfaRPU/cSsgAzvoiqlEENq3vjzfO4tMhT+0FgK/27QmZSKVG0pq1Hiz
	 lvwT6zgmHGR2frVrxrMZDX02TrPm09CunVcyFbzl5viBf+sX2KnA8hg67Qpea1gSSeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l1gpc0+i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CF2606A31C;
	Thu, 19 Nov 2026 02:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l1gpc0+i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFDD1F000C4;
	Thu, 19 Nov 2026 02:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054275;
	bh=CWazGq7cVH4k0kvDbHX4KokFc6cEUn4Io3FNhKXpAuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l1gpc0+inc4rrko6oF5c7xEM193mWOf2Lp8uOOV8zUWOiidipt/eMLY3M2pFX7nbQ
	 QWNRzqO7f+FF9CKdEmljTlnbkswmarcjLuC901dVwqhF+KnD7tG0TArWj20HVOoZag
	 xPt4KGzl02kkhPreGmh9JIdTe13LFkHIKzNFNYhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	guolingxing <guolingxing@tju.edu.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1218/2214] btrfs: prevent deleting the wrong subvolume by ID
Date: Wed, 18 Nov 2026 15:48:14 +0100
Message-ID: <20261118150100.510426490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted error handling to use err instead of ret and out_dput instead of out_end_removing. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d56d6144707bb..a20abb2f5437e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3070,6 +3070,17 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 
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



