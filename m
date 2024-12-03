Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D071F6691;
	Tue,  3 Dec 2024 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238410; cv=none; b=AyTkf2i/Bld95Tu8yngWNiCkpqf5ZQbX/xRrnzRwN3Ued+LSxx24PsQ1Mc3TzWdSK3C8KATmMO86u7NmY3k8nSfsn6gqBQN8Y3BuZUuuS7kZJTAWOmRIVKr8VbF2e5vxU7YEhbsp1n7hqr4vnrpBEl9wdkmQCP4L6C6KpEDIkuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238410; c=relaxed/simple;
	bh=sBoytRqrIwhY0oLFAfFu+SHL83DYdCvxYYy30r2k5Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qx+ZX6RrUZkksmPVOWcpo0eSbb9iC++9UGlapqvpLo74KUst1DtPLRcmZrkUO6BJo1TTSvbrQlvbcr8gHj9fD6euskUxKsRm7Ctd/Os/Mqx3rGzvl5dvNcV1plaNI6YMsr/vYfRz7S2+K+HgzFLy9FxqEQNfO5caX059QUocnq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/Hpksy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/Hpksy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93662C4CECF;
	Tue,  3 Dec 2024 15:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238410;
	bh=sBoytRqrIwhY0oLFAfFu+SHL83DYdCvxYYy30r2k5Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/Hpksy43RqPPq9MsV0X0g8HBy6aZkhngnOgHhADj1Dt+uBcGaBrxcX6ewKjbuuGH
	 LNPzUunh/jl5FYGcqD3WzFSyJESMVa+fhYWnitdCk1wHDD/eYAzb/qcZt+LSE9b3f3
	 33ET/rIZSMPKUdGv+aDTiFzEa6CT3W1A6+DSYMpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dom Cobley <popcornmix@gmail.com>,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 266/817] drm/vc4: hdmi: Increase audio MAI fifo dreq threshold
Date: Tue,  3 Dec 2024 15:37:18 +0100
Message-ID: <20241203144006.173732389@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 9b2b07104a7ac..2b8e1642f9cf4 100644
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



