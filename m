Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6317D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D86FC433EF;
	Mon, 12 Jun 2023 10:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566971;
	bh=ZWnLCg783LgU6iQ68YeUrBpMXCgjJBflXJoFsNQkXJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WapSxwkxU8ZTXA3aFUBcOIu8JEGQ0Hfs02t0PL0KAcXcpQJyBUVGdqs3KwZaGvZy6
	 w0an4/3m8c7K74czgDS6Y+j5GYTX2VfSTB9Gb4XrEgsPYQPcJu8w+bWaOyAQScPjAI
	 Ixa5SlT/RUVtio0YzC9ludQi/pvSB5UIeCbxfbuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Milind Changire <mchangir@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.3 101/160] ceph: fix use-after-free bug for inodes when flushing capsnaps
Date: Mon, 12 Jun 2023 12:27:13 +0200
Message-ID: <20230612101719.641658253@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
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

commit 409e873ea3c1fd3079909718bbeb06ac1ec7f38b upstream.

There is a race between capsnaps flush and removing the inode from
'mdsc->snap_flush_list' list:

   == Thread A ==                     == Thread B ==
ceph_queue_cap_snap()
 -> allocate 'capsnapA'
 ->ihold('&ci->vfs_inode')
 ->add 'capsnapA' to 'ci->i_cap_snaps'
 ->add 'ci' to 'mdsc->snap_flush_list'
    ...
   == Thread C ==
ceph_flush_snaps()
 ->__ceph_flush_snaps()
  ->__send_flush_snap()
                                handle_cap_flushsnap_ack()
                                 ->iput('&ci->vfs_inode')
                                   this also will release 'ci'
                                    ...
				      == Thread D ==
                                ceph_handle_snap()
                                 ->flush_snaps()
                                  ->iterate 'mdsc->snap_flush_list'
                                   ->get the stale 'ci'
 ->remove 'ci' from                ->ihold(&ci->vfs_inode) this
   'mdsc->snap_flush_list'           will WARNING

To fix this we will increase the inode's i_count ref when adding 'ci'
to the 'mdsc->snap_flush_list' list.

[ idryomov: need_put int -> bool ]

Cc: stable@vger.kernel.org
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2209299
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c |    6 ++++++
 fs/ceph/snap.c |    4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1627,6 +1627,7 @@ void ceph_flush_snaps(struct ceph_inode_
 	struct inode *inode = &ci->netfs.inode;
 	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
 	struct ceph_mds_session *session = NULL;
+	bool need_put = false;
 	int mds;
 
 	dout("ceph_flush_snaps %p\n", inode);
@@ -1671,8 +1672,13 @@ out:
 		ceph_put_mds_session(session);
 	/* we flushed them all; remove this inode from the queue */
 	spin_lock(&mdsc->snap_flush_lock);
+	if (!list_empty(&ci->i_snap_flush_item))
+		need_put = true;
 	list_del_init(&ci->i_snap_flush_item);
 	spin_unlock(&mdsc->snap_flush_lock);
+
+	if (need_put)
+		iput(inode);
 }
 
 /*
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -693,8 +693,10 @@ int __ceph_finish_cap_snap(struct ceph_i
 	     capsnap->size);
 
 	spin_lock(&mdsc->snap_flush_lock);
-	if (list_empty(&ci->i_snap_flush_item))
+	if (list_empty(&ci->i_snap_flush_item)) {
+		ihold(inode);
 		list_add_tail(&ci->i_snap_flush_item, &mdsc->snap_flush_list);
+	}
 	spin_unlock(&mdsc->snap_flush_lock);
 	return 1;  /* caller may want to ceph_flush_snaps */
 }


