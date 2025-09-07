Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3141A704B;
	Sun,  7 Sep 2025 20:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277347; cv=none; b=Z1w83GY1Y6HJYE84UQRPETlVUM5uVvC+NGvAq3XEWa08qR8qnQuoDqlbHGuabSzdtigqDD4FsUyCEjVeSxnJF70VwMZ1vjtOlBBENxUM9fYztB1kZ6kHeHn7U9YE5oh8YEvlY646UGDp/dZODzxdf2n+pVng7FhpRnvNVmSb+lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277347; c=relaxed/simple;
	bh=S8Hp/cu7FHGEuFsh0JvuvLJNQ51b6sv5PaQ4ckGa+Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rF1omknE67havZNC8L0jGs10ykpybNF8Vg17ZbiYNgO5keGMexl1Qe7I1/mSSI2uLc5GNccD8qrn+qszifB1XXZwFkLZOwTmcfkcjJVdFOvQJ5EnJoss+IUKyhYFaF5hjhlmwSu8yAzdovdx6RdLLEdanOoGku7eOUm/G+eG1/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rY7uVLJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rY7uVLJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE717C4CEF0;
	Sun,  7 Sep 2025 20:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277346;
	bh=S8Hp/cu7FHGEuFsh0JvuvLJNQ51b6sv5PaQ4ckGa+Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rY7uVLJNv9f4tjS20b/lapSUV/42d0f6aMS4PCmoF1FitauhaOTbEXFi82431REE1
	 WIyY3F7bB+zN8UTDCw3SqDxyHCL6b80TH1Wg4up/71vYAPhQAbryaPVTGYJ9O47Z7t
	 8OAc2z+f7ecFHuoOJ8Z/oe9LAmyAkwp81DoNLk/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/175] drm/bridge: ti-sn65dsi86: fix REFCLK setting
Date: Sun,  7 Sep 2025 21:59:16 +0200
Message-ID: <20250907195618.665895181@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit bdd5a14e660062114bdebaef9ad52adf04970a89 ]

The bridge has three bootstrap pins which are sampled to determine the
frequency of the external reference clock. The driver will also
(over)write that setting. But it seems this is racy after the bridge is
enabled. It was observed that although the driver write the correct
value (by sniffing on the I2C bus), the register has the wrong value.
The datasheet states that the GPIO lines have to be stable for at least
5us after asserting the EN signal. Thus, there seems to be some logic
which samples the GPIO lines and this logic appears to overwrite the
register value which was set by the driver. Waiting 20us after
asserting the EN line resolves this issue.

Fixes: a095f15c00e2 ("drm/bridge: add support for sn65dsi86 bridge driver")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20250821122341.1257286-1-mwalle@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 4d17d1e1c38b4..9859ec688e567 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -375,6 +375,17 @@ static int __maybe_unused ti_sn65dsi86_resume(struct device *dev)
 
 	gpiod_set_value_cansleep(pdata->enable_gpio, 1);
 
+	/*
+	 * After EN is deasserted and an external clock is detected, the bridge
+	 * will sample GPIO3:1 to determine its frequency. The driver will
+	 * overwrite this setting in ti_sn_bridge_set_refclk_freq(). But this is
+	 * racy. Thus we have to wait a couple of us. According to the datasheet
+	 * the GPIO lines has to be stable at least 5 us (td5) but it seems that
+	 * is not enough and the refclk frequency value is still lost or
+	 * overwritten by the bridge itself. Waiting for 20us seems to work.
+	 */
+	usleep_range(20, 30);
+
 	/*
 	 * If we have a reference clock we can enable communication w/ the
 	 * panel (including the aux channel) w/out any need for an input clock
-- 
2.51.0



