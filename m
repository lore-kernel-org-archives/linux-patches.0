Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3CC18E759;
	Tue, 18 Jun 2024 13:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715761; cv=none; b=mQM1xWmx4gvcbsVYNGR+BKo2s1lBvfBWOPhwkPSSWnT4vug8ksEzs1fAZOV578sQOl19iqAmAJU7JDvmuPDmxuul49x6m/GxHnqJbHddk9ym9CSG59Sp8Ybl7hX7qY6TCQbObcFwdNYCvYMXNu1zCVU6aaZUKrV3Ld3sfxi2jHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715761; c=relaxed/simple;
	bh=mpHmjAjuD8pH0O8l7iWkiFPBhFA3aYay1BFAv7RBV3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLN7OA3L5zxbJFV5moUZWzoWfaZ5eTs8PXgbkvpFMSJGwQqURjejY/ZZ8FVRkMfs1KEhTxulZJF36aXpx+Sv5DnM+fOndXwcIWNVjFHhoF0P7Z3HSCn/nL2Q4jlSFV2S7mbB4i5G9O0/t+TEWOzoz0xJ5HYJhTfG66saCIDTd98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcqfFJyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcqfFJyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFC5C3277B;
	Tue, 18 Jun 2024 13:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715760;
	bh=mpHmjAjuD8pH0O8l7iWkiFPBhFA3aYay1BFAv7RBV3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PcqfFJyKXYew8njV1V5nkBnNtsKp6qmmDtcd/gUaKNNws6SenPLUhPcUXeCo51eX5
	 ICc8DByxXaoa3MqKh8sllKvggPZMkDKZiSGL5ZbxL+KBonU/tDJVEsnRNIt9gZxYnl
	 Isy4XULDPUATOd3hNr8ckyc6LwICirQ17a1Fvv7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 376/770] fanotify: Require fid_mode for any non-fd event
Date: Tue, 18 Jun 2024 14:33:49 +0200
Message-ID: <20240618123421.783225553@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 4fe595cf1c80e7a5af4d00c4da29def64aff57a2 ]

Like inode events, FAN_FS_ERROR will require fid mode.  Therefore,
convert the verification during fanotify_mark(2) to require fid for any
non-fd event.  This means fid_mode will not only be required for inode
events, but for any event that doesn't provide a descriptor.

Link: https://lore.kernel.org/r/20211025192746.66445-17-krisman@collabora.com
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 12 ++++++------
 include/linux/fanotify.h           |  3 +++
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 6dd6a2e05f55d..34bf71108f7a3 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1471,14 +1471,14 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 		goto fput_and_out;
 
 	/*
-	 * Events with data type inode do not carry enough information to report
-	 * event->fd, so we do not allow setting a mask for inode events unless
-	 * group supports reporting fid.
-	 * inode events are not supported on a mount mark, because they do not
-	 * carry enough information (i.e. path) to be filtered by mount point.
+	 * Events that do not carry enough information to report
+	 * event->fd require a group that supports reporting fid.  Those
+	 * events are not supported on a mount mark, because they do not
+	 * carry enough information (i.e. path) to be filtered by mount
+	 * point.
 	 */
 	fid_mode = FAN_GROUP_FLAG(group, FANOTIFY_FID_BITS);
-	if (mask & FANOTIFY_INODE_EVENTS &&
+	if (mask & ~(FANOTIFY_FD_EVENTS|FANOTIFY_EVENT_FLAGS) &&
 	    (!fid_mode || mark_type == FAN_MARK_MOUNT))
 		goto fput_and_out;
 
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index eec3b7c408115..52d464802d99f 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -84,6 +84,9 @@ extern struct ctl_table fanotify_table[]; /* for sysctl */
  */
 #define FANOTIFY_DIRENT_EVENTS	(FAN_MOVE | FAN_CREATE | FAN_DELETE)
 
+/* Events that can be reported with event->fd */
+#define FANOTIFY_FD_EVENTS (FANOTIFY_PATH_EVENTS | FANOTIFY_PERM_EVENTS)
+
 /* Events that can only be reported with data type FSNOTIFY_EVENT_INODE */
 #define FANOTIFY_INODE_EVENTS	(FANOTIFY_DIRENT_EVENTS | \
 				 FAN_ATTRIB | FAN_MOVE_SELF | FAN_DELETE_SELF)
-- 
2.43.0



