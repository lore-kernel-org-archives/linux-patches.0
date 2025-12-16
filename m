Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F1A34D920;
	Tue, 16 Dec 2025 11:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886112; cv=none; b=udZSVxDg4cXEfIF03FUf04s1mVWD7KIe7w6zPcWsVMZlk9NpYlSoMD03I484/FYdM/0p+f9VEkqrDa8jp4q/ZKMw8Y9FDIU4BS5spvTkkRJI2SzDwFaCHLYj1uYQVIaQUnls+Hr6iWwbXzdMMbPcbWDp+Yb3KOt1i7zB0ADxYdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886112; c=relaxed/simple;
	bh=YZtbGg9AQ5iBI1kJ9Q2/sc+nlwXFgynxxdo5qo/pWxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=efXS7gqPJRE/AbennLuZCGJRe77Lu5QmljSAPKmLmjPX8bZNvCly+p776AeHZP9kJJvH5v6tpheKiixPBF6dtdJE32pwFN046f+zEmQajkbXc9lUYm69vD8YZ8uEEMlEGwB8JK8qx0V4lJrPgKJpQR0S3INRRB4nAF+zG3nxz+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMa7uUQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMa7uUQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8012C4CEF1;
	Tue, 16 Dec 2025 11:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886112;
	bh=YZtbGg9AQ5iBI1kJ9Q2/sc+nlwXFgynxxdo5qo/pWxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMa7uUQmwBjPz4O4EYMOtHslFZOqIYAfD4o9keuoAAFlmjR8Glq86X5v7xmaQ+5Xf
	 2WLiX3MXP4L+B4MwkMCFByKHqmiBbpvEniYfb06Oyyfos4s3LTgRLn1//qK1OYmGl+
	 zTGNSkk9j94kf8bsLlimbsbSE2TfvB+W+n/XZLp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 341/507] btrfs: fix double free of qgroup record after failure to add delayed ref head
Date: Tue, 16 Dec 2025 12:13:02 +0100
Message-ID: <20251216111357.815068017@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 fs/btrfs/delayed-ref.c | 43 ++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index ca382c5b186f4..39c7ad1231675 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -798,9 +798,13 @@ static void init_delayed_ref_head(struct btrfs_delayed_ref_head *head_ref,
 }
 
 /*
- * helper function to actually insert a head node into the rbtree.
- * this does all the dirty work in terms of maintaining the correct
- * overall modification count.
+ * Helper function to actually insert a head node into the xarray. This does all
+ * the dirty work in terms of maintaining the correct overall modification
+ * count.
+ *
+ * The caller is responsible for calling kfree() on @qrecord. More specifically,
+ * if this function reports that it did not insert it as noted in
+ * @qrecord_inserted_ret, then it's safe to call kfree() on it.
  *
  * Returns an error pointer in case of an error.
  */
@@ -814,7 +818,14 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_head *existing;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	const unsigned long index = (head_ref->bytenr >> fs_info->sectorsize_bits);
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
 	lockdep_assert_held(&delayed_refs->lock);
@@ -833,6 +844,12 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 
 	/* Record qgroup extent info if provided */
 	if (qrecord) {
+		/*
+		 * Setting 'qrecord' but not 'qrecord_inserted_ret' will likely
+		 * result in a memory leakage.
+		 */
+		ASSERT(qrecord_inserted_ret != NULL);
+
 		int ret;
 
 		ret = btrfs_qgroup_trace_extent_nolock(fs_info, delayed_refs, qrecord,
@@ -840,12 +857,10 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 		if (ret) {
 			/* Clean up if insertion fails or item exists. */
 			xa_release(&delayed_refs->dirty_extents, index);
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
 
@@ -888,8 +903,6 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 		delayed_refs->num_heads++;
 		delayed_refs->num_heads_ready++;
 	}
-	if (qrecord_inserted_ret)
-		*qrecord_inserted_ret = qrecord_inserted;
 
 	return head_ref;
 }
@@ -1049,6 +1062,14 @@ static int add_delayed_ref(struct btrfs_trans_handle *trans,
 		xa_release(&delayed_refs->head_refs, index);
 		spin_unlock(&delayed_refs->lock);
 		ret = PTR_ERR(new_head_ref);
+
+		/*
+		 * It's only safe to call kfree() on 'qrecord' if
+		 * add_delayed_ref_head() has _not_ inserted it for
+		 * tracing. Otherwise we need to handle this here.
+		 */
+		if (!qrecord_reserved || qrecord_inserted)
+			goto free_head_ref;
 		goto free_record;
 	}
 	head_ref = new_head_ref;
@@ -1071,6 +1092,8 @@ static int add_delayed_ref(struct btrfs_trans_handle *trans,
 
 	if (qrecord_inserted)
 		return btrfs_qgroup_trace_extent_post(trans, record, generic_ref->bytenr);
+
+	kfree(record);
 	return 0;
 
 free_record:
-- 
2.51.0



