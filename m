Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D78A3DAAC8;
	Fri,  4 Sep 2026 05:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499526; cv=none; b=pRVJ7LlXumSui73HHc5TzMpVeJZ+J3N5JtYfFl30m8LHwwwJ1suwrVG6Cu4HOzRU0Jap/fkVdUF/vGkDESDLJzBuZCvLczGPbQKVQiTPkIv3UkbYQBiEl0vsGeZ939XdI3yuL777/F+J3y3QV+oUW7yzGSJOc36tgSnea5h/d6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499526; c=relaxed/simple;
	bh=x/Ty1u7WI7gABoyVn1bTL/VbvTUCee9lyXnqrv9BB6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sy7pFeoM/w7ofWmatJ06wEGRG4gzd50MStblqEIlpxLjlWbV6ToBJUk3lpPoYYX0koFWcSyiSABG97P2EwFBjym3XUzngxcWdWak03N+rNIDV5RTSKp0BznZXuS66PzF5V5zwAJaoT+wELyE2rnkbOCnqfZTWpzQxXS9vwL2xug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axtIRXDE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axtIRXDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646731F00A3D;
	Fri,  4 Sep 2026 05:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499524;
	bh=+UNv2kLTjYlgGuhOfHDPTZyUnjOwewdDZu9nyNSmnOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axtIRXDEOe+Xb+iWuxNwak7ssCbLqzNowy8aVFfKBBkPOB8szVofMD2jtyRnjnab6
	 rNliIEsM4UHRr96dLux0Fk0k9avfKlYhfIlbB2DXRpSIswv89wkl+n4aMIEtY6Bbq5
	 zXMe8s/pZqmJfX8FO7ycLDKlAW2kqqcRj2/4wxjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.2 446/713] RDMA/ucma: Lock the handler in ucma_write_cm_event()
Date: Fri,  4 Sep 2026 06:56:54 +0200
Message-ID: <20260904045813.828508420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit f4cc21c6a8e9d392871477f9fd98d68e5ad80272 upstream.

ctx->file may only be changed under the handler lock and the xa_lock, which
is what stops uevents being queued for a ctx while ucma_migrate_id() moves
it to another file.  The CM core takes that lock before invoking
ucma_event_handler(), but the write() paths that queue uevents themselves
do not.

ucma_write_cm_event() re-reads ctx->file for each of its four dereferences,
so ucma_migrate_id() can swap it mid-sequence:

	mutex_lock(&ctx->file->mut);			/* file A */
	list_add_tail(&uevent->list, &ctx->file->event_list);	/* file B */
	mutex_unlock(&ctx->file->mut);			/* file B */
	wake_up_interruptible(&ctx->file->poll_wait);	/* file B */

The window is the mutex_lock() itself: the writer sleeps in it while the
migration reassigns ctx->file.  The list_add_tail() then runs on file B's
event_list holding only file A's mutex:

  list_add corruption. prev->next should be next (ffff888101320f30),
    but was ffff88814a08c418. (prev=ffff88814a075c18).
  kernel BUG at lib/list_debug.c:32!
  Call Trace:
   ucma_write_cm_event+0x36e/0x5e0

and file A's mut is left held forever, wedging its next writer in D state.
The uevent is also stranded on a list ucma_cleanup_ctx_events() will not
walk, so it outlives its context.  /dev/infiniband/rdma_cm is 0666 and no
RDMA device is involved, so an unprivileged user reaches all of this.

Take the handler lock, as ucma_cleanup_mc_events() does; ctx->cm_id is
pinned by the ucma_get_ctx() reference.

Fixes: a3c9d0fcd371 ("RDMA/ucma: Support write an event into a CM")
Link: https://patch.msgid.link/r/60544A67-EFD6-4D5D-974C-D983445F1070@doyensec.com
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/ucma.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1779,6 +1779,13 @@ static ssize_t ucma_write_cm_event(struc
 		goto out;
 	}
 
+	rdma_lock_handler(ctx->cm_id);
+	if (!ctx->uid) {
+		kfree(uevent);
+		ret = -EINVAL;
+		goto err_unlock;
+	}
+
 	uevent->ctx = ctx;
 	uevent->resp.uid = ctx->uid;
 	uevent->resp.id = ctx->id;
@@ -1792,6 +1799,8 @@ static ssize_t ucma_write_cm_event(struc
 	mutex_unlock(&ctx->file->mut);
 	wake_up_interruptible(&ctx->file->poll_wait);
 
+err_unlock:
+	rdma_unlock_handler(ctx->cm_id);
 out:
 	ucma_put_ctx(ctx);
 	return ret;


