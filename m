Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382EB2AE94;
	Thu, 23 May 2024 13:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470286; cv=none; b=jTco4V30pC5DY3kcGFth1erb70yZEvMQu1Bk2XoboGkBzED81MkWVg/vy0NeNzWcRbjX8OtKtF3kcul0EzshFVlNZu2wIyu0I6fZyOrv1Pn74XDUBQ2IBluY0bwCdpNNLuFpWEvs3SEEMoS1cYcW1LpAz8bPsUGzSby7fhpaPP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470286; c=relaxed/simple;
	bh=j502eUQRyRQ0rmk0zHZYhHd61TEqrO+miE+N3yBgp/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQuGzmuPkJy47TLlONKlahHpfEqc8Co3tHqam1BWD5yqFsPaAV12TjjmT5yXZn/hKF+uNWFv7Pe5eNFcRlBS7B3r5lJIzvWrpBQ7aIZBDacI6OqMBDX8kBqh4dlwlFd5U2nCMLlPXoQ47FKjzpyz3zetraSpi0Nk/TzTbzaA9XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYpS3zon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYpS3zon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DACC2BD10;
	Thu, 23 May 2024 13:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470285;
	bh=j502eUQRyRQ0rmk0zHZYhHd61TEqrO+miE+N3yBgp/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYpS3zonHE88My8V+t33OY2BMWxQ2tj0OxZsmobpg4MC6kFCbP5/8F+Pg/qZWXJPR
	 9hhnCV+Tg5OF1HF0LROto/l/d72BxoQPt8qU+vn1MTfXZIihM/rnkqDLMd8ztVl9Fj
	 gMFyXv3D+lB4GWAuM/fsHwgfLnjLubQv1VjVUFg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Javier Carrasco <javier.carrasco@wolfvision.net>
Subject: [PATCH 6.9 14/25] usb: typec: tipd: fix event checking for tps25750
Date: Thu, 23 May 2024 15:12:59 +0200
Message-ID: <20240523130330.927059534@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco@wolfvision.net>

commit d64adb0f41e62f91fcfdf0e0d9d5bfa714db0d23 upstream.

In its current form, the interrupt service routine of the tps25750
checks the event flags in the lowest 64 bits of the interrupt event
register (event[0]), but also in the upper part (event[1]).

Given that all flags are defined as BIT() or BIT_ULL(), they are
restricted to the first 64 bits of the INT_EVENT1 register. Including
the upper part of the register can lead to false positives e.g. if the
event 64 bits above the one being checked is set, but the one being
checked is not.

Restrict the flag checking to the first 64 bits of the INT_EVENT1
register.

Fixes: 7e7a3c815d22 ("USB: typec: tps6598x: Add TPS25750 support")
Cc: stable@vger.kernel.org
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Javier Carrasco <javier.carrasco@wolfvision.net>
Link: https://lore.kernel.org/r/20240429-tps6598x_fix_event_handling-v3-1-4e8e58dce489@wolfvision.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -604,11 +604,11 @@ static irqreturn_t tps25750_interrupt(in
 	if (!tps6598x_read_status(tps, &status))
 		goto err_clear_ints;
 
-	if ((event[0] | event[1]) & TPS_REG_INT_POWER_STATUS_UPDATE)
+	if (event[0] & TPS_REG_INT_POWER_STATUS_UPDATE)
 		if (!tps6598x_read_power_status(tps))
 			goto err_clear_ints;
 
-	if ((event[0] | event[1]) & TPS_REG_INT_DATA_STATUS_UPDATE)
+	if (event[0] & TPS_REG_INT_DATA_STATUS_UPDATE)
 		if (!tps6598x_read_data_status(tps))
 			goto err_clear_ints;
 
@@ -617,7 +617,7 @@ static irqreturn_t tps25750_interrupt(in
 	 * a plug event. Therefore, we need to check
 	 * for pr/dr status change to set TypeC dr/pr accordingly.
 	 */
-	if ((event[0] | event[1]) & TPS_REG_INT_PLUG_EVENT ||
+	if (event[0] & TPS_REG_INT_PLUG_EVENT ||
 	    tps6598x_has_role_changed(tps, status))
 		tps6598x_handle_plug_event(tps, status);
 


