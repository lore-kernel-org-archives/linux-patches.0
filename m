Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75F9137750;
	Sat, 30 May 2026 18:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167046; cv=none; b=UsvX1X8STCmgMbmllXHghkCWxUiaVhp2sTWvkStV+ERq3JF9yHdb6v53hPi0DXhIRa2fGyDSAkmFxKOtaM6HoHY8MjYZPODnS6jHJcu/IPqDNbU8jkS6h80BFI7/j4VLArWUyL3cL5SqN0v0lI6iL0Bi4DASFAqqCyCOG8gBOt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167046; c=relaxed/simple;
	bh=NYsMaFVPCVA9GypOU/j9yGajSTYxW0oMXwHiumt6Zv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1HmfxcHgxo6zy8ghjr23x6SIqXMC8PRpzT6aZYiJeP8KCoPaNH/d/ORf1C7wYElFJn91pT00LbMRNE6R1plQRG9Gu36vHMwtLVUTg4pgJ1kJbpKu+NdpyCV4cEIRsoegYhGPwLY316Q+LwUpjK3KPV7H44mEiTkpepb2d/8DJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aa6AZuV1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aa6AZuV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDE21F00893;
	Sat, 30 May 2026 18:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167044;
	bh=GuAm+Pvnmxm/o5G0im2vC9gj/QpwrS7NdrI+zcY2jm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aa6AZuV170UGBb8wXU4TVJoQRxYTgHLmeOvggnrCq+XcZTlVM/r0IzVI/L9XjPJgk
	 1YyYU+/vuQCbRLxtdKa/RgR+TqN1QOd3qmJWiWdiumoceGmrYex4LM0x+jn6bEVm3g
	 GyL6x7XF1F3W01mXHd7lZDEX14zKm93VzgqAiz1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Ian Ray <ian.ray@gehealthcare.com>
Subject: [PATCH 5.10 548/589] drm/bridge: megachips: remove bridge when irq request fails
Date: Sat, 30 May 2026 18:07:09 +0200
Message-ID: <20260530160239.074207123@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit d45d5c819f2cd0b6b5d76a194a537a5f4aeefecb upstream.

If devm_request_threaded_irq() fails after drm_bridge_add(), remove the
bridge before returning.

Keep drm_bridge_add() rather than devm_drm_bridge_add(): registration is
tied to the STDP4028 device while ge_b850v3_register() may complete from
either I2C probe; devm would not unwind the bridge if the other client's
probe fails.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Fixes: fcfa0ddc18ed ("drm/bridge: Drivers for megachips-stdpxxxx-ge-b850v3-fw (LVDS-DP++)")
Cc: stable@vger.kernel.org
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Tested-by: Ian Ray <ian.ray@gehealthcare.com>
Link: https://patch.msgid.link/20260430195700.80317-1-osama.abdelkader@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c |   16 +++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -302,7 +302,6 @@ static void ge_b850v3_lvds_remove(void)
 		goto out;
 
 	drm_bridge_remove(&ge_b850v3_lvds_ptr->bridge);
-
 	ge_b850v3_lvds_ptr = NULL;
 out:
 	mutex_unlock(&ge_b850v3_lvds_dev_mutex);
@@ -312,6 +311,7 @@ static int ge_b850v3_register(void)
 {
 	struct i2c_client *stdp4028_i2c = ge_b850v3_lvds_ptr->stdp4028_i2c;
 	struct device *dev = &stdp4028_i2c->dev;
+	int ret;
 
 	/* drm bridge initialization */
 	ge_b850v3_lvds_ptr->bridge.funcs = &ge_b850v3_lvds_funcs;
@@ -329,11 +329,15 @@ static int ge_b850v3_register(void)
 	if (!stdp4028_i2c->irq)
 		return 0;
 
-	return devm_request_threaded_irq(&stdp4028_i2c->dev,
-			stdp4028_i2c->irq, NULL,
-			ge_b850v3_lvds_irq_handler,
-			IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
-			"ge-b850v3-lvds-dp", ge_b850v3_lvds_ptr);
+	ret = devm_request_threaded_irq(&stdp4028_i2c->dev,
+					stdp4028_i2c->irq, NULL,
+					ge_b850v3_lvds_irq_handler,
+					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					"ge-b850v3-lvds-dp", ge_b850v3_lvds_ptr);
+	if (ret)
+		drm_bridge_remove(&ge_b850v3_lvds_ptr->bridge);
+
+	return ret;
 }
 
 static int stdp4028_ge_b850v3_fw_probe(struct i2c_client *stdp4028_i2c,


