Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB50186E47;
	Mon, 12 Aug 2024 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479086; cv=none; b=dTTLOx/FqsQBIHjcURBjkIY7rXPN1R9iNIssmQWm91AGuoLvh0XEOWXXBtEEu2uqrnJLAJ1FGXMOjUNrzGimkWdIMW1JwwqxSMNsWv8nm7S4KfvyKSfS4Ou5fAgmesT23+hFyfW8s2HkzqCK+ogQD8YpYOLWA+ugMu+lCZcWHms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479086; c=relaxed/simple;
	bh=JmDgb7+ZFUDoW6Ltg7bJvTt3SMxUjZ9cizhhwCY1m4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KueLeLL4jdnptAt7GVeBDUtfpfcuGQVykDfusEEJhfBPpW2wqpVy3v3ULnvFZpoucihEPySy4lxkdXzzv8q+w/7FPuXkij6MOdwa7I306H0ax1bhMQNj27w1lwJjnFmW/XVILaFxmKrBKS56V9pl9Nq17SNVazrR49hJV5/RhAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/eMzo7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/eMzo7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84012C32782;
	Mon, 12 Aug 2024 16:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479085;
	bh=JmDgb7+ZFUDoW6Ltg7bJvTt3SMxUjZ9cizhhwCY1m4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/eMzo7GsSEgAmZB2nf8tU0jC9JyaFRYZasM043+pckrRji/g8x4pX1CFlzBPf2S1
	 rHXLinU+shnw6otirB1ivHJ8S8ZYnpX69nV7EBI3b5jBC83SM+lDioNtPW0zVpybhm
	 HZXyCK7+4PREbeVUzEfuHP5z24Td8C82C49PJuiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wulff <crwulff@gmail.com>
Subject: [PATCH 6.1 097/150] usb: gadget: u_audio: Check return codes from usb_ep_enable and config_ep_by_speed.
Date: Mon, 12 Aug 2024 18:02:58 +0200
Message-ID: <20240812160128.905892968@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wulff <crwulff@gmail.com>

commit 76a7bfc445b8e9893c091e24ccfd4f51dfdc0a70 upstream.

These functions can fail if descriptors are malformed, or missing,
for the selected USB speed.

Fixes: eb9fecb9e69b ("usb: gadget: f_uac2: split out audio core")
Fixes: 24f779dac8f3 ("usb: gadget: f_uac2/u_audio: add feedback endpoint support")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Wulff <crwulff@gmail.com>
Link: https://lore.kernel.org/r/20240721192314.3532697-2-crwulff@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_audio.c |   42 +++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 8 deletions(-)

--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -592,16 +592,25 @@ int u_audio_start_capture(struct g_audio
 	struct usb_ep *ep, *ep_fback;
 	struct uac_rtd_params *prm;
 	struct uac_params *params = &audio_dev->params;
-	int req_len, i;
+	int req_len, i, ret;
 
 	prm = &uac->c_prm;
 	dev_dbg(dev, "start capture with rate %d\n", prm->srate);
 	ep = audio_dev->out_ep;
-	config_ep_by_speed(gadget, &audio_dev->func, ep);
+	ret = config_ep_by_speed(gadget, &audio_dev->func, ep);
+	if (ret < 0) {
+		dev_err(dev, "config_ep_by_speed for out_ep failed (%d)\n", ret);
+		return ret;
+	}
+
 	req_len = ep->maxpacket;
 
 	prm->ep_enabled = true;
-	usb_ep_enable(ep);
+	ret = usb_ep_enable(ep);
+	if (ret < 0) {
+		dev_err(dev, "usb_ep_enable failed for out_ep (%d)\n", ret);
+		return ret;
+	}
 
 	for (i = 0; i < params->req_number; i++) {
 		if (!prm->reqs[i]) {
@@ -629,9 +638,18 @@ int u_audio_start_capture(struct g_audio
 		return 0;
 
 	/* Setup feedback endpoint */
-	config_ep_by_speed(gadget, &audio_dev->func, ep_fback);
+	ret = config_ep_by_speed(gadget, &audio_dev->func, ep_fback);
+	if (ret < 0) {
+		dev_err(dev, "config_ep_by_speed in_ep_fback failed (%d)\n", ret);
+		return ret; // TODO: Clean up out_ep
+	}
+
 	prm->fb_ep_enabled = true;
-	usb_ep_enable(ep_fback);
+	ret = usb_ep_enable(ep_fback);
+	if (ret < 0) {
+		dev_err(dev, "usb_ep_enable failed for in_ep_fback (%d)\n", ret);
+		return ret; // TODO: Clean up out_ep
+	}
 	req_len = ep_fback->maxpacket;
 
 	req_fback = usb_ep_alloc_request(ep_fback, GFP_ATOMIC);
@@ -687,13 +705,17 @@ int u_audio_start_playback(struct g_audi
 	struct uac_params *params = &audio_dev->params;
 	unsigned int factor;
 	const struct usb_endpoint_descriptor *ep_desc;
-	int req_len, i;
+	int req_len, i, ret;
 	unsigned int p_pktsize;
 
 	prm = &uac->p_prm;
 	dev_dbg(dev, "start playback with rate %d\n", prm->srate);
 	ep = audio_dev->in_ep;
-	config_ep_by_speed(gadget, &audio_dev->func, ep);
+	ret = config_ep_by_speed(gadget, &audio_dev->func, ep);
+	if (ret < 0) {
+		dev_err(dev, "config_ep_by_speed for in_ep failed (%d)\n", ret);
+		return ret;
+	}
 
 	ep_desc = ep->desc;
 	/*
@@ -720,7 +742,11 @@ int u_audio_start_playback(struct g_audi
 	uac->p_residue_mil = 0;
 
 	prm->ep_enabled = true;
-	usb_ep_enable(ep);
+	ret = usb_ep_enable(ep);
+	if (ret < 0) {
+		dev_err(dev, "usb_ep_enable failed for in_ep (%d)\n", ret);
+		return ret;
+	}
 
 	for (i = 0; i < params->req_number; i++) {
 		if (!prm->reqs[i]) {


