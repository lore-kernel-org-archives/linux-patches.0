Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DB7267386;
	Tue, 26 Aug 2025 11:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208517; cv=none; b=a8jOOHnqATYpfKRIrp8w6RMU0bqCGETc56xr6F3j4dtDErRzHdItUCCzHruJm9O5YRTK1N6judnSyhqtL2hYdQXccmj8q6AWTHnEKkRfAnl6hh2+maEmRP/GQ8qHL1kliyKGRbMzro8yGev2YO4QHEiIVqdTjdhon//G/UZV7j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208517; c=relaxed/simple;
	bh=co7IBiseY2/AfHAZBuxegkui80qpxn2I5ukuOABSdW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McivxDU3wK5fN+eQpEbxaRdrVUDpeBwGWd0l7831Hz0arn2pHWpnyMZOZKtw8avmxnRS4v5Xm2/WhV9HjllwYRPjof6pbLWCRayY/1Zo6Bdr5AE0+W0FT5KZzogE6Mxd5/PT8ddmYNFJQb2cLweZyQ/GGhrtsrZ3ryOv33G0Bps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXJKqNuq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXJKqNuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96196C4CEF1;
	Tue, 26 Aug 2025 11:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208516;
	bh=co7IBiseY2/AfHAZBuxegkui80qpxn2I5ukuOABSdW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXJKqNuq0CX39f7j7om8xTN4j5enxDwS/TS/3HP38sikB9OA+d1UAQNi+t4w7jNft
	 CVvcjjPQsNh6CGHwbQtys5YuOuUdSi2knsTgaY2rpEPh1DhN1PSEBHHpHhKfKC4p+4
	 ZUPkU0eJMlZELn30gH6HcbbsTk008zK7mkWefSqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 111/322] media: qcom: camss: cleanup media device allocated resource on error path
Date: Tue, 26 Aug 2025 13:08:46 +0200
Message-ID: <20250826110918.528560505@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

commit 69080ec3d0daba8a894025476c98ab16b5a505a4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -2275,7 +2275,7 @@ static int camss_probe(struct platform_d
 	ret = v4l2_device_register(camss->dev, &camss->v4l2_dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to register V4L2 device: %d\n", ret);
-		goto err_genpd_cleanup;
+		goto err_media_device_cleanup;
 	}
 
 	v4l2_async_nf_init(&camss->notifier, &camss->v4l2_dev);
@@ -2330,6 +2330,8 @@ err_v4l2_device_unregister:
 	v4l2_device_unregister(&camss->v4l2_dev);
 	v4l2_async_nf_cleanup(&camss->notifier);
 	pm_runtime_disable(dev);
+err_media_device_cleanup:
+	media_device_cleanup(&camss->media_dev);
 err_genpd_cleanup:
 	camss_genpd_cleanup(camss);
 


