Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028D028936D;
	Wed, 23 Apr 2025 15:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421312; cv=none; b=SqTCWYSP0kQDf/MYC0T49AT0EF+wWGcIM8W/omhDmEMABD/i5qdPiebJ1nuP3SN/ZDRvTiO0CTVdslJj+wlw8s+v4lQtkFSatJvT278SnAsCSGv9wbdnNHsZJUwgncCvEnPhN6ZPjt+5tQ56dyuMmeeO33siDWNiNi9OMZ93fDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421312; c=relaxed/simple;
	bh=X+ogWlbRNJhclx7MozH3FekpRf9YgB5PN9vSItlJo7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouDRzM50qJm/UquwX8KA9QCPOWGrisoxvBgyW+K4L4sxQOGUzmPbygtbqzZWzWPY0AM2btTEqTR5kd6+X44OSTlxzvWa/pUzKcR2b+aLloo/iF9lCsIu65ZVxgJB03nh4jgHB1ZpvRJ2TdfCldV/RN8XslgOj71tJ6VRlacJ588=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfGeDOo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfGeDOo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B741C4CEE2;
	Wed, 23 Apr 2025 15:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421311;
	bh=X+ogWlbRNJhclx7MozH3FekpRf9YgB5PN9vSItlJo7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BfGeDOo7DSk9Sv6Lzn0/DyHKLqcAjZ2JbpOpMyjJJdztKLRxG8jUl8OwRnEQw2J7R
	 fFzQb1HNA97Udaa8VyJ59i2XD3jCwcw0rrQovHb6umKt2RJsnxMvWNkhKqMpzXnlzY
	 G5zE+1RNwa2dfHrMd+ndMg3bAAjhWmox2pDk+xxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.14 174/241] drm/msm/dsi: Add check for devm_kstrdup()
Date: Wed, 23 Apr 2025 16:43:58 +0200
Message-ID: <20250423142627.641541642@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 
 	if (of_property_present(np, "syscon-sfpb")) {


