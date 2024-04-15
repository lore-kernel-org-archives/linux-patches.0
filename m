Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0BC7F7D1;
	Mon, 15 Apr 2024 14:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191403; cv=none; b=eMt/EYK/rQDed6cut7KhSzib7F/aujs63h/NUsmuP7TucPlxlQV/+wv5A2jt8kUpGFkU8JxxlA9pH7Jh0TYCzRI3M/ex4EQGsInmT/xJoRbfvTPQxvChsZ6xPgnYwQ+4y+IYBVCPPuvetP6mrwAo5Y7weyX75Guhc8AxXMTodQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191403; c=relaxed/simple;
	bh=o0gUuRM4EjdAzkkjC9AXUE7Q5rWgMOC/P0Tx3/J5Mw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pe+6Jgl5GE74+EYw+OeEtSl26WdcmPNS34IE2a2eQkALeQLsn/lfIPnBMXleuKRboO/wmTqiHh2dw5xcelwEhxIyVKvLeiMsqGJ04waXozhSK6bs/xY5SVOyhkU2E83u4C7kwu6znU2Y131B8vgbSRt6Aat2zRX/UvctOeGuIKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkSmUrXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkSmUrXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37760C2BD10;
	Mon, 15 Apr 2024 14:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191402;
	bh=o0gUuRM4EjdAzkkjC9AXUE7Q5rWgMOC/P0Tx3/J5Mw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkSmUrXcaepdYLC08goDGK0uhKBgw3r6Y5MwEeBFgPFt/4aJSZbEnJl2GFuKqBqqo
	 LyLS2FmRPBhGoHO6OI8Z73BF+N/AvJZSWQXSBthvKrJK2pHlcP6qM+mhOVyvh2NaL1
	 7/kl42kfB80vJemtbTlEfvrpSshoCJj/5Sbizoxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.8 129/172] drm/msm/dp: fix runtime PM leak on disconnect
Date: Mon, 15 Apr 2024 16:20:28 +0200
Message-ID: <20240415142004.300860482@linuxfoundation.org>
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

commit 0640f47b742667fca6aac174f7cd62b6c2c7532c upstream.

Make sure to put the runtime PM usage count (and suspend) also when
receiving a disconnect event while in the ST_MAINLINK_READY state.

This specifically avoids leaking a runtime PM usage count on every
disconnect with display servers that do not automatically enable
external displays when receiving a hotplug notification.

Fixes: 5814b8bf086a ("drm/msm/dp: incorporate pm_runtime framework into DP driver")
Cc: stable@vger.kernel.org      # 6.8
Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/582744/
Link: https://lore.kernel.org/r/20240313164306.23133-2-johan+linaro@kernel.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -655,6 +655,7 @@ static int dp_hpd_unplug_handle(struct d
 		dp_display_host_phy_exit(dp);
 		dp->hpd_state = ST_DISCONNECTED;
 		dp_display_notify_disconnect(&dp->dp_display.pdev->dev);
+		pm_runtime_put_sync(&pdev->dev);
 		mutex_unlock(&dp->event_mutex);
 		return 0;
 	}


