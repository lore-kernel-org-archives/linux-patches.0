Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB564E534E;
	Thu, 17 Sep 2026 16:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664160; cv=none; b=Z/f24pfw9jGCJxYMhps9BO+BPR2349h0Gef73ic+FEBP82VDFk/VRl2qXKfAoG3wPgVj6bKT/zfNWV2xmnW/cciFyfF+9CtDGndUPpSfp4nvTLP9NDwDaiXXEjpXWsAoyL/Genzt97ksN3p5LrH4GixCyjSJXE2ybHwEiLNoXQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664160; c=relaxed/simple;
	bh=/Gb556OGp25M4oeyNYDdrkd0dig7EhqQCDsv6qNrd5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBzMPzVWrzNhI2/AwPtOGpD+VZI7fDxptHSF2s4gM/OhVrKU7aSP7NS1JZvdm5/L11QMwmigyvs2BElK8cL1jqa85Wc9DXAi1W8T7miRkGtXZ/uuoQUmX5v73ifFGautFpkfjIa6zFvqEuXbyW2rEXWGzG60uyiMrAd/K+Mt4V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tk+GdR8x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tk+GdR8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB3F1F000FF;
	Thu, 17 Sep 2026 16:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664159;
	bh=+2hBQYueoirjUFHjs5nCPOI7Vx5GfBRDc8fmvaQNHBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tk+GdR8xEpPSNtge3trmr0mbqcLrW3z9rSZMQ2M6Yd28J+nLN/225h7Jqy3apw0+7
	 3sJ9pBuPsJ6wrMqr+FdLLSS1H76Jdks2IM5CCMTarhtb+7OjS1NoK6Dab/4xUY3MnX
	 nceudNOQm9A87gPfLdMxknERf5eMUOBjo6PgcAj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0279/1250] ASoC: qcom: q6apm: return error code to consumers on failures
Date: Thu, 17 Sep 2026 16:01:14 +0100
Message-ID: <20260917151559.698479167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

[ Upstream commit 3075ae5abbc370d2a9a01bd6d554a412d406f5bd ]

Return errors from audioreach_set_media_format() to ensure callers are
notified when media format setup fails.

This could hide failures while programming media format parameters for
individual modules and allow graph setup to continue with incomplete
configuration.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260528185806.6316-3-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
index 16b2e227a6f13..9122876e00a2a 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -203,10 +203,7 @@ int q6apm_graph_media_format_shmem(struct q6apm_graph *graph,
 	if (!module)
 		return -ENODEV;
 
-	audioreach_set_media_format(graph, module, cfg);
-
-	return 0;
-
+	return audioreach_set_media_format(graph, module, cfg);
 }
 EXPORT_SYMBOL_GPL(q6apm_graph_media_format_shmem);
 
@@ -374,6 +371,7 @@ int q6apm_graph_media_format_pcm(struct q6apm_graph *graph, struct audioreach_mo
 	struct audioreach_sub_graph *sgs;
 	struct audioreach_container *container;
 	struct audioreach_module *module;
+	int ret;
 
 	list_for_each_entry(sgs, &info->sg_list, node) {
 		list_for_each_entry(container, &sgs->container_list, node) {
@@ -382,7 +380,9 @@ int q6apm_graph_media_format_pcm(struct q6apm_graph *graph, struct audioreach_mo
 					(module->module_id == MODULE_ID_RD_SHARED_MEM_EP))
 					continue;
 
-				audioreach_set_media_format(graph, module, cfg);
+				ret = audioreach_set_media_format(graph, module, cfg);
+				if (ret)
+					return ret;
 			}
 		}
 	}
-- 
2.53.0



