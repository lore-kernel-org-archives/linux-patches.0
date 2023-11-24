Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E1A2EAEA;
	Fri, 24 Nov 2023 18:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="roxpnYbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2C1C433C8;
	Fri, 24 Nov 2023 18:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852219;
	bh=mbJFG6+mI6MBFWHIvHA7AigSS0pAF+CSa1XSQkWuM90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roxpnYbWhwqjh86r69fylQNValZUdPYEVl8Nsqaqwv4FrnNgZ6V4I8dDDdkgthK3I
	 w6EljKAFwO1g3pbNPN2A0sa05YoD251kXwayxBuQeMXwLd5K6hcs2til8YVUNwSvDb
	 9TY4PGYtTEm29xHhFm5jLkuiYmP/jHytYRgkvbx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 267/372] fs: add ctime accessors infrastructure
Date: Fri, 24 Nov 2023 17:50:54 +0000
Message-ID: <20231124172019.382008335@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 9b6304c1d53745c300b86f202d0dcff395e2d2db upstream.

struct timespec64 has unused bits in the tv_nsec field that can be used
for other purposes. In future patches, we're going to change how the
inode->i_ctime is accessed in certain inodes in order to make use of
them. In order to do that safely though, we'll need to eradicate raw
accesses of the inode->i_ctime field from the kernel.

Add new accessor functions for the ctime that we use to replace them.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Message-Id: <20230705185812.579118-2-jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/inode.c         |   16 ++++++++++++++++
 include/linux/fs.h |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 1 deletion(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2502,6 +2502,22 @@ struct timespec64 current_time(struct in
 EXPORT_SYMBOL(current_time);
 
 /**
+ * inode_set_ctime_current - set the ctime to current_time
+ * @inode: inode
+ *
+ * Set the inode->i_ctime to the current value for the inode. Returns
+ * the current value that was assigned to i_ctime.
+ */
+struct timespec64 inode_set_ctime_current(struct inode *inode)
+{
+	struct timespec64 now = current_time(inode);
+
+	inode_set_ctime(inode, now.tv_sec, now.tv_nsec);
+	return now;
+}
+EXPORT_SYMBOL(inode_set_ctime_current);
+
+/**
  * in_group_or_capable - check whether caller is CAP_FSETID privileged
  * @mnt_userns: user namespace of the mount @inode was found from
  * @inode:	inode to check
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1812,7 +1812,50 @@ static inline bool fsuidgid_has_mapping(
 	       kgid_has_mapping(fs_userns, kgid);
 }
 
-extern struct timespec64 current_time(struct inode *inode);
+struct timespec64 current_time(struct inode *inode);
+struct timespec64 inode_set_ctime_current(struct inode *inode);
+
+/**
+ * inode_get_ctime - fetch the current ctime from the inode
+ * @inode: inode from which to fetch ctime
+ *
+ * Grab the current ctime from the inode and return it.
+ */
+static inline struct timespec64 inode_get_ctime(const struct inode *inode)
+{
+	return inode->i_ctime;
+}
+
+/**
+ * inode_set_ctime_to_ts - set the ctime in the inode
+ * @inode: inode in which to set the ctime
+ * @ts: value to set in the ctime field
+ *
+ * Set the ctime in @inode to @ts
+ */
+static inline struct timespec64 inode_set_ctime_to_ts(struct inode *inode,
+						      struct timespec64 ts)
+{
+	inode->i_ctime = ts;
+	return ts;
+}
+
+/**
+ * inode_set_ctime - set the ctime in the inode
+ * @inode: inode in which to set the ctime
+ * @sec: tv_sec value to set
+ * @nsec: tv_nsec value to set
+ *
+ * Set the ctime in @inode to { @sec, @nsec }
+ */
+static inline struct timespec64 inode_set_ctime(struct inode *inode,
+						time64_t sec, long nsec)
+{
+	struct timespec64 ts = { .tv_sec  = sec,
+				 .tv_nsec = nsec };
+
+	return inode_set_ctime_to_ts(inode, ts);
+}
 
 /*
  * Snapshotting support.


