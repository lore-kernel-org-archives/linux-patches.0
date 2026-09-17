Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E342F360A;
	Thu, 17 Sep 2026 15:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659992; cv=none; b=Rzc5BOenQOwjIDz6hODsTNYdT8r7Jr7GBW5JIYvijiidyb6kJIsccdU11cmLBh8+5s/FZCdYV/v8kxanthGHAnV+9s1TKNFHbrYerc9xqeu3eJqYLnPBz4ysfUzNcx0bSa+cZNPZv8egD+rAqVGQXzt/uWkW+bsNzEKY6Yd2Jl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659992; c=relaxed/simple;
	bh=b8YQfWwpcRyIQDJNQP0w5vuPw1rdlZpQn9570E15YMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvx3RFW0eMY5o6bn+qaLhFLiw9/B0d+Kx7dk4JDfIswyDYNsBZoVlYm28m3haRtpHQP/Z/zwRUcDcC4LEj7AIRmiUbsKe3NQVJyAWdQpJNO43NQRaViQH9Ypcy/iT5w39/jYh/p12DvUiqxajBuJo+4efd5qgzj1FmzufdGHTnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQJ9qQUK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQJ9qQUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07B91F00898;
	Thu, 17 Sep 2026 15:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659982;
	bh=QoRitSp622IpmMNB/N+EQ8mM+6yaZvFVX5RmioqnT3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dQJ9qQUKGsQl7E/JvnUYKjDAn5w3IqE+6ddo7qlaj66kr+L2jXlBRd3KkQs9tKOL9
	 iMJaTbpE6MXwlKxuXHHU4KiFl0O7xmurEpuORE50O3mv4JVk4U1I67s6+RTukzXrET
	 86HSvw5sTMhL1VSL4lZhX66FfDrE5JMvvHULswmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Stian Halseth <stian@itx.no>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 439/733] sunvdc: unmap LDC cookies when the descriptor send fails
Date: Thu, 17 Sep 2026 16:12:27 +0100
Message-ID: <20260917151402.800394062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 020bd9f1a7b6a..24ad56536ed60 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -525,6 +525,23 @@ static int __send_request(struct request *req)
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



