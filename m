Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7152D4EDCAE;
	Thu, 17 Sep 2026 17:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667758; cv=none; b=Du/Pi2Xh/rXMTA+1JIWADH2oE+Hmaot/CbnTlZnzILYrZX56vfiMv5ks2KH0NxA9mGudZsBRxoWkz78V47ragd1IcfHjHK3iay3XHBLcLC8FRuoZ/HDUYYV2Zah8HeIKzy8wY2xedJawCWSu+8wiLM2pb90YIZ+z9sZA4UCXKTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667758; c=relaxed/simple;
	bh=TS1F1txbD4IvjvLHu/Klo+fCsimUuJIRISjeS4Wv5ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5Fzj4Y8ppE5VcUu4Owe3t6s+gMaV1+gWGAdKIJa0Pusigp2Nx0oD+OOeX4jDULpa+hU6GU5i7i0N3D6xalSXAAPsM1w88oaTa0yRRo0t/3y3OUuo4QyuYMg5zr+igSvEw9EfS0O/F6iH8dCBL8/UDk1227VAW+73f0s8mvvh+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fcu6zEea; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fcu6zEea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD29F1F000FF;
	Thu, 17 Sep 2026 17:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667757;
	bh=fgtBJ99DR5BX7qWCBL5KMVmvmOHmx70U+Cjidbx3JLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fcu6zEeaj9SwMGC4raiSaatQH+qh/JOuR+M6Ug+gEeohIwUfHXZuODkS3JlSiyCpa
	 9V3w1qx56Lr3LL7fs0R7B2qV24/NnMl8EfDGQUOt5S19GE0Smm/SA4Uua78gF4q9ed
	 1wIq7wOvX8fcqIpyY9Wi3457po09aIjEy0qJsmoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0198/1102] ASoC: qcom: q6apm: return error code to consumers on failures
Date: Thu, 17 Sep 2026 16:02:21 +0100
Message-ID: <20260917151544.543330839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



