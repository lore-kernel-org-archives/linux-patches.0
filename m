Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621693;
	b=K9JClbxBl/Af1Jorg225t0sD6E97rv21FdF8a6PmlJy1ejP7dYlODIGBMnm6dBDssW6z
	 HVIRmcYFKcEigw2SOqO1zdiNaEGBYayTSfo0gS2X/4159qzFJkW2bYnmnEYYPgs3oxO4z
	 UKCxbEabRSKT7W84lnwX04FWi8SJsnKvaWDgGBJfkT4hiLFAIsVbTpGT2/uFp5WRGQoEp
	 /1dxOAHN76E7N035shu3ZmwvcEYX/A6Gs/XQpM8w6xVqlmi9tZXp7uheu+CUPsiZID9zR
	 NI3tLqIb0YaPtMk96S1RMoKudOYnW5BojLYpJfcCxP7c+0KW0Jv+4mHLkBsd18BLxZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m4I2nQz8n6zAzeQEJwob4OHeEG18IkNjYw2hb/sgc7A=;
	b=eK8Ht/I+1y1BvChYfbnmrXHDZb5uZmKaEzL+reyralgM4p0MKr9PowfSrW1NY3oqGBza
	 zfbOVqtpofDMaM6nGcaSP9KQKdQI3IDyd6CxF6zF5u+lSGjC9hKFrNRt5ppYH1UjXj3r1
	 NtR2dHSmKEe0bJdLapXRBcxQigI/zn+loRqgEIM94LnMjFtHO+AWrapgJQi2hU+V2cL/6
	 GdqnJ6UXeBofIO9TpbMAmQUUrUaQOVu51VhLNW7P+0j1HXpAMVC6mrUbmL25ffwl8N+0R
	 SnXPsTpA40f66g9JNIjid65aAkUFQANhNpzs3uDiSnZlKWPqtycxEerw2ITBNlqfgyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRj6BbLX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A755606A33E;
	Wed, 25 Nov 2026 15:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRj6BbLX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE141F000C4;
	Wed, 25 Nov 2026 15:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621692;
	bh=m4I2nQz8n6zAzeQEJwob4OHeEG18IkNjYw2hb/sgc7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRj6BbLXTgSNu9l/8MzuQN+twJbXAbHHRzSSBcrjE6xg2T4TRqZFGiAFPqENZ50Ay
	 nBIXiAtX3qBENGVdBW6KY3xadnto9ayIUGYWOevokY/wAGa9MvVxxiFo7rx1SEF7Hs
	 uX7hwTJgoxTOVBCahwcoh0pwVZAVXkWpwigeLtJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 261/990] firmware: cs_dsp: Fix memory leak on cs_dsp_power_up() error path
Date: Wed, 25 Nov 2026 15:27:08 +0100
Message-ID: <20261125143828.207929586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 39d31f76ad1b12f1b5e6ef4c15f89e6b3c3f603a ]

If cs_dsp_power_up() fails on or after cs_dsp_load() mark the controls
disabled and free the alg regions.

Fixes: f6bc909e7673c ("firmware: cs_dsp: add driver to support firmware loading on Cirrus Logic DSPs")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20261104152402.1153795-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index 15710c97f9fb0..0e20f72cfdfcf 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -2745,6 +2745,7 @@ int cs_dsp_power_up(struct cs_dsp *dsp,
 		    const struct firmware *coeff_firmware, const char *coeff_filename,
 		    const char *fw_name)
 {
+	struct cs_dsp_coeff_ctl *ctl;
 	int ret;
 
 	mutex_lock(&dsp->pwr_lock);
@@ -2789,6 +2790,11 @@ int cs_dsp_power_up(struct cs_dsp *dsp,
 
 	return 0;
 err_ena:
+	list_for_each_entry(ctl, &dsp->ctl_list, list)
+		ctl->enabled = 0;
+
+	cs_dsp_free_alg_regions(dsp);
+
 	if (dsp->ops->disable_core)
 		dsp->ops->disable_core(dsp);
 err_mem:
-- 
2.53.0



