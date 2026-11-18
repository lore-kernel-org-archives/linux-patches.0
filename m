Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018692;
	b=M59gS271Po59cLWpSh6PbkJhPR46ahqtyjKuUd9JFXryg71zDGwIbsB8QZEcMETEYfXQ
	 u9FMoBMGcBnUQSzv55fsKZSmAlU/Op5MmaZFze9YdReVrEg8sZ6iBR0shulJtOA1qiWXj
	 /v4pX2eXHOMdlgyUVjUaPMXg7tgQK7Bjx59riKBJCvhv1t+qRyJ6MHpRK/6L8QpI6lzIv
	 DNCent6UivZv7ZRX8LMOMoGq1k9ajkKux8yxAg9nJngix5JxiYTB//RDAgn44tzxF9kMZ
	 ISVlHsJODADK1KTh3Gg+iCA/4ZO7uwrbM/q5gr5HuFLFgB7l9GnCSqULK0gqKGHqsaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=29IP/kbzu0QvsyN9pcIIGYo+XTfE+vScghdUbmlim28=;
	b=wwxFAzzZV//fSvonXbvl1bhG/z6+nUN0WPWy5uWxHPHJsyIRRYZ4PzsDKs9Bt0lxArcS
	 yFflJ5OquzmrvvBkL6WfbvTVygoxyVEH9hRHcVg4QpII70spS6wbz8aF4jKgzxyN7pKgm
	 HTCRk9Qlqz/3Xj3eAgZFu8+DLYI0cNcLDtXFhmGkum1z9KtpZKpUwauzlA5J71Ea9BdsF
	 cJh4cRoGk0IyuwdGlShfdEucJa6v9yIxKqmd1fNom8F0Zuc7W5+2e+LRFU9nkIsTAvAgz
	 o99DddV3JIc9dX1gH6OwlZeELWIuFSXB3Rh00dJ7600zOMujp8gqiRHiqXPkRgS5Wyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SYkQKlAb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035BA606A331;
	Wed, 18 Nov 2026 16:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SYkQKlAb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FACB1F000C4;
	Wed, 18 Nov 2026 16:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018691;
	bh=29IP/kbzu0QvsyN9pcIIGYo+XTfE+vScghdUbmlim28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SYkQKlAbIKZRQXGvtCx8cBIp9MQ4MNF2vMKZ/GuHeqSUo+SYmiMEaPQRYZ1Aik13X
	 lsr98QlMM9hny+46dGEenQIze1REph69AmkvvLwsrz8cEjJ2Q5mNYnVh2B4Y0F8Z/O
	 OfimCBv30lwWCxm6HAMxmAi8MG8jGVaSa4JfkbLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Demidov <roman.demidov.nn@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1330/2651] drm/msm/a6xx: fix use-after-free of OPP in a6xx_pm_resume
Date: Wed, 18 Nov 2026 15:42:50 +0100
Message-ID: <20261118150335.887775290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 081e79ea46528..33424eb8cd9df 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2183,10 +2183,10 @@ static int a6xx_pm_resume(struct msm_gpu *gpu)
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



