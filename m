Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB02331A41;
	Wed, 20 May 2026 18:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302121; cv=none; b=Xg44JcmP9DKJ/reZ8rA0XBT7h3zDxuuLSRHIAgdfupxRFaKCZLjK0NIoSbmNj9jDn16RKpmDuO9n+7PoiirFr17FJgu3SQBLizKNgEPW0pvSv7okYLagf0dJEPmmgB4xwdiLy2azwKIC6Hk+6dA1hvHofEJZJ9xHirpKee+cMhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302121; c=relaxed/simple;
	bh=7dt1hudJaydaruABMlmmloK2BCxyFilkzUDr/g3dee0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q630p5RCYnErOLb1ZhkmyCSdjXi9VR5rsVqLgzskFLa4JjjMlHZ69BLTqwExWFeEriZ27jGHj5Wv9ccE5PrxHLic7EppiDFnlX+jaakMnjUVGtDBXBkcHgCRZA9+qDYNSqI1lPfyVEWMQy3iaGSY5DNbcb6yGTYBwI7HRY3EQGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ff9SWkiC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ff9SWkiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4DC1F000E9;
	Wed, 20 May 2026 18:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302119;
	bh=jbl1vKl82iRCjYCmEhyPi/DZXfCo6MJcqkKwxlCYZKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ff9SWkiC2YILD1xFnKF/9Ci6BSV2Dkif6qeL8orfwGONjb6WgBTV+jEmJcLR40qbv
	 yoz64FBVg5hKUWBlgjqfhyw/saPFkq3GIe06jyi0Ctu727Kyy6ob69R4XmGRNHe9Y8
	 QOgs5gzbZZi9qeO/BgFB4ubv9ta/ssVffnSFrTjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/508] ASoC: qcom: qdsp6: topology: check widget type before accessing data
Date: Wed, 20 May 2026 18:19:29 +0200
Message-ID: <20260520162101.794038965@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit d5bfdd28e0cdd45043ae6e0ac168a451d59283dc ]

Check widget type before accessing the private data, as this could a
virtual widget which is no associated with a dsp graph, container and
module. Accessing witout check could lead to incorrect memory access.

Fixes: 36ad9bf1d93d ("ASoC: qdsp6: audioreach: add topology support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260402081118.348071-4-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/topology.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/topology.c b/sound/soc/qcom/qdsp6/topology.c
index d4c3bc85fb356..51d1926ea3c2b 100644
--- a/sound/soc/qcom/qdsp6/topology.c
+++ b/sound/soc/qcom/qdsp6/topology.c
@@ -903,9 +903,6 @@ static int audioreach_widget_unload(struct snd_soc_component *scomp,
 	struct audioreach_container *cont;
 	struct audioreach_module *mod;
 
-	mod = dobj->private;
-	cont = mod->container;
-
 	if (w->id == snd_soc_dapm_mixer) {
 		/* virtual widget */
 		struct snd_ar_control *scontrol = dobj->private;
@@ -914,6 +911,11 @@ static int audioreach_widget_unload(struct snd_soc_component *scomp,
 		kfree(scontrol);
 		return 0;
 	}
+	mod = dobj->private;
+	if (!mod)
+		return 0;
+
+	cont = mod->container;
 
 	mutex_lock(&apm->lock);
 	idr_remove(&apm->modules_idr, mod->instance_id);
-- 
2.53.0



