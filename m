Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA561F75B3;
	Tue,  3 Dec 2024 15:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240800; cv=none; b=BhhXYZR8RYZNxHyVW1zMnE81OM6usKaEZHt3ZhRAQJAs+crxyXTDtw2FSrdQcgPpmeBDhyKzzpylo02ZpPBhhkMJXlPKLGVfxtaccbK9MOextyPxGiQE1IHdQd5psBTlenll1nrZMUXBi5POCPc45t2k+GDu3vXnkI5XXF88u/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240800; c=relaxed/simple;
	bh=7qrpEzu0HlqKQXnaCwlTF6fcHaEBUXN3uZf6RWuEKE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7COQxrbjLOXtR5c4W0LU+qE39jqzoO/poq9nE67D1WsQIaGuwcE765pEk8oahm4SsUabmIyJcFF7n5UwSvrPHQkJ/22KgSb/jkUS+VBoPkmaB/1I9Vq9eBvHGtSv8O4LQO97NQZRHtgEthd1SBiyw4a+IyEdnguzJu2POatM+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mp5FPRTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mp5FPRTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DB4C4CECF;
	Tue,  3 Dec 2024 15:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240800;
	bh=7qrpEzu0HlqKQXnaCwlTF6fcHaEBUXN3uZf6RWuEKE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mp5FPRTTaojPHXFFngVHMd1vbfDH/wa2hu9qROrlomQ4cb1ghxkehePrsnHjpF4JB
	 qQKQjYEk4kqQjLdpMU7fiXw42SosI1SNP4WA38icrK5PCwHVl9AbGoheG4tMNPfCvT
	 46zd9D+1mGa1p468+XdzZES9UAii/Yjf25yA6GfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dom Cobley <popcornmix@gmail.com>,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 237/826] drm/vc4: hdmi: Increase audio MAI fifo dreq threshold
Date: Tue,  3 Dec 2024 15:39:24 +0100
Message-ID: <20241203144753.003040410@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit 59f8b2b7fb8e460881d21c7d5b32604993973879 ]

Now we wait for write responses and have a burst
size of 4, we can set the fifo threshold much higher.

Set it to 28 (of the 32 entry size) to keep fifo
fuller and reduce chance of underflow.

Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621152055.4180873-8-dave.stevenson@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Stable-dep-of: cf1c87d978d4 ("drm/vc4: Match drm_dev_enter and exit calls in vc4_hvs_lut_load")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 6c2215068c537..0117c5495b893 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2051,6 +2051,7 @@ static int vc4_hdmi_audio_prepare(struct device *dev, void *data,
 	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
 	struct drm_device *drm = vc4_hdmi->connector.dev;
 	struct drm_connector *connector = &vc4_hdmi->connector;
+	struct vc4_dev *vc4 = to_vc4_dev(drm);
 	unsigned int sample_rate = params->sample_rate;
 	unsigned int channels = params->channels;
 	unsigned long flags;
@@ -2108,11 +2109,18 @@ static int vc4_hdmi_audio_prepare(struct device *dev, void *data,
 					     VC4_HDMI_AUDIO_PACKET_CEA_MASK);
 
 	/* Set the MAI threshold */
-	HDMI_WRITE(HDMI_MAI_THR,
-		   VC4_SET_FIELD(0x08, VC4_HD_MAI_THR_PANICHIGH) |
-		   VC4_SET_FIELD(0x08, VC4_HD_MAI_THR_PANICLOW) |
-		   VC4_SET_FIELD(0x06, VC4_HD_MAI_THR_DREQHIGH) |
-		   VC4_SET_FIELD(0x08, VC4_HD_MAI_THR_DREQLOW));
+	if (vc4->is_vc5)
+		HDMI_WRITE(HDMI_MAI_THR,
+			   VC4_SET_FIELD(0x10, VC4_HD_MAI_THR_PANICHIGH) |
+			   VC4_SET_FIELD(0x10, VC4_HD_MAI_THR_PANICLOW) |
+			   VC4_SET_FIELD(0x1c, VC4_HD_MAI_THR_DREQHIGH) |
+			   VC4_SET_FIELD(0x1c, VC4_HD_MAI_THR_DREQLOW));
+	else
+		HDMI_WRITE(HDMI_MAI_THR,
+			   VC4_SET_FIELD(0x8, VC4_HD_MAI_THR_PANICHIGH) |
+			   VC4_SET_FIELD(0x8, VC4_HD_MAI_THR_PANICLOW) |
+			   VC4_SET_FIELD(0x6, VC4_HD_MAI_THR_DREQHIGH) |
+			   VC4_SET_FIELD(0x8, VC4_HD_MAI_THR_DREQLOW));
 
 	HDMI_WRITE(HDMI_MAI_CONFIG,
 		   VC4_HDMI_MAI_CONFIG_BIT_REVERSE |
-- 
2.43.0



