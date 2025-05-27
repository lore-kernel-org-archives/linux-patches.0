Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A158C27A463;
	Tue, 27 May 2025 17:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365923; cv=none; b=vEL1FZ7RA+tklUlMw7pZm09MVca5r28Kl3XUviuOz6MSgkMVMuJE1P+KxqKIa4wV5CWEDcOBXQgjSYSm1mNU41Uio8W9HPOnASu7SdaogBOiHxYMC+a63f3bIvE8Ri2ExhkmX2BmL/POmqdtirbMy/GvaNcFMSfc6VSkeoFx+4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365923; c=relaxed/simple;
	bh=JnazW+JgV4I97HqQH6GrPqDMrosqs688EnPr4mvaVic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsojBdzMmaYhv4KWH49VHUg+W7xft7N5PN73WqnwGIrqjAKbRjqVwx2wf98+y8M3LGQN+TpYe9mupUkUiNC1Rueh6LdYQ+S+rW3EhWsOdmmUJLPAXl05iO75FN4bwJ2VbmAdBgPRIdYgaemL+C4xlU7ngggJgX83sBCKy+m+3/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SltJQeXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SltJQeXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B05DC4CEE9;
	Tue, 27 May 2025 17:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365923;
	bh=JnazW+JgV4I97HqQH6GrPqDMrosqs688EnPr4mvaVic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SltJQeXHeajc3ljPt7l8J34pS3gEyEw8jIwkCY5WNTDjBdOkXmxZyQayyIoZhNvXF
	 IghGt2ykiI8VXaeCAujHaeieG0Grd2w5Cx7uEODxSpQFm7YOPOUKiI/ySR9xcNP8tw
	 Que4AwMjKhOisCoXy7/L+7iEronv/5xROxFs2IfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 533/626] __legitimize_mnt(): check for MNT_SYNC_UMOUNT should be under mount_lock
Date: Tue, 27 May 2025 18:27:06 +0200
Message-ID: <20250527162506.654150529@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c3c1e8c644f2e..c1ac585e41e36 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -750,12 +750,8 @@ int __legitimize_mnt(struct vfsmount *bastard, unsigned seq)
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



