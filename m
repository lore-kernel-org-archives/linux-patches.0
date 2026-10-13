Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131A04F30DC;
	Tue, 13 Oct 2026 11:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892445; cv=none; b=GgpRiAdJnPoT5BsHMPDd3xYqDoAj1kVt0LvfeXoY3dKuUFZEx4dU3QMvsl8rs/62fP8G5M55LDY4MXKZJfF3E0wXM/87zDkmdPUADt53XMWW0RWMBHNwhegVO11SLezZ7PjCH77txEH0Lln8Y2XXE9bDLCjI6CjlYngzDRqwafQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892445; c=relaxed/simple;
	bh=W5gVzmTgFKtsXrS3Nk962QhNTQ6TFzmxibJSxDSJqFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qNjqa6Yr+DVcxkcKjxGpUlz9cSKWyEfcs7vvbBo1b+LnmFxzylhT364fDTyh0uMWcfoN+Fkvs8UDs2D06gaNWauQimNhguFFzieb/pMxBB4wyK4Yzufv4At4PanxHlw1kFMYTn0TsrlgNFcir95LWR9WJoGJMaLboue/sSeX4OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QiSSRHwu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiSSRHwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9108C1F000FF;
	Tue, 13 Oct 2026 11:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892444;
	bh=0vOPsN0jUI5J0UQzQArJT12IVsVJuhb3OgNojTt0J10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QiSSRHwuxYtb7qbp+7iX8HGkhalQDAZ6liktzOR00+4+nMysueiHxo0vtyHCPYo9f
	 TLTuUkldrccGmEoprzEkUo8gK9zVV2tPvTDrWX7nLg5HUj2ZXSu9AxIDCg5Bc5LZ62
	 EVpP8awCMyKWKEtKDt5N0LU3hio4asZ0fEz/ZXog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 7.2 131/281] drm/vc4: Fix firmware reference leak in vc4_drm_bind()
Date: Tue, 13 Oct 2026 13:37:27 +0200
Message-ID: <20261013112858.330131965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit b816da5d5df1461446a0a5f3fe2b4948a659a790 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_drv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -360,8 +360,11 @@ static int vc4_drm_bind(struct device *d
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


