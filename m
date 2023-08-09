Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1461B13FE6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F3FC433C7;
	Wed,  9 Aug 2023 10:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578172;
	bh=naHCkN39sn/xC4MwydPG6sQHTM2pf4nQMXtbvgTN+aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHwL0BuxIEXf4CtCM1WgDrGHgXM6WdAHDMRkBNVJb11oh5tTaKFcwlx7dcbFzOq3x
	 2CDcSxurxcJzZkQLxzbqHbDjL+SmFgLU7MzGU5G/DBO2dIWm7PNgKzQ/OvxhGUXvg/
	 XfqJGJjbECk+E+rwcRXOTlFl9DQqExkPocVK+p0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Milind Changire <mchangir@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.4 102/165] ceph: defer stopping mdsc delayed_work
Date: Wed,  9 Aug 2023 12:40:33 +0200
Message-ID: <20230809103646.112117545@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiubo Li <xiubli@redhat.com>

commit e7e607bd00481745550389a29ecabe33e13d67cf upstream.

Flushing the dirty buffer may take a long time if the cluster is
overloaded or if there is network issue. So we should ping the
MDSs periodically to keep alive, else the MDS will blocklist
the kclient.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/61843
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    4 ++--
 fs/ceph/mds_client.h |    5 +++++
 fs/ceph/super.c      |   10 ++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4762,7 +4762,7 @@ static void delayed_work(struct work_str
 
 	dout("mdsc delayed_work\n");
 
-	if (mdsc->stopping)
+	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
 		return;
 
 	mutex_lock(&mdsc->mutex);
@@ -4941,7 +4941,7 @@ void send_flush_mdlog(struct ceph_mds_se
 void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 {
 	dout("pre_umount\n");
-	mdsc->stopping = 1;
+	mdsc->stopping = CEPH_MDSC_STOPPING_BEGIN;
 
 	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
 	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -380,6 +380,11 @@ struct cap_wait {
 	int			want;
 };
 
+enum {
+       CEPH_MDSC_STOPPING_BEGIN = 1,
+       CEPH_MDSC_STOPPING_FLUSHED = 2,
+};
+
 /*
  * mds client state
  */
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1374,6 +1374,16 @@ static void ceph_kill_sb(struct super_bl
 	ceph_mdsc_pre_umount(fsc->mdsc);
 	flush_fs_workqueues(fsc);
 
+	/*
+	 * Though the kill_anon_super() will finally trigger the
+	 * sync_filesystem() anyway, we still need to do it here
+	 * and then bump the stage of shutdown to stop the work
+	 * queue as earlier as possible.
+	 */
+	sync_filesystem(s);
+
+	fsc->mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
+
 	kill_anon_super(s);
 
 	fsc->client->extra_mon_dispatch = NULL;


