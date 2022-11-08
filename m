Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC1615CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE9BC433D7;
	Tue,  8 Nov 2022 14:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916617;
	bh=NTOMFuo0zAi61ivrDTWUeW1q31wzmTLJLPDhXfieEKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWBtWp+z9BZigs3mpKRPx3ND5TCxtGTwOHWsbBUmgJK90hHbcN3RxqGoyxaFJdKTT
	 mfHnAgmmyRxgHHYhop7kQqmyLhwSER1Bb8nTzPdq3OrhUaXZHrx33xIerP7eN3Alrd
	 OUBwPAQLKxpJVTV3THK+tImR2am0FqC3ZnY0EgHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Martinez Canillas <javierm@redhat.com>,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 078/197] drm/vc4: hdmi: Check the HSM rate at runtime_resume
Date: Tue,  8 Nov 2022 14:38:36 +0100
Message-Id: <20221108133358.392051887@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 4190e8bbcbc77a9c36724681801cedc5229e7fc2 ]

If our HSM clock has not been properly initialized, any register access
will silently lock up the system.

Let's check that this can't happen by adding a check for the rate before
any register access, and error out otherwise.

Link: https://lore.kernel.org/dri-devel/20220922145448.w3xfywkn5ecak2et@pengutronix.de/
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220929-rpi-pi3-unplugged-fixes-v1-2-cd22e962296c@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 780a19a75c3f..874c6bd787c5 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2869,6 +2869,7 @@ static int vc4_hdmi_runtime_resume(struct device *dev)
 	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
 	unsigned long __maybe_unused flags;
 	u32 __maybe_unused value;
+	unsigned long rate;
 	int ret;
 
 	/*
@@ -2884,6 +2885,21 @@ static int vc4_hdmi_runtime_resume(struct device *dev)
 	if (ret)
 		return ret;
 
+	/*
+	 * Whenever the RaspberryPi boots without an HDMI monitor
+	 * plugged in, the firmware won't have initialized the HSM clock
+	 * rate and it will be reported as 0.
+	 *
+	 * If we try to access a register of the controller in such a
+	 * case, it will lead to a silent CPU stall. Let's make sure we
+	 * prevent such a case.
+	 */
+	rate = clk_get_rate(vc4_hdmi->hsm_clock);
+	if (!rate) {
+		ret = -EINVAL;
+		goto err_disable_clk;
+	}
+
 	if (vc4_hdmi->variant->reset)
 		vc4_hdmi->variant->reset(vc4_hdmi);
 
@@ -2905,6 +2921,10 @@ static int vc4_hdmi_runtime_resume(struct device *dev)
 #endif
 
 	return 0;
+
+err_disable_clk:
+	clk_disable_unprepare(vc4_hdmi->hsm_clock);
+	return ret;
 }
 
 static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
-- 
2.35.1



