Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741F26FE35;
	Mon,  8 Apr 2024 13:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583879; cv=none; b=r9tocrTqpafDZAPYt9LlhkZq2QLA6bBWTIR06kXoc5PmsbL9uz39pOl2ql9m6MD9h7f43UGPgdNRqS2AALi+p+8CwWULjZgI3UOyR+aAfvpCWicwpL7EKVQxIhqpc88Lo3HkT06odynDIlHQq/ErUFW2FaKI4tTcySxISQCdz80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583879; c=relaxed/simple;
	bh=WtIcB81vpJhY72ewG6pHESJJVG9R9VHJGlfgg/4vpcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgv6a/2YJbiRzJS2GEO1hzJVg6HG+TEp8CMVT4ab3ZdPp6GYoPpF31V+lcYB3fe5lsb1/rbaEGdeKYj3dL9v6a6F09CHoiGvqWWyTZBfk6QtEpRh9GXqGf3Ih6aWKsE0+j7HgMa2C+KN674FMa6Ozhlw9JKA8iV2kTpbglnd0o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Y7C5Hgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Y7C5Hgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F086AC433F1;
	Mon,  8 Apr 2024 13:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583879;
	bh=WtIcB81vpJhY72ewG6pHESJJVG9R9VHJGlfgg/4vpcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Y7C5HgqW5rXI2IkM7i1/MVRnvMC7YByBRX8cbzEM3RoqQcEK1C5MQcr4yybd0rTA
	 17oYtKdPZxY/WJdeX4whBlWs9klkcXYt9280lRDBHeV1zZbwEttY4DAl/kBqhlMOAI
	 FKlFW7MD1MD36WXNlpAn9apWnSP2j+l1V3vx3wKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 298/690] fanotify: create helper fanotify_mark_user_flags()
Date: Mon,  8 Apr 2024 14:52:44 +0200
Message-ID: <20240408125410.404893119@linuxfoundation.org>
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

[ Upstream commit 4adce25ccfff215939ee465b8c0aa70526d5c352 ]

To translate from fsnotify mark flags to user visible flags.

Link: https://lore.kernel.org/r/20220422120327.3459282-13-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.h | 10 ++++++++++
 fs/notify/fdinfo.c            |  6 ++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index a3d5b751cac5b..87142bc0131a4 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -490,3 +490,13 @@ static inline unsigned int fanotify_event_hash_bucket(
 {
 	return event->hash & FANOTIFY_HTABLE_MASK;
 }
+
+static inline unsigned int fanotify_mark_user_flags(struct fsnotify_mark *mark)
+{
+	unsigned int mflags = 0;
+
+	if (mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY)
+		mflags |= FAN_MARK_IGNORED_SURV_MODIFY;
+
+	return mflags;
+}
diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 1f34c5c29fdbd..59fb40abe33d3 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -14,6 +14,7 @@
 #include <linux/exportfs.h>
 
 #include "inotify/inotify.h"
+#include "fanotify/fanotify.h"
 #include "fdinfo.h"
 #include "fsnotify.h"
 
@@ -103,12 +104,9 @@ void inotify_show_fdinfo(struct seq_file *m, struct file *f)
 
 static void fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 {
-	unsigned int mflags = 0;
+	unsigned int mflags = fanotify_mark_user_flags(mark);
 	struct inode *inode;
 
-	if (mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY)
-		mflags |= FAN_MARK_IGNORED_SURV_MODIFY;
-
 	if (mark->connector->type == FSNOTIFY_OBJ_TYPE_INODE) {
 		inode = igrab(fsnotify_conn_inode(mark->connector));
 		if (!inode)
-- 
2.43.0



