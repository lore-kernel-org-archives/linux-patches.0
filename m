Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E96B36D501;
	Tue, 16 Dec 2025 12:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888023; cv=none; b=VW+4EpOUoKyNvtijahUabi2pCPYJP7L70amyt+/KOlJx4bpzpys7ymTbBOrvyJcQQfsJyqmUakihmbs1Jd4EmY+WZOk3q7ZtgZ0Om+2b3xq8oAUFzrApHjA44fCo/pv0Ut0WjS6tWQm+q5GqEZXw0IwqtO9ACArd/o/O8+Dg6JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888023; c=relaxed/simple;
	bh=HqnciSoGH1P+DTSrv2J0jwuc0VO2hOtwrYUKD4PTr18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DlHrLw7NUxcTl+PhcHYxBzvwNeGu/4vyPIs7SXd8LKmhaLCpCVnCeFzU0A6ZBUrFl6aw7tJXPhayLED0i5o+HePZIIiQXOz+50j+qshUHYEQaU8pP0Ya1uz7yNhqweqcL+Z82IE844GVXSAyRbvjjXpuBfxLvMhf3hheBPyxOos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vyJ+t99Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyJ+t99Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F9CC4CEF1;
	Tue, 16 Dec 2025 12:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888023;
	bh=HqnciSoGH1P+DTSrv2J0jwuc0VO2hOtwrYUKD4PTr18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyJ+t99YD2K9TnyUC9cFQNBtdnvdRrRdtAFeGOSfmEWi9D6WRst4jN2Yi2aI8oHUQ
	 9XB4jL2OJK3FDOEQG8kn6+DYy8sV6EPv0hGDblUXIrTd8evV9smE9B00b660X+grv/
	 3DNE36XVd7qfkZvl+9IBdSIGpT3zv+3kdbRYyoA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 408/614] btrfs: fix double free of qgroup record after failure to add delayed ref head
Date: Tue, 16 Dec 2025 12:12:55 +0100
Message-ID: <20251216111416.155821526@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 481802efaa143..f8fc26272f76c 100644
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



