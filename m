Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036963;
	b=vErKZc2eJYXv8k8x/Of77g0uNvV32awqSdEvn++mORB+6levtzGUS0YZYXz65t91hu6L
	 rE0/5dTPEMLXaQaETN6wGCPNfNsDSdWz9b4mwZmUAM4gn0GkLe8hz76gJv/28TtfIfstJ
	 FRMAnW7E5GFNgowUxV3Pfpn5FxuPUDpAJBVjjtI9k+mwps5C8ItH1GppF889kh3+5GxYr
	 c12Qab6kYp+Do9EZndwb3qQQmEWq+34t9Eg2XWtcke+qyfqfMCzbLH/iZDXJNS9XG1X1p
	 yi9bOJajEhcfXBzes54XvqklSI3tmow/TDTy9a9FBBumTgZ0lRFavvWMcT52zlJTsvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f5gUDsx2kXAJ4+dbM4ySrJsDnutVQOrBZpBPd7i8U8g=;
	b=MLn+kCLN9KawxwFEDv7VOeCsTfP6NpSiom6DhxfhrjpYWjkSPowDwelH5Comvf12MG3M
	 t4FZPwwocljzL+wlRIfTgjnZm/2Fq/alqE9qwt65RpngLFMHEO0DHscb04Wqn1KcFjQGr
	 8GausjpooK0aEs+kDSW0PdTOKupAwx5hlglV+GhyjIO7FfjJriBk/EbuXBAmw2FAz84H1
	 KJRHZb8Imr6c8GyaDGpVZ2iuvcQkCbes9Bry1ddGxahzTGmorSLrSWC26lHgAcE6b/QMx
	 7Es4UUi0v/zdFK5go2I4+hiUdUjtulVjntWA8+UHkx7qZvMcbWpJeYgmpcMVfQY8IYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Kbbz1VF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43640606A336;
	Wed, 18 Nov 2026 21:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Kbbz1VF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EFD1F000CA;
	Wed, 18 Nov 2026 21:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036963;
	bh=f5gUDsx2kXAJ4+dbM4ySrJsDnutVQOrBZpBPd7i8U8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Kbbz1VFg8b6m5svqMSHPXfxPUAVjbYFFtn4MXieWoLJkdKNFEETKDWCleAdRmNnr
	 Cv02ydGHtoP9SFGCmYkJdTA04hxsy0icYbI3vM65xGdlVykVMRGBscaqfJwKHGG/kg
	 RKj32n7/IhLTCFsNtwGB6onQu6L0J47Mo+TJzOYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1202/3318] tpm: tpm_nsc: stop using the cleanup callback as dev.release
Date: Wed, 18 Nov 2026 15:30:24 +0100
Message-ID: <20261118150356.231461053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit df0ef271087623439a1e900f323ed2a57204706d ]

tpm_nsc_remove() is called explicitly from cleanup_nsc() and also
runs as the platform device release callback on the final
platform_device_put(), so the cleanup executes twice on module
exit; the second invocation operates on a chip that has already
been freed by the devm cleanup, and the I/O region is released
twice.

Overwriting the release callback installed by
platform_device_alloc() also keeps platform_device_release() from
running, leaking the platform object allocation.

Leave the default release callback in place; the explicit call in
cleanup_nsc() remains the single cleanup point.

Cc: stable@vger.kernel.org
Fixes: 570302a31149 ("[PATCH] tpm: move nsc driver off pci_dev")
Assisted-by: GLM-5.3
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/a6155310e6772f708b47291cc959e02c05b90eb7.1791015549.git.xiaopei01@kylinos.cn
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_nsc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index bec0b1fcad27a..c33d49172df23 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -326,7 +326,6 @@ static int __init init_nsc(void)
 
 	pdev->num_resources = 0;
 	pdev->dev.driver = &nsc_drv.driver;
-	pdev->dev.release = tpm_nsc_remove;
 
 	if ((rc = platform_device_add(pdev)) < 0)
 		goto err_put_dev;
-- 
2.53.0



