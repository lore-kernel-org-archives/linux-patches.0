Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0002E1A705B;
	Thu, 15 Aug 2024 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730671; cv=none; b=hLuWXJ2sXaaqvbANAnlh5QyKsmobHkyVw7zBUUAnM8VmMLKhvj0Xssg/PvgO9RE6V9GnVs8Z+TBi3qhT8fmrCjpLx2N0GlAeWiLfoALtB2GXQKjyLR/p4YpMpcZrZP3po3jmHialJyFnF2SMmWOigT0w7e54EsZqVFvK64PxQZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730671; c=relaxed/simple;
	bh=fIkNjniE7my9/YWQapxFJo80R+jgKR5ebwOPWa3nAeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XK+0wEOoySeJIxaIuwYWAWjFy7UaIIDX9rfq3j9MDZc5MZzIvDLF8z1Ibe5fdoWSa2FV2C9FELHghPFg8ZtPdVu/YYB7pOP+zHp2qbwU0R6LY8qGqpnJmm1MGW6nHKsqUnkEDqKuuYDvTg3qB55PDmlOyEa40mS4dgxtst1WrEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYts9ZnO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYts9ZnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5DFC32786;
	Thu, 15 Aug 2024 14:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730670;
	bh=fIkNjniE7my9/YWQapxFJo80R+jgKR5ebwOPWa3nAeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYts9ZnOS85f6zkLTo4vkPsN+H74z0nAI0qz35U6sENKITaMx6mFJu2UiRbbTwQj2
	 kyTNfRnN9I05ARyPLPRuo4BsiKWVOsE+TP3z6qJnPqxPA+S4VrkzxbTU5igkPIQ1mq
	 xf3DSFoDU7Rwlqtn3ajaSdECS213iraT5zNt5ST8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wulff <crwulff@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 481/484] usb: gadget: u_audio: Check return codes from usb_ep_enable and config_ep_by_speed.
Date: Thu, 15 Aug 2024 15:25:39 +0200
Message-ID: <20240815132000.063951462@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wulff <crwulff@gmail.com>

[ Upstream commit 76a7bfc445b8e9893c091e24ccfd4f51dfdc0a70 ]

These functions can fail if descriptors are malformed, or missing,
for the selected USB speed.

Fixes: eb9fecb9e69b ("usb: gadget: f_uac2: split out audio core")
Fixes: 24f779dac8f3 ("usb: gadget: f_uac2/u_audio: add feedback endpoint support")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Wulff <crwulff@gmail.com>
Link: https://lore.kernel.org/r/20240721192314.3532697-2-crwulff@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_audio.c | 42 ++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index 5e34a7ff1b63d..6bd908c7bfe63 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -474,15 +474,24 @@ int u_audio_start_capture(struct g_audio *audio_dev)
 	struct usb_ep *ep, *ep_fback;
 	struct uac_rtd_params *prm;
 	struct uac_params *params = &audio_dev->params;
-	int req_len, i;
+	int req_len, i, ret;
 
 	ep = audio_dev->out_ep;
 	prm = &uac->c_prm;
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
@@ -508,9 +517,18 @@ int u_audio_start_capture(struct g_audio *audio_dev)
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
@@ -565,11 +583,15 @@ int u_audio_start_playback(struct g_audio *audio_dev)
 	struct uac_params *params = &audio_dev->params;
 	unsigned int factor;
 	const struct usb_endpoint_descriptor *ep_desc;
-	int req_len, i;
+	int req_len, i, ret;
 
 	ep = audio_dev->in_ep;
 	prm = &uac->p_prm;
-	config_ep_by_speed(gadget, &audio_dev->func, ep);
+	ret = config_ep_by_speed(gadget, &audio_dev->func, ep);
+	if (ret < 0) {
+		dev_err(dev, "config_ep_by_speed for in_ep failed (%d)\n", ret);
+		return ret;
+	}
 
 	ep_desc = ep->desc;
 
@@ -598,7 +620,11 @@ int u_audio_start_playback(struct g_audio *audio_dev)
 	uac->p_residue = 0;
 
 	prm->ep_enabled = true;
-	usb_ep_enable(ep);
+	ret = usb_ep_enable(ep);
+	if (ret < 0) {
+		dev_err(dev, "usb_ep_enable failed for in_ep (%d)\n", ret);
+		return ret;
+	}
 
 	for (i = 0; i < params->req_number; i++) {
 		if (!prm->reqs[i]) {
-- 
2.43.0



