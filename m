Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFB72FFDF9;
	Tue,  6 Jan 2026 17:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721965; cv=none; b=hZ+SZftNvu0MlNdE6Au/XZ7VJ6ptvbw2Mmg2V3A/wBIypJ+SyfzI4vKRxtS5Uhv/TtxoVa0uRp+42lo4Ybczk6JI6sPdjDYnP/nq2pN25rU4ITC4m6JF4Mldk76tFrUsv/vIx36YtYc8GmpOarbzwo9OqE8y0tZu77AGYacJTDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721965; c=relaxed/simple;
	bh=bzC5mdUwy9zCNQ0vtql3ILY737Vf+Zvr7HDsHmrv4nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgBw5dk/Nu/l5nWmP2NC2r/3IneldN5BSxJZMWwy8HkHAtnf2EMWqUcFnXBsiem3a+ux1Ad9w83jALNj9F3dGy1OKI4kZb6iCwVkVoVW3hLxKTSd0ztynos5js+2m7XnWhehFSF/rn+a4NewWCox0ARAgI/89xCapyRbJIZH0cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vG7Lcbko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vG7Lcbko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A5DC116C6;
	Tue,  6 Jan 2026 17:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721964;
	bh=bzC5mdUwy9zCNQ0vtql3ILY737Vf+Zvr7HDsHmrv4nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vG7LcbkotWboC5P3uvdIDLW1GZUJ9zoWMrd0DkurgOmoO6xsiP2oqx7PSssnX5VLJ
	 KeqDxjhqn10mL8yjUc2Q6oxDFBrNNvWmRl3CRuQADo/l6DCN7uLKltpIg1PCCsYTu8
	 0HVG6tG/HdEACNB8RakCLnknf6gp5lKWwQt8xCsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	olivier moysan <olivier.moysan@st.com>,
	Wen Yang <yellowriver2010@hotmail.com>,
	Johan Hovold <johan@kernel.org>,
	olivier moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 092/312] ASoC: stm32: sai: fix device leak on probe
Date: Tue,  6 Jan 2026 18:02:46 +0100
Message-ID: <20260106170551.162452391@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit e26ff429eaf10c4ef1bc3dabd9bf27eb54b7e1f4 upstream.

Make sure to drop the reference taken when looking up the sync provider
device and its driver data during DAI probe on probe failures and on
unbind.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Fixes: 7dd0d835582f ("ASoC: stm32: sai: simplify sync modes management")
Fixes: 1c3816a19487 ("ASoC: stm32: sai: add missing put_device()")
Cc: stable@vger.kernel.org	# 4.16: 1c3816a19487
Cc: olivier moysan <olivier.moysan@st.com>
Cc: Wen Yang <yellowriver2010@hotmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: olivier moysan <olivier.moysan@foss.st.com>
Link: https://patch.msgid.link/20251124104908.15754-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/stm/stm32_sai.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/stm/stm32_sai.c
+++ b/sound/soc/stm/stm32_sai.c
@@ -143,6 +143,7 @@ static int stm32_sai_set_sync(struct stm
 	}
 
 	sai_provider = platform_get_drvdata(pdev);
+	put_device(&pdev->dev);
 	if (!sai_provider) {
 		dev_err(&sai_client->pdev->dev,
 			"SAI sync provider data not found\n");
@@ -159,7 +160,6 @@ static int stm32_sai_set_sync(struct stm
 	ret = stm32_sai_sync_conf_provider(sai_provider, synco);
 
 error:
-	put_device(&pdev->dev);
 	of_node_put(np_provider);
 	return ret;
 }


