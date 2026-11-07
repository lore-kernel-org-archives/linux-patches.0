Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062922;
	b=o/O42yrkHjoFJw3V43DG0ZGneuycRIbiStDR+351gdI5TphEvwrlb6QpHMd5Ur2cwnTO
	 +CuD1SGTpFSHsome+E2aMqVPWbjt3rzwMPYGNICJl4mwS6FzgbYZ9kqLgfJvPOFLECaj7
	 y871OeYvRi1SQJrhy09r2Oh/x1E8Ys1WPMnL5Y2tIk4S43tGfLRjqL8Au0a5Ho0n2MGpb
	 8XRBnd03m5lyeXybxPkRlQDGWVClkmGHEsj25c3AIClll4MquyyXUgQE+K3jHmmGiP1eS
	 ZMTDEelqMMCdVp+ajNbDWVOVVOtAx9B6D8SlDLs7gQhkDU06vJ3rPk84zatj45+BPzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QZhFGwsCxGv+f/+G9SZkd4NO9L2Jhg/N3B2OozrZ1Uk=;
	b=fW0N/+/ZA/EqJ9lBjTHgDOpaxuMKQMBeW0usC1bTDPFCwuazBUjon8olZqN89YaLo5bD
	 OPUw0onhP7UaNRKp4DHxblZO7QVTN635wYcAmjndA4PDRYB9SW0SJzBoO3rIMynVn6LP5
	 cCwPGcZ5P82DpfDdZoXwJ0Fr7RTBQ1PD1+bENmscQKcfkRBm3vaefPohFpZtEm+0BVRGg
	 Ga1CA8cqrvLI3kqw/GZt94I1lEmRx5JgEtK1+tZouoNFH4+7bAgpp+Y08aMgT3KjOAkvl
	 fe3W49fIpw9dZriU6EfoGraAsNaIfiq46ABgdT8m5rSY+HOKr5eRfY9z1r9kd9PAm7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQVSB5Fm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A07606A330;
	Sat,  7 Nov 2026 14:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQVSB5Fm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D291F0089F;
	Sat,  7 Nov 2026 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062922;
	bh=QZhFGwsCxGv+f/+G9SZkd4NO9L2Jhg/N3B2OozrZ1Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQVSB5FmojydvDKErslYHadJSTE+toLFsYlHOCyD4hTKyzG929HbfgNYraaKYWimc
	 sV3uGEt7UMn20JvUKj0TvjisIFCuSzO8XB35aYypRlObY454Er2ockVnrqhfO8j4k5
	 9eXV5CkxQlVEQ4+oIcTndi5SrL/Bt7agQtzzoWfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 196/869] drm/mali-dp: Fix runtime PM leak in malidp_crtc_atomic_enable()
Date: Sat,  7 Nov 2026 08:47:58 -0500
Message-ID: <20261107134858.700562842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



