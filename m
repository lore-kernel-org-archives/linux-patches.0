Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10451D545;
	Thu, 23 May 2024 13:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470504; cv=none; b=PVCnrVpO6HX1Oxzy1E6veN4O16ZlnlayUvb8FI0aaL1+OoZUsErtmcHWp9BmQ31joj1gO2VEcz1GLpQByps7TXZOcfJlnyL7tIlTZqxTXqrLxjR18+wdSJsS6w7oFCEIE1bX2Gu1aMdn77Ru1OpY/RQXB49dRwEaE1T2TSF8ls4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470504; c=relaxed/simple;
	bh=KnH4jX7S63BImvOfw9Kq+W4TVOokds9geFhQ6FWRTPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m629dt1IXG0TgcrcuFOPFcW73QUaTHlHmVDmzQ8yxC3+Xx1CHLdxWpSEvkVw00pv9HpuqYuyZPDr/EJ7EA0sJc/CC6jjCR3EFcs3K7tcvylJDXNIuIC89kPCx7IqTZJyL9tFXnRfRnUF8z7mBZe01quiSEvhG1cVHKbh/ImFSjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKGSqV4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKGSqV4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F84C3277B;
	Thu, 23 May 2024 13:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470503;
	bh=KnH4jX7S63BImvOfw9Kq+W4TVOokds9geFhQ6FWRTPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKGSqV4LM4qOsM30P2BgL4zPaVjAT/itkooF8naGQmcALncP1Rezij401EpV913iJ
	 1E70jPo9gVVJomTrEzXI8Ao2H3nMKJ7azTH8SiMuwed+kh0qfXD81DhEx2T2KWiqGu
	 iXORDCdY5f8Hn/6YPK2E5hyfZgszM5rF+maw/ZHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Javier Carrasco <javier.carrasco@wolfvision.net>
Subject: [PATCH 6.8 14/23] usb: typec: tipd: fix event checking for tps25750
Date: Thu, 23 May 2024 15:13:41 +0200
Message-ID: <20240523130330.290345589@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
References: <20240523130329.745905823@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 


