Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24CF30DD1D;
	Mon, 13 Oct 2025 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367394; cv=none; b=Y9BeqdCAari6/Dg4/Ky+1SKAO92SLxtDyHcos5pU58bqTUqSG45QoAyfzeUPiHWoiXkg89zjTZ/kGOoXZXxpdqJC9QLwKB2FpdSXazcGLzZgxRKdSddV4Bgbkl1wKVLmEtTPZupyq4oID/WHc75xkoFlJV3xRdt8emgiZ87XlTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367394; c=relaxed/simple;
	bh=2PrLHXKLAAK9GvgEdBu7jYd/NHUNZqlOKM+ftSObTzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/k98yJvxeGi7O5Qu0K/UNYGARHRz+O4luCaNdwt3Ge0Vb5IH5GsTy0I7S6OG+Zo+hDWaw51GeKT4hQr8MMqwo8GCSBkxAhvXHUmQh9DjuBscVFM5X+p0YrC6uaLKWRwfMjUtnG0aZESGav/0K9dgEllMu40zLVcU0cuCPlFTBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/HuwrKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/HuwrKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D36AC4CEE7;
	Mon, 13 Oct 2025 14:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367394;
	bh=2PrLHXKLAAK9GvgEdBu7jYd/NHUNZqlOKM+ftSObTzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/HuwrKrNJjk0oKvLR3yl4I2+lOL/OLxcRo3CMCXO9RFDqGaEE2eUrte4Mi+AQwaX
	 V3SavieyXr6vPydw2CGzVN7ulBcjn6UkzqpIb1ahcqz9/gcX0pVX2ZC5BWfuuacbje
	 rfph3MXQXImXsknbc/C8FaxzS+D/esUEBwPRVtlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neal Gompa <neal@gompa.dev>,
	Sven Peter <sven@kernel.org>
Subject: [PATCH 6.1 192/196] usb: typec: tipd: Clear interrupts first
Date: Mon, 13 Oct 2025 16:46:05 +0200
Message-ID: <20251013144321.636338904@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

From: Sven Peter <sven@kernel.org>

commit be5ae730ffa6fd774a00a4705c1e11e078b08ca1 upstream.

Right now the interrupt handler first reads all updated status registers
and only then clears the interrupts. It's possible that a duplicate
interrupt for a changed register or plug state comes in after the
interrupts have been processed but before they have been cleared:

* plug is inserted, TPS_REG_INT_PLUG_EVENT is set
* TPS_REG_INT_EVENT1 is read
* tps6598x_handle_plug_event() has run and registered the plug
* plug is removed again, TPS_REG_INT_PLUG_EVENT is set (again)
* TPS_REG_INT_CLEAR1 is written, TPS_REG_INT_PLUG_EVENT is cleared

We then have no plug connected and no pending interrupt but the tipd
core still thinks there is a plug. It's possible to trigger this with
e.g. a slightly broken Type-C to USB A converter.

Fix this by first clearing the interrupts and only then reading the
updated registers.

Fixes: 45188f27b3d0 ("usb: typec: tipd: Add support for Apple CD321X")
Fixes: 0a4c005bd171 ("usb: typec: driver for TI TPS6598x USB Power Delivery controllers")
Cc: stable@kernel.org
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Sven Peter <sven@kernel.org>
Link: https://lore.kernel.org/r/20250914-apple-usb3-tipd-v1-1-4e99c8649024@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -491,24 +491,23 @@ static irqreturn_t cd321x_interrupt(int
 	if (!event)
 		goto err_unlock;
 
+	tps6598x_write64(tps, TPS_REG_INT_CLEAR1, event);
+
 	if (!tps6598x_read_status(tps, &status))
-		goto err_clear_ints;
+		goto err_unlock;
 
 	if (event & APPLE_CD_REG_INT_POWER_STATUS_UPDATE)
 		if (!tps6598x_read_power_status(tps))
-			goto err_clear_ints;
+			goto err_unlock;
 
 	if (event & APPLE_CD_REG_INT_DATA_STATUS_UPDATE)
 		if (!tps6598x_read_data_status(tps))
-			goto err_clear_ints;
+			goto err_unlock;
 
 	/* Handle plug insert or removal */
 	if (event & APPLE_CD_REG_INT_PLUG_EVENT)
 		tps6598x_handle_plug_event(tps, status);
 
-err_clear_ints:
-	tps6598x_write64(tps, TPS_REG_INT_CLEAR1, event);
-
 err_unlock:
 	mutex_unlock(&tps->lock);
 
@@ -555,25 +554,24 @@ static irqreturn_t tps6598x_interrupt(in
 	if (!(event1[0] | event1[1] | event2[0] | event2[1]))
 		goto err_unlock;
 
+	tps6598x_block_write(tps, TPS_REG_INT_CLEAR1, event1, intev_len);
+	tps6598x_block_write(tps, TPS_REG_INT_CLEAR2, event2, intev_len);
+
 	if (!tps6598x_read_status(tps, &status))
-		goto err_clear_ints;
+		goto err_unlock;
 
 	if ((event1[0] | event2[0]) & TPS_REG_INT_POWER_STATUS_UPDATE)
 		if (!tps6598x_read_power_status(tps))
-			goto err_clear_ints;
+			goto err_unlock;
 
 	if ((event1[0] | event2[0]) & TPS_REG_INT_DATA_STATUS_UPDATE)
 		if (!tps6598x_read_data_status(tps))
-			goto err_clear_ints;
+			goto err_unlock;
 
 	/* Handle plug insert or removal */
 	if ((event1[0] | event2[0]) & TPS_REG_INT_PLUG_EVENT)
 		tps6598x_handle_plug_event(tps, status);
 
-err_clear_ints:
-	tps6598x_block_write(tps, TPS_REG_INT_CLEAR1, event1, intev_len);
-	tps6598x_block_write(tps, TPS_REG_INT_CLEAR2, event2, intev_len);
-
 err_unlock:
 	mutex_unlock(&tps->lock);
 


