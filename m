Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9D128A419;
	Wed, 23 Apr 2025 15:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420661; cv=none; b=EVz1/9PuQ9/WFI8LYC9vGZn1k7zCw1ox3UrrtWOYDECpQbF0p+lm49T7qacbxjhO17LJ4K/BbJRYfetUWja9DuB0jPZSmoy7/Emx8MSSfp3i8g/P2kWnCRmArQ7JU7aruCNU28gW5w7uja7ZsXsMiwOW77L9DzVHOuPd5eDwsrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420661; c=relaxed/simple;
	bh=5sGWRvHneMxcFkcHN6NVakmiWGh9bAbFM9gB2KbZQHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdPXI+QKT6V3NmBShJMWIbYW9e5ZfW1cgoqmw0dureStaRSz8EjeF9pSeQmE4WFncvKpVFRzfdDc67Wbom+bjtt/AAgSZ3+Y2czpg9Iuc7WaaaWo5bZGDJh5Y373WuycyFcWDNx2OVDgBteXraja4GV1YvXNG5i/KxQ4LMbzvVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6S1Me70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6S1Me70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BA1C4CEE8;
	Wed, 23 Apr 2025 15:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420661;
	bh=5sGWRvHneMxcFkcHN6NVakmiWGh9bAbFM9gB2KbZQHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6S1Me70vYnD/lR1SXhDskchpLBQ10o561lQfYM+EoxEdD1cQyW9Pd/0QS2s+0ZF1
	 QopiC1vJdRYyGH/X4y0dj6JDX2cxAij7cz8zkN1IejjidDVpSNlpnXEqStxLIQIw3d
	 MpayI5AHFYFU4RDxR0URwIJWplFAfuRVew71dy28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.12 150/223] drm/msm/dsi: Add check for devm_kstrdup()
Date: Wed, 23 Apr 2025 16:43:42 +0200
Message-ID: <20250423142623.289801051@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 52b3f0e118b1700e5c60ff676a1f522ce44fadc8 upstream.

Add check for the return value of devm_kstrdup() in
dsi_host_parse_dt() to catch potential exception.

Fixes: 958d8d99ccb3 ("drm/msm/dsi: parse vsync source from device tree")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/638297/
Link: https://lore.kernel.org/r/20250219040712.2598161-1-haoxiang_li2024@163.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1827,8 +1827,15 @@ static int dsi_host_parse_dt(struct msm_
 			__func__, ret);
 		goto err;
 	}
-	if (!ret)
+	if (!ret) {
 		msm_dsi->te_source = devm_kstrdup(dev, te_source, GFP_KERNEL);
+		if (!msm_dsi->te_source) {
+			DRM_DEV_ERROR(dev, "%s: failed to allocate te_source\n",
+				__func__);
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
 	ret = 0;
 
 	if (of_property_read_bool(np, "syscon-sfpb")) {


