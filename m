Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1F8149E0E;
	Fri,  6 Dec 2024 14:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496098; cv=none; b=uNTwfNznVX0D/sm0zo45jHogkQBVsjwVkRC1h4+R1ZjbYg6Efs7dNLIeujl/Ep5TsBvwo16PP85mBt0chjEkAm3gJ3tDo1x9LZnAegHPaBL8q2MHOWJeUYIpdOS9L4+PC7o3bh2Adh8sBPCGB1by1Tdx6GAGcrRHvf5bzcxuwJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496098; c=relaxed/simple;
	bh=rkzvOmwAr4OoPrtuXXNmUVFUICUGWwd3ngMcqusy7/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMVXsQeFoO72/L0RdHQdA8ZTQVuMm8Q622XRcCJ0gMq+XVnMoX5P3qO9B5Kua4Hl0aREMY2F8xDPvgKerIh5jTPuQ5DgjWYB+ewmQxIVXirjRYUHoxZoK+HWnPuOVAPa6ApvP6QMkx2HObY0eXakUHqS3CJZXNZzpIc6eOYol/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a52el0Uc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a52el0Uc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6B1C4CEE1;
	Fri,  6 Dec 2024 14:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496097;
	bh=rkzvOmwAr4OoPrtuXXNmUVFUICUGWwd3ngMcqusy7/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a52el0UcT27BnQ3vDonPwMixdb8UbyVNwoyFqzOJj/h8urFQBsIuSJIhsOhbQljT0
	 fT15BcNtHK7ELgOo2xGERYqfgYQZoUcqBqiwAxaQct2GQkA9+Y5G2HqQzEYDWVInSp
	 zovqhS6cK5HJCRowDpkmpz4DqB8HPvkUmUKSFFOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.12 019/146] media: qcom: camss: fix error path on configuration of power domains
Date: Fri,  6 Dec 2024 15:35:50 +0100
Message-ID: <20241206143528.406810804@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 4f45d65b781499d2a79eca12155532739c876aa2 upstream.

There is a chance to meet runtime issues during configuration of CAMSS
power domains, because on the error path dev_pm_domain_detach() is
unexpectedly called with NULL or error pointer.

One of the simplest ways to reproduce the problem is to probe CAMSS
driver before registration of CAMSS power domains, for instance if
a platform CAMCC driver is simply not built.

Warning backtrace example:

    Unable to handle kernel NULL pointer dereference at virtual address 00000000000001a2

    <snip>

    pc : dev_pm_domain_detach+0x8/0x48
    lr : camss_probe+0x374/0x9c0

    <snip>

    Call trace:
     dev_pm_domain_detach+0x8/0x48
     platform_probe+0x70/0xf0
     really_probe+0xc4/0x2a8
     __driver_probe_device+0x80/0x140
     driver_probe_device+0x48/0x170
     __device_attach_driver+0xc0/0x148
     bus_for_each_drv+0x88/0xf0
     __device_attach+0xb0/0x1c0
     device_initial_probe+0x1c/0x30
     bus_probe_device+0xb4/0xc0
     deferred_probe_work_func+0x90/0xd0
     process_one_work+0x164/0x3e0
     worker_thread+0x310/0x420
     kthread+0x120/0x130
     ret_from_fork+0x10/0x20

Fixes: 23aa4f0cd327 ("media: qcom: camss: Move VFE power-domain specifics into vfe.c")
Cc: <stable@vger.kernel.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -2130,10 +2130,8 @@ static int camss_configure_pd(struct cam
 	if (camss->res->pd_name) {
 		camss->genpd = dev_pm_domain_attach_by_name(camss->dev,
 							    camss->res->pd_name);
-		if (IS_ERR(camss->genpd)) {
-			ret = PTR_ERR(camss->genpd);
-			goto fail_pm;
-		}
+		if (IS_ERR(camss->genpd))
+			return PTR_ERR(camss->genpd);
 	}
 
 	if (!camss->genpd) {
@@ -2143,14 +2141,13 @@ static int camss_configure_pd(struct cam
 		 */
 		camss->genpd = dev_pm_domain_attach_by_id(camss->dev,
 							  camss->genpd_num - 1);
+		if (IS_ERR(camss->genpd))
+			return PTR_ERR(camss->genpd);
 	}
-	if (IS_ERR_OR_NULL(camss->genpd)) {
-		if (!camss->genpd)
-			ret = -ENODEV;
-		else
-			ret = PTR_ERR(camss->genpd);
-		goto fail_pm;
-	}
+
+	if (!camss->genpd)
+		return -ENODEV;
+
 	camss->genpd_link = device_link_add(camss->dev, camss->genpd,
 					    DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME |
 					    DL_FLAG_RPM_ACTIVE);


