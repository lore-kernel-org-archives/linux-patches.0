Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6423FF1DD;
	Fri, 15 May 2026 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860430; cv=none; b=Ytsi82gXoGgQNw5mqauIG2fEt0SjSRsZbVoY/Esg2LbXOxCkYT3J2W4rBHvPIOn0SvS9O2wuHuKHFipcCCp5hgMoNo979N2xw+flVL3g8Kj0Kpyu6g2Hy5JOW7/RaVqEWZC7Oo7SbrIV0fH3/mYHlE8fCbxxqC/c7QE95qyjF+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860430; c=relaxed/simple;
	bh=ioDL2l7FeF24FRAnKC9S3PNgbq2S5IcQ00HNwbKEFTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qrsu1smmI35FfKWa/fHAcpiXR2L0rNVZYhvvnxdJ03jdBa+ex4j4oy1r8JxZfNXmT4ZINOOnbhtcFsoI5EshvfI4MFFwM8QdujpuxENltAjmTTgk6ipax4JOon9IGRdvih86qPCn9xUZJuAOwpM/Gh5GLNFwbfqOMoOsUJt7NHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujKGuuES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujKGuuES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64873C2BCB0;
	Fri, 15 May 2026 15:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860430;
	bh=ioDL2l7FeF24FRAnKC9S3PNgbq2S5IcQ00HNwbKEFTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujKGuuESWC8JIXWQSq+3x0wIgFHMZiOZjcKIA3PmsMwa1vafe5aYkm6FwO8QaSvCP
	 Oe6xtDN/B9e1Z9XBkNZpPvDC61WZyBJ6Knon8LO+rBeJ5plv8gFDbNEOpJccxwhDRK
	 fyvjarN3oUYshiVIRppcObPpxT+psLZiSjvjRvow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.12 086/144] drm/panel: himax-hx83102: restore MODE_LPM after sending disable cmds
Date: Fri, 15 May 2026 17:48:32 +0200
Message-ID: <20260515154655.516990150@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <zhengxingda@iscas.ac.cn>

commit 2d4e80271f784aa0c7b17676e9762c7e8156be1c upstream.

When preparing the panel, it seems that it always expects commands to be
transferred in LP mode. However, the disable function removes the
MIPI_DSI_MODE_LPM flag, and no other function re-adds it.

As the unprepare function contains no DSI commands, re-adding the flag
just after disabling the panel should be safe. Add the code re-adding
the flag after the two commands for disabling the panel are sent.

This fixes screen unblanking (after blanking once) on
mt8188-geralt-ciri-sku1 device.

Cc: stable@vger.kernel.org # 6.11+
Fixes: 0ef94554dc40 ("drm/panel: himax-hx83102: Break out as separate driver")
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260425165751.1716569-1-zhengxingda@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-himax-hx83102.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/panel/panel-himax-hx83102.c
+++ b/drivers/gpu/drm/panel/panel-himax-hx83102.c
@@ -479,6 +479,8 @@ static int hx83102_disable(struct drm_pa
 	mipi_dsi_dcs_set_display_off_multi(&dsi_ctx);
 	mipi_dsi_dcs_enter_sleep_mode_multi(&dsi_ctx);
 
+	dsi->mode_flags |= MIPI_DSI_MODE_LPM;
+
 	mipi_dsi_msleep(&dsi_ctx, 150);
 
 	return dsi_ctx.accum_err;


