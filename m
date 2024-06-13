Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3449DDDB1;
	Thu, 13 Jun 2024 11:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278716; cv=none; b=XekqdSbOtSLon3r3NsP76WaTJWrNd+85nOEORcrcDaHlmd9BvmyzogHmWqGi1EwowvlOhi384HmFr0QYeFgMwBRO1BVSdgjoNhCMAqaRwhttRxZ/0zsf5i+O5dbOErRIGVKbflzyZz07Ek03kzIGPvK1pIbt0Dz4CbWKSPVrxOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278716; c=relaxed/simple;
	bh=UfHQxxWC41xQgm/emXt8N+c97wq7XZ4+rvfnwLqJGP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4QTzaZnqKEnay2KIn9/i3yhL4DVVqvwH5IBaLJRJtOSFWZdHn6jzzC/B6ZcotoeQtpU6xC3KGxA6wycTXr/4yUcer8VO5agpOMQQoTl5jugJFG9FgM28e5aUKFwQ2/+IRajxJT+Oie48x0/e0VnLOoGVG3MSLRQ6zJFReUdXTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSmI0h6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSmI0h6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6044C2BBFC;
	Thu, 13 Jun 2024 11:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278716;
	bh=UfHQxxWC41xQgm/emXt8N+c97wq7XZ4+rvfnwLqJGP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSmI0h6FPEkpp/sO34tbe9Hi0Dho9GtKkFAs3k6z2x5bYNQLHXLI8gnuioQeK2MK7
	 rzQVgA1xbu/2Hv7f9HTC2Bsm3ZgpDpAQaCw/Q/01jIq301JYKnlkHL1jiy5RXbIUxs
	 VNnp8WvYMwfEVkpi8zvOI6+nh8lfZTnPy9VSHjSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@telegraphics.com.au>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/213] macintosh/via-macii: Remove BUG_ON assertions
Date: Thu, 13 Jun 2024 13:31:32 +0200
Message-ID: <20240613113229.704602501@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 5f93d7081a47e1972031ccf57c4b2779eee162fb ]

The BUG_ON assertions I added to the via-macii driver over a decade ago
haven't fired AFAIK. Some can never fire (by inspection). One assertion
checks for a NULL pointer, but that would merely substitute a BUG crash
for an Oops crash. Remove the pointless BUG_ON assertions and replace
the others with a WARN_ON and an array bounds check.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Stable-dep-of: d301a71c76ee ("macintosh/via-macii: Fix "BUG: sleeping function called from invalid context"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/via-macii.c | 49 +++++------------------------------
 1 file changed, 7 insertions(+), 42 deletions(-)

diff --git a/drivers/macintosh/via-macii.c b/drivers/macintosh/via-macii.c
index cf6f7d52d6bee..fc6ad5bf1875a 100644
--- a/drivers/macintosh/via-macii.c
+++ b/drivers/macintosh/via-macii.c
@@ -120,23 +120,6 @@ static int srq_asserted;     /* have to poll for the device that asserted it */
 static int command_byte;         /* the most recent command byte transmitted */
 static int autopoll_devs;      /* bits set are device addresses to be polled */
 
-/* Sanity check for request queue. Doesn't check for cycles. */
-static int request_is_queued(struct adb_request *req) {
-	struct adb_request *cur;
-	unsigned long flags;
-	local_irq_save(flags);
-	cur = current_req;
-	while (cur) {
-		if (cur == req) {
-			local_irq_restore(flags);
-			return 1;
-		}
-		cur = cur->next;
-	}
-	local_irq_restore(flags);
-	return 0;
-}
-
 /* Check for MacII style ADB */
 static int macii_probe(void)
 {
@@ -213,8 +196,6 @@ static void macii_queue_poll(void)
 	else
 		next_device = ffs(autopoll_devs) - 1;
 
-	BUG_ON(request_is_queued(&req));
-
 	adb_request(&req, NULL, ADBREQ_NOSEND, 1,
 	            ADB_READREG(next_device, 0));
 
@@ -237,18 +218,13 @@ static int macii_send_request(struct adb_request *req, int sync)
 	int err;
 	unsigned long flags;
 
-	BUG_ON(request_is_queued(req));
-
 	local_irq_save(flags);
 	err = macii_write(req);
 	local_irq_restore(flags);
 
-	if (!err && sync) {
-		while (!req->complete) {
+	if (!err && sync)
+		while (!req->complete)
 			macii_poll();
-		}
-		BUG_ON(request_is_queued(req));
-	}
 
 	return err;
 }
@@ -327,9 +303,6 @@ static int macii_reset_bus(void)
 {
 	static struct adb_request req;
 	
-	if (request_is_queued(&req))
-		return 0;
-
 	/* Command = 0, Address = ignored */
 	adb_request(&req, NULL, 0, 1, ADB_BUSRESET);
 
@@ -346,10 +319,6 @@ static void macii_start(void)
 
 	req = current_req;
 
-	BUG_ON(req == NULL);
-
-	BUG_ON(macii_state != idle);
-
 	/* Now send it. Be careful though, that first byte of the request
 	 * is actually ADB_PACKET; the real data begins at index 1!
 	 * And req->nbytes is the number of bytes of real data plus one.
@@ -387,7 +356,6 @@ static void macii_start(void)
 static irqreturn_t macii_interrupt(int irq, void *arg)
 {
 	int x;
-	static int entered;
 	struct adb_request *req;
 
 	if (!arg) {
@@ -398,8 +366,6 @@ static irqreturn_t macii_interrupt(int irq, void *arg)
 			return IRQ_NONE;
 	}
 
-	BUG_ON(entered++);
-
 	last_status = status;
 	status = via[B] & (ST_MASK|CTLR_IRQ);
 
@@ -408,7 +374,7 @@ static irqreturn_t macii_interrupt(int irq, void *arg)
 			if (reading_reply) {
 				reply_ptr = current_req->reply;
 			} else {
-				BUG_ON(current_req != NULL);
+				WARN_ON(current_req);
 				reply_ptr = reply_buf;
 			}
 
@@ -473,8 +439,8 @@ static irqreturn_t macii_interrupt(int irq, void *arg)
 
 		case reading:
 			x = via[SR];
-			BUG_ON((status & ST_MASK) == ST_CMD ||
-			       (status & ST_MASK) == ST_IDLE);
+			WARN_ON((status & ST_MASK) == ST_CMD ||
+				(status & ST_MASK) == ST_IDLE);
 
 			/* Bus timeout with SRQ sequence:
 			 *     data is "XX FF"      while CTLR_IRQ is "L L"
@@ -501,8 +467,8 @@ static irqreturn_t macii_interrupt(int irq, void *arg)
 				}
 			}
 
-			if (macii_state == reading) {
-				BUG_ON(reply_len > 15);
+			if (macii_state == reading &&
+			    reply_len < ARRAY_SIZE(reply_buf)) {
 				reply_ptr++;
 				*reply_ptr = x;
 				reply_len++;
@@ -545,6 +511,5 @@ static irqreturn_t macii_interrupt(int irq, void *arg)
 		break;
 	}
 
-	entered--;
 	return IRQ_HANDLED;
 }
-- 
2.43.0



