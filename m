Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2252E296FBC;
	Mon, 12 May 2025 18:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073573; cv=none; b=GC9A1661DdZdEsESU4/0/JhDdC5gxyVcChcnppxdohqRhuhigC5vV8bVoLmKGqDXFYb7FrFEObs7LMot2K5wY9m7woKR1EoxDJwqqizmQ2ZYDbcL9TBPqdDMr6svQUdGJphw1CdyLrAhrXXBA/GGieKu5AlUCAeOaxoE7a1eF6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073573; c=relaxed/simple;
	bh=qme6yMXdc2McZlG0PAH77I5dp7o4EG0JL/2vccPCH7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPgQXfb701X3lY+qCDLG/k4D7F/5TTDbwJI85ujKldTLWrxAuwIzf76ycxxO44aMunihM0gWpEDrGHKTGZOksHjUwrSIV5AyQodOCW2T0UCc19GO0LS2Y8Ao7Qrm/1QG+6ntLMrB2PO/9GdMUp4qD0YQa+P7o8oBV+4xJf+8Ytg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fq90U+nu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fq90U+nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D8DC4CEE9;
	Mon, 12 May 2025 18:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073573;
	bh=qme6yMXdc2McZlG0PAH77I5dp7o4EG0JL/2vccPCH7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fq90U+nuAcTtT21bpKKJvWJozSO7h3k97ewVC/Gw0ThveEgH1YnU5YYvH8FWDMY44
	 gMFedDuCHJGVW0sjnNuf+WAl9UWIGxkaDIHpmI7zvbgb1yj1uhbOC0mVfGhGOqXoQV
	 E74YqTDrMW72WwCe7LqtajuV0KysZeKwacbCYwXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/113] do_umount(): add missing barrier before refcount checks in sync case
Date: Mon, 12 May 2025 19:46:18 +0200
Message-ID: <20250512172031.305234421@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

[ Upstream commit 65781e19dcfcb4aed1167d87a3ffcc2a0c071d47 ]

do_umount() analogue of the race fixed in 119e1ef80ecf "fix
__legitimize_mnt()/mntput() race".  Here we want to make sure that
if __legitimize_mnt() doesn't notice our lock_mount_hash(), we will
notice their refcount increment.  Harder to hit than mntput_no_expire()
one, fortunately, and consequences are milder (sync umount acting
like umount -l on a rare race with RCU pathwalk hitting at just the
wrong time instead of use-after-free galore mntput_no_expire()
counterpart used to be hit).  Still a bug...

Fixes: 48a066e72d97 ("RCU'd vfsmounts")
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5a885d35efe93..450f4198b8cdd 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -633,7 +633,7 @@ int __legitimize_mnt(struct vfsmount *bastard, unsigned seq)
 		return 0;
 	mnt = real_mount(bastard);
 	mnt_add_count(mnt, 1);
-	smp_mb();			// see mntput_no_expire()
+	smp_mb();		// see mntput_no_expire() and do_umount()
 	if (likely(!read_seqretry(&mount_lock, seq)))
 		return 0;
 	if (bastard->mnt_flags & MNT_SYNC_UMOUNT) {
@@ -1786,6 +1786,7 @@ static int do_umount(struct mount *mnt, int flags)
 			umount_tree(mnt, UMOUNT_PROPAGATE);
 		retval = 0;
 	} else {
+		smp_mb(); // paired with __legitimize_mnt()
 		shrink_submounts(mnt);
 		retval = -EBUSY;
 		if (!propagate_mount_busy(mnt, 2)) {
-- 
2.39.5



