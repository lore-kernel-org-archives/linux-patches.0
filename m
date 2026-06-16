Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55854657F8;
	Tue, 16 Jun 2026 16:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629017; cv=none; b=GwGzhXacEwOQob+lPhd4mzi6NnGFS+ak9uJRwP0ED9oKY6rWoUu1/QERRe9Yzec8sxPA/QJ0GVdpR1s45dYb227LEgYiZGWOU5eYZ4DYqn1k4BouvFufwo4qwGqbaokmT7UvnP57mDBFcQKOajTdJCPDHl5yf56gmIFJ0NZXWDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629017; c=relaxed/simple;
	bh=u9zICj3MmrHbSDJPyPIFYZ8eVTc5u9byZAobT+ztaWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzG8xBFqBBjwbweMxQm53XG0UX9G7VR9OqhdIoH2MRYDziIxGhiFStb7P1QJOkILj/vGG8SzD0ZyJTiDfLs73fJNpSNtb8ChB3GduexzKavGtmTE+doMuVRypqpr+C04kT4pJgXEh3+RMxrYDZpE9hwXtM9D0Q3/MYDWMld9lbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRH+n8TV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRH+n8TV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C29C1F000E9;
	Tue, 16 Jun 2026 16:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629016;
	bh=eoQJ/THWWjx5d9pnvoW9L/DzKmflTfG3yjC7ejpi04k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRH+n8TV2V4R430D/D21qk/fnvaExErExgDiPuy3Uqqk7BjIiDFCYHsltLE91H9nV
	 9zH1zfvDnX883Ek7whzEtqcVxNgnz9kAbfpOvfqDhPXTtvA2BZ4OXbH799Trx3AXxQ
	 zqynrA1Lxn8PoSuBmu23qAcQHzVvKQb2H5kYjDOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 205/452] USB: serial: mct_u232: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:27:12 +0530
Message-ID: <20260616145128.580278902@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 915b36d701950503c4ea0f6e314b10868e59fce3 upstream.

The driver overrides the maximum transfer size for a specific device
which only accepts 16 byte packets for its 32 byte bulk-out endpoint.

Make sure to never increase the maximum transfer size to prevent slab
corruption should a malicious device report a smaller endpoint max
packet size than expected.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/mct_u232.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index 6c2c4a597fb146..be63f5f3740477 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -379,6 +379,7 @@ static int mct_u232_port_probe(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv;
+	u16 pid;
 
 	/* check first to simplify error handling */
 	if (!serial->port[1] || !serial->port[1]->interrupt_in_urb) {
@@ -386,6 +387,16 @@ static int mct_u232_port_probe(struct usb_serial_port *port)
 		return -ENODEV;
 	}
 
+	/*
+	 * Compensate for a hardware bug: although the Sitecom U232-P25
+	 * device reports a maximum output packet size of 32 bytes,
+	 * it seems to be able to accept only 16 bytes (and that's what
+	 * SniffUSB says too...)
+	 */
+	pid = le16_to_cpu(serial->dev->descriptor.idProduct);
+	if (pid == MCT_U232_SITECOM_PID)
+		port->bulk_out_size = min(16, port->bulk_out_size);
+
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
@@ -411,7 +422,6 @@ static void mct_u232_port_remove(struct usb_serial_port *port)
 
 static int  mct_u232_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 	int retval = 0;
 	unsigned int control_state;
@@ -419,15 +429,6 @@ static int  mct_u232_open(struct tty_struct *tty, struct usb_serial_port *port)
 	unsigned char last_lcr;
 	unsigned char last_msr;
 
-	/* Compensate for a hardware bug: although the Sitecom U232-P25
-	 * device reports a maximum output packet size of 32 bytes,
-	 * it seems to be able to accept only 16 bytes (and that's what
-	 * SniffUSB says too...)
-	 */
-	if (le16_to_cpu(serial->dev->descriptor.idProduct)
-						== MCT_U232_SITECOM_PID)
-		port->bulk_out_size = 16;
-
 	/* Do a defined restart: the normal serial device seems to
 	 * always turn on DTR and RTS here, so do the same. I'm not
 	 * sure if this is really necessary. But it should not harm
-- 
2.53.0



