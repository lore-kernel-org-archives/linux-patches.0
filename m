Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC76F47AF5D;
	Tue, 16 Jun 2026 17:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630877; cv=none; b=lM0qPQpksp+f1y43dNYXmN5tb4yvdYHtFkloptZVmuxxr3f4Mtgo4ol6KP75tnKK6wcNH4aJdMhwEtLNNVd4nnyQK2Hg32oHiDw+72yLQDXcr/QzIDd+RbEn8Z3bpNCQJnuqPzbuLwZZ5jq/pFp9pAyy+9U3z8eyQwBx4nP+/uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630877; c=relaxed/simple;
	bh=3sZdDhvSvNfO3i/p0SRYFeRAWpm4hhJrsUt7bjaIcvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3OWqusLe7ze7ln7ygGyBBlURZz4Wtf6yozyN81pOmvf6WO1717KyZKbswIQdDaimzMnjyRXhcV9aPvI7XjTfZoYWqoUVS9bqRStAe5xLDjob92SCZyCjcYmmGbVicRas+cMIwUMx5cF6pkxCYEWcuOI0nOKlnP8EavPqjZbzpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ie9tCCeY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ie9tCCeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C5C1F000E9;
	Tue, 16 Jun 2026 17:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630874;
	bh=549RcJ+J4fP89oBBvfMmzZxfF1u7j/4GgGj4FHYt9Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ie9tCCeYWMsYWVI4kvI0zqwfKb4qMmSzUV5nmbNwUIdRz7j4MOLbopfeEhtN9bpjb
	 0qe3Ih55ZaNA7XR2QvyTM0mzFsrclsj6lrE+t74ZP+MKNIVRe3SzvTjDkoIrnOHw5X
	 KGTykWMIoY1M+DgYJ2xTd5S3dlU5eKHiMMOhMrp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 114/522] USB: serial: omninet: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:24:21 +0530
Message-ID: <20260616145131.291418306@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 60df93d30f9bdd27db17c4d80ed80ef718d7226b upstream.

Make sure that the bulk-out buffers are at least as large as the
hardcoded transfer size to avoid user-controlled slab corruption should
a malicious device report a smaller endpoint max packet size than
expected.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/omninet.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -30,6 +30,10 @@
 /* This one seems to be a re-branded ZyXEL device */
 #define BT_IGNITIONPRO_ID	0x2000
 
+#define OMNINET_HEADERLEN	4
+#define OMNINET_BULKOUTSIZE	64
+#define OMNINET_PAYLOADSIZE	(OMNINET_BULKOUTSIZE - OMNINET_HEADERLEN)
+
 /* function prototypes */
 static void omninet_process_read_urb(struct urb *urb);
 static int omninet_prepare_write_buffer(struct usb_serial_port *port,
@@ -55,6 +59,7 @@ static struct usb_serial_driver zyxel_om
 	.description =		"ZyXEL - omni.net usb",
 	.id_table =		id_table,
 	.num_bulk_out =		2,
+	.bulk_out_size =	OMNINET_BULKOUTSIZE,
 	.calc_num_ports =	omninet_calc_num_ports,
 	.port_probe =		omninet_port_probe,
 	.port_remove =		omninet_port_remove,
@@ -131,10 +136,6 @@ static void omninet_port_remove(struct u
 	kfree(od);
 }
 
-#define OMNINET_HEADERLEN	4
-#define OMNINET_BULKOUTSIZE	64
-#define OMNINET_PAYLOADSIZE	(OMNINET_BULKOUTSIZE - OMNINET_HEADERLEN)
-
 static void omninet_process_read_urb(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;


