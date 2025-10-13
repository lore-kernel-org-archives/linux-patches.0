Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D627277CB8;
	Mon, 13 Oct 2025 15:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367968; cv=none; b=BZo6lNVAPf5hH/gqTbfS1dsH1VewaVORqO6JKmxMbQICeHust2kU3VaaOJNvvjczfCMQd+trkR2Eq0GHG5l/fvrB7yydI2CcYR7Fx9NQx5WxL7XcHPmtc08VbNPj2cTCgMrF70MuIiVzrwIty8z3YFV1BM+BXG17ee/Rrorrhdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367968; c=relaxed/simple;
	bh=+rbnb3fNZo4A+dQk2O9tQjIkQgAgqtkOxwPs2QgSHWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7jdgMCsMpA5YM2FEcL0BoI3DxDhb5oGVY2Di2nRlCizbnfq9+EHHHEptIm3FFFunIbR64/w9ZG1XM9b7pI3WrrmPfmn492TTuJdKeyRBZffcDBj9aiPm3J+KvIAu6AN/wviHrMZHo70EkrSjqSd/ejNTSixZnW+137CBaLaa0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mh8C1I5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mh8C1I5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2092DC4CEE7;
	Mon, 13 Oct 2025 15:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367966;
	bh=+rbnb3fNZo4A+dQk2O9tQjIkQgAgqtkOxwPs2QgSHWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mh8C1I5z0/e87hqKPeHNAaCYDQ52iFAfU/K3UflZ2qlhi/by8GrV3qqeIrAQIOaoR
	 PRS31/3aO+gA42BaxHyfYYSDLdYz7sdZJnaV0U2Z+5MnZjK/zPllNpnhaNEdWQHRqJ
	 McTYO6k/zreTQxaIhqQiBHfX+AlrAMkrnM84gLt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neal Gompa <neal@gompa.dev>,
	Sven Peter <sven@kernel.org>
Subject: [PATCH 6.6 194/196] usb: typec: tipd: Clear interrupts first
Date: Mon, 13 Oct 2025 16:46:25 +0200
Message-ID: <20251013144322.322339241@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
@@ -488,24 +488,23 @@ static irqreturn_t cd321x_interrupt(int
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
 
@@ -552,25 +551,24 @@ static irqreturn_t tps6598x_interrupt(in
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
 


