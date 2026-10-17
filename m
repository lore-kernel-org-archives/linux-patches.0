Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48903839B2;
	Sat, 17 Oct 2026 16:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253710; cv=none; b=JixYHxm69VVaLusNHHVQGFlTzM0gapNpQD7N1kpmqth5qBMhycicHqGcn7Fh6EG5bjturp+Sjl7Si8vGiz2Lkpx44vEo9pBscpT4K44vQruz6bnv8Z1WyRcgGkIT8WcssgFXWngLmWPg8NgbjaDfiRlQ3zymVuHHMGzRM0IoD8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253710; c=relaxed/simple;
	bh=9pleGtLmLrezHBbO+ZIsAiKWrI2Q9iVQbpokyGWQEMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XrsTBj678qxaKGsNM8yorbAcK2aRHHQ/9y9whPKPfLg2xbRxwSL0nxkCRSVkJ/H+1ccfT4XnAPim5SH8XQI+JnNHz6KU8raQmtqMNINqksW87HZsTfvd6IFCbpr0OZ+pYsvAC0B24e8LCc9HS0KEauZNU2J1x9GsdVYbi/cUpYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELxFQWvT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELxFQWvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37E31F000C4;
	Sat, 17 Oct 2026 16:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253708;
	bh=ZgrlPfM8Nxy1YTP7o6dkI4u3xGOBDj0rRLAKlE9BMcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ELxFQWvTa+x6oGNmjr54HU5eCeGV6nUXnXsfPN7h4vIl2Ues/sic4+Ha4N8HgXJ85
	 UM8LE8qGqx+hJv1Czv3OT5DWUsEb+z8HrNEYjjGxj97A9hlYFmU7QuqSYami5awEyh
	 ADud5rXWpeJZbl/Z/dz19DHhqFDWMJVAEa3BtCpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/869] btrfs: fix double free of qgroup record after failure to add delayed ref head
Date: Sat, 17 Oct 2026 17:49:55 +0200
Message-ID: <20261017160040.990447370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Sabaté Solà <mssola@mssola.com>

[ Upstream commit 725e46298876a2cc1f1c3fb22ba69d29102c3ddf ]

In the previous code it was possible to incur into a double kfree()
scenario when calling add_delayed_ref_head(). This could happen if the
record was reported to already exist in the
btrfs_qgroup_trace_extent_nolock() call, but then there was an error
later on add_delayed_ref_head(). In this case, since
add_delayed_ref_head() returned an error, the caller went to free the
record. Since add_delayed_ref_head() couldn't set this kfree'd pointer
to NULL, then kfree() would have acted on a non-NULL 'record' object
which was pointing to memory already freed by the callee.

The problem comes from the fact that the responsibility to kfree the
object is on both the caller and the callee at the same time. Hence, the
fix for this is to shift the ownership of the 'qrecord' object out of
the add_delayed_ref_head(). That is, we will never attempt to kfree()
the given object inside of this function, and will expect the caller to
act on the 'qrecord' object on its own. The only exception where the
'qrecord' object cannot be kfree'd is if it was inserted into the
tracing logic, for which we already have the 'qrecord_inserted_ret'
boolean to account for this. Hence, the caller has to kfree the object
only if add_delayed_ref_head() reports not to have inserted it on the
tracing logic.

As a side-effect of the above, we must guarantee that
'qrecord_inserted_ret' is properly initialized at the start of the
function, not at the end, and then set when an actual insert
happens. This way we avoid 'qrecord_inserted_ret' having an invalid
value on an early exit.

The documentation from the add_delayed_ref_head() has also been updated
to reflect on the exact ownership of the 'qrecord' object.

Fixes: 6ef8fbce0104 ("btrfs: fix missing error handling when adding delayed ref with qgroups enabled")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-ref.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index cab94d141f662..55d2a3089ac1a 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -837,9 +837,13 @@ static void init_delayed_ref_head(struct btrfs_delayed_ref_head *head_ref,
 }
 
 /*
- * helper function to actually insert a head node into the rbtree.
- * this does all the dirty work in terms of maintaining the correct
- * overall modification count.
+ * Helper function to actually insert a head node into the rbtree. This does all
+ * the dirty work in terms of maintaining the correct overall modification
+ * count.
+ *
+ * The caller is responsible for calling kfree() on @qrecord. More specifically,
+ * if this function reports that it did not insert it as noted in
+ * @qrecord_inserted_ret, then it's safe to call kfree() on it.
  *
  * Returns an error pointer in case of an error.
  */
@@ -852,12 +856,25 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_delayed_ref_head *existing;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	bool qrecord_inserted = false;
+
+	/*
+	 * If 'qrecord_inserted_ret' is provided, then the first thing we need
+	 * to do is to initialize it to false just in case we have an exit
+	 * before trying to insert the record.
+	 */
+	if (qrecord_inserted_ret)
+		*qrecord_inserted_ret = false;
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
 	/* Record qgroup extent info if provided */
 	if (qrecord) {
+		/*
+		 * Setting 'qrecord' but not 'qrecord_inserted_ret' will likely
+		 * result in a memory leakage.
+		 */
+		ASSERT(qrecord_inserted_ret != NULL);
+
 		int ret;
 
 		ret = btrfs_qgroup_trace_extent_nolock(fs_info, delayed_refs, qrecord);
@@ -865,12 +882,10 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 			/* Clean up if insertion fails or item exists. */
 			xa_release(&delayed_refs->dirty_extents,
 				   qrecord->bytenr >> fs_info->sectorsize_bits);
-			/* Caller responsible for freeing qrecord on error. */
 			if (ret < 0)
 				return ERR_PTR(ret);
-			kfree(qrecord);
-		} else {
-			qrecord_inserted = true;
+		} else if (qrecord_inserted_ret) {
+			*qrecord_inserted_ret = true;
 		}
 	}
 
@@ -902,8 +917,6 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 		delayed_refs->num_heads_ready++;
 		atomic_inc(&delayed_refs->num_entries);
 	}
-	if (qrecord_inserted_ret)
-		*qrecord_inserted_ret = qrecord_inserted;
 
 	return head_ref;
 }
@@ -1075,6 +1088,8 @@ static int add_delayed_ref(struct btrfs_trans_handle *trans,
 
 	if (qrecord_inserted)
 		return btrfs_qgroup_trace_extent_post(trans, record);
+
+	kfree(record);
 	return 0;
 
 free_record:
-- 
2.53.0



