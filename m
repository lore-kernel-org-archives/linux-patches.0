Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624497;
	b=0tr+HjvDxHEUbyZnDa+mWZukEnmlCyApzQ6UuWeBm/JKXJwhFAoPT6j/+aLzXje4Y4WJ
	 Cvvk+YQ8ILYi3mm5Xi5IWGJWSQhoAN5ikMwJ58VN8Xzwrw6wnrXgaPWiv1PRB/W0YsA/c
	 4YEtx1BuXuz6MJIRSHW8ekiWJMT9r6HXX83ze+ZcbA6V+ccNWNsryGupQ3OsIpe+409dk
	 ui/NM8GJX9E+c7pA5B9h45jkP0U3iOqNAIRvsmGGfq/4ltGo0qH/0k9jkFAv3STOcPlfn
	 BActCb8ZOU28AxWLwVFdJJhSFDlwDBDUCDr+giOldb+6Ea36UaujxGDZcRr2agvjMHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DjGR5qEt/hOiQlg+whwgIiCPDMah5fGGvqufTiiGE5Y=;
	b=yBBWb1fb6HwWY+c5bHfEpouWFQzi+Nud2CWN3qfYj2Ise2naA1Hdv0HZ7mFNjbIWLX1c
	 KlQceT6SCJ3NhaujY+/1YZnjUL7A5AptHSO/TpHz9LqXVXnlBwVHWQeAjuv6QwEHHgFNB
	 /MN/TYj6zt6cN5BAkui/RAmSxpdm67/2CIMQ6mvHzVmpNEIJ2uLgmKqVTimypXydM7hKr
	 nEQC9fkd2+RsPHbQDwV0un8q1+rjbwNXrYFTjZqjI7a0HxyhpmexDUBQdG4qEM8JS1bE+
	 +CH4lEar+XzC1RTSFnkQuHJ6ubWi2eVeZqtDoQr78UQwHdsZHTh0NqYCpoDDMEoZQwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f4u5W3c2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A369606A681;
	Wed, 25 Nov 2026 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f4u5W3c2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B47E1F000EC;
	Wed, 25 Nov 2026 16:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624497;
	bh=DjGR5qEt/hOiQlg+whwgIiCPDMah5fGGvqufTiiGE5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4u5W3c26ni4E7MV9BExBC20RCIZ9lSn5rsYF5wLgo4JF73c1BNMgJZrbcAg64cJe
	 hfcflDazhixAaYAperlDUkwmATML2uzUvBwgJBc7vM5c1sZBHtHaNhzj/3NTdW3APe
	 BlQVFLx062sDbwD5ZOx6uyPUmanGPplmt+PlVyts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/816] firmware: cs_dsp: Fix memory leak on cs_dsp_power_up() error path
Date: Wed, 25 Nov 2026 15:29:19 +0100
Message-ID: <20261125143854.084984078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index ff1d0793a7ca0..6191cce9a66fe 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -2706,6 +2706,7 @@ int cs_dsp_power_up(struct cs_dsp *dsp,
 		    const struct firmware *coeff_firmware, const char *coeff_filename,
 		    const char *fw_name)
 {
+	struct cs_dsp_coeff_ctl *ctl;
 	int ret;
 
 	mutex_lock(&dsp->pwr_lock);
@@ -2750,6 +2751,11 @@ int cs_dsp_power_up(struct cs_dsp *dsp,
 
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



