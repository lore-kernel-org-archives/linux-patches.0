Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05990331220;
	Wed, 20 May 2026 17:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298140; cv=none; b=GATBdoAP0LaB3TsyogNo6mmRNU+nMUjWrUWyiiyP4z92Q1XRWfvVhoi0wj5/Z33wgtjsMR0URrO+VjJBDP0G6OFsmGckS+4N54jki3VR9/BT5S9bqf08cgdXfEzMlRQh5o6rttGJyCcJZloUQou/mM0GjsgIKWF1K3SMge39JXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298140; c=relaxed/simple;
	bh=jUXjx/56MfTYXWLFQJpuGf5GpgS/h/c6YYFweDXqsBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbQ9bBraOlgC1ny5jqGS0yclJGoqC+eme/z3HYaa7KtEWRMw34zIRE84GoVeTwhxi0k5zVH5HZuYhKaNws+jH907yv8IQgthBADNzlkomjs7jnF3Xg8uLpFEprqzSEliohunCI0feMVz1SysqOZRMX6nOI4gQa1N4LQ3yS0kUmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iu2g5k0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iu2g5k0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6357C1F000E9;
	Wed, 20 May 2026 17:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298138;
	bh=J7cszxHD1xSJ7OM/glTrubTdG7nhx1zrROmawWMqjog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iu2g5k0V+S57eNlTLJ39IMdCUIMvUnZhGk6c3qRbRenbHGzEe4/M5M+ni6UUWhLpI
	 702hEaO1NC3kyZ2SR8PYq/O9qlVP7gDT3HXjQYi8RL9wEKUR0Gs3poJPpiPiYf81fg
	 /KwcGD5t71L6HWwFGV8o4/JE+JtRuAZi7orRZUpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 296/957] ASoC: qcom: qdsp6: topology: check widget type before accessing data
Date: Wed, 20 May 2026 18:12:59 +0200
Message-ID: <20260520162140.954669520@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index f61285e7dcf20..f8d3bb83e3b0d 100644
--- a/sound/soc/qcom/qdsp6/topology.c
+++ b/sound/soc/qcom/qdsp6/topology.c
@@ -952,9 +952,6 @@ static int audioreach_widget_unload(struct snd_soc_component *scomp,
 	struct audioreach_container *cont;
 	struct audioreach_module *mod;
 
-	mod = dobj->private;
-	cont = mod->container;
-
 	if (w->id == snd_soc_dapm_mixer) {
 		/* virtual widget */
 		struct snd_ar_control *scontrol = dobj->private;
@@ -963,6 +960,11 @@ static int audioreach_widget_unload(struct snd_soc_component *scomp,
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



