Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600C01A6166;
	Tue, 30 Jul 2024 16:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358019; cv=none; b=R+KKqT0QetXCZuFQZ1doCS8sbYPHh4Z8Xx9CUdhFpedtAK0GuyN5wclWIDmzEv2fuEYElUYuMPBaS/WyREzXRiFE3YsdeVCjtDFMik/sWEb7nWBlcE4NZcOZCAcFrHI5pRlp5PaC3Zb5jX1NKpdcWiBCjJZZ3dxt6YzKmus0n0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358019; c=relaxed/simple;
	bh=q9L3Cnn+8ZCGu91BnoMF9ze2lnGSW/kFd/pppSUPO+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujQRpBUTG4JITAFW6NDjX4gt3kx51LzAuN+rguoFNpBr8OpDeKUVEdhmUAISOM4CgSgmcft06huoU2x0d5zPRcpi/XYIwGbqRfcyWkvEBPySDqI0g8bV7HE9+TadRCbZATCExUjCBR09tvyO6R0i3zwg+/iGG1e3qUr2W1KP1mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QD7R9qxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QD7R9qxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9B4C32782;
	Tue, 30 Jul 2024 16:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358019;
	bh=q9L3Cnn+8ZCGu91BnoMF9ze2lnGSW/kFd/pppSUPO+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QD7R9qxxK0cXu4AEnATTlaAGVel/7HHx2jvWssjHlnK/Hxq05EQlz7HTgOkvhZ0Rc
	 O5TO4VPCiX1JyWDKrrlgmYL5FD2OTNvyyWnHweTQOhRz94Wmtcog0mfvK4fs72zZ6y
	 sMHr1mofS6pzpcK9Vvn8oRJU/cnKku1SpL3d1FR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sean Anderson <sean.anderso@linux.dev>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 315/809] drm: zynqmp_dpsub: Fix an error handling path in zynqmp_dpsub_probe()
Date: Tue, 30 Jul 2024 17:43:11 +0200
Message-ID: <20240730151737.040236807@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 4ea3deda1341fef7b923ad9cfe5dd46b1b51bfa8 ]

If zynqmp_dpsub_drm_init() fails, we must undo the previous
drm_bridge_add() call.

Fixes: be3f3042391d ("drm: zynqmp_dpsub: Always register bridge")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Sean Anderson <sean.anderso@linux.dev>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/974d1b062d7c61ee6db00d16fa7c69aa1218ee02.1716198025.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/zynqmp_dpsub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_dpsub.c b/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
index face8d6b2a6fb..f5781939de9c3 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
@@ -269,6 +269,7 @@ static int zynqmp_dpsub_probe(struct platform_device *pdev)
 	return 0;
 
 err_disp:
+	drm_bridge_remove(dpsub->bridge);
 	zynqmp_disp_remove(dpsub);
 err_dp:
 	zynqmp_dp_remove(dpsub);
-- 
2.43.0



