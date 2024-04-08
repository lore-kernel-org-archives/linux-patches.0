Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C992127B7B;
	Mon,  8 Apr 2024 13:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583841; cv=none; b=G4ZEqvrEwlCnM5IjXdCjllpUDn25lGPQyynedrun7Dyof28zDTJynYw2+SNge/RV7mk2CgXs1sekeflyCK7HnQ420O77yx3iVeDyxZ6glTcYnT2e4WBNeiDa7vuumBCpLJLdd0LOTAsXQrEvy6c4UDl7Flj1PcW//2Ihcn1IlZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583841; c=relaxed/simple;
	bh=C+wwCE05ANkR0iIjumODgA9l4SdOWXYIC49enn3BedE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPu38PqjdO/2pcj6M29f3PbM9bYsbD1tItVKnGfvTX/6q7QSZPy0xwpufusrP1SiQ4/Pm6QSCjV5nKfS+aMCH36cjpl80ZEKc3JheH8nlXxWsT+yOZWKkg4usXVQYH6r3RYVoc0e3Rlm7nVWyUoIYH8gvb2BhLOQCQLzjlvu6Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+/3DDkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+/3DDkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB2EC433F1;
	Mon,  8 Apr 2024 13:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583841;
	bh=C+wwCE05ANkR0iIjumODgA9l4SdOWXYIC49enn3BedE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+/3DDkvq3LwWusWuUB2XQ7mvaDp2jQDKrNllX7pQxrXXw2z9Run/FIXkmOmZDHsA
	 iIW1tDLXx5fo1dY7zUJ+ayU3Z5wn6yHv+kVUquj82kxI3qpuREXJYixgzQcJTeLVtK
	 MTMqdupy4F/T20B5mm4cW2RL8ynNjwmSFVdpcIPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 288/690] fanotify: do not allow setting dirent events in mask of non-dir
Date: Mon,  8 Apr 2024 14:52:34 +0200
Message-ID: <20240408125410.040322984@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit ceaf69f8eadcafb323392be88e7a5248c415d423 ]

Dirent events (create/delete/move) are only reported on watched
directory inodes, but in fanotify as well as in legacy inotify, it was
always allowed to set them on non-dir inode, which does not result in
any meaningful outcome.

Until kernel v5.17, dirent events in fanotify also differed from events
"on child" (e.g. FAN_OPEN) in the information provided in the event.
For example, FAN_OPEN could be set in the mask of a non-dir or the mask
of its parent and event would report the fid of the child regardless of
the marked object.
By contrast, FAN_DELETE is not reported if the child is marked and the
child fid was not reported in the events.

Since kernel v5.17, with fanotify group flag FAN_REPORT_TARGET_FID, the
fid of the child is reported with dirent events, like events "on child",
which may create confusion for users expecting the same behavior as
events "on child" when setting events in the mask on a child.

The desired semantics of setting dirent events in the mask of a child
are not clear, so for now, deny this action for a group initialized
with flag FAN_REPORT_TARGET_FID and for the new event FAN_RENAME.
We may relax this restriction in the future if we decide on the
semantics and implement them.

Fixes: d61fd650e9d2 ("fanotify: introduce group flag FAN_REPORT_TARGET_FID")
Fixes: 8cc3b1ccd930 ("fanotify: wire up FAN_RENAME event")
Link: https://lore.kernel.org/linux-fsdevel/20220505133057.zm5t6vumc4xdcnsg@quack3.lan/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220507080028.219826-1-amir73il@gmail.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify_user.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 4f607fd793f3a..336ccec2abed3 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1671,6 +1671,19 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	else
 		mnt = path.mnt;
 
+	/*
+	 * FAN_RENAME is not allowed on non-dir (for now).
+	 * We shouldn't have allowed setting any dirent events in mask of
+	 * non-dir, but because we always allowed it, error only if group
+	 * was initialized with the new flag FAN_REPORT_TARGET_FID.
+	 */
+	ret = -ENOTDIR;
+	if (inode && !S_ISDIR(inode->i_mode) &&
+	    ((mask & FAN_RENAME) ||
+	     ((mask & FANOTIFY_DIRENT_EVENTS) &&
+	      FAN_GROUP_FLAG(group, FAN_REPORT_TARGET_FID))))
+		goto path_put_and_out;
+
 	/* Mask out FAN_EVENT_ON_CHILD flag for sb/mount/non-dir marks */
 	if (mnt || !S_ISDIR(inode->i_mode)) {
 		mask &= ~FAN_EVENT_ON_CHILD;
-- 
2.43.0



