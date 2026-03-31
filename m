Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B14042669C;
	Tue, 31 Mar 2026 16:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975187; cv=none; b=WmtpvtXsIP/Kclf6plTOjDVzgkuDSYsVDprbhC6Erpuv1CuN+bJPAC3SdGQ42piCOoahoAIjQ/9eNEsmimq6YXQcSCpCcnZXH5Uvx2zPKusNWLHCqclbTyXL1q71tnwQI4CGnu24OdxoaX54ICFOYQfynkycHabjAMJWoAN6860=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975187; c=relaxed/simple;
	bh=Y5J8WQCoaGd0doGlH0/1GWAJCYnAc3Vq+QYbVgENRVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMlcpoNkEwINZd5VYNHq5OYBlpglu+pq723/j1t9bnAQ4JkFyyz3khirh4z5zPQ4NiwvVrnLp4jgd+3JiVwPxXe+3TZC981fJLXVeGqhSwYcRSdeM+qc0yZrwoq1SRrJJnbzIPpD6ezD/lQ7rwXNA4HEKwTK9OfXzxekcwc4obU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDA+w9HD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDA+w9HD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA89C19423;
	Tue, 31 Mar 2026 16:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975187;
	bh=Y5J8WQCoaGd0doGlH0/1GWAJCYnAc3Vq+QYbVgENRVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDA+w9HDEw5HTy/euqKXD7VuaK2XPNiJFe6ddlUQaNFfqt3Ap3AYN0akIEBmx4j9y
	 x0gJTHcYYqfSm1IBYzUZhbz2cPRqHqPjZjql2p53KEc2hPIRDeJ7/KJDhDxzcqO4Ih
	 ++w0QHt2d5WOvps7df1PfLqM90tTSqyU5yuhAa28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 164/342] ASoC: simple-card-utils: Check value of is_playback_only and is_capture_only
Date: Tue, 31 Mar 2026 18:19:57 +0200
Message-ID: <20260331161805.045966737@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 0e9fc79132ce7ea1e48c388b864382aa38eb0ed4 ]

The audio-graph-card2 gets the value of 'playback-only' and
'capture_only' property in below sequence, if there is 'playback_only' or
'capture_only' property in port_cpu and port_codec nodes, but no these
properties in ep_cpu and ep_codec nodes, the value of playback_only and
capture_only will be flushed to zero in the end.

graph_util_parse_link_direction(lnk,            &playback_only, &capture_only);
graph_util_parse_link_direction(ports_cpu,      &playback_only, &capture_only);
graph_util_parse_link_direction(ports_codec,    &playback_only, &capture_only);
graph_util_parse_link_direction(port_cpu,       &playback_only, &capture_only);
graph_util_parse_link_direction(port_codec,     &playback_only, &capture_only);
graph_util_parse_link_direction(ep_cpu,         &playback_only, &capture_only);
graph_util_parse_link_direction(ep_codec,       &playback_only, &capture_only);

So check the value of is_playback_only and is_capture_only in
graph_util_parse_link_direction() function, if they are true, then rewrite
the values, and no need to check the np variable as
of_property_read_bool() will ignore if it was NULL.

Fixes: 3cc393d2232e ("ASoC: simple-card-utils: Fix pointer check in graph_util_parse_link_direction")
Fixes: 22a507d7680f ("ASoC: simple-card-utils: Check device node before overwrite direction")
Suggested-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260318102850.2794029-2-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card-utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index 9e5be0eaa77f3..89d694c2cbdda 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -1183,9 +1183,9 @@ void graph_util_parse_link_direction(struct device_node *np,
 	bool is_playback_only = of_property_read_bool(np, "playback-only");
 	bool is_capture_only  = of_property_read_bool(np, "capture-only");
 
-	if (np && playback_only)
+	if (playback_only && is_playback_only)
 		*playback_only = is_playback_only;
-	if (np && capture_only)
+	if (capture_only && is_capture_only)
 		*capture_only = is_capture_only;
 }
 EXPORT_SYMBOL_GPL(graph_util_parse_link_direction);
-- 
2.53.0



