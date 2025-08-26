Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA7A352094;
	Tue, 26 Aug 2025 14:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219407; cv=none; b=IlujiRqIT7H8OZIXWZncGlyOrkHGcsbLgyotx9vT6znWhJgv+enTj12Ey/e7tOweYkX9yEDrdicD6KpzjvkNPF9sU9mjpK1OB8vsPOAK/Jnr5t7Afzdim6St6oaPB5SR522uHza2bYsXxLaBRmGVj8pi1+GpG4EpmLvm9WjBofA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219407; c=relaxed/simple;
	bh=yeJ0s/Jes2wEvFFEGH1IFqRroruyKein3FUpxf8hfvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDmJGGpGcIJCIIOHhEQKei91wVAauJtBOibyC12DY7vcd++3t+CMLHDtQbyYGgHK50u8K6227C+fuCFtjKqVn3m/d3lbAFcQfzd/HE6UIFJv6Nx4TMwmgRYZzSxlp+Gtg08oo3F/KdxiKtezldNCODkgSuQ/VFf40nncwcVYxNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TidTXRnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TidTXRnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFAFC4CEF1;
	Tue, 26 Aug 2025 14:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219406;
	bh=yeJ0s/Jes2wEvFFEGH1IFqRroruyKein3FUpxf8hfvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TidTXRnMBY+hPBeOSogOgbIgce942x/u0B7Wl05TnFyUnlaNG1U7/kYx9bvMRt2HY
	 FLt+8xYxiBawEnMJAxtEeXQPrB3L4s42UeICQyn51isNFJfZQRq9Nkp/7SUty6zph3
	 ykDJ/nzjeyCei91GMEOio4B2/wPe0x+l2jYWbJCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 370/403] media: qcom: camss: cleanup media device allocated resource on error path
Date: Tue, 26 Aug 2025 13:11:36 +0200
Message-ID: <20250826110917.228691919@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 69080ec3d0daba8a894025476c98ab16b5a505a4 ]

A call to media_device_init() requires media_device_cleanup() counterpart
to complete cleanup and release any allocated resources.

This has been done in the driver .remove() right from the beginning, but
error paths on .probe() shall also be fixed.

Fixes: a1d7c116fcf7 ("media: camms: Add core files")
Cc: stable@vger.kernel.org
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[ err_genpd_cleanup => err_cleanup ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -888,7 +888,7 @@ static int camss_probe(struct platform_d
 	ret = v4l2_device_register(camss->dev, &camss->v4l2_dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to register V4L2 device: %d\n", ret);
-		goto err_cleanup;
+		goto err_media_device_cleanup;
 	}
 
 	ret = camss_register_entities(camss);
@@ -945,6 +945,8 @@ err_register_subdevs:
 	camss_unregister_entities(camss);
 err_register_entities:
 	v4l2_device_unregister(&camss->v4l2_dev);
+err_media_device_cleanup:
+	media_device_cleanup(&camss->media_dev);
 err_cleanup:
 	v4l2_async_notifier_cleanup(&camss->notifier);
 err_free:


