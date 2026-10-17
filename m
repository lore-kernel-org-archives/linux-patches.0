Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B22303A04;
	Sat, 17 Oct 2026 16:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253209; cv=none; b=N2xgHvEkO7C3uIDxUW10Y4w7ipoNW3SKUAIZZm05uNktHAgLePliqJtw5Keeu1V9hagMTA6RTo+66fnUJPvjXl2A71ftDDqWie0Qunc6m4BS53EuEYcbvtOnVr0d9RYvUKvRGGTvR9kfPwCMSAidq64wZbNA0wp7ROXxWj1jcUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253209; c=relaxed/simple;
	bh=4h/3BsS/XHREZ7wszOu44k72zlxhAFMnBODx8aPbLY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h5KC4ZEcezcDoibnuIuls+Pil3fXmXPTZvntQ/JRdabyQmHDNmEh7tBMz3lnEjV+6RT46gJ2bNp98FZOXnbk+/4ZLd7s0TiN5/JZ5gau8uiw8UY/sHj0LtC7NocIe7fJkh4l+NjmHrznnJGFBz6d6lDWoa8lrt8j+HE8gTbr70E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oetzLkHu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oetzLkHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1E11F000C4;
	Sat, 17 Oct 2026 16:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253207;
	bh=q1/3LapAzRVIjyjVK7R8RYi2FD2ZVVZC1Sr+K6xeuXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oetzLkHuhQoJoQI0Gw7wM9Cl6mzgChbj4hI+B4gIqQxDqe9JMborwF7Mo3fAZoN8R
	 cMwG1hIeNob+XRbNX/R4dKRQZDh6DPXnlmKpzg67r9fpOW5hnmE1kUM7TgeQCRt3IO
	 PcExRvM+iNYrCriZP3YrTQmu0PEZTqFnpFVsoJqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/869] drm/vc4: Fix firmware reference leak in vc4_drm_bind()
Date: Sat, 17 Oct 2026 17:48:05 +0200
Message-ID: <20261017160038.145647063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit b816da5d5df1461446a0a5f3fe2b4948a659a790 ]

The firmware reference obtained via rpi_firmware_get() is leaked when
aperture_remove_all_conflicting_devices() fails, as the error label
returns without putting it. This happens before the firmware is
consumed and put further down in the function.

Put the firmware reference before jumping to err.

Fixes: c406ad5e4a85 ("drm/vc4: Notify the firmware when DRM is in charge")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916154015.2056797-1-vulab@iscas.ac.cn
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 802e716f7dc83..871d4096b74a0 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -357,8 +357,11 @@ static int vc4_drm_bind(struct device *dev)
 	}
 
 	ret = aperture_remove_all_conflicting_devices(driver->name);
-	if (ret)
+	if (ret) {
+		if (firmware)
+			rpi_firmware_put(firmware);
 		goto err;
+	}
 
 	if (firmware) {
 		ret = rpi_firmware_property(firmware,
-- 
2.53.0



