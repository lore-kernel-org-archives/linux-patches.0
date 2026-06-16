Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EA635292A;
	Tue, 16 Jun 2026 18:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633783; cv=none; b=XILOUV1jcAmhjNBlHufr12gVO+z5pvZw4dh9ls4vOQCkN6KYNHjowjB5Tb4N958xQiQLIqnDtkKWa6aSLOY9UV5p3PSi5Hc4k0ok6MZE5XFaXhhYK1MNgjSBQcTHqRIDrLSXvWheXarYI1CXkK0YxUwmLtfYEVEu5ICmrx0uBas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633783; c=relaxed/simple;
	bh=p7v3EOuaUtZ7nXQJ3SNKvOeX1xwGPi8vGlRX16Muc2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYCdgnpHcmT1s9Pz8TWlSO9JR5iF919YKQH2o6jTorLBuhNhkeF2ckGM9d+8dlbfLU5Uua2UWCRSUWxFPxAJEoC/FaPzghQUGEuvcs1EA7i4Axyy0T2QxWwf/vhf4Y4gGnR7mCYU+OHnp136zLS9GJZCsx+8CXIVaOJsaLpRwVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJon+/Ol; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJon+/Ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BE81F000E9;
	Tue, 16 Jun 2026 18:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633782;
	bh=z+yCIcs11LaKCyey8o4e5b/pBz9Hbu9PrtUVmfZJReY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJon+/Oln3AFjRaAOuKX4jn2aiTgBXSBglw9blpVJb90pZ43zBvLTolxi4Uq2yAgB
	 PslKuybY74vI2cJZZ68aVnk2dev334q6j2zFLJD+jPH6WAj/RPLz50Osgm/aAWC/PF
	 JN3UeHgdqlyZRbz9P5mOYyLAjbWffGuxQ29tsfQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/411] USB: serial: mct_u232: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:26:22 +0530
Message-ID: <20260616145108.035901826@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5070e6d5cfd9eb..a359669df3dfff 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -378,6 +378,7 @@ static int mct_u232_port_probe(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv;
+	u16 pid;
 
 	/* check first to simplify error handling */
 	if (!serial->port[1] || !serial->port[1]->interrupt_in_urb) {
@@ -385,6 +386,16 @@ static int mct_u232_port_probe(struct usb_serial_port *port)
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
@@ -410,7 +421,6 @@ static void mct_u232_port_remove(struct usb_serial_port *port)
 
 static int  mct_u232_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 	int retval = 0;
 	unsigned int control_state;
@@ -418,15 +428,6 @@ static int  mct_u232_open(struct tty_struct *tty, struct usb_serial_port *port)
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



