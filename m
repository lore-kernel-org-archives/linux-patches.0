Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9823C4551;
	Wed, 30 Sep 2026 19:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795533; cv=none; b=RMajR4eFOW8J6z7CpL1ut/rVSeiLgGjoYXnL90nJPsZ8zUYIdJyht151a3KhIaaA2Fu0yJ8+NiPlC4Lf5LvUmBkfT6XFeyoVIrJ+g2TDP4/wsWOxZqdaVg/lf+e6FWR86TJT3PuBAL2DxeA1OD4qwMWfpapaqDhBNTz7dnyk/2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795533; c=relaxed/simple;
	bh=vL+ffQb7AR9F+XWjOan1QtpRD7wmn6oaIydgcLE5KX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7K63vdF1oskf7dYgVgCWs0HLzjDju7F+XMvjIdaAUisK3fo3z7Q2Ti/dYB+rK5IAajpvLyZC9TTZC70JOJ3kmb8CYsGcI0V9NRsnM2TIejFhLHw9YERohh3es62piav7WTrcmjyV21zZUR1dT97aKVu56cyTUtY7FbvFHQqjbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUJU+SX2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUJU+SX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697511F000FF;
	Wed, 30 Sep 2026 19:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795532;
	bh=q0Cta+ixBcMBGVsC+Xgf3b/4FhfyTyVn0U3uYTa0DUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUJU+SX2wEw7L6/04BjQpsaJC1Lb0cXXdNudfv3V6iVP7ItGi51wiGjkxfxb8wHCs
	 cPgByo5tu2X3tpCkMq2BgrgFS/7Ugr3gCcB9xrLexfnaXm0Dwow4Jf7XgnOsPouz38
	 iiAg/iL5wfIy2R3UyquWXPowXIZClBXzcOFIPNGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Stian Halseth <stian@itx.no>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0593/1193] sunvdc: unmap LDC cookies when the descriptor send fails
Date: Wed, 30 Sep 2026 17:21:17 +0200
Message-ID: <20260930152447.420894745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index a379a37c94498..829da2723fda4 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -526,6 +526,23 @@ static int __send_request(struct request *req)
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



