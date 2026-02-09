Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3969B276028;
	Mon,  9 Feb 2026 14:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647894; cv=none; b=NHaOmzf3wtNk4uQdsaXFBVjvC+oFj6qSE8Jq2lAc9GKHMRm09KeKORZnBUNlPvMolyP3USCmshlMd13bhCjg2J74lppokuqlsgVl84Za7Lq4G6ametzGAo+XyVwX5v3FgML/bV/TP60ENyc3BqFkJUqPL/0sNa2mvlNqJzud0sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647894; c=relaxed/simple;
	bh=nPhRrmsiuBnrX3cqpk9z+Mr2q1MCLSBkTchgDjHnzvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwhsUOXFe+x7cSlA07yvdqztP8e5m96aY9/7IoVLwWT+r/XJz16OShir1Ff/nlB6FLeQsncqz8BzGubv8eEymE6J/w9i+EUcZatkC5Wxi6/bhs67ZQKjRFvml0nBQquOHuBQfLHGW+0oUs9F9qPdmAC/RgGdbwcjpr1gaVclxXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWF96MO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWF96MO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1BFC19422;
	Mon,  9 Feb 2026 14:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647894;
	bh=nPhRrmsiuBnrX3cqpk9z+Mr2q1MCLSBkTchgDjHnzvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWF96MO8EKZNEXNZ7HQ8hHUfWeKMiFrtUjtKRZ8cTVb3oar3Vx5L67FagnhCB2DBR
	 R5ETsGyfwyi+JL9x4k1W4+jUCsLbPwfRZoWoSnf85Z0n2Yojut+k65/4qx1RfSuBJW
	 ut6TkrFu99X9YnS0/74S9L8TZXwSCo/+pup7WcXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/113] ASoC: simple-card-utils: Check device node before overwrite direction
Date: Mon,  9 Feb 2026 15:23:27 +0100
Message-ID: <20260209142312.284115040@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 22a507d7680f2c3499c133f6384349f62f916176 ]

Even the device node don't exist, the graph_util_parse_link_direction()
will overwrite the playback_only and capture_only to be zero. Which
cause the playback_only and capture_only are not correct, so check device
node exist or not before update the value.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/20251229090432.3964848-1-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card-utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index 809dbb9ded365..47933afdb7261 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -1150,9 +1150,9 @@ void graph_util_parse_link_direction(struct device_node *np,
 	bool is_playback_only = of_property_read_bool(np, "playback-only");
 	bool is_capture_only  = of_property_read_bool(np, "capture-only");
 
-	if (playback_only)
+	if (np && playback_only)
 		*playback_only = is_playback_only;
-	if (capture_only)
+	if (np && capture_only)
 		*capture_only = is_capture_only;
 }
 EXPORT_SYMBOL_GPL(graph_util_parse_link_direction);
-- 
2.51.0



