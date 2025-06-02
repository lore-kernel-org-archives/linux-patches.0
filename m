Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77C42153CB;
	Mon,  2 Jun 2025 14:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875028; cv=none; b=u6MQXJdNVwH8yrsUjwGzuPjG7I/zs9yNFySkrGZl2XcJX75ecgETQn7NF6YunZY9gYn3fggbYKXo4Nwkq0dyjfmoMR0XRI/e/wEt1FFOQDDWvWTXiolZ+Apr4F1wOTb0QCTT5/Eb1r/xFir33Du31xwh8DSbqz032X/dzhdNXtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875028; c=relaxed/simple;
	bh=rWKwgkZLWnGwusvO3hPyLc5YP/bpb58m+PILSuLT2+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKhhQozaq63pb2gWvxa26tARqGytA672jWCDA/mYjKpcjUULzPYTfHWxXyn05rp5j/V7Q7WXxJwPk7Qg8xMP3syEyTA19JR6/DzGudfPSsxHIqoAdrbxA6qlVwHi4lAO+MH+i+E56jDowcnw16/9hGkQ448OMtf+OUlmH0ADQs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezwTE48N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezwTE48N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C98BC4CEEB;
	Mon,  2 Jun 2025 14:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875028;
	bh=rWKwgkZLWnGwusvO3hPyLc5YP/bpb58m+PILSuLT2+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezwTE48NWl1gAzRIuVSgZNOdRN2rOHwIlAdvC4CER0OHrPf5tgc05D8pAwC/Yxhvm
	 1WakF56o/ll1wY9STqlNBnmTpt+PtFtFncj8odzaa6wp5czvna0mRCuoWnzKP9J7y0
	 LZLteoROG1lDN1T+DRuN2L9fDgRoE6L7I6MFO3q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 170/204] __legitimize_mnt(): check for MNT_SYNC_UMOUNT should be under mount_lock
Date: Mon,  2 Jun 2025 15:48:23 +0200
Message-ID: <20250602134302.333835280@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 809ec3acb147c..a5cb608778b1e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -572,12 +572,8 @@ int __legitimize_mnt(struct vfsmount *bastard, unsigned seq)
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



