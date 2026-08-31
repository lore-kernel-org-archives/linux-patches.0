Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E89043E074;
	Mon, 31 Aug 2026 13:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184752; cv=none; b=EY093/dd1AUFDOVhBtkT4prT2xT8D5VQmOlZK7ALmMEjBnFtm3s/3anvmEp/s1o9INkEUn6X2oMz4jKRzKG4gJh0h6y+0z/2TawTb0eogOHT0ZjmSM8mfrTw9/CYVCPX45EYIO+RSnPHJyoRgTizEfZlMg6qgPbX0Nvfte02oN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184752; c=relaxed/simple;
	bh=9clxBcnm8JQ2lZXUS9YC5ZiOZC1ClWfpunFmXokUKZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVA5FWS/7yeo4g3HCz8vaQ29mmaLpBj1086x40b+MPd6OU/Atyf0tGvLFrg04MHfczhDwgcy8wtLccNfd1HDufHmsdRCdlTCRmmPBXKfCnPpFdudYtKUeSRzchLgpKyZrl54z3eskVfQ8/kyE198C9ZfhUyXJ6PI4hG5ixOL08Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wxa3cwvq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wxa3cwvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692401F000E9;
	Mon, 31 Aug 2026 13:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184751;
	bh=/zGnFSC313eAe7qzR19jlIFC2jQezd1wL9Xk3jROoyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wxa3cwvqtDqbLztB9O766XunBpOI1DK8KKeYw06AyrD7J/l7MVlX+WsmJyPD1xIbF
	 xiQa2Fc5MEKCxw0XbNmSe2Nx0NrA/pw74vz53Hc4jhrT4FikVCkBgyOMxzMTi5+SSp
	 XHA0xAGhdg+w+9y2br3uYBC2fG7MXsl3+7+adTHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@redhat.com>,
	Karol Herbst <kherbst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 09/92] drm/nouveau/kms/nv50-: init hpd_irq_lock for PIOR DP
Date: Mon, 31 Aug 2026 15:34:07 +0200
Message-ID: <20260831133359.966321263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit ea293f823a8805735d9e00124df81a8f448ed1ae ]

Fixes OOPS on boards with ANX9805 DP encoders.

Cc: stable@vger.kernel.org # 6.4+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230719044051.6975-3-skeggsb@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index a851354c0c5f8..2bed699cadb47 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2018,6 +2018,8 @@ nv50_pior_destroy(struct drm_encoder *encoder)
 	nvif_outp_dtor(&nv_encoder->outp);
 
 	drm_encoder_cleanup(encoder);
+
+	mutex_destroy(&nv_encoder->dp.hpd_irq_lock);
 	kfree(encoder);
 }
 
@@ -2062,6 +2064,8 @@ nv50_pior_create(struct drm_connector *connector, struct dcb_output *dcbe)
 	nv_encoder->i2c = ddc;
 	nv_encoder->aux = aux;
 
+	mutex_init(&nv_encoder->dp.hpd_irq_lock);
+
 	encoder = to_drm_encoder(nv_encoder);
 	encoder->possible_crtcs = dcbe->heads;
 	encoder->possible_clones = 0;
-- 
2.53.0



