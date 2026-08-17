Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF4B4322E5;
	Mon, 17 Aug 2026 14:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978238; cv=none; b=alxprEbarSaSQHweoaGTjKsYAJu8h6kLapQUJspyWr5S0zlxi2LHVmMPmrWebU0hcpgowDv+qx7SPaf49bmapmxzdoBxdKAsWSy2zoRTPEHdIg/BPKHAxRzFX9vGvMBJB6AriNotZqNtmuhefaQn1iThhrnXczLGle6bw2j065U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978238; c=relaxed/simple;
	bh=nlwRV/S0R/oO6T/3OVI9ighPrRIkDCnOShUzn9U3jSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbSVZYuVV1ukVTnIKutU52ZiJYS2vdQlboYFPXAyzIGuHi3nrLbKh9x+fu24PWt4PlrjN5ay7OCCzhTk8u6rx+seOW06uF8Fan/BPC3kt13DC29yMfPveBXofe7T2DcgXc56IsbkZEjf9iPm9lr/tTsIj5DIW2xPf8SFkFIYiEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0m+KoKJn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0m+KoKJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553EB1F000E9;
	Mon, 17 Aug 2026 14:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978236;
	bh=P71epoDihCk8nZ8Lm3HZ38HmPeg/9hcd3ul21yuGiPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0m+KoKJnu2tyYdGNgdZPOBTn05fqYkuppUT0n72dTOTwYZtzG95HA5kRiMkM6/vS7
	 Z0X5+uh710xHFJSadFuxD/VfcEKQEgYXxuDTF/7aqDHnug95dtB6GhZLmqQ92USpOM
	 6CuG74C3B1NhQzzOcC9oMLDYoOtNTa4aj1XeZbyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Menachem Adin <menachem.adin@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.12 122/181] mei: pull kvfree out of spinlock
Date: Mon, 17 Aug 2026 15:33:36 +0200
Message-ID: <20260817132540.358897855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


