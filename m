Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAC61C282;
	Wed,  3 Jan 2024 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7DxzuBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A7EC433C7;
	Wed,  3 Jan 2024 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301405;
	bh=NWKClQASbiyC1elGymUgUI0GH21BwGK+nJ+3N5SEmro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7DxzuBFoa5pv9D4/RUWJfGLQPg97n0P1Oaq9UunUgumaxzzSxxpliZqnNAbglf3U
	 pEljlkJCOg4V8lHVrzN4aRpq+YmBGShGukH0IV93e1L6/mBQUtoWLc2MlufY1GAujO
	 RKSCPhMYTziq4/JoIWMyI1OZ4gj7BD/7vJhr32LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 24/95] afs: Fix use-after-free due to get/remove race in volume tree
Date: Wed,  3 Jan 2024 17:54:32 +0100
Message-ID: <20240103164857.740565772@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 9a6b294ab496650e9f270123730df37030911b55 ]

When an afs_volume struct is put, its refcount is reduced to 0 before
the cell->volume_lock is taken and the volume removed from the
cell->volumes tree.

Unfortunately, this means that the lookup code can race and see a volume
with a zero ref in the tree, resulting in a use-after-free:

    refcount_t: addition on 0; use-after-free.
    WARNING: CPU: 3 PID: 130782 at lib/refcount.c:25 refcount_warn_saturate+0x7a/0xda
    ...
    RIP: 0010:refcount_warn_saturate+0x7a/0xda
    ...
    Call Trace:
     afs_get_volume+0x3d/0x55
     afs_create_volume+0x126/0x1de
     afs_validate_fc+0xfe/0x130
     afs_get_tree+0x20/0x2e5
     vfs_get_tree+0x1d/0xc9
     do_new_mount+0x13b/0x22e
     do_mount+0x5d/0x8a
     __do_sys_mount+0x100/0x12a
     do_syscall_64+0x3a/0x94
     entry_SYSCALL_64_after_hwframe+0x62/0x6a

Fix this by:

 (1) When putting, use a flag to indicate if the volume has been removed
     from the tree and skip the rb_erase if it has.

 (2) When looking up, use a conditional ref increment and if it fails
     because the refcount is 0, replace the node in the tree and set the
     removal flag.

Fixes: 20325960f875 ("afs: Reorganise volume and server trees to be rooted on the cell")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/internal.h |  2 ++
 fs/afs/volume.c   | 26 +++++++++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index b29e9c206f782..0c03877cdaf7e 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -589,6 +589,7 @@ struct afs_volume {
 #define AFS_VOLUME_OFFLINE	4	/* - T if volume offline notice given */
 #define AFS_VOLUME_BUSY		5	/* - T if volume busy notice given */
 #define AFS_VOLUME_MAYBE_NO_IBULK 6	/* - T if some servers don't have InlineBulkStatus */
+#define AFS_VOLUME_RM_TREE	7	/* - Set if volume removed from cell->volumes */
 #ifdef CONFIG_AFS_FSCACHE
 	struct fscache_cookie	*cache;		/* caching cookie */
 #endif
@@ -1507,6 +1508,7 @@ extern struct afs_vlserver_list *afs_extract_vlserver_list(struct afs_cell *,
 extern struct afs_volume *afs_create_volume(struct afs_fs_context *);
 extern void afs_activate_volume(struct afs_volume *);
 extern void afs_deactivate_volume(struct afs_volume *);
+bool afs_try_get_volume(struct afs_volume *volume, enum afs_volume_trace reason);
 extern struct afs_volume *afs_get_volume(struct afs_volume *, enum afs_volume_trace);
 extern void afs_put_volume(struct afs_net *, struct afs_volume *, enum afs_volume_trace);
 extern int afs_check_volume_status(struct afs_volume *, struct afs_operation *);
diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index 32941bffa2ec1..137a970c19fb3 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -33,8 +33,13 @@ static struct afs_volume *afs_insert_volume_into_cell(struct afs_cell *cell,
 		} else if (p->vid > volume->vid) {
 			pp = &(*pp)->rb_right;
 		} else {
-			volume = afs_get_volume(p, afs_volume_trace_get_cell_insert);
-			goto found;
+			if (afs_try_get_volume(p, afs_volume_trace_get_cell_insert)) {
+				volume = p;
+				goto found;
+			}
+
+			set_bit(AFS_VOLUME_RM_TREE, &volume->flags);
+			rb_replace_node_rcu(&p->cell_node, &volume->cell_node, &cell->volumes);
 		}
 	}
 
@@ -57,7 +62,8 @@ static void afs_remove_volume_from_cell(struct afs_volume *volume)
 				 afs_volume_trace_remove);
 		write_seqlock(&cell->volume_lock);
 		hlist_del_rcu(&volume->proc_link);
-		rb_erase(&volume->cell_node, &cell->volumes);
+		if (!test_and_set_bit(AFS_VOLUME_RM_TREE, &volume->flags))
+			rb_erase(&volume->cell_node, &cell->volumes);
 		write_sequnlock(&cell->volume_lock);
 	}
 }
@@ -236,6 +242,20 @@ static void afs_destroy_volume(struct afs_net *net, struct afs_volume *volume)
 	_leave(" [destroyed]");
 }
 
+/*
+ * Try to get a reference on a volume record.
+ */
+bool afs_try_get_volume(struct afs_volume *volume, enum afs_volume_trace reason)
+{
+	int r;
+
+	if (__refcount_inc_not_zero(&volume->ref, &r)) {
+		trace_afs_volume(volume->vid, r + 1, reason);
+		return true;
+	}
+	return false;
+}
+
 /*
  * Get a reference on a volume record.
  */
-- 
2.43.0



