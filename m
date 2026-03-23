Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EA623BD1D;
	Mon, 23 Mar 2026 15:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278194; cv=none; b=lQDvlp0AOczsYKeP6wgjU7JCfz6vWc6pj6P/fGTah59rQ2l5MR8PdALGFtPNYByK17MrvIMWaX9xoGZEcLKa/t3/IYOAdGElyNeZyIZAQ42TJcc/cfqZJz3v+9839Ou0flxQJ/Vd2dTmKUlbIu8HbvF7+E1hk7NmL2gnnYaSt2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278194; c=relaxed/simple;
	bh=wIJlO4i6/PiwqmZA6d2UBL5XF8AAwHNNDJYkHM/EwfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e94+CSRdL/+Bs2Zc2tQoDlo2nPNEbsmFcybDMYAJuUP2wR9VCAZfg+YiMU4cvR3GkSE5PSuarEJDBo1A+eCjEAXGkiGAkrpiQsy6h8svcYbJR4RmfgcztdB6qlan4+ylstzHSV1DjnVjHgcnUphRB1MQlnEqfh7U/C69uDpCu1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eblTErWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eblTErWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA25C4CEF7;
	Mon, 23 Mar 2026 15:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278194;
	bh=wIJlO4i6/PiwqmZA6d2UBL5XF8AAwHNNDJYkHM/EwfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eblTErWW0/1VrYo2Cf6PAsEsWVR2JQ/V0dEj91hUa6ZAYZT5M89UvwtJLDWKRgFgY
	 BC7IxPEinc9W4W0/4n0ihM+W0IOKeAjINge86E7e6H625+uR1IAhB/FVS6rbjJ8ADc
	 mgQA6kOGOZ8r9ZSov924Q9oE0lsbu4Daw8LEYL6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/567] ASoC: simple-card-utils: use __free(device_node) for device node
Date: Mon, 23 Mar 2026 14:42:28 +0100
Message-ID: <20260323134539.475007076@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 419d1918105e5d9926ab02f1f834bb416dc76f65 ]

simple-card-utils handles many type of device_node, thus need to
use of_node_put() in many place. Let's use __free(device_node)
and avoid it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87r06pfre8.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 4185b95f8a42 ("ASoC: simple-card-utils: fix graph_util_is_ports0() for DT overlays")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card-utils.c | 44 +++++++++------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index 598b0000df244..9ef3e69683271 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -988,35 +988,27 @@ EXPORT_SYMBOL_GPL(asoc_graph_card_probe);
 
 int asoc_graph_is_ports0(struct device_node *np)
 {
-	struct device_node *port, *ports, *ports0, *top;
-	int ret;
+	struct device_node *parent __free(device_node) = of_get_parent(np);
+	struct device_node *port;
 
 	/* np is "endpoint" or "port" */
-	if (of_node_name_eq(np, "endpoint")) {
-		port = of_get_parent(np);
-	} else {
+	if (of_node_name_eq(np, "endpoint"))
+		port = parent;
+	else
 		port = np;
-		of_node_get(port);
-	}
-
-	ports	= of_get_parent(port);
-	top	= of_get_parent(ports);
-	ports0	= of_get_child_by_name(top, "ports");
-
-	ret = ports0 == ports;
 
-	of_node_put(port);
-	of_node_put(ports);
-	of_node_put(ports0);
-	of_node_put(top);
+	struct device_node *ports  __free(device_node) = of_get_parent(port);
+	struct device_node *top    __free(device_node) = of_get_parent(ports);
+	struct device_node *ports0 __free(device_node) = of_get_child_by_name(top, "ports");
 
-	return ret;
+	return ports0 == ports;
 }
 EXPORT_SYMBOL_GPL(asoc_graph_is_ports0);
 
 static int graph_get_dai_id(struct device_node *ep)
 {
-	struct device_node *node;
+	struct device_node *node __free(device_node) = of_graph_get_port_parent(ep);
+	struct device_node *port __free(device_node) = of_get_parent(ep);
 	struct device_node *endpoint;
 	struct of_endpoint info;
 	int i, id;
@@ -1039,13 +1031,10 @@ static int graph_get_dai_id(struct device_node *ep)
 		if (of_property_present(ep,   "reg"))
 			return info.id;
 
-		node = of_get_parent(ep);
-		ret = of_property_present(node, "reg");
-		of_node_put(node);
+		ret = of_property_present(port, "reg");
 		if (ret)
 			return info.port;
 	}
-	node = of_graph_get_port_parent(ep);
 
 	/*
 	 * Non HDMI sound case, counting port/endpoint on its DT
@@ -1059,8 +1048,6 @@ static int graph_get_dai_id(struct device_node *ep)
 		i++;
 	}
 
-	of_node_put(node);
-
 	if (id < 0)
 		return -ENODEV;
 
@@ -1070,7 +1057,6 @@ static int graph_get_dai_id(struct device_node *ep)
 int asoc_graph_parse_dai(struct device *dev, struct device_node *ep,
 			 struct snd_soc_dai_link_component *dlc, int *is_single_link)
 {
-	struct device_node *node;
 	struct of_phandle_args args = {};
 	struct snd_soc_dai *dai;
 	int ret;
@@ -1078,7 +1064,7 @@ int asoc_graph_parse_dai(struct device *dev, struct device_node *ep,
 	if (!ep)
 		return 0;
 
-	node = of_graph_get_port_parent(ep);
+	struct device_node *node __free(device_node) = of_graph_get_port_parent(ep);
 
 	/*
 	 * Try to find from DAI node
@@ -1120,10 +1106,8 @@ int asoc_graph_parse_dai(struct device *dev, struct device_node *ep,
 	 *    if he unbinded CPU or Codec.
 	 */
 	ret = snd_soc_get_dlc(&args, dlc);
-	if (ret < 0) {
-		of_node_put(node);
+	if (ret < 0)
 		return ret;
-	}
 
 parse_dai_end:
 	if (is_single_link)
-- 
2.51.0



