Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211249;
	b=ggteyTBqbxKKIPoezYBwB6Tqgwg9UwJChbSIVK45J4RwUONFzu3S4kQYytGk90xSDWov
	 lOgIjPS+KiRj48nFYKP6Vy5zI9BEiK9xSpnj11ARMRtfOAFKAoOb1+Qy9IttcZ/2s3CFi
	 dyG/Umh7bO+zLWE1g+QTd+8D48TsJGNdXowSIfNx+PRukNqGGxPFj/NA5H9ez0Sff94Cl
	 ARwU9XfCsXXRf9lZaAD304Wwbls9v0iHDoHkC62B4nr/N7eY9tTKMD3Y99XNsyX5Z22Rp
	 BImwThIFdkVBeqvLC7T3PKl74K989FGLEUxWeX9Kp0D+iuATOFAcF0FyMoG8H5cmfmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SA7CR1ima9ptwi2UhtHqYbf5aTIvWLlUNfSTBaU5lhA=;
	b=KgbRAeuWrun/ImAZlJ6Rteql1Pn8u8/8Imk0T67cGhYaG7bj2rKtm3NK1u6Dg1tR4I0G
	 zdZ9cvwrmdcCsYH48WAdc1LvidnZSsbrGpzHh57R+WXlVugsdvR+Uv3z2HznBjDQ1lOWy
	 m93rdGPSM504M82hx0TYh6Jif9wmGKlTtF47APd+r8iCfyyV8TIEfaa/8SAd1ITitZmpT
	 axtOHFPJOfI55dX3DSuun9Rj+ZYwZVJgJWTbN07Ij/4dCuDuHtQUgGOOuwIcEejwHCCar
	 tUUPfklHljyCUzMl10NrFpNnb7IZuzTwbVSvqT955qZU9plmdmFcL9PPp3V/Cm6Zdhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PET4gsTt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F8560A3801;
	Wed, 28 Oct 2026 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PET4gsTt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E0E1F01825;
	Wed, 28 Oct 2026 18:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211248;
	bh=SA7CR1ima9ptwi2UhtHqYbf5aTIvWLlUNfSTBaU5lhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PET4gsTtnVOpziOmT8i2K5XKNF1JcKc0fQ0oRfyVZgXdYqltnzwPsljqI8DXatw1Y
	 /zYA2543jntXa6A2Ds3i+gd3lW2z/XdUgXl6CPhblH8WrNquRpfKQKDbAMYBLoD9nA
	 htci57+Zxn8HTOxD4Ure7l0xddRR7zENcLYT0EcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 309/571] USB: dwc2: shut down wakeup timer before freeing HCD state
Date: Wed, 28 Oct 2026 17:57:36 +0100
Message-ID: <20261028170015.330736230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit fd772af9512cdecb83de34a461801533828e77fd ]

dwc2_wakeup_detected() accesses the DWC2 host state and can rearm the
wakeup timer.  dwc2_hcd_free() currently deletes the timer only after
freeing host-owned state, and timer_delete() does not synchronize a
callback or prevent it from being queued again.

Stop and shut down the timer in dwc2_hcd_release(), before the HCD
resources are freed.  This covers both the HCD initialization error path
and normal HCD removal.

Fixes: 7359d482eb4d ("staging: HCD files for the DWC2 driver")
Cc: stable <stable@kernel.org>
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260904065323.4047026-1-runyu.xiao@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Adapted the timer removal hunk to match del_timer() instead of timer_delete(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/hcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 109b02830d882..cfc02759f4921 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5115,14 +5115,13 @@ static void dwc2_hcd_free(struct dwc2_hsotg *hsotg)
 	}
 
 	cancel_work_sync(&hsotg->phy_reset_work);
-
-	del_timer(&hsotg->wkp_timer);
 }
 
 static void dwc2_hcd_release(struct dwc2_hsotg *hsotg)
 {
 	/* Turn off all host-specific interrupts */
 	dwc2_disable_host_interrupts(hsotg);
+	timer_shutdown_sync(&hsotg->wkp_timer);
 
 	dwc2_hcd_free(hsotg);
 }
-- 
2.53.0



