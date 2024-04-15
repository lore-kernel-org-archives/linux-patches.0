Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690AF74E25;
	Mon, 15 Apr 2024 14:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191046; cv=none; b=hxtyJIRvVshu4A4/APHFuF2k0A1SBKfc9WdXgt9Cj2zv1P8yr+HkEYcd2banghVUrNIMUnRKQvwTJDJkR0o1LnRgt/zl9ohwBPyp9+ieAJhKMQRTB0bM+dN8GJLD+B3AGUhXEeZj2Biajmi6x6BRjXfNc7HiJLdaQ4f1Nixy5GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191046; c=relaxed/simple;
	bh=D5t778jukwcKPL9djdHbgU5voSnYICvSNJ0/tQUxj54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FX/Yc/dUWeoP8pB8LzSpqFrKH2VK5rJ3WuXTSrHiEL1HhTNbiX8Cwd9utQdcXNv3Pd498jYjHyhwrMWeb7mDNm1qlqR+D5ea9grwuvxBTRw9B4qWSiH2nHUapLKZsWd9zljQ3YdGr44s7puIigxl6LS2MKW8Dpqb8SwZ2O7Lg3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MWVGy2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MWVGy2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D7DC2BD10;
	Mon, 15 Apr 2024 14:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191046;
	bh=D5t778jukwcKPL9djdHbgU5voSnYICvSNJ0/tQUxj54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2MWVGy2zIQfUOpXE1hENYKQpD7K5UMPAgv+tjlP1BC5yCKYxfg4iMLIajsghM678j
	 +HqZStjVT3AokLEf8bhgHnjEptBhR0Kfwlh06go9wUV+auajZfB/MGxQbCM1o6AeAk
	 KQvNuj8nRqsYbTo4kRf4b5WbXFwAjHQwwI0UrUgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Ruhmann <ruhmann@luis.uni-hannover.de>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.8 007/172] ceph: switch to use cap_delay_lock for the unlink delay list
Date: Mon, 15 Apr 2024 16:18:26 +0200
Message-ID: <20240415142000.197682942@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubli@redhat.com>

commit 17f8dc2db52185460f212052f3a692c1fdc167ba upstream.

The same list item will be used in both cap_delay_list and
cap_unlink_delay_list, so it's buggy to use two different locks
to protect them.

Cc: stable@vger.kernel.org
Fixes: dbc347ef7f0c ("ceph: add ceph_cap_unlink_work to fire check_caps() immediately")
Link: https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/AODC76VXRAMXKLFDCTK4TKFDDPWUSCN5
Reported-by: Marc Ruhmann <ruhmann@luis.uni-hannover.de>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Tested-by: Marc Ruhmann <ruhmann@luis.uni-hannover.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c       |    4 ++--
 fs/ceph/mds_client.c |    9 ++++-----
 fs/ceph/mds_client.h |    3 +--
 3 files changed, 7 insertions(+), 9 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4775,13 +4775,13 @@ int ceph_drop_caps_for_unlink(struct ino
 
 			doutc(mdsc->fsc->client, "%p %llx.%llx\n", inode,
 			      ceph_vinop(inode));
-			spin_lock(&mdsc->cap_unlink_delay_lock);
+			spin_lock(&mdsc->cap_delay_lock);
 			ci->i_ceph_flags |= CEPH_I_FLUSH;
 			if (!list_empty(&ci->i_cap_delay_list))
 				list_del_init(&ci->i_cap_delay_list);
 			list_add_tail(&ci->i_cap_delay_list,
 				      &mdsc->cap_unlink_delay_list);
-			spin_unlock(&mdsc->cap_unlink_delay_lock);
+			spin_unlock(&mdsc->cap_delay_lock);
 
 			/*
 			 * Fire the work immediately, because the MDS maybe
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2504,7 +2504,7 @@ static void ceph_cap_unlink_work(struct
 	struct ceph_client *cl = mdsc->fsc->client;
 
 	doutc(cl, "begin\n");
-	spin_lock(&mdsc->cap_unlink_delay_lock);
+	spin_lock(&mdsc->cap_delay_lock);
 	while (!list_empty(&mdsc->cap_unlink_delay_list)) {
 		struct ceph_inode_info *ci;
 		struct inode *inode;
@@ -2516,15 +2516,15 @@ static void ceph_cap_unlink_work(struct
 
 		inode = igrab(&ci->netfs.inode);
 		if (inode) {
-			spin_unlock(&mdsc->cap_unlink_delay_lock);
+			spin_unlock(&mdsc->cap_delay_lock);
 			doutc(cl, "on %p %llx.%llx\n", inode,
 			      ceph_vinop(inode));
 			ceph_check_caps(ci, CHECK_CAPS_FLUSH);
 			iput(inode);
-			spin_lock(&mdsc->cap_unlink_delay_lock);
+			spin_lock(&mdsc->cap_delay_lock);
 		}
 	}
-	spin_unlock(&mdsc->cap_unlink_delay_lock);
+	spin_unlock(&mdsc->cap_delay_lock);
 	doutc(cl, "done\n");
 }
 
@@ -5404,7 +5404,6 @@ int ceph_mdsc_init(struct ceph_fs_client
 	INIT_LIST_HEAD(&mdsc->cap_wait_list);
 	spin_lock_init(&mdsc->cap_delay_lock);
 	INIT_LIST_HEAD(&mdsc->cap_unlink_delay_list);
-	spin_lock_init(&mdsc->cap_unlink_delay_lock);
 	INIT_LIST_HEAD(&mdsc->snap_flush_list);
 	spin_lock_init(&mdsc->snap_flush_lock);
 	mdsc->last_cap_flush_tid = 1;
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -461,9 +461,8 @@ struct ceph_mds_client {
 	struct delayed_work    delayed_work;  /* delayed work */
 	unsigned long    last_renew_caps;  /* last time we renewed our caps */
 	struct list_head cap_delay_list;   /* caps with delayed release */
-	spinlock_t       cap_delay_lock;   /* protects cap_delay_list */
 	struct list_head cap_unlink_delay_list;  /* caps with delayed release for unlink */
-	spinlock_t       cap_unlink_delay_lock;  /* protects cap_unlink_delay_list */
+	spinlock_t       cap_delay_lock;   /* protects cap_delay_list and cap_unlink_delay_list */
 	struct list_head snap_flush_list;  /* cap_snaps ready to flush */
 	spinlock_t       snap_flush_lock;
 


