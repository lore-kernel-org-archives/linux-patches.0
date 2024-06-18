Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372761891C9;
	Tue, 18 Jun 2024 13:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715668; cv=none; b=t8vjsCFKdpF7qIgk1QELquIWPFOM1JIAU2rsJ5rwEi3XNRS4AP4R+OSUzqhF0YxCVNEvRHwyX9uBip0FnukecpfOgUtnkoqKZNZ4YRrtd6C/8uuXIIIn33cNZC1gOfTBidNW75JazB6ErKiCkyCrBY6TDc8Ely2L8xday7nxd+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715668; c=relaxed/simple;
	bh=l7y0hQOEX178f9LDSIW2dAbi4nN2Gy63fYI/3V6XMf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atFqTv5pUiOo9OxEc4p3/P4eqmcmtPlPcEZREJhG70ikSTqSHAuXYKI335+5eoU//PbNYMEqWflfdTkcw1Lrill+orvdog+HNd9amK7NcadUAU2lBTo1Lp1Uuwv6Oct6nVgsfVtFTbWP7RnpLSsPTLph93kOkYh3QTMTSHBP32o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVlhmRyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVlhmRyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CCEC3277B;
	Tue, 18 Jun 2024 13:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715668;
	bh=l7y0hQOEX178f9LDSIW2dAbi4nN2Gy63fYI/3V6XMf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVlhmRyNvqrXPVON5XOSl33RKaZTvaIqGfrID2/aFjQ+yBVREXAXZWWOjyq/ggmQ8
	 52Meh0xPoT5Tr+WPZvdtfsgYhhnEV19fWLL859eNh0ZAPZbGZEd+qAEnKpiNQdZNrs
	 A49dzhyCEiHkdegZA1DtrgAtJWQginuC0Njyw+UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 387/770] fanotify: Allow users to request FAN_FS_ERROR events
Date: Tue, 18 Jun 2024 14:34:00 +0200
Message-ID: <20240618123422.213844892@linuxfoundation.org>
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

[ Upstream commit 9709bd548f11a092d124698118013f66e1740f9b ]

Wire up the FAN_FS_ERROR event in the fanotify_mark syscall, allowing
user space to request the monitoring of FAN_FS_ERROR events.

These events are limited to filesystem marks, so check it is the
case in the syscall handler.

Link: https://lore.kernel.org/r/20211025192746.66445-29-krisman@collabora.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c      | 2 +-
 fs/notify/fanotify/fanotify_user.c | 4 ++++
 include/linux/fanotify.h           | 6 +++++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index af61425e6e3bf..b6091775aa6ef 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -822,7 +822,7 @@ static int fanotify_handle_event(struct fsnotify_group *group, u32 mask,
 	BUILD_BUG_ON(FAN_OPEN_EXEC_PERM != FS_OPEN_EXEC_PERM);
 	BUILD_BUG_ON(FAN_FS_ERROR != FS_ERROR);
 
-	BUILD_BUG_ON(HWEIGHT32(ALL_FANOTIFY_EVENT_BITS) != 19);
+	BUILD_BUG_ON(HWEIGHT32(ALL_FANOTIFY_EVENT_BITS) != 20);
 
 	mask = fanotify_group_event_mask(group, iter_info, mask, data,
 					 data_type, dir);
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 3040c8669dfd1..e6860c55b3dcb 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1533,6 +1533,10 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	    group->priority == FS_PRIO_0)
 		goto fput_and_out;
 
+	if (mask & FAN_FS_ERROR &&
+	    mark_type != FAN_MARK_FILESYSTEM)
+		goto fput_and_out;
+
 	/*
 	 * Events that do not carry enough information to report
 	 * event->fd require a group that supports reporting fid.  Those
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 52d464802d99f..616af2ea20f30 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -91,9 +91,13 @@ extern struct ctl_table fanotify_table[]; /* for sysctl */
 #define FANOTIFY_INODE_EVENTS	(FANOTIFY_DIRENT_EVENTS | \
 				 FAN_ATTRIB | FAN_MOVE_SELF | FAN_DELETE_SELF)
 
+/* Events that can only be reported with data type FSNOTIFY_EVENT_ERROR */
+#define FANOTIFY_ERROR_EVENTS	(FAN_FS_ERROR)
+
 /* Events that user can request to be notified on */
 #define FANOTIFY_EVENTS		(FANOTIFY_PATH_EVENTS | \
-				 FANOTIFY_INODE_EVENTS)
+				 FANOTIFY_INODE_EVENTS | \
+				 FANOTIFY_ERROR_EVENTS)
 
 /* Events that require a permission response from user */
 #define FANOTIFY_PERM_EVENTS	(FAN_OPEN_PERM | FAN_ACCESS_PERM | \
-- 
2.43.0



