Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062105;
	b=Doo6E9fsS6aQNyxVu7HmYseKiil686DSzLcSMLz3RQZJ/V4o2ysDrjam6STmoEr+npEf
	 T5kh9BAQiFKjGAVBjanOLVapUTMyVfjnteJo8jYfMtEYsFasoL2fUaKwcHqs99qnhREKn
	 eZZUb+IlXMgZ0u0j0ZMHrJ/iz3K+bQPFsffzyU4lkgzzr2m6nEEt1a7ftpO7TriQoWHuN
	 51S7wtZyS7gAkcoJKm5VLkqw53jYH38TND5DwCmwHIBKyoSErvZvcHl8X9RPAGqJSQ+V/
	 sznfWcCPSzXAkQc1vmyZuoEajaNz9K9AMIOgO4eEHxTVkeVUDJJ8N1C8Okzc+1qu6BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eFvSUl1f+w957k7BPpoWLTQcw/WSIQgg6psDCOQ+eJU=;
	b=463U+9IRcD1PtL00IdckorHdT611kOMjNN1L5OgEvuOBuhcgaszV00PEPOeBjHmXIXVc
	 yi7FTg8P3UEBz6ciYUzIUSI2E9CTS9hyZghE3sdvmDCZLhXcKyohURZxowAiCY6G5UTXs
	 R1jrkN0C/AX6A7lMpMgVQCxJx3/KYmky+nNA+XptZ17IKOnMZriDEhdRG0D4FaeyD+iEl
	 umHX/C4I7SglKL1OFfq1ADcUit6uqD/WCK2tahM2tcerm9FMD2hfdLTTygu9y1sUWC69M
	 X2xFGfUnoW/4yc6koiXlsvy1JDz5uiRNPFElrpIZSc5j8lWhj7VuiAEMIeNjgSovFtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CG8cn72j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1017606D839;
	Sat,  7 Nov 2026 14:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CG8cn72j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F65F1F008A5;
	Sat,  7 Nov 2026 14:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062104;
	bh=eFvSUl1f+w957k7BPpoWLTQcw/WSIQgg6psDCOQ+eJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CG8cn72jbGaC9e5IDA4pyenDSmWwrFM42+yPMJRocbr/2ph0ejMMF52ur+sUAv7Fx
	 pwZjyGLLAEjpdO6xQxw+nFpK/5IwAtlqf9EB11Z1VcHjs0V1AQrC1yP9f1Q5nziCUv
	 GhvNDh0MUs+IHeZ2xgugxEzNxXD8SUzAVsfreuTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1029/1536] drm/mali-dp: Fix runtime PM leak in malidp_crtc_atomic_enable()
Date: Sat,  7 Nov 2026 08:50:45 -0500
Message-ID: <20261107135026.576652850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 73ef663c75688168e31dbe9c585b939be410a945 ]

malidp_crtc_atomic_enable() resumes the device with
pm_runtime_get_sync() and returns early when the resume fails.  The
runtime PM usage count is incremented by pm_runtime_get_sync() even
when the resume fails, so returning without dropping the reference
leaks it and, once the error has been hit, prevents the device from
ever suspending again.

Drop the runtime PM reference with pm_runtime_put_noidle() on the
resume failure path before returning.

Fixes: 85f6421889ec ("drm: mali-dp: Enable power management for the device.")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260916102112.2018372-1-vulab@iscas.ac.cn
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_crtc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/arm/malidp_crtc.c b/drivers/gpu/drm/arm/malidp_crtc.c
index d72c22dcf6855..591f71577937e 100644
--- a/drivers/gpu/drm/arm/malidp_crtc.c
+++ b/drivers/gpu/drm/arm/malidp_crtc.c
@@ -56,6 +56,7 @@ static void malidp_crtc_atomic_enable(struct drm_crtc *crtc,
 
 	if (err < 0) {
 		DRM_DEBUG_DRIVER("Failed to enable runtime power management: %d\n", err);
+		pm_runtime_put_noidle(crtc->dev->dev);
 		return;
 	}
 
-- 
2.53.0



