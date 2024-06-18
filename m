Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2A51581F4;
	Tue, 18 Jun 2024 13:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716009; cv=none; b=CAp3PsaquFotO9fRTxPGHGU3/IKwhVmYNtCvylw8G6KVYclYG5GUczPQgImhmou6K4W9U5ofQA+zcsW2LXs+M/QMCUT5ocn08n21J7FrhXLBEnVl3Nt0/eXV/Y23j4QKdnMp3kKVnZfNEg946j/L8THgZhVK46X8iAGuQKwdCIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716009; c=relaxed/simple;
	bh=ubiqyS+8+i6A3WQEp/NAlbAAA5X1XoN4VqSXJP4csSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMaeWzKS4ylcUOejPTJfCE3+2Qknn4JKbffvbH7uX0vsQDpJvpm9ulYKz/uEZqwXZ3iBbQmdg0gEhMZz26VqRJ3Z2BxYhmpnjyXGC4LdQRZ21NnK0fSIQqx+TdHOXBRICa+lzv/nr8izvTalvCdyPFUeL81tzeUrG+Od3pN2Sxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0D2Q4KU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0D2Q4KU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1BFC3277B;
	Tue, 18 Jun 2024 13:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716008;
	bh=ubiqyS+8+i6A3WQEp/NAlbAAA5X1XoN4VqSXJP4csSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0D2Q4KU8l0wpoaSekOmNCR16RH76P57xb7ohe0XMBV0txvStobJf7jsdEBvfTk3D2
	 /LdMBI8qFoIUyDYhvpSKi9oCiMv4N+zNm2q7z4HhIRbdi1QHUayPk0pjYDUyvhbRXA
	 iuDo11sS7Ayff+1iJdgtj5QLL11UKi2YDsaWPv+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 501/770] fanotify: create helper fanotify_mark_user_flags()
Date: Tue, 18 Jun 2024 14:35:54 +0200
Message-ID: <20240618123426.655031600@linuxfoundation.org>
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

[ Upstream commit 4adce25ccfff215939ee465b8c0aa70526d5c352 ]

To translate from fsnotify mark flags to user visible flags.

Link: https://lore.kernel.org/r/20220422120327.3459282-13-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



