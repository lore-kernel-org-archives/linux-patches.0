Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54CE376E7;
	Mon, 15 Apr 2024 14:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191408; cv=none; b=Kut6rkjHOQs4Vv6rHRaTPttj0RGJDVssmpFEXpy+XjoeDUGmFR2C6evXh4bnUqYPIY/7DUhuvKYE/hRlnhvNdrX5k8OLxdAoLTihGlLUM0UPVvgUPkz4TENXZdCjpopimRclyxiVYCsLawO76l3AxXSsWGjwsA5hth6BJ9e+LcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191408; c=relaxed/simple;
	bh=VBWh27yz+TIxS77uRb3dTQAC5/Ly7iGX+rmXjSMAjD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STQ40iMdzUdsDP1w+AIHkcekXfMBJOLF5RVzBlyuuXaq8pzSVK0XIxtmx8TATgNdP6X6L4Eo4+R1WSnbt2DYWXme50aicSQtJfGgreW6VmMX3BvzBK4db07pKeV6FojkmwDyP8L3uppeYjKgI7neufeLQC8SSpw3lxILMbvELQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1YCY6hz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1YCY6hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9B8C2BD11;
	Mon, 15 Apr 2024 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191408;
	bh=VBWh27yz+TIxS77uRb3dTQAC5/Ly7iGX+rmXjSMAjD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1YCY6hzQ+Ps5CicKOEP6c2FIaDigVofNObtzWzb0snoWeIFlF28USLHHdxNnZd/z
	 1N4+33UAqJFyeM02DYHG9HKzZ+Qx0grt6/iV4uyIFSUhPYhaYQIMQElzZqEHh9uClH
	 mw5HK5RkyGey4KCJVBj7RS7A1enATegXun/Tf7Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.8 130/172] drm/msm/dp: fix runtime PM leak on connect failure
Date: Mon, 15 Apr 2024 16:20:29 +0200
Message-ID: <20240415142004.331338861@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit e86750b01a1560f198e4b3e21bb3f78bfd5bb2c3 upstream.

Make sure to balance the runtime PM usage counter (and suspend) before
returning on connect failures (e.g. DPCD read failures after a spurious
connect event or if link training fails).

Fixes: 5814b8bf086a ("drm/msm/dp: incorporate pm_runtime framework into DP driver")
Cc: stable@vger.kernel.org      # 6.8
Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/582746/
Link: https://lore.kernel.org/r/20240313164306.23133-3-johan+linaro@kernel.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -598,6 +598,7 @@ static int dp_hpd_plug_handle(struct dp_
 	ret = dp_display_usbpd_configure_cb(&pdev->dev);
 	if (ret) {	/* link train failed */
 		dp->hpd_state = ST_DISCONNECTED;
+		pm_runtime_put_sync(&pdev->dev);
 	} else {
 		dp->hpd_state = ST_MAINLINK_READY;
 	}


