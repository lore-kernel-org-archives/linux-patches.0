Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97C61A76A5;
	Mon, 14 Oct 2024 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918740; cv=none; b=J6nF1UpzE3A1bUNxpXTOaA7HjQwmcB9dxBxN9sk+y8PQabK8rdYNmxBG/N3PfweXPNL/eV6FrAzRHXosDMg/yd02YDZWySb/N7HnxoTdMUCenRIN29lIBoicqTRZfM4Vn5RYr3dPfXQTsAQPj9giIdr8AdPRTpJkWrjeNya3Nb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918740; c=relaxed/simple;
	bh=6rm42rjd206iHceAH3XQ71kci3whWAJiUEvJg7SqMSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVGCqjy9NdKocD0E0LFdOPlB/VSXbnZVyvCwZd2gijzIubve0dIFE74BTHE6P/cmZ3R37LrA/LWlqKRmmdqu22TkM26fVZGcwEMX5eE0eRiwZVRQudUaktpTqTb75ugdGLnyxUJYDmLBGgxRrQwzDdOXSPsi3FwAquz0iprr+K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xs56Pykr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xs56Pykr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68863C4CEC3;
	Mon, 14 Oct 2024 15:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918739;
	bh=6rm42rjd206iHceAH3XQ71kci3whWAJiUEvJg7SqMSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xs56PykrGAF3t6WomzXuk2fqjpoX6uLirVM2SyvgvmDCuU65ZI5B1v3+hbSxZhS5W
	 arWPw+N927LjXvttdBpTzy+9B+k2OxCg/HM0RXNQmcnsPvdxD9NAFf2Oko4ealvkCs
	 XRnGyzWeG4ATFDuOueORztealvQdAmychQrtd+Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Simion <andrei.simion@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 410/798] ASoC: atmel: mchp-pdmc: Skip ALSA restoration if substream runtime is uninitialized
Date: Mon, 14 Oct 2024 16:16:04 +0200
Message-ID: <20241014141234.058849271@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Andrei Simion <andrei.simion@microchip.com>

[ Upstream commit 09cfc6a532d249a51d3af5022d37ebbe9c3d31f6 ]

Update the driver to prevent alsa-restore.service from failing when
reading data from /var/lib/alsa/asound.state at boot. Ensure that the
restoration of ALSA mixer configurations is skipped if substream->runtime
is NULL.

Fixes: 50291652af52 ("ASoC: atmel: mchp-pdmc: add PDMC driver")
Signed-off-by: Andrei Simion <andrei.simion@microchip.com>
Link: https://patch.msgid.link/20240924081237.50046-1-andrei.simion@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/mchp-pdmc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/atmel/mchp-pdmc.c b/sound/soc/atmel/mchp-pdmc.c
index 44aefbd5b62c7..bdd2ae09714fe 100644
--- a/sound/soc/atmel/mchp-pdmc.c
+++ b/sound/soc/atmel/mchp-pdmc.c
@@ -286,6 +286,9 @@ static int mchp_pdmc_chmap_ctl_put(struct snd_kcontrol *kcontrol,
 	if (!substream)
 		return -ENODEV;
 
+	if (!substream->runtime)
+		return 0; /* just for avoiding error from alsactl restore */
+
 	map = mchp_pdmc_chmap_get(substream, info);
 	if (!map)
 		return -EINVAL;
-- 
2.43.0



