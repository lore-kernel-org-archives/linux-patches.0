Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040833;
	b=dHW4Q0ErN4iRuZyrPCW/fMDd3ix+ftBmzyJQX1qLWcJEx+56r2rkvNbnycd68Q2khL/B
	 iXvsg9UAWnYFotXQhO0AbQykya44tX+HCo1hzBTnrPyQR1BhCX3mxjJFAlOVDp9s9Zi8G
	 Lll0b2Hcpl3zKpf74hVtRe7dAilnP8S0/m/vLtd8OUWFtvkYcu0IcmF1egOZvi+Zy8WNL
	 WGnGgCdQNXr/v3JsCD4dft9S5hXl19GJPrR0zH+QMyfCpLjtRfUsrz1ycjUP58xpWmTl6
	 Fpwhv3OnpjqqHkbzG7qi/ThSAKrCvc/wPIhvi6nqwhF034QB0nVVYy+bmfeEF0oMdvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nb/xlBzyijW8v7KFQfroDfQNN9GDfaMvIOSgBliDYFs=;
	b=a50RlTjneT+KZSNmfy4UsBDM2KhEfBw2uc/gOrLFlU3i75kiRC7qb5XgCGBt+6BRAOUD
	 FNF9wFVgts7qLKc9B9Dbb/zLOnHlwziZf6FxaUCE5aU48ixbqCqmw9j85mO/ghNjzFnYK
	 Odq0IsPo/RmKeBiItwOAaSe6rZcDBLMmohFxdmXrcnebuN5+6U4aE2a2VzTcX6shxvYND
	 4tXdos5zr1GWERGTXGpgigUuy5RAexu+6I/Ns0Vo6gq8Y8M2G+wP3/CHAusEeC0qHAt3O
	 8ZNNYR4z0gndbCjCvd2VviOXxnc+Vcyi6WLXL80kfiv6P088S0zzjbgwvN0KtjcvSew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UAMT0mIZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8448D606A31C;
	Wed, 18 Nov 2026 22:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UAMT0mIZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A4A1F000C4;
	Wed, 18 Nov 2026 22:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040833;
	bh=nb/xlBzyijW8v7KFQfroDfQNN9GDfaMvIOSgBliDYFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UAMT0mIZj4ccpvF7+Zwia8dvHDXzxV2+Ts3UKv0/kB9SvZp2Mutw3c2kLUd/wpC7L
	 Aryb0cjumVwuNL6O4tppI4fKJ9Lk7dOmZ8Mx6rxtcZWf0h+zgL4igt81yLgUuuYk9H
	 mT+7uIIqU+efyqvkkda+jxJbN+F0L8FKKjXN5NH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Demidov <roman.demidov.nn@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2599/3318] drm/msm/a6xx: fix use-after-free of OPP in a6xx_pm_resume
Date: Wed, 18 Nov 2026 15:53:41 +0100
Message-ID: <20261118150439.138192712@linuxfoundation.org>
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

From: Roman Demidov <roman.demidov.nn@gmail.com>

[ Upstream commit 8128ae7af6b4dc95e486c5c0a80839a069df578e ]

The OPP reference obtained via dev_pm_opp_find_freq_ceil() is dropped
with dev_pm_opp_put() before being passed to dev_pm_opp_set_opp(). If
the reference count reaches zero, the OPP object may be freed, leading
to a use-after-free when dev_pm_opp_set_opp() dereferences it.

Fix the order of calls: first use the OPP to set the required
performance state, then release the reference.

Fixes: 5a903a44a984 ("drm/msm/a6xx: Introduce GMU wrapper support")
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/757104/
Message-ID: <20260929142103.81854-1-roman.demidov.nn@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 58233ca8d1d39..fe223823deae8 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1948,10 +1948,10 @@ static int a6xx_pm_resume(struct msm_gpu *gpu)
 		ret = PTR_ERR(opp);
 		goto err_set_opp;
 	}
-	dev_pm_opp_put(opp);
 
 	/* Set the core clock and bus bw, having VDD scaling in mind */
 	dev_pm_opp_set_opp(&gpu->pdev->dev, opp);
+	dev_pm_opp_put(opp);
 
 	pm_runtime_resume_and_get(gmu->dev);
 	pm_runtime_resume_and_get(gmu->gxpd);
-- 
2.53.0



