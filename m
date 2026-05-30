Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E56B2E7379;
	Sat, 30 May 2026 17:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162283; cv=none; b=c2VWmXHebIcFxD/AsdLLXRmvj8WKwDNIP8+8pX7A/ffI8JniiieFmRKRrtHRQxECcBEr/ei5DLzx6AIXpgYQAZfpErdbCpS4fGojhzLMCuZMURic6MjaTRthMdlb5JDZRhPT1zFK4jGQ53/ExfHjROQ1Sqy9B5rqoZYPnlKqQs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162283; c=relaxed/simple;
	bh=YsleyhcKVJ3kE80JIp6VBq4wPkA3vlytittg72D6FGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaU7AMKfda3+OGe0On3VXJvT0/KsnHy+5oFB3uPNfi8dBmA6HgPSb2pFhW0A7F4cCMNWb8rLNHMyqNV0geWAEY+Ud2keFZ1SwlaMV9dXIWpbb5H2E5PUo4ssHM+gU6zZVRVviSCaMcYUZD0En16wUaqg9WHhMC4i+YOe/Y2m9sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhHRLIpY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhHRLIpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D941F00893;
	Sat, 30 May 2026 17:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162282;
	bh=UKI0GcAOQOkk3qNHQJyey01tOARsk7AODGsOoLxZVA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jhHRLIpYDrRfLjWi9GSXiOknizdMrcBubTw4dUogYAepe0RtVuMTwmDEAHMbnAsl9
	 vM2H95l0jlOE1Halj1KOeVnhcsxjrs0tl4OofITDdLQvG5ee9WQKkelq3Y6P4pcctc
	 isEWXmGWWjoLrUMZIngDgdvO5HYjznwffTzc16w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Ian Ray <ian.ray@gehealthcare.com>
Subject: [PATCH 6.1 876/969] drm/bridge: megachips: remove bridge when irq request fails
Date: Sat, 30 May 2026 18:06:40 +0200
Message-ID: <20260530160324.876304422@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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


