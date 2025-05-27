Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A4D280328;
	Tue, 27 May 2025 17:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368447; cv=none; b=XjcLASYBAhERgNsimPd4u94T8/en39sL6ZDE9Ov3uYF1fcrKsiUsLEoRvaOBpCVTY0OVUwqpFtp9RSlnGxbGzG9lgzKFyHJ7rm9gqXGYnR13MH2MRthKOx2rBOEMndg26HAwwTynZSGTp7XlaftWuZ/At52vbuAPc/HmkB1ypmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368447; c=relaxed/simple;
	bh=fy0U5mcbevCti0INX+BHN/Ml3ajVf9/06x/Kwful1eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/iwnLm7W7UIfywPP2hwaaJyWQK5oFbG+9uCN+c4BgwydK2za5vqu7vQQkljThxMpwg6oKUP9F6v4dshPDWkNFPn+v4p7cwjYQBZ5/h2hEgvd7+aVh1r2i16C5eOQigqIG2yE3E5rSvnynbxOP44A/v0fe+9gV8O9qBQBRcYosY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNvpq3GP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNvpq3GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC77BC4CEE9;
	Tue, 27 May 2025 17:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368447;
	bh=fy0U5mcbevCti0INX+BHN/Ml3ajVf9/06x/Kwful1eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNvpq3GPUKz3zFpgY/AtMas6mObEgUi0zpK8DtDeu77Y5ZQ17/2dbcEzQaq6OAgtI
	 94flI6ofipKo1q3Vw1FxolKpNGxpE5+wHU3L8vnFzK1MWP4GGL9fUWKKJm+LO3yOaf
	 9S0fALtoR8uPdCSFwER/yx6CIDMIRASdmjOoNYZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 680/783] __legitimize_mnt(): check for MNT_SYNC_UMOUNT should be under mount_lock
Date: Tue, 27 May 2025 18:27:57 +0200
Message-ID: <20250527162540.822978816@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 5b84e29613fe4..1d950974d67ee 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -781,12 +781,8 @@ int __legitimize_mnt(struct vfsmount *bastard, unsigned seq)
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



