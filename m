Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0B51CA8F;
	Mon,  1 Apr 2024 16:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988806; cv=none; b=TdictRpM9tT2NvR/XS+jwLJIwV/u+GUMgdppSejmJvdmbDDgRIOoDBHLE7m/FLo+4Hyrnygpgw58NC70/ibFZ6p7JoPm/QFyaEvgTvW6w6kMqsqhBJ77uCAeVHFS9GtgOSRdoSx+YUFVJ0LjtTnEFgR+6bzZAe1NUPGhO5QvNRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988806; c=relaxed/simple;
	bh=MVdARjtk2gmKylNWPsvcnW/wtJu+Z+dGr0271r0zkvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HV32gRusKhcWNvWN81Tvg5fTMw3KZIFsBjTjwO1d2J8QIyqLo8aL9ShTWST/UYAhxZxCXJ7M2DCtXGMwtskCCVglRJEFZZB3covL4wkH5Gn8Yvw1Ws2crPqM6AALW1zKMv/l8HGli6M6SHxSRDmiZYwLRmJh8FVaMQgLtkuvFAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+mhWMr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+mhWMr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208C9C433F1;
	Mon,  1 Apr 2024 16:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988806;
	bh=MVdARjtk2gmKylNWPsvcnW/wtJu+Z+dGr0271r0zkvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+mhWMr/sl2ah0Oeexz/sdkapsJFfAHJIM99ozNloa7ULqUMmJm0HfBMtF45VhEqH
	 +J7xWPhx4wSeDSoL9Kt61W4vozF9DToZOi6SsMfvQok8Qh5WnKXkWUCjH8qo6jEvUl
	 jNZ60LgOps3Swh61H+Gxn0Y11axODUStTP8lCw/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Yokum <linux-usb@mail.totalphase.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.7 265/432] xhci: Fix failure to detect ring expansion need.
Date: Mon,  1 Apr 2024 17:44:12 +0200
Message-ID: <20240401152601.054502749@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit b234c70fefa7532d34ebee104de64cc16f1b21e4 upstream.

Ring expansion checker may incorrectly assume a completely full ring
is empty, missing the need for expansion.

This is due to a special empty ring case where the dequeue ends up
ahead of the enqueue pointer. This is seen when enqueued TRBs fill up
exactly a segment, with enqueue then pointing to the end link TRB.
Once those TRBs are handled the dequeue pointer will follow the link
TRB and end up pointing to the first entry on the next segment, past
the enqueue.

This same enqueue - dequeue condition can be true if a ring is full,
with enqueue ending on that last link TRB before the dequeue pointer
on the next segment.

This can be seen when queuing several ~510 small URBs via usbfs in
one go before a single one is handled (i.e. dequeue not moved from first
entry in segment).

Expand the ring already when enqueue reaches the link TRB before the
dequeue segment, instead of expanding it when enqueue moves into the
dequeue segment.

Reported-by: Chris Yokum <linux-usb@mail.totalphase.com>
Closes: https://lore.kernel.org/all/949223224.833962.1709339266739.JavaMail.zimbra@totalphase.com
Tested-by: Chris Yokum <linux-usb@mail.totalphase.com>
Fixes: f5af638f0609 ("xhci: Fix transfer ring expansion size calculation")
Cc: stable@vger.kernel.org # v6.5+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240305132312.955171-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -326,7 +326,13 @@ static unsigned int xhci_ring_expansion_
 	/* how many trbs will be queued past the enqueue segment? */
 	trbs_past_seg = enq_used + num_trbs - (TRBS_PER_SEGMENT - 1);
 
-	if (trbs_past_seg <= 0)
+	/*
+	 * Consider expanding the ring already if num_trbs fills the current
+	 * segment (i.e. trbs_past_seg == 0), not only when num_trbs goes into
+	 * the next segment. Avoids confusing full ring with special empty ring
+	 * case below
+	 */
+	if (trbs_past_seg < 0)
 		return 0;
 
 	/* Empty ring special case, enqueue stuck on link trb while dequeue advanced */


