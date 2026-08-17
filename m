Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CFF3E5EC0;
	Mon, 17 Aug 2026 14:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978631; cv=none; b=S+BUuq3teB7IO3Gi3P4JVEmCBV3caebfyuXlYJUL5paZdReyb84RV6rCAgnjl6ZJEYr+2ernlaEaK2x1LULq41niyW8x1VvXTt7Nxz1xnQ81aphM40cjXxVJoJq14dBQ/J6M5JD00fdEhJ96Bz3tden8TYZoSd8nMOdaHlbRFYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978631; c=relaxed/simple;
	bh=lCWcnGmhZLebAaYuWDdhy1P3CCGdHx8jUtEw98XbOnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukiUt49sTYDkC5Cg2ZKZdv/y922z6F0D9/Sz/arltedd7KtMJoJlGFXiFIicKnqfzLcBI0lcTVIxvQrsA4Zba2k1IabBfsz6o4+syU13RhfywH+PMrUj7Ju3jVKdYV9hymKv1jvOYIEa4WcVaU6Wv9+37D/TMCi75NSqoezOVS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLZ/Gb+9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLZ/Gb+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184F01F000E9;
	Mon, 17 Aug 2026 14:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978630;
	bh=n4LjX7Y/3xjbrMOcrIz0r7oxoAv+uGLw1IwNMCMhjpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLZ/Gb+9RtkbGlilzGDr7U2mEutLDM6T0yJzASIYRm8wPViIM8ywpLReXR3c9k11D
	 rYN06c0kzWRBCT3EQrtO3d+AtFwxAnhteBaYMLSAJgxaWLELl2VhmJ6vLWl/8O7TB6
	 /pxyqrQh/QsnnOIth/TkpgBgFvsnH9//azkR2C8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Menachem Adin <menachem.adin@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.6 103/156] mei: pull kvfree out of spinlock
Date: Mon, 17 Aug 2026 15:33:57 +0200
Message-ID: <20260817132538.649999430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit b0495bb58af06a7de4628c72d500e3d5e180d808 upstream.

The read buffer allocation was changed from kmalloc() to kvmalloc().

This buffer is part of mei_cl_cb structure that can be queued in
rd_complete queue protected by spinlock.
Releasing the structure leads to errors like below when freeing buffer
that allocated non-contiguous:

BUG: sleeping function called from invalid context at mm/vmalloc.c:3448

Separate mei_cl_cb structure dequeue and release to
perform only dequeue under spinlock and push release out of spinlock.

Cc: stable <stable@kernel.org>
Fixes: 4adf613e01bf ("mei: use kvmalloc for read buffer")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/16359
Reviewed-by: Menachem Adin <menachem.adin@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20260719-kvfree_out_of_spinlock-v1-1-e07d6333bea7@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/client.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -447,18 +447,24 @@ static void mei_io_tx_list_free_cl(struc
 }
 
 /**
- * mei_io_list_free_fp - free cb from a list that matches file pointer
+ * mei_io_rd_list_free_fp - free cb from a rd_completed list that matches file pointer
  *
- * @head: io list
+ * @cl: host client
  * @fp: file pointer (matching cb file object), may be NULL
  */
-static void mei_io_list_free_fp(struct list_head *head, const struct file *fp)
+static void mei_io_rd_list_free_fp(struct mei_cl *cl, const struct file *fp)
 {
 	struct mei_cl_cb *cb, *next;
+	LIST_HEAD(cmpl_list);
 
-	list_for_each_entry_safe(cb, next, head, list)
+	spin_lock(&cl->rd_completed_lock);
+	list_for_each_entry_safe(cb, next, &cl->rd_completed, list)
 		if (!fp || fp == cb->fp)
-			mei_io_cb_free(cb);
+			list_move(&cb->list, &cmpl_list);
+	spin_unlock(&cl->rd_completed_lock);
+
+	list_for_each_entry_safe(cb, next, &cmpl_list, list)
+		mei_io_cb_free(cb);
 }
 
 /**
@@ -587,9 +593,7 @@ int mei_cl_flush_queues(struct mei_cl *c
 		mei_io_list_flush_cl(&cl->dev->ctrl_rd_list, cl);
 		mei_cl_free_pending(cl);
 	}
-	spin_lock(&cl->rd_completed_lock);
-	mei_io_list_free_fp(&cl->rd_completed, fp);
-	spin_unlock(&cl->rd_completed_lock);
+	mei_io_rd_list_free_fp(cl, fp);
 
 	return 0;
 }
@@ -1426,7 +1430,7 @@ void mei_cl_add_rd_completed(struct mei_
 }
 
 /**
- * mei_cl_del_rd_completed - free read completed callback with lock
+ * mei_cl_del_rd_completed - unlink read completed callback with lock and free it
  *
  * @cl: host client
  * @cb: callback block
@@ -1435,8 +1439,9 @@ void mei_cl_add_rd_completed(struct mei_
 void mei_cl_del_rd_completed(struct mei_cl *cl, struct mei_cl_cb *cb)
 {
 	spin_lock(&cl->rd_completed_lock);
-	mei_io_cb_free(cb);
+	list_del_init(&cb->list);
 	spin_unlock(&cl->rd_completed_lock);
+	mei_io_cb_free(cb);
 }
 
 /**


