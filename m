Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDD31A6803;
	Tue, 16 Jun 2026 17:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629825; cv=none; b=r5N+bLZrRlSpcW21MPrsExPDVUNBHK19dQgABrvg4ZuVeOtJHSBPfrgYj+Fij+raCognSQa6daf/wZDa5zRevcoYyw8kbxIjwYg34OJAKMk3EudeyWe1hrX+Qy4n91W+glfVvuACyN+DEOEi9sOY4PhmLz+ZIZPm4wZRNJn4q60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629825; c=relaxed/simple;
	bh=YC8v4uPmaONfwYPxTk/0zlQNgeRtp3Ii4Oxq8Kejygg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAc8m2xmC0Vau0o9v1vwhg6KHfr8Q542/DqQComBt57SS8PGdMqySOn97wzzYw0whYDdLKazmTvzjXjSfOn+dgSf0qpVy/Qpt2JSZHs9CF/c2cAYFurEQYwUUk+yWmRcQZO2tt308tzZqpmxob6JoGGZsDULlhvDreN9Bud7AgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rr5SGZOq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rr5SGZOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE8B1F000E9;
	Tue, 16 Jun 2026 17:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629824;
	bh=AQuqq+OZEUebIskQHXF/lqbbQYzuCHfR8a7jI50kSsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rr5SGZOq0rpCh0jQ9yhLDYaX5mUNceWk2htTYj6V9HOgcWnDCv2msRYGAVTVmXzqq
	 R4IHREU8gu4xOvISPdJpAjeFgVCdPVpWUFdb0LZN0DlcbZJqr0J+Hy+TolIT92QYkx
	 MeNcOiwFH8mmT0aWgrbZhMZ2/yKBHuJG4mzyz/+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.6 359/452] slimbus: qcom-ngd-ctrl: fix OF node refcount
Date: Tue, 16 Jun 2026 20:29:46 +0530
Message-ID: <20260616145135.984901626@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 120134fe75c6b0ae38f14eb8b548ad1e5761f912 upstream.

Platform devices created with platform_device_alloc() call
platform_device_release() when the last reference to the device's
kobject is dropped. This function calls of_node_put() unconditionally.
This works fine for devices created with platform_device_register_full()
but users of the split approach (platform_device_alloc() +
platform_device_add()) must bump the reference of the of_node they
assign manually. Add the missing call to of_node_get().

Cc: stable@vger.kernel.org
Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530204421.116824-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1545,7 +1545,7 @@ static int of_qcom_slim_ngd_register(str
 			of_node_put(node);
 			return ret;
 		}
-		ngd->pdev->dev.of_node = node;
+		ngd->pdev->dev.of_node = of_node_get(node);
 		ctrl->ngd = ngd;
 
 		ret = platform_device_add(ngd->pdev);


