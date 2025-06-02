Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103AE22A7E4;
	Mon,  2 Jun 2025 14:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876386; cv=none; b=R9D5CmVlp1X4zTANu+B0h08hebj1H0rik9LYuZEoirBg9PkPH2UBn4UmPSvMPSbLig62g6zsYadOKGmdEuitYtWM/2/K2fbhh9YBNfu6KYQ2c8as9UUwvvcfbn5bKn0CwsxJ1k4y0IFPf6+CRrzlvtnzByhFj7Evl0VfPaMHzJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876386; c=relaxed/simple;
	bh=H3iabgjzWGDBvdWTXK+o1wcPcmY4lUN6/AiHT/EToq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUybpb4AXUpDprw1thAk29fZ6AocH39qlKcMUv9rs6Hlc2nu/HVmjk6wrOc8TsPyvJF91iKlZ+nE1/+zLwhT/UNuyeacpp3xbgy9F02hC6A83+nYnaTYgJgW/RISeJ1yDeSrEmGhxwrirq3kyMonhcPcMgUbkMXv0DKJmMgH1oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=be4Celva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="be4Celva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9D7C4CEEB;
	Mon,  2 Jun 2025 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876385;
	bh=H3iabgjzWGDBvdWTXK+o1wcPcmY4lUN6/AiHT/EToq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=be4CelvaDUdDiP1HvW+xVhaDwJpcizb05N5wZ/bIcNnozxHNZGRqdMK/UsvYHyCJB
	 +fGEuvWAj1zCeTJmn0wyz4CjDIr7uK6P5ii3JBefZXIeeT4LTsSXHjLMxF7kO1qayl
	 ZORS/yvdsTMcogCiBrnJEzpNu6k+kf/GWcsTkOWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/207] __legitimize_mnt(): check for MNT_SYNC_UMOUNT should be under mount_lock
Date: Mon,  2 Jun 2025 15:48:53 +0200
Message-ID: <20250602134305.026554807@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 27ec6d0a68ff5..a99a060e89316 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -589,12 +589,8 @@ int __legitimize_mnt(struct vfsmount *bastard, unsigned seq)
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



