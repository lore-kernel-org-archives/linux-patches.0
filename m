Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045077;
	b=GHe2Oo3hmMtflDK/moAb5LjrOUKZLJYHDfSD6Wevp5c2N5JV73skJyh/d0TEehH+yBH/
	 c3CMH6LsStOz3y7bc5dHgo4u7evSR/3M3fGfoDQIpVWE8+rZx73EDAYjjc1fNueSeKNSL
	 L++ldQnoULlh8SaLsiEzv5L8MEpz/SOrpoOH5RjNTR3YWxK0eWp3E5HiFbGObXDZOPDr2
	 thzW6vePbImmhgPxOGblyPp/sOFx/fukVN01VTpteSF0wNRH0xsXRnaYl5DpsexYjFYv1
	 eiRSVw5c++7NZUGmrag4CS6TAdSJ5LBygztM3k00/l9SrBDRyHpYzCQDVKJkfN/5+ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o2LaNc1FOwvdP8dcaVg7K1If+ijIcrA9nYDCTeLoLTs=;
	b=tJ0aQWEYJfxan6y5aTlWdV5oK/u/GAawfWeC4j5TFypDshdgAMP8ETRbXvwKvX1d/29F
	 KYKES/ek1tldedyJfda9YpLErB7JNRY+K8NQ4g33QRxBmfdGWrFzamPlvguJSCpB3gnQu
	 m49BfQADtOIMmoRaQnoAYMcbf5IYDqMFxHxll5fs8pyuPCeH2x14y/XW382xk2Lt91LcV
	 kigI+lzQB2GmIktOpiS3P04Y9iFQmQ+ETa4OM45vpEMxi5L62XJeOnSpJ8qRy+55sodYc
	 q59SUBks3uZMHWbrSuuJCtOQGHcdfkp4iH7iN/8Y+bjGcaYbH0ILaK4Q2b8qQRo8H+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJqWLLrj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59933606A337;
	Wed, 18 Nov 2026 23:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJqWLLrj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5591F000CA;
	Wed, 18 Nov 2026 23:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045077;
	bh=o2LaNc1FOwvdP8dcaVg7K1If+ijIcrA9nYDCTeLoLTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CJqWLLrjWL4lLXWz8xYmzQJah0Q4Zw9FXoFsHSQVLlM/zSbAX2SYVOhKrd+P8dbc6
	 QwNE3VoagtyO1CVZl1C3GwdTdGikeXDO6STAyhZ9q6ya0MhOlfLr0Je6F4mlpmapr6
	 Uf6co7zCPEN+8mt8MnVk4bzRVctcdcNMPqITloE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0796/2857] drm/mali-dp: Fix runtime PM leak in malidp_crtc_atomic_enable()
Date: Wed, 18 Nov 2026 15:30:30 +0100
Message-ID: <20261118150230.237220727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 962730772b2ff..c1319b1612971 100644
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



