Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2071FF7D1;
	Fri,  6 Dec 2024 14:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497012; cv=none; b=berhb7HDrM49Jc9lRaSi0GAAIgcz4WPmcCEibIFCMJkWc8vOWMIE/a2X7YQF7vm/GKa3s5o9OHkNbOeQTgs72p+wFXsPc+aAnv804rHMwYEjwgxDz240Txoi+8v4Ots/8ciaM3VVaJy/KyA46TjLO2uJ//ZRb3ezCSdtRPBXlgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497012; c=relaxed/simple;
	bh=QginPOWwUHoZwCGwnPyx3rsoEqTtOpxDUZxeM/yqbDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4fjiyJWmcwNP3D4VIwAPYozywgnt/iQAYklC/ySkXJYte8iZssQScYpLe9lI4PQWBFhP56DJXyMUnhVfSUnpVavDTxJNWGBHXA42p9T8goU7Uq+uCQl/t3HdAXEf5zx6XRM4tZtpZ2XaY2Ar9Oqu3Lm2ZuTPi5Tr/5S26jvQRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8qujCt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8qujCt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3A4C4CED1;
	Fri,  6 Dec 2024 14:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497012;
	bh=QginPOWwUHoZwCGwnPyx3rsoEqTtOpxDUZxeM/yqbDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8qujCt4UU7Lx2uDcC12EpLeNEKrjEyhQmSg8vS7bPcCtb2dgQSDfGQ/NFso1cqeF
	 t5AMNgenxPKyr4hAYVn86MxyrdpqY36EEedvJyhC7ZdFVPgkHxTnjHsE+KhkEc0bfZ
	 vKiHNmexZaCrleEHT5U8NgQTE+kqg0f/4KJnz9Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/676] drm/vc4: hvs: Correct logic on stopping an HVS channel
Date: Fri,  6 Dec 2024 15:29:48 +0100
Message-ID: <20241206143659.952361398@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 7ab6512e7942889c0962588355cb92424a690be6 ]

When factoring out __vc4_hvs_stop_channel, the logic got inverted from
	if (condition)
	  // stop channel
to
	if (condition)
	  goto out
	//stop channel
	out:
and also changed the exact register writes used to stop the channel.

Correct the logic so that the channel is actually stopped, and revert
to the original register writes.

Fixes: 6d01a106b4c8 ("drm/vc4: crtc: Move HVS init and close to a function")
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621152055.4180873-32-dave.stevenson@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 3e72219a6a75f..27c8fb9efa854 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -420,13 +420,11 @@ void vc4_hvs_stop_channel(struct vc4_hvs *hvs, unsigned int chan)
 	if (!drm_dev_enter(drm, &idx))
 		return;
 
-	if (HVS_READ(SCALER_DISPCTRLX(chan)) & SCALER_DISPCTRLX_ENABLE)
+	if (!(HVS_READ(SCALER_DISPCTRLX(chan)) & SCALER_DISPCTRLX_ENABLE))
 		goto out;
 
-	HVS_WRITE(SCALER_DISPCTRLX(chan),
-		  HVS_READ(SCALER_DISPCTRLX(chan)) | SCALER_DISPCTRLX_RESET);
-	HVS_WRITE(SCALER_DISPCTRLX(chan),
-		  HVS_READ(SCALER_DISPCTRLX(chan)) & ~SCALER_DISPCTRLX_ENABLE);
+	HVS_WRITE(SCALER_DISPCTRLX(chan), SCALER_DISPCTRLX_RESET);
+	HVS_WRITE(SCALER_DISPCTRLX(chan), 0);
 
 	/* Once we leave, the scaler should be disabled and its fifo empty. */
 	WARN_ON_ONCE(HVS_READ(SCALER_DISPCTRLX(chan)) & SCALER_DISPCTRLX_RESET);
-- 
2.43.0



