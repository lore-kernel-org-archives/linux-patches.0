Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638BA3ED101;
	Tue, 17 Mar 2026 16:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765674; cv=none; b=bad3ptRrb2/3PNDu18/wb/VNY9DFglMVO4accCpPCfRrImWZRDAf/IMZVS7/3evXvirY6buJYaoTMUfhKueMwGmPKuRDCQrOrqIdlvMfW8COVlP7B0qLgfUX8qgUm0YCLpf1xjwZCcX7YjFQocFMDydsnIh83EAdJS1yslRaIh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765674; c=relaxed/simple;
	bh=6Qcdug5mFymWZdxudFa+1Hb7mD7L89JSPye8ndoJ7/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSYlPF3vRYhjGAHUQ9hAMU+ow02wr0OgwW67vxcryUTZWylIVFq6NyAKvkEgPTE5BRkJNsquJMU7VtBwLirsTgqePhgnDR5rDLHHF9lsyjlO/x+38pKRLQa42hL810pgAgqfwE9Xi2lDEXGlkZFURbjtvAjlxZMSrorYiF6MqNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHbsv2+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHbsv2+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA86EC19424;
	Tue, 17 Mar 2026 16:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765674;
	bh=6Qcdug5mFymWZdxudFa+1Hb7mD7L89JSPye8ndoJ7/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHbsv2+dZrAJeXMpkyEeP7pkk2JkN7Ply+olev1R9YRycA6GVZUuyMKfKQ27Z1WoF
	 P8L8/ffOd3Xs0zh+/1ekfEu4BplrzQorYCxUw60czIpg3A2fotvXPds0YwNykivHq3
	 XcpkcLx+Ookw+zD22HW7A3H2jULXh/kTX5qSVtUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sen Wang <sen@ti.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 059/378] ASoC: simple-card-utils: fix graph_util_is_ports0() for DT overlays
Date: Tue, 17 Mar 2026 17:30:16 +0100
Message-ID: <20260317163009.163140107@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Sen Wang <sen@ti.com>

[ Upstream commit 4185b95f8a42d92d68c49289b4644546b51e252b ]

graph_util_is_ports0() identifies DPCM front-end (ports@0) vs back-end
(ports@1) by calling of_get_child_by_name() to find the first "ports"
child and comparing pointers. This relies on child iteration order
matching DTS source order.

When the DPCM topology comes from a DT overlay, __of_attach_node()
inserts new children at the head of the sibling list, reversing the
order. of_get_child_by_name() then returns ports@1 instead of ports@0,
causing all front-end links to be classified as back-ends. The card
registers with no PCM devices.

Fix this by matching the unit address directly from the node name
instead of relying on sibling order.

Fixes: 92939252458f ("ASoC: simple-card-utils: add asoc_graph_is_ports0()")
Signed-off-by: Sen Wang <sen@ti.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/20260309042109.2576612-1-sen@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card-utils.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index bdc02e85b089f..9e5be0eaa77f3 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -1038,11 +1038,15 @@ int graph_util_is_ports0(struct device_node *np)
 	else
 		port = np;
 
-	struct device_node *ports  __free(device_node) = of_get_parent(port);
-	struct device_node *top    __free(device_node) = of_get_parent(ports);
-	struct device_node *ports0 __free(device_node) = of_get_child_by_name(top, "ports");
+	struct device_node *ports __free(device_node) = of_get_parent(port);
+	const char *at = strchr(kbasename(ports->full_name), '@');
 
-	return ports0 == ports;
+	/*
+	 * Since child iteration order may differ
+	 * between a base DT and DT overlays,
+	 * string match "ports" or "ports@0" in the node name instead.
+	 */
+	return !at || !strcmp(at, "@0");
 }
 EXPORT_SYMBOL_GPL(graph_util_is_ports0);
 
-- 
2.51.0



