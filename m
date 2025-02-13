Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4669D1514F6;
	Thu, 13 Feb 2025 14:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458668; cv=none; b=CPdsSTbwlLqdPg3EzWQwuKjIUc18ptCPntruZ8/JjxRZI+38IWmOcRdajbjdrziEzcqKxT2jyKES4XMXosCyqXh82EOaa+1p84udW/bj4KIp19QLbI/NnOryfesFYtaxGLAWQBddkgUhnRdKYE7ZroLieI2by4qiaAlmKzNj530=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458668; c=relaxed/simple;
	bh=kL8Ol9E+SQMXkCOZLXTXxw3EJQlK/+H9cON34g9q8hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDuwvtZpem3M6kkWkKLUR0JP3iRVcxfbsLTQjUUniZOeqEdZpWXtkqXgTbrH4klGxQzzPnQRcwXUbYcvCgYG3oG+wotV0LpKhe6bTJa+8KkeyzHMnGyV0uMJpVJq9HZRyy+dCWEyHKoyHcbOJriaDiL3kWoFAfJdr5up1TYDYMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUqSfa39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUqSfa39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFA9C4CED1;
	Thu, 13 Feb 2025 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458667;
	bh=kL8Ol9E+SQMXkCOZLXTXxw3EJQlK/+H9cON34g9q8hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUqSfa39Fst/u5RtiT3XcNvG9Z2WmranPEFr3oNkWNwXhIxhOp2DLqduGjuZksLDJ
	 fkns9V6dQzKuVkoDwT/pdUexTT+CFMoDjFjV9LfzKlutR/6ASE0spJ/SRj5Zt+YbUq
	 Omx6ukKsqeVRKTg3GOI3evdgu9gIqi249Fvg3PnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Hermes Wu <hermes.wu@ite.com.tw>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 045/443] drm/bridge: it6505: fix HDCP Bstatus check
Date: Thu, 13 Feb 2025 15:23:30 +0100
Message-ID: <20250213142442.363174730@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hermes Wu <hermes.wu@ite.com.tw>

[ Upstream commit 0fd2ff47d8c207fa3173661de04bb9e8201c0ad2 ]

When HDCP is activated,
a DisplayPort source receiving CP_IRQ from the sink
shall check Bstatus from DPCD and process the corresponding value

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Hermes Wu <hermes.wu@ite.com.tw>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241230-v7-upstream-v7-5-e0fdd4844703@ite.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index d55d7dad9545f..0f7d50da56835 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2312,14 +2312,20 @@ static int it6505_process_hpd_irq(struct it6505 *it6505)
 	DRM_DEV_DEBUG_DRIVER(dev, "dp_irq_vector = 0x%02x", dp_irq_vector);
 
 	if (dp_irq_vector & DP_CP_IRQ) {
-		it6505_set_bits(it6505, REG_HDCP_TRIGGER, HDCP_TRIGGER_CPIRQ,
-				HDCP_TRIGGER_CPIRQ);
-
 		bstatus = it6505_dpcd_read(it6505, DP_AUX_HDCP_BSTATUS);
 		if (bstatus < 0)
 			return bstatus;
 
 		DRM_DEV_DEBUG_DRIVER(dev, "Bstatus = 0x%02x", bstatus);
+
+		/*Check BSTATUS when recive CP_IRQ */
+		if (bstatus & DP_BSTATUS_R0_PRIME_READY &&
+		    it6505->hdcp_status == HDCP_AUTH_GOING)
+			it6505_set_bits(it6505, REG_HDCP_TRIGGER, HDCP_TRIGGER_CPIRQ,
+					HDCP_TRIGGER_CPIRQ);
+		else if (bstatus & (DP_BSTATUS_REAUTH_REQ | DP_BSTATUS_LINK_FAILURE) &&
+			 it6505->hdcp_status == HDCP_AUTH_DONE)
+			it6505_start_hdcp(it6505);
 	}
 
 	ret = drm_dp_dpcd_read_link_status(&it6505->aux, link_status);
-- 
2.39.5



