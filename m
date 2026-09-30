Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C55D4DE720;
	Wed, 30 Sep 2026 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783108; cv=none; b=Dkd4+NPsjvaxl31l+5eWBfkAaOY/EnGQG+pWHAhU+7/QmkP+a28zViIlTBl75SdGzmlYrJiu1iph+fyHqq5OdXciaygyWsjXXeWzPeoF1jb0aSX3ln2X7YobIewnfrCdy4Qs1x3YIaTELGzOfjhpkngpsbqg+sdN1nC5sW8Vxjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783108; c=relaxed/simple;
	bh=v25tC2xNuj5hzrhcVlUr5Aglry8Xdisv9yUj8hcicM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6tVlZ7eZdCrcM1OyV03yVH7OPjIE7BMNhzGpAmW/p2V1aTpELNKKZdnENVrIk/1fYZPICY7MGJLf/gbRL2JX0CpZ7AV+QjFUO7U8izgDGgmGIPPgYW/RUG0+0RkHXVKlzUsVC675MSj77TzYdD4evtsBu8mg5CqJrA3KUDhvEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QUpYQHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QUpYQHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD0A1F00898;
	Wed, 30 Sep 2026 15:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783103;
	bh=7BPbKpnoWEXV9A/b/Cm/jCbZSb/bbRq+zL5Cq1tj3qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1QUpYQHNCXAQ5WL6ql/V9UOXIck0lPVCWNRDLmY08TN//c3FAwod3ISsy2eXjB7Ew
	 G/VDIiW1mg/IaGt7DGUSuaiZQY21qIvguSMVU4ysvouLIXppGv/XBkfvIcLaYPthaW
	 ywqdHHdYwp58QBHio6mQPCkVMeKDOKyHIxu9B0yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Stian Halseth <stian@itx.no>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/595] sunvdc: unmap LDC cookies when the descriptor send fails
Date: Wed, 30 Sep 2026 17:22:54 +0200
Message-ID: <20260930152353.746118730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stian Halseth <stian@itx.no>

[ Upstream commit 0c6da21fa35e03fc74f09895433ccd6d4a9c3530 ]

__send_request() maps the request's pages into the LDC channel's map
table (ldc_map_sg()), fills in the descriptor and marks it
VIO_DESC_READY before ringing the doorbell via __vdc_tx_trigger().
When the trigger fails, the error path only prints a message: the
descriptor stays READY and the cookies are never unmapped. The
mapping is normally released in vdc_end_one() when the peer completes
the descriptor - but a descriptor whose doorbell was never sent will
never complete, and since dr->prod is not advanced on failure, the
reset path (vdc_requeue_inflight(), which walks [cons, prod)) never
visits it either. The map table entries are leaked permanently.

Since commit a11f6ca9aef9 ("sunvdc: Do not spin in an infinite loop
when vio_ldc_send() returns EAGAIN") trigger failures occur in
practice under load, so every resulting I/O error also leaks one
request's worth of entries from the fixed-size (8192 entries per
channel) map table. Because the allocator hands out contiguous
ranges, fragmentation makes large multi-segment requests fail first
as the table drains, until ldc_map_sg() fails permanently and the
disk is dead until reboot.

It also makes any retry-based recovery unusable: requeuing the
request on -EAGAIN remaps the pages on every attempt, overwriting
desc->cookies and orphaning the previous mapping, so the table
drains at the retry rate. This is the memory exhaustion observed
when the requeue approach was first tested in October 2025.

Roll back on failure: unmap the cookies, mark the descriptor FREE
again and clear the request entry. If the trigger failed with
-ENOTCONN, __vdc_tx_trigger() has already reset the port, which
tears down and reallocates both the dring and the LDC channel
including its map table - nothing to roll back, and the stale
descriptor must not be touched.

Fixes: a11f6ca9aef9 ("sunvdc: Do not spin in an infinite loop when vio_ldc_send() returns EAGAIN")
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://github.com/sparclinux/issues/issues/2
Signed-off-by: Stian Halseth <stian@itx.no>
Link: https://patch.msgid.link/20260901173947.3292110-2-stian@itx.no
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/sunvdc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 9cf0b858f7b85..fe52b716f8442 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -524,6 +524,23 @@ static int __send_request(struct request *req)
 	err = __vdc_tx_trigger(port);
 	if (err < 0) {
 		printk(KERN_ERR PFX "vdc_tx_trigger() failure, err=%d\n", err);
+		/*
+		 * If the port was reset (-ENOTCONN), the dring and the
+		 * LDC channel including all of its mappings are already
+		 * torn down and reallocated - there is nothing to undo
+		 * and @desc must not be touched.
+		 *
+		 * For any other failure the descriptor was never handed
+		 * to the peer: unmap the cookies and free the descriptor
+		 * again, so that a later retry of the request does not
+		 * leak LDC map table entries.
+		 */
+		if (err != -ENOTCONN) {
+			ldc_unmap(port->vio.lp, desc->cookies,
+				  desc->ncookies);
+			desc->hdr.state = VIO_DESC_FREE;
+			rqe->req = NULL;
+		}
 	} else {
 		port->req_id++;
 		dr->prod = vio_dring_next(dr, dr->prod);
-- 
2.53.0



