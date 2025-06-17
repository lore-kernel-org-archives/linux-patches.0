Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D1BCA4B;
	Tue, 17 Jun 2025 16:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179235; cv=none; b=QYU5NCLTg2amemuvCLxpD149FJ1+m8xaAgyceV0SqA1o7S4EyQ1k/Qid9fc+BD3fw5hfwRHLt6KSmt7XBAISxdY5TfIQTsnJc8iJxOwV9DHluaI961vmvOdLzTigU7V1tiC7VhnKg1++RccXNeae+Eu2fEe0OqM9CZk3L27HV1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179235; c=relaxed/simple;
	bh=FwntFBhyjBL6Bc+IQCKAVqLvYR7IpFEKWIZWg6m5mZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PatXdmdzxNHglv068h/dGroW/ngArHRAoCpTYfM5heKraahscwyAxgRecSPDTPf8yPnmHB2ieX8Tg48we4A6GGlLM312k8PGVDEI45QGHg++i/5F/zL4bKGZV7DO/IRB6Xq5TmtdEqVPtCy3CwVCPGhVqDTrB5+e7gy+QbTEvMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cg0qp2ZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cg0qp2ZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC49FC4CEE3;
	Tue, 17 Jun 2025 16:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179235;
	bh=FwntFBhyjBL6Bc+IQCKAVqLvYR7IpFEKWIZWg6m5mZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cg0qp2ZFWQzr6fOYYwVUsgP/04orpZ3ekwj/c8hc9NRMZtU7YHYHUg66kSfGq2GpP
	 l+zxwLNblUt62IGfQgvispSAnNtFv7V0dFUEPOSXP+YTN0ppHXq8zs00H1vb778b4s
	 w/2l8BHymNrRvhzn8eSTGlbU1JjS+TuBFZLGMrkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Dalimonte <gabriel.dalimonte@gmail.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 689/780] drm/vc4: fix infinite EPROBE_DEFER loop
Date: Tue, 17 Jun 2025 17:26:37 +0200
Message-ID: <20250617152519.546508134@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Dalimonte <gabriel.dalimonte@gmail.com>

[ Upstream commit c0317ad44f45b3c1f0ff46a4e28d14c7bccdedf4 ]

`vc4_hdmi_audio_init` calls `devm_snd_dmaengine_pcm_register` which may
return EPROBE_DEFER. Calling `drm_connector_hdmi_audio_init` adds a
child device. The driver model docs[1] state that adding a child device
prior to returning EPROBE_DEFER may result in an infinite loop.

[1] https://www.kernel.org/doc/html/v6.14/driver-api/driver-model/driver.html

Fixes: 9640f1437a88 ("drm/vc4: hdmi: switch to using generic HDMI Codec infrastructure")
Signed-off-by: Gabriel Dalimonte <gabriel.dalimonte@gmail.com>
Link: https://lore.kernel.org/r/20250601-vc4-audio-inf-probe-v2-1-9ad43c7b6147@gmail.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 37a7d45695f23..176aba27b03d3 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -559,12 +559,6 @@ static int vc4_hdmi_connector_init(struct drm_device *dev,
 	if (ret)
 		return ret;
 
-	ret = drm_connector_hdmi_audio_init(connector, dev->dev,
-					    &vc4_hdmi_audio_funcs,
-					    8, false, -1);
-	if (ret)
-		return ret;
-
 	drm_connector_helper_add(connector, &vc4_hdmi_connector_helper_funcs);
 
 	/*
@@ -2274,6 +2268,12 @@ static int vc4_hdmi_audio_init(struct vc4_hdmi *vc4_hdmi)
 		return ret;
 	}
 
+	ret = drm_connector_hdmi_audio_init(&vc4_hdmi->connector, dev,
+					    &vc4_hdmi_audio_funcs, 8, false,
+					    -1);
+	if (ret)
+		return ret;
+
 	dai_link->cpus		= &vc4_hdmi->audio.cpu;
 	dai_link->codecs	= &vc4_hdmi->audio.codec;
 	dai_link->platforms	= &vc4_hdmi->audio.platform;
-- 
2.39.5



