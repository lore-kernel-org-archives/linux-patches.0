Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0295D2AF1D;
	Fri,  9 Oct 2026 14:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556151; cv=none; b=Sx7rz1ORML+RqHvuJs9tYwnac2nOIvHfNORAcnBz4L17KBY8fEcsQGditByUxxwFVY6qzIuUn2nCF7fbSgbE5P/riHFXkF3J6mx5YKxWZH1C6AbH08gvogaKGJKQ2+xZLEGvghOVV9IFxadX/GQoLRlsjdPrVcWMSHhO74rc9Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556151; c=relaxed/simple;
	bh=Mf4muBAD6tVioQK3t/m6H7yArqcyEB9uS8Wj8v7yQEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViTw3ny0MIeI9Zu4b/n0KgIwtreDqEQGr4bu8p3jjhXa2X8SQ4jsVWyfiBjZUTQENfJjsF5sliMNQaZ3LK6iLONQmpYRrnKmN0WIVVfw9p2WZ5zlHGCIbbyzeBNownidzyUBZnlADZia1YmminrZGVnb7iNk4hz67q2iOZ40y6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHMHc2Rx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHMHc2Rx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9A31F000FF;
	Fri,  9 Oct 2026 14:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556149;
	bh=fZ/5Q/W6IKy7Rn2PYkctWkMnn7Hm2eltiJNkkGXHqyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fHMHc2RxbZWWDbzjBwHGse/FT21NIxIp7yXNCKYy5lJfmaYCX7PTBH6Cmq47/IK3e
	 Xm04LgozLwil+P/E4fsO2b2Ti1RRrqcA5l/4J8/Jj6kIqP13PkkR0TOEWabW+xzzmr
	 6/ptfQ2wbNrzYK3OIcksBjApm7fq1UDZ7gR2wIdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marian Rotariu <marian.c.rotariu@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 182/403] usb: typec: tipd: dont send GAID when probe fails in APP mode
Date: Fri,  9 Oct 2026 16:09:03 +0200
Message-ID: <20261009140956.376158451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marian Rotariu <marian.c.rotariu@gmail.com>

commit c5df31f10880737d13b75eff42faee7accb9f956 upstream.

When probe fails after the chip was already in APP mode (booted from
EEPROM), the err_reset_controller path unconditionally calls
tps->data->reset(), which for tps25750 sends the GAID 4CC command.
GAID transitions the chip from APP back to PTCH, causing a second
probe attempt that sees PTCH mode and tries to load the firmware from
/lib/firmware, instead of reading the EEPROM as it should.

The err_reset_controller path can be triggered by -EPROBE_DEFER from
the probe sequence. GAID should only be sent when the controller
actually loaded firmware at probe time.

The abnormal behavior was seen on a tps25751d that has an EEPROM
connected to it.

Fixes: d49f90822015 ("usb: typec: tipd: add init and reset functions to tipd_data")
Cc: stable <stable@kernel.org>
Signed-off-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260806085302.1307606-1-marian.c.rotariu@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -1745,6 +1745,7 @@ static int tps6598x_probe(struct i2c_cli
 	const struct tipd_data *data;
 	struct tps6598x *tps;
 	struct fwnode_handle *fwnode;
+	bool patch_loaded = false;
 	u32 status;
 	u32 vid;
 	int ret;
@@ -1797,6 +1798,7 @@ static int tps6598x_probe(struct i2c_cli
 		return ret;
 
 	if (ret == TPS_MODE_PTCH) {
+		patch_loaded = true;
 		ret = tps->data->init(tps);
 		if (ret)
 			return ret;
@@ -1885,7 +1887,8 @@ err_clear_mask:
 	tps6598x_write64(tps, TPS_REG_INT_MASK1, 0);
 err_reset_controller:
 	/* Reset PD controller to remove any applied patch */
-	tps->data->reset(tps);
+	if (patch_loaded)
+		tps->data->reset(tps);
 
 	return ret;
 }


