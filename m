Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D4363D5;
	Sat, 30 Dec 2023 12:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLf+UcCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E698CC433C8;
	Sat, 30 Dec 2023 12:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937697;
	bh=yvkM82Fe90gX1byEW5QK1wr+kxDDaeG2EV2u6hqnOUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLf+UcCYQ7Wkktm2OhskZOHwP1HFDs3crUMwaKjWc2xd6rKn5A6evnfX+0fEk0dbW
	 gBkUFApTg6NGQTsOMSjh/UJbvKx6eQ3EvuOa1WM7gGodpUBaValyHAsNDe1qovr/sG
	 J+3m6Fjdh+U2C8nlRCMxSomRkqFcwoPBMKGQJ6FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/156] btrfs: qgroup: use qgroup_iterator in qgroup_convert_meta()
Date: Sat, 30 Dec 2023 11:57:39 +0000
Message-ID: <20231230115812.526105458@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 0913445082496c2b29668ee26521401b273838b8 ]

With the new qgroup_iterator_add() and qgroup_iterator_clean(), we can
get rid of the ulist and its GFP_ATOMIC memory allocation.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: b321a52cce06 ("btrfs: free qgroup pertrans reserve on transaction abort")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 32e5defe4eff4..0d2212fa0ce85 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4106,9 +4106,7 @@ static void qgroup_convert_meta(struct btrfs_fs_info *fs_info, u64 ref_root,
 				int num_bytes)
 {
 	struct btrfs_qgroup *qgroup;
-	struct ulist_node *unode;
-	struct ulist_iterator uiter;
-	int ret = 0;
+	LIST_HEAD(qgroup_list);
 
 	if (num_bytes == 0)
 		return;
@@ -4119,31 +4117,21 @@ static void qgroup_convert_meta(struct btrfs_fs_info *fs_info, u64 ref_root,
 	qgroup = find_qgroup_rb(fs_info, ref_root);
 	if (!qgroup)
 		goto out;
-	ulist_reinit(fs_info->qgroup_ulist);
-	ret = ulist_add(fs_info->qgroup_ulist, qgroup->qgroupid,
-		       qgroup_to_aux(qgroup), GFP_ATOMIC);
-	if (ret < 0)
-		goto out;
-	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(fs_info->qgroup_ulist, &uiter))) {
-		struct btrfs_qgroup *qg;
-		struct btrfs_qgroup_list *glist;
 
-		qg = unode_aux_to_qgroup(unode);
+	qgroup_iterator_add(&qgroup_list, qgroup);
+	list_for_each_entry(qgroup, &qgroup_list, iterator) {
+		struct btrfs_qgroup_list *glist;
 
-		qgroup_rsv_release(fs_info, qg, num_bytes,
+		qgroup_rsv_release(fs_info, qgroup, num_bytes,
 				BTRFS_QGROUP_RSV_META_PREALLOC);
-		qgroup_rsv_add(fs_info, qg, num_bytes,
+		qgroup_rsv_add(fs_info, qgroup, num_bytes,
 				BTRFS_QGROUP_RSV_META_PERTRANS);
-		list_for_each_entry(glist, &qg->groups, next_group) {
-			ret = ulist_add(fs_info->qgroup_ulist,
-					glist->group->qgroupid,
-					qgroup_to_aux(glist->group), GFP_ATOMIC);
-			if (ret < 0)
-				goto out;
-		}
+
+		list_for_each_entry(glist, &qgroup->groups, next_group)
+			qgroup_iterator_add(&qgroup_list, glist->group);
 	}
 out:
+	qgroup_iterator_clean(&qgroup_list);
 	spin_unlock(&fs_info->qgroup_lock);
 }
 
-- 
2.43.0



