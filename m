Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041B147ECCC;
	Sat, 12 Sep 2026 13:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220414; cv=none; b=OPEl5AkIwjZh9WQLrA+M98HKz/mIFf+MKLUba9uB9rCwhAdnTF3IlcwLH2yPUesxjWHBl4aXcvEPmsQsELuf9VBzkOC+9jGRGz07fhe5B22y1r4wItQrRS7cGIj/rnEVOga9eXBNJlr5gPxgjBAdnlN/0diZ26gQePf+6ugrcVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220414; c=relaxed/simple;
	bh=UCffITD4+H9pCob4WGa16gDRrkTEiz68KcKRVC/bRCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHmVUdY2OXX0KzbFFr/LjCy5esgGWZ5TkdsyDEVC77EJ4pJolqCVK8c22ibyt6z7gx7MrJuuXxozUbfc7RaTg7TjPdQFfs/wqUGZfhsZCTfXtEtRkb42zup8ZrWaI6APtmYkkIR0fU4jrNr+g9GA1FZiNvvKLSRkJDFqsiB3JGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVSDfUEw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVSDfUEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC941F000FF;
	Sat, 12 Sep 2026 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220412;
	bh=K+QkFF5EseIeyz6eh3dxcFmT8sNkP9T8iIMhugLeavw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVSDfUEwb5uwAhisftizOT9LXgpp5OER3x9S6n4T+tN5MLxJHGQipctBJ0MulnTu1
	 M0KkkD8gXpJ7BSWb8y6dIxd6KJV6L4bgfKuaBiZNqyJa5zTzhS4EtV/O5JfDAMHrGe
	 wr22iGvGBTbQ7oPkQsD4Y0opr637Wj0mffsPEjU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.6 0173/1424] RDMA/ucma: Lock the handler in ucma_set_ib_path()
Date: Sat, 12 Sep 2026 08:43:25 +0200
Message-ID: <20260912065611.167378641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Norbert Szetei <norbert@doyensec.com>

commit ecbe7d36dc2de07e5dfbb4a8ff5b315ab43de820 upstream.

ucma_set_ib_path() calls ucma_event_handler() straight from the write()
path, without the handler lock that keeps ctx->file stable while a uevent
is queued.  The handler re-reads ctx->file for every dereference:

	mutex_lock(&ctx->file->mut);			/* file A */
	list_add_tail(&uevent->list, &ctx->file->event_list);	/* file B */
	mutex_unlock(&ctx->file->mut);			/* file B */
	wake_up_interruptible(&ctx->file->poll_wait);	/* file B */

A concurrent ucma_migrate_id() reassigns ctx->file while the SET_OPTION
caller sleeps in mutex_lock(), so the list_add_tail() lands on file B's
event_list while only file A's mutex is held, racing every other user of
that list:

  BUG: KASAN: slab-use-after-free in __list_add_valid_or_report+0x1aa/0x1c0
  Read of size 8 at addr ffff888153c6a418 by task poc_corr/486
  Call Trace:
   __list_add_valid_or_report+0x1aa/0x1c0
   ucma_event_handler+0x1be/0xc00
   ucma_set_ib_path+0x45e/0x710
   ucma_set_option+0x32e/0x590
   ucma_write+0x1f9/0x330
  Allocated by task 505:
   ucma_write_cm_event+0x1a1/0x660
  Freed by task 505:
   kfree+0x1da/0x4c0
   ucma_get_event+0x5d5/0x7e0

The freed object is a ucma_event that another thread dequeued from file B's
list under file B's mutex.  File A's mut is left held on top of that,
wedging its next writer in uninterruptible sleep.

This path needs a bound and address-resolved cm_id, so it requires an RDMA
device to be present.

Take the handler lock around the call.

Fixes: 09e328e47a69 ("RDMA/ucma: Fix the locking of ctx->file")
Link: https://patch.msgid.link/r/2823D190-92D5-4714-8769-4FB643C64FF3@doyensec.com
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/ucma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1336,7 +1336,10 @@ static int ucma_set_ib_path(struct ucma_
 
 	memset(&event, 0, sizeof event);
 	event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
-	return ucma_event_handler(ctx->cm_id, &event);
+	rdma_lock_handler(ctx->cm_id);
+	ret = ucma_event_handler(ctx->cm_id, &event);
+	rdma_unlock_handler(ctx->cm_id);
+	return ret;
 }
 
 static int ucma_set_option_ib(struct ucma_context *ctx, int optname,


