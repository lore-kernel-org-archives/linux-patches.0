Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92B11ACEDA;
	Tue, 26 Aug 2025 13:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213625; cv=none; b=fgl4RR2PvyC8les5zomI5f7rOylU4EcVxIEhe++vHi58mZ0d4k6BPhYFduHLO5tFufG7f6sp4uHlqRly0Zul/EWu6o8eumQ4OMkmQjArY7iR98YDpRalw/rQmHS3ShmVdFAgRQrHOEp2EE8+3sM2KoRfywAEDT2kc8E5Yzx+2VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213625; c=relaxed/simple;
	bh=I+XxFpSPfLtFIU5PQmR1tVRQHWOs4VECWrqx93QvEeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9pgo7QXomyfQg3Uo2nzE7MJ6c9OpzmyPs4FLZfCm9KiKpUVMrF1foZdPTtf2Zyp7fuNPlnH/KWAwCj7FWkMpmxRMBA18TErmK7gQIJdrqf4dkhcNHUy1U6bUz7VyRv/NQnf5CcBwWp2GzD3KahYQ15Gp92KFMhDThIPYVypSNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgdCvqWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgdCvqWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4232CC4CEF1;
	Tue, 26 Aug 2025 13:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213625;
	bh=I+XxFpSPfLtFIU5PQmR1tVRQHWOs4VECWrqx93QvEeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgdCvqWpVPN3SPCphChkdOxCjx5Hd8WACfJnf7iIUzgj8g92p2ce/hPmzbwqqBOPr
	 gamRODGkNOpg40M6R1omYD3p8tId5FCjxh6alKHD+/CTOJbFrxdek1KjyW9lJ8hkXg
	 iqiUl3v37JcJnFsjz4v44mf4+haf/uwXH7mjblbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 411/587] media: qcom: camss: cleanup media device allocated resource on error path
Date: Tue, 26 Aug 2025 13:09:20 +0200
Message-ID: <20250826111003.386980451@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1660,7 +1660,7 @@ static int camss_probe(struct platform_d
 	ret = v4l2_device_register(camss->dev, &camss->v4l2_dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to register V4L2 device: %d\n", ret);
-		goto err_genpd_cleanup;
+		goto err_media_device_cleanup;
 	}
 
 	v4l2_async_nf_init(&camss->notifier, &camss->v4l2_dev);
@@ -1711,6 +1711,8 @@ err_v4l2_device_unregister:
 	v4l2_device_unregister(&camss->v4l2_dev);
 	v4l2_async_nf_cleanup(&camss->notifier);
 	pm_runtime_disable(dev);
+err_media_device_cleanup:
+	media_device_cleanup(&camss->media_dev);
 err_genpd_cleanup:
 	camss_genpd_cleanup(camss);
 


