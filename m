Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBFF6FE1A;
	Mon,  8 Apr 2024 13:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583215; cv=none; b=GAlwBvLkjwVdeEMXC5E0Mj7bCsdrQTlQDjbvttvDDT7433bw7DEKrLVaalprqxFlFjWKpaGG7h+SVJZlPZXpHg2zVdkgoJ4WwNGaVoNmJXrIh4ftL7Y8W9UnWXU18Etf97jjQzycrme5ELcoHFyoF/uLEE2PYEXSbIgerhXFbnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583215; c=relaxed/simple;
	bh=fD+atUKnKzViPHRoCZ5083IfwubLVsSi2T0fJqH6xA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAJY0uazzj4dRyCaB2Gip9zpJiGPsNAdoQJyifgNnV39m4MrFjI+8M9KVcI0jmP42W2466DAebd4g5R610sb39GeP4oQ3AOJSiKuiPC1BU8aLwDw3cjXRk1gg3ynYmq4j4CuzCXQbJ1km5WKgo9A44GZD6Xctcvi55g6HfK4i/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDDnr5+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDDnr5+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0B5C433F1;
	Mon,  8 Apr 2024 13:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583215;
	bh=fD+atUKnKzViPHRoCZ5083IfwubLVsSi2T0fJqH6xA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDDnr5+sqwf8uScRG9ORaog/UdXDUKA92wn56PNc6BGo80TuPfLaOzY4acOXy/hJs
	 kiFxeuyn8YAKg6Uf1rh5KAQ2cNsf1Qrl8StyjU6B3GeI6JDTJ22+VUMB7aPJHYO2h2
	 OB5p9jRZ4MfFrQPW2HyVHJHPGlLaL6JrA/KPx02I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 223/690] fanotify: wire up FAN_RENAME event
Date: Mon,  8 Apr 2024 14:51:29 +0200
Message-ID: <20240408125407.624287720@linuxfoundation.org>
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
index b3ac2d877e1ee..ce84eb8443b10 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1604,6 +1604,14 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
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



