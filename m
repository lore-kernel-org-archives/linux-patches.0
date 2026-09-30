Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94704376A09;
	Wed, 30 Sep 2026 18:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794317; cv=none; b=D0nJLHB62r5RVUycE4kiX5R3wUGDngfPWSoXb16qWp06gB3Dlj1ofy13bAoeBcJD4Z+83toWKuRy1h4wOyhMsglptzOHsqTNGrZFEm4GdAfGFEbeHiTIRr1L7aIr5S5JXMKhlpB/kiZHpz3I1Ktax67EqitMy9oF43z/3ebfcmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794317; c=relaxed/simple;
	bh=jRggGJVxmP+DaQBf8WkLqO/dKJ4XoamwOyDqNLu9SOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4ehNhha70flAXJz0ZtPPE6H+0EYp9UvL1lv/nSBRwS1NPESIaZgRxYilPWobLMO+Us0gl313OrG6g3ToiCvTcNpJ4fFqs2SusaBc62PMOUTums4PZcPtryV+hcko99KND/oFU5eyeb02KchQHNJ9OYcko8ebzu5uXIL8m96rYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xm5W0lem; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xm5W0lem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2D51F000FF;
	Wed, 30 Sep 2026 18:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794316;
	bh=jGIVumNoI49AD7Z9qa0afzLhyk939vsvkUmhsWDn9bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xm5W0lemDbE/pTb3ZlC40NnZhU+k/8RzMUbZPI0QlAURkXgA+D6K0bCzKbYge31tp
	 6YXC9jO550tTKphviPQqQuRnbwIu6ADrh30FOML0r+b8cufWDRkQzMLk/xHh2f7afi
	 sxKWZci8kTmzVdSkO4UlJSpBNysk/zyPfG3R4+u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0151/1193] ASoC: qcom: q6apm: return error code to consumers on failures
Date: Wed, 30 Sep 2026 17:13:55 +0200
Message-ID: <20260930152437.561640611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index b6d957f7c7aba..50a496e665f85 100644
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
 
@@ -371,6 +368,7 @@ int q6apm_graph_media_format_pcm(struct q6apm_graph *graph, struct audioreach_mo
 	struct audioreach_sub_graph *sgs;
 	struct audioreach_container *container;
 	struct audioreach_module *module;
+	int ret;
 
 	list_for_each_entry(sgs, &info->sg_list, node) {
 		list_for_each_entry(container, &sgs->container_list, node) {
@@ -379,7 +377,9 @@ int q6apm_graph_media_format_pcm(struct q6apm_graph *graph, struct audioreach_mo
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



