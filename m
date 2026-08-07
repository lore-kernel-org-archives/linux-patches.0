Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C193431F5;
	Fri,  7 Aug 2026 15:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117348; cv=none; b=aAPpzpOQGQLOdfa/5v0ILfsUCxSv39cu/rsB0euvkoE+Md4JDEYwmwGuR3SHOA+CFTheE5GATg4z6u9Yck4gYRG1+mS9nOzgxvmOHSdlx1pEp8+N6C3ADtFowEr/nqNJ19r7j+1el8c95T126QWxHQF6EU1NugorMuONoTC5EMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117348; c=relaxed/simple;
	bh=msolPwwn2q0arwbEa/tpsIFiinqpS0udGChrzptIue4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aESHTdwWWYPUFvMmuPXyCq4yQcSz+50BRiQcchC+kGZo0lMJHAxzdPTkVK4wgNV6ZonOYQGUw7nbg8F45VMt37TfTmQ0H0V2eYdF7vrxQF1wZkXzKjrb1LBW3cpj34KHP8co2Xtm/lmRuQ07a1fCxLpC5S3TpF7cRWT1J7iICrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQcN7V4M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQcN7V4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B221F000E9;
	Fri,  7 Aug 2026 15:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117347;
	bh=sisWwvp/Vwa8clNu8RIVTOvEwHos8egdc73DTD2XMVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQcN7V4MwZjoNgon6X9jJ1yHS/jdVjWhQ5ZCJnLi8x1pte0S3Y6IJeFBDSSKi8+A7
	 tUy4sCVZtOE6h5QIJR6xxNISUDhS5gmpjggGIOb09mNJzBRpQrb4hPLbrIU+a/46+L
	 HVcADDYmy2ulOtCJo5d8S+koPtgGjveckDBS37KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 260/438] ASoC: fsl_easrc: fix m2m_init error path to use goto instead of bare return
Date: Fri,  7 Aug 2026 16:37:36 +0200
Message-ID: <20260807143433.536372941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit a54bc0eef90ea760039c14bb7f3b5db42529f84d upstream.

When fsl_asrc_m2m_init() fails in fsl_easrc_probe(), the code did a
bare return ret, bypassing pm_runtime_disable() in err_pm_disable.
Use goto err_pm_disable to ensure proper cleanup on failure.

Fixes: b62eaff0650d ("ASoC: fsl_easrc: register m2m platform device")
Cc: stable@vger.kernel.org
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260715024758.1252801-3-shengjiu.wang@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_easrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -2269,7 +2269,7 @@ static int fsl_easrc_probe(struct platfo
 	ret = fsl_asrc_m2m_init(easrc);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to init m2m device %d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	return 0;


