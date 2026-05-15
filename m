Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78DA3F44E7;
	Fri, 15 May 2026 16:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861340; cv=none; b=MnBnO+/G/ehdNNjQCy3uVUpLfwengXnlimjL5/MtCZgX50CI5pGuk4t2q6HwUC8vCRN682NZ4/sgsgSfTeh7tF7Zw8a1I7nqb9ucu/gBLnbHTan7pSevZaMjzmzW+3G6QcVCTh+j4qLWCF2acoeBhcghNzV94qBv07VLBwuFD4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861340; c=relaxed/simple;
	bh=6hwQeqddc/rFrGRSBP4vC8Q+A5k8dYeiJcxRGPX1v6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5uZEyVp3sZvqmu7klGkU63eNIV3H+gjuITUQjT6ser5SstmnONldMZ/yKFJS69Mq9qtQPSiOgRZ9UkfIqQvJLejjIDRtS1jB+bWVt+6+jw5N4gLOilJ3507GyaOLOOLN+TT4i+OZtwxTNnHdj+vJgknKWy3gvO86djlGzxpIco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfzdJsjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfzdJsjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF3FC2BCB0;
	Fri, 15 May 2026 16:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861340;
	bh=6hwQeqddc/rFrGRSBP4vC8Q+A5k8dYeiJcxRGPX1v6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfzdJsjvjgTQwL+wAZPG6Q3NBjHfjh7ahcTxW0EkL9tejXMJr9lKHEV9aNtCW5V9p
	 cyZQ4n+UbOXVGH6rcGC4Q01oHrcG7DFy/p1A/B5DRF/AyWQrSieEaJB8bJ98pXf1ix
	 xV/8w4wBLIiS7F66b/aUQieoyNJhY+o+3blHhnOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 249/474] ASoC: qcom: q6apm: remove child devices when apm is removed
Date: Fri, 15 May 2026 17:45:58 +0200
Message-ID: <20260515154720.386632837@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 4a0e1bcc98f7281d1605768bd2fe71eacc34f9b7 upstream.

looks like q6apm driver does not remove the child driver q6apm-dai and
q6apm-bedais when the this driver is removed.

Fix this by depopulating them in remove callback.

With this change when the dsp is shutdown all the devices associated with
q6apm will now be removed.

Fixes: 5477518b8a0e ("ASoC: qdsp6: audioreach: add q6apm support")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260402081118.348071-3-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -781,6 +781,7 @@ static int apm_probe(gpr_device_t *gdev)
 
 static void apm_remove(gpr_device_t *gdev)
 {
+	of_platform_depopulate(&gdev->dev);
 	snd_soc_unregister_component(&gdev->dev);
 }
 


