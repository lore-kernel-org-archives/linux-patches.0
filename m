Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49AA3A542F;
	Sat, 30 May 2026 17:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161245; cv=none; b=gGSB614K7imt470VhKoK+v1fSHiy8oedQxsDttzhS63Vr7QYz6UXavRoITjQE9Vh/3JCoOW16McONyDRCBqMKHJITT3uB1mn1btQ0PpgSTHmp2HBynJ6PakI+Ji3CJpgCwrMKrEr1Qf/RbDkLubFcWwj7qP+PgY/k8n8Y8h9ddQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161245; c=relaxed/simple;
	bh=RQjjaYWHmZ2lQ1HBYxOG+RWkzCXCD5yxb5oL3oww0bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ax/8Pt6jwizMcR+8pZZcwNdFRLk2GG/TQ7esHtSiTEcQCLY8onuSeAalDazkz1cFIFtLLWxwJ+dCceqKZ06kMWPJtmZrJh6tDhTMMMmMxDyWZ8qYgK9UKX2c8QbvVfi5/T3YPic4uCvnwp1u8rYV/rsVmfJv48yO+vBiQNexdos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lo9zqrFn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lo9zqrFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0591F00893;
	Sat, 30 May 2026 17:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161244;
	bh=B1W+91P83JOWexRcOzK2NkN5TeX0rYashiHZeiHZf/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lo9zqrFnNHAGIU/DD84RnXCok5OUzjS042EmmVqzePm1eFdCgvz7t6LFGQE4QBwCD
	 Hu6QksQGbmCnoc6oKd1leVQ3jzd4T1QINi3+2Un10yooCv0XnO1LXB2yt4cU2YFNuv
	 NUffooHTrD7Qgy5uNjIK1WyEtmDE63HQewepYXjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 537/969] ASoC: qcom: qdsp6: topology: check widget type before accessing data
Date: Sat, 30 May 2026 18:01:01 +0200
Message-ID: <20260530160315.197070620@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 600e39e73b87a..fdb87e585e276 100644
--- a/sound/soc/qcom/qdsp6/topology.c
+++ b/sound/soc/qcom/qdsp6/topology.c
@@ -814,14 +814,16 @@ static int audioreach_widget_unload(struct snd_soc_component *scomp,
 	struct audioreach_container *cont;
 	struct audioreach_module *mod;
 
-	mod = dobj->private;
-	cont = mod->container;
-
 	if (w->id == snd_soc_dapm_mixer) {
 		/* virtual widget */
 		kfree(dobj->private);
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



