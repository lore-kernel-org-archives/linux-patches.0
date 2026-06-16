Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385263D8100;
	Tue, 16 Jun 2026 18:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635805; cv=none; b=LWcAVLursfDufBVRR3UL4Zns3/tYktPfwm9vq9xs27QbPxDjkPUtIk9x56wUb8eZWW5eTeVezlgA4D7V5f1AmDsT0JP/khCf880QOM2wE4UGfsh8q5tSNyFOlaljYHd9/RX20MITUYQKVoJEQTGqp6IOHsGSSLCFFWmKJ84b1mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635805; c=relaxed/simple;
	bh=vReoA5u3XtukyAWFlofN7nk25J6iDc4W7yJ5eKMN0p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEAgRpBq4tGT5Aq505VpAhQaCPm44rkMUFSun6ME9aZYNXtEsJz78+H/5MEukPM7/fyV7YsEsNtCgMWSg754MBmtfjDTFYguAa6XVfJKIH9N3IffUBzfEOkn5YeQwELRhLfhz+MCLmE0zY8OKG/FY7Kh2Kt4KQMgVh2s10pSW10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFgKc017; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFgKc017"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0111F000E9;
	Tue, 16 Jun 2026 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635804;
	bh=VkDStdSYyV3FPlSpKcLjQEZtjYeQoViBmKY41IaVFHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pFgKc017uriw6OoFXj9PFwmJtfNYXmsji0uXhku1biXg9TvQK1fs4nT9evJEhIa0d
	 91VlEu8c6Zuwo+/QlHwgD5+GZyartrKjSqhwWh7mmtVwzF/voLIztU4K10B8FUgCd1
	 8zXbzUbV3B/C6DvMTojM9D5C3x7TDW037wV8lvEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/342] USB: serial: digi_acceleport: fix memory corruption with small endpoints
Date: Tue, 16 Jun 2026 20:26:53 +0530
Message-ID: <20260616145053.664616371@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit cb3560e8eab1dfa1cac1ed52631adf8ec6ff2cd5 upstream.

Add the missing bulk-out buffer size sanity checks to avoid
out-of-bounds memory accesses or slab corruption should a malicious
device report smaller buffers than expected.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/digi_acceleport.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 0d606fa9fdca1a..d03bba38d802d2 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -1229,15 +1229,34 @@ static int digi_port_init(struct usb_serial_port *port, unsigned port_num)
 static int digi_startup(struct usb_serial *serial)
 {
 	struct digi_serial *serial_priv;
+	int oob_port_num;
 	int ret;
+	int i;
+
+	/*
+	 * The port bulk-out buffers must be large enough for header and
+	 * buffered data.
+	 */
+	for (i = 0; i < serial->type->num_ports; i++) {
+		if (serial->port[i]->bulk_out_size < DIGI_OUT_BUF_SIZE + 2)
+			return -EINVAL;
+	}
+
+	/*
+	 * The OOB port bulk-out buffer must be large enough for the two
+	 * commands in digi_set_modem_signals().
+	 */
+	oob_port_num = serial->type->num_ports;
+	if (serial->port[oob_port_num]->bulk_out_size < 8)
+		return -EINVAL;
 
 	serial_priv = kzalloc(sizeof(*serial_priv), GFP_KERNEL);
 	if (!serial_priv)
 		return -ENOMEM;
 
 	spin_lock_init(&serial_priv->ds_serial_lock);
-	serial_priv->ds_oob_port_num = serial->type->num_ports;
-	serial_priv->ds_oob_port = serial->port[serial_priv->ds_oob_port_num];
+	serial_priv->ds_oob_port_num = oob_port_num;
+	serial_priv->ds_oob_port = serial->port[oob_port_num];
 
 	ret = digi_port_init(serial_priv->ds_oob_port,
 						serial_priv->ds_oob_port_num);
-- 
2.53.0



