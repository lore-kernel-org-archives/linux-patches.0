Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827188;
	b=lEV0XPWji7dSEZl7xKJC9Av0zYvXXDUCEGB6ci2EXiSENsYS/EFVFT4+IDUyTml+6CCM
	 O8KhkXUXdCL8hhxCNYn909opURbZqxvjXTp16IkaIJGsRz5xAP9OxnwZc8bOkyGfnajpW
	 S5eWTlSOnIDNVORKejfA2MWwdDoO2J7T8WP1dy9LJGAwKDV+hP+9+Cu2sdy/sP6cPq/eI
	 LkyUSrqdUQH7qP9YyXrTsy7Opk9hfvGlB0Cc2K2QeJsjFiw2MwScWaeYos2BiTum6FqEY
	 6jEPRwwm5t937+eHqMtRZRwGhCz2yBMCPY8gnzVfRAUUcfMtrbdCa7i95Q8MnfwlYbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oivF4mERPgMGNZp7bkEAs6Q7tGQ24AjFefusQUi5Dko=;
	b=J4tW+VUuazsmIocB24IQpbnHFdeDJAWhUOV3O+pcKNR0EdWdjrsXQeDIdEUBPxz8of05
	 8C/WtV3hJtA63zBk0sTH23AGRx3czdtLvbhZvUyyo2Fa8Acu7DiQRhZBYHTfDYe0ejf4Q
	 Drn5suIqrUHGgPzsqw2JLcM5EbTxkbckC5dzJVS4wusXFEl4Ejxabd/eZYnkBqrGYFyZl
	 Y6x/lwqG+9+Rd5eSf/b5QRhRRDSmCKOKbjgzLmSA36vIhocdQ7Wo9lFFosgwRgXvuoVpm
	 /Q6zvYs6uLlnQu43BgtNM/mzHN+meYyALlIex3xbJsFG0eST82a3kvEWAXAd2lrj2GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iS7keu3u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD65606B38A;
	Wed,  4 Nov 2026 21:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iS7keu3u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5CB1F000C1;
	Wed,  4 Nov 2026 21:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827188;
	bh=oivF4mERPgMGNZp7bkEAs6Q7tGQ24AjFefusQUi5Dko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iS7keu3utV3MUWHgBAPaZ33KwaFKRGihnl74ZSRKQZ/7r/t2+zutXCZB7L2BZHXf7
	 jpDnyjmmeNp1/eUYgxTrm487W0K1WEJeWsi/pM1MPBv+cqrSjlUacE6gcDXv1pOtsV
	 25Len5+UHm2acr7YWpw0CCPApNZHWTQC6XNNBlQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchao Zhang <ndaugoing@gmail.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 7.3 247/547] xen-blkfront: unbind irq before tearing down ring and shadow requests
Date: Wed,  4 Nov 2026 16:07:11 -0500
Message-ID: <20261104211045.190262149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchao Zhang <ndaugoing@gmail.com>

commit f3e27b7955727a4d7c0e9264a2a209fbba788bdc upstream.

In blkif_free_ring(), the driver tears down the ring's persistent grants,
shadow request arrays, and shared ring structure (xenbus_teardown_ring),
and only calls unbind_from_irqhandler() at the very end.

While blkif_free_ring() is freeing persistent grants and clearing the
shadow array, the event channel interrupt (blkif_interrupt) is still
registered and active.  If an interrupt arrives from the backend during
this teardown window, blkif_interrupt() reads rinfo->ring.sring and,
via blkif_completion(), accesses rinfo->shadow[id].grants_used and
rinfo->shadow[id].sg.  blkif_free_ring() tears these structures down
without holding rinfo->ring_lock, and the handler only checks
info->connected at entry, so this is a real race resulting in a
use-after-free or NULL pointer dereference.

Fix this by moving unbind_from_irqhandler() to the beginning of
blkif_free_ring().  Calling unbind_from_irqhandler() first frees the
IRQ and synchronizes with any in-flight interrupt handlers on other CPUs
before ring memory and shadow request structures are deallocated,
matching the teardown order in drivers/net/xen-netfront.c.

Fixes: 11659569f720 ("xen/blkfront: split per device io_lock")
Cc: stable@vger.kernel.org
Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
Acked-by: Roger Pau Monné <roger@xenproject.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260922072155.34625-1-ndaugoing@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/xen-blkfront.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1211,6 +1211,14 @@ static void blkif_free_ring(struct blkfr
 	int i, j, segs;
 
 	/*
+	 * Interrupt teardown must be done ahead of freeing queue-related
+	 * data, otherwise the interrupt handler can race with the cleanup.
+	 */
+	if (rinfo->irq)
+		unbind_from_irqhandler(rinfo->irq, rinfo);
+	rinfo->evtchn = rinfo->irq = 0;
+
+	/*
 	 * Remove indirect pages, this only happens when using indirect
 	 * descriptors but not persistent grants
 	 */
@@ -1292,10 +1300,6 @@ free_shadow:
 	/* Free resources associated with old device channel. */
 	xenbus_teardown_ring((void **)&rinfo->ring.sring, info->nr_ring_pages,
 			     rinfo->ring_ref);
-
-	if (rinfo->irq)
-		unbind_from_irqhandler(rinfo->irq, rinfo);
-	rinfo->evtchn = rinfo->irq = 0;
 }
 
 static void blkif_free(struct blkfront_info *info, int suspend)


