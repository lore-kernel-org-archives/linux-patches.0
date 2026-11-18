Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046858;
	b=Tl07VHxmvnpiOfC6KM6T5J14b/2zwFJgYo3MwVq3GSXfC/RRL1U4iMX85UaoN00idXDo
	 mX0q+Jp5oH9/o/vhAiHP+FiFwO1SqsM0isbOXjK+K/StCckbmex70ZQSwC+BgIZpUZ7cu
	 5CR61j4qnpCPa7ZsMgXHFt/uOha9igczTDIpTAsDyKoEDroq0Jwwll+le+fFapGR9oZWU
	 cq3YD1OSqeaQjSYd89HSf7r8H/e/kxlphLnE1ypCIYnHK1xwuoIsb+2z6OkuFVnhEP/Bh
	 Vs5yIjR0cZPLDN/C86Dacm4SFCwkakeLWo62ZrfsFT0t25z3lHOcAQUDZZoC1MZQL/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q15QdTSM27bAFll5A33eMO29qtJkeYl9Cj6H2iyJdoI=;
	b=cZpTV2Ff5VtkOkKw4mdB/XJ0DVRMiA0CQoI7U2kL9tmD/m9dVnFjhNKP8cU1VtXNUN5E
	 paRv7WkLZwhFrtnKhmJO6IHZa4JdvQ9MRhtrOvBmwzXxyFdFm/EYSe15q4v2HTEZ0vcL2
	 ECjS9x39YEOmjpcOS7GqvN+2vmUxfAyZiL/avp3sdNbPcuxCbDPQcZLkpzGOIwqSmz1ui
	 Ta9mGtUGUAURqgjEjl4Q72vkLjUHwkXgyCvO3adpQwPMlAutHc9swjsRBw2Og9JUiJ7h9
	 RDuQ1v1TwMWvu0cxuq9ZtFRtSOp0M3IiLusUudYqIRC4qge9vX3Mjv3RwPpRy7FNfrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+nbNcEc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF2A606A333;
	Thu, 19 Nov 2026 00:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+nbNcEc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFFD1F000C5;
	Thu, 19 Nov 2026 00:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046857;
	bh=Q15QdTSM27bAFll5A33eMO29qtJkeYl9Cj6H2iyJdoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+nbNcEcVpahXtqUBAd0RqQyT7Ne9R1KoarildBWz2s1Wvyu2RepahBl2hXAaGTdK
	 Dvx/5aDCvoBWP0JucUcuzXF3aJr7VDxydicaLGnA+iJsIsGN0B4sIOOPcBYyn4W9Gx
	 jtWaqfsWtDOPki5mnx3hTHgzmPj1BqU0XEf858zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Rob Clark <rob.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1432/2857] drm/msm/dsi: Fix VM leak in dsi_tx_buf_alloc_6g()
Date: Wed, 18 Nov 2026 15:41:06 +0100
Message-ID: <20261118150252.870626568@linuxfoundation.org>
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

[ Upstream commit ab91ba61871a896ca2ecc6e048d80a152136da44 ]

dsi_tx_buf_alloc_6g() takes a reference to the kms VM with
drm_gpuvm_get() and stores it in msm_host->vm.  If
msm_gem_kernel_new() fails, the function returns early without
dropping that reference.  Since msm_host->tx_gem_obj is cleared on
the error path, msm_dsi_tx_buf_free() will never see a non-NULL
tx_gem_obj and thus never calls drm_gpuvm_put(), leaking the VM
reference.

Drop the VM reference and clear msm_host->vm on the error path.

Fixes: 5e05be782645 ("drm/msm/dsi: free TX buffer in unbind")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Rob Clark <rob.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/754332/
Link: https://lore.kernel.org/r/20260916175738.2089950-1-vulab@iscas.ac.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
[ sashal: Replaced drm_gpuvm_put() and msm_host->vm with msm_gem_address_space_put() and msm_host->aspace. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 634e42630dbf2..5a2d41ba37b78 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1147,6 +1147,8 @@ int dsi_tx_buf_alloc_6g(struct msm_dsi_host *msm_host, int size)
 
 	if (IS_ERR(data)) {
 		msm_host->tx_gem_obj = NULL;
+		msm_gem_address_space_put(msm_host->aspace);
+		msm_host->aspace = NULL;
 		return PTR_ERR(data);
 	}
 
-- 
2.53.0



