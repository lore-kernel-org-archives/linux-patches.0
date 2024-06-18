Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C6618EFE7;
	Tue, 18 Jun 2024 13:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715846; cv=none; b=LUPNEoGcXD3kUfc2JAP/vGvAna69wSSl/IZezloLbDTZyjbysoVx8easxJAdu32wbUbilaUa0DAVTOpbg9tuB1bBLdb1M1IGjXkx2Bd+mJ8b9kY6qYHYeaObsXM6hUtqQISh8DJsw2fAftAG6T80/uC/rv7HWBiofCQ7Oeb7zSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715846; c=relaxed/simple;
	bh=ukWaCu/eef1RvA+VglO61R7RJI0O3J0gzNE4ockmCGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjuP51xgbO0lJv96WPPiyTTAIyscqRJe+45Ix3oNgc4Hv75tKmTum5MIIK2c5US9/cSo2WcRNscaXb3XqtL/kLwxUVpzs7/38CiqZKRjeNoxHNxDgbdMnOkxNB26tzaY827M++dRVtfzQUoOHIME7Fb01WEepR1rblJFsGO3P74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utdi7rSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utdi7rSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6129EC3277B;
	Tue, 18 Jun 2024 13:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715846;
	bh=ukWaCu/eef1RvA+VglO61R7RJI0O3J0gzNE4ockmCGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utdi7rSn3lUJ7i9TYCZp7JLa7TRz2YpjaC2+JAsi7Dz66Q7Q62jxbFOR9miBLjADY
	 VRjb1MeP+HUHnCTTFOWqqujU9hfuceYV1NJXldXpmFM7pkoqw4fOU++5GhYO1Hz0zb
	 z5+7XP1GXEyrVgmSUtG234ZpPHlImD/blwSfMOS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 415/770] fanotify: wire up FAN_RENAME event
Date: Tue, 18 Jun 2024 14:34:28 +0200
Message-ID: <20240618123423.304364099@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 8cc3b1ccd930fe6971e1527f0c4f1bdc8cb56026 ]

FAN_RENAME is the successor of FAN_MOVED_FROM and FAN_MOVED_TO
and can be used to get the old and new parent+name information in
a single event.

FAN_MOVED_FROM and FAN_MOVED_TO are still supported for backward
compatibility, but it makes little sense to use them together with
FAN_RENAME in the same group.

FAN_RENAME uses special info type records to report the old and
new parent+name, so reporting only old and new parent id is less
useful and was not implemented.
Therefore, FAN_REANAME requires a group with flag FAN_REPORT_NAME.

Link: https://lore.kernel.org/r/20211129201537.1932819-12-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c      | 2 +-
 fs/notify/fanotify/fanotify_user.c | 8 ++++++++
 include/linux/fanotify.h           | 3 ++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 0da305b6f3e2f..985e995d2a398 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -930,7 +930,7 @@ static int fanotify_handle_event(struct fsnotify_group *group, u32 mask,
 	BUILD_BUG_ON(FAN_FS_ERROR != FS_ERROR);
 	BUILD_BUG_ON(FAN_RENAME != FS_RENAME);
 
-	BUILD_BUG_ON(HWEIGHT32(ALL_FANOTIFY_EVENT_BITS) != 20);
+	BUILD_BUG_ON(HWEIGHT32(ALL_FANOTIFY_EVENT_BITS) != 21);
 
 	mask = fanotify_group_event_mask(group, iter_info, &match_mask,
 					 mask, data, data_type, dir);
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index e16b18fdf1a65..3bac2329dc35f 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1599,6 +1599,14 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	    (!fid_mode || mark_type == FAN_MARK_MOUNT))
 		goto fput_and_out;
 
+	/*
+	 * FAN_RENAME uses special info type records to report the old and
+	 * new parent+name.  Reporting only old and new parent id is less
+	 * useful and was not implemented.
+	 */
+	if (mask & FAN_RENAME && !(fid_mode & FAN_REPORT_NAME))
+		goto fput_and_out;
+
 	if (flags & FAN_MARK_FLUSH) {
 		ret = 0;
 		if (mark_type == FAN_MARK_MOUNT)
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 376e050e6f384..3afdf339d53c9 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -82,7 +82,8 @@ extern struct ctl_table fanotify_table[]; /* for sysctl */
  * Directory entry modification events - reported only to directory
  * where entry is modified and not to a watching parent.
  */
-#define FANOTIFY_DIRENT_EVENTS	(FAN_MOVE | FAN_CREATE | FAN_DELETE)
+#define FANOTIFY_DIRENT_EVENTS	(FAN_MOVE | FAN_CREATE | FAN_DELETE | \
+				 FAN_RENAME)
 
 /* Events that can be reported with event->fd */
 #define FANOTIFY_FD_EVENTS (FANOTIFY_PATH_EVENTS | FANOTIFY_PERM_EVENTS)
-- 
2.43.0



