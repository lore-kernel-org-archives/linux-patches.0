Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8557C350825;
	Tue, 26 Aug 2025 14:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218354; cv=none; b=U7swWufouHzwk0FcdzEqNBhshaevF8VkYNVquSGVSGFHJyxrAdhfMUbxGGvdfo7+QBiK8uQe4Gx8bzoTwuK9e457Lb3xSzINhH7U49QgXdpq66IDZdaC51kkFshqNlL9ftDbkb+1sQOJn9Bn1J1Hlf2aezTL4QXAZfbH37Yp9KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218354; c=relaxed/simple;
	bh=psrU+LM/XVpxfb5j6hnSOkwi1zMwLDxyz0oa/ITE3qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKt+5Odceyve/Lna5z6J76yHwfGds6pwNWwAemXe6tiTK7A+nF0yrhgkDXsjExyrnmSTKZD2idfEnZLZKyfybdUVhm7pjPzJkyjvOCqIyHA2IK9uEmBX6DGNCD1ZdP9psSKU1S402JYPFIZCR2NTk3rWSpskon2ZJl/mJh+1kNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJJYlrmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJJYlrmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF44C4CEF1;
	Tue, 26 Aug 2025 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218354;
	bh=psrU+LM/XVpxfb5j6hnSOkwi1zMwLDxyz0oa/ITE3qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJJYlrmPBhvD/xISEW6Pc+ylUNEHNnMXYAcVq7QudFiQ1e+vJb2Zk7ySptu/F3JV6
	 PO/itNoES29eztg64ZrhmL8bDftnn1hqIbFSyqq2nawO59TlYzwxHR+RJu5XeU77hN
	 qCLYWZxxu9sXFsZeLzugrHR5e7DiuzW5kdhPn/Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 490/523] media: qcom: camss: cleanup media device allocated resource on error path
Date: Tue, 26 Aug 2025 13:11:40 +0200
Message-ID: <20250826110936.531252905@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


