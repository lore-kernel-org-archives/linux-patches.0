Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24945238176;
	Mon,  2 Jun 2025 14:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874018; cv=none; b=QDhCZiJZJccm+mtVARpvYlc/HrCc7yQ6t+OIeiFNFin6nKzEq2HdIkdvDVAS7IS5sGBOLWAR3U3Skwjqrel0CaWnHUzNSX9nbSKE4Ya9CZOxJ6Tb3Ey7xvOmcH/uxR7l5DI9+PWjmRxoL13r/6t6NYTTZcTa+Teru5SRsEdf9xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874018; c=relaxed/simple;
	bh=gI4SSs3iY7poogC3AVSQVpVljpdrEhDBhTEsSQb2P0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtBJF/FO/BS7jabDQSV7gh4bpMiDcFXSd/AgWWFzWyJXSNoWec++yfNPdC5H3tFIeth/rn0NCjIVHTbvlnIqBo3z933aC7xugYzgYoNKaK9AyMRxsiAq4jSEDltij55D05HMoEj/IjG6Z8WwF2MNX0GMGie6Ny7Z/BC70oK+2CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqtULLU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqtULLU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989E4C4CEEB;
	Mon,  2 Jun 2025 14:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874018;
	bh=gI4SSs3iY7poogC3AVSQVpVljpdrEhDBhTEsSQb2P0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqtULLU4XYZN6ug9KfiKws5yLHK3S8W2FD3KHeki2bBVssC1mbaXVc/vMXZL/DnNb
	 C6EezbUXEKjiZifx8np2wV9NKCevzGjp2xSsvqQhoPL96UEtGdJnjxzO/iIBCVlewH
	 K3gZ9aPEewsFbzt37vyW17NzWtzstwo/T69WYQfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 329/444] __legitimize_mnt(): check for MNT_SYNC_UMOUNT should be under mount_lock
Date: Mon,  2 Jun 2025 15:46:33 +0200
Message-ID: <20250602134354.290273924@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 250cf3693060a5f803c5f1ddc082bb06b16112a9 ]

... or we risk stealing final mntput from sync umount - raising mnt_count
after umount(2) has verified that victim is not busy, but before it
has set MNT_SYNC_UMOUNT; in that case __legitimize_mnt() doesn't see
that it's safe to quietly undo mnt_count increment and leaves dropping
the reference to caller, where it'll be a full-blown mntput().

Check under mount_lock is needed; leaving the current one done before
taking that makes no sense - it's nowhere near common enough to bother
with.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 450f4198b8cdd..ef3b2ae2957ec 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -636,12 +636,8 @@ int __legitimize_mnt(struct vfsmount *bastard, unsigned seq)
 	smp_mb();		// see mntput_no_expire() and do_umount()
 	if (likely(!read_seqretry(&mount_lock, seq)))
 		return 0;
-	if (bastard->mnt_flags & MNT_SYNC_UMOUNT) {
-		mnt_add_count(mnt, -1);
-		return 1;
-	}
 	lock_mount_hash();
-	if (unlikely(bastard->mnt_flags & MNT_DOOMED)) {
+	if (unlikely(bastard->mnt_flags & (MNT_SYNC_UMOUNT | MNT_DOOMED))) {
 		mnt_add_count(mnt, -1);
 		unlock_mount_hash();
 		return 1;
-- 
2.39.5



