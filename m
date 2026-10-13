Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9DD4F96BD;
	Tue, 13 Oct 2026 12:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893241; cv=none; b=FLqW+P66FyccVEvozkiamFt+re/+C167OwkyMAZN9ROGyz0svtJwOYtKu76CTrme8CJ+v9mBrPxsL4Mnlgynn53BTzMxW0Sv6pqoZFN32d0cmLwbEWWaOVQeELubHG9r/JEGxYhDT+ToJW8sHZt597zEa7c4pRDs3Tg0u6dWN3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893241; c=relaxed/simple;
	bh=mtegfBKXn20WAeD32GtMQpc9WqikjZ0ioL/QgA1WMyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ql+a+azit55c7FZ2cZrfZ7I4WdCmsdRLa9ySmCsKV0X/Wb/LHs/iySQ4YfJv56/WrgZSxqg1d30gqOI1Hy3OjmmhqVNwCdb/IWG59r7eTwq6zkba8+no07o0Z8PC5HdK2ZG5fZJqAjbpG+yGyU2JPH25wxJorPYVes6lu4yVbJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKin94uD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKin94uD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88E21F000FF;
	Tue, 13 Oct 2026 12:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893240;
	bh=31FnoQ13Y66mIdGXVxk+pcZpGHO42Y+BREXsm5Hnj3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKin94uD0ZlDzliOwmMVeEiIk63hpyBHsoNcyXUVkdMzs8wb4hX+P+ri76kwZlAJu
	 gBF1DkFDpo1o5QXsff2pA1zRSWj5DkVATCqD2WKCzuYzBLYMWQ+tycmfw3oa3xHqzU
	 VxXv+kMQWLyfWwKX9Z0pWKnv409BO0vuoen5lg4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.18 116/621] drm/vc4: Fix firmware reference leak in vc4_drm_bind()
Date: Tue, 13 Oct 2026 13:31:51 +0200
Message-ID: <20261013112923.612630572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -361,8 +361,11 @@ static int vc4_drm_bind(struct device *d
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


