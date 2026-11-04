Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827054;
	b=o8XxrDMyRzWpU+gxkup4zeEIHUkah/cfK+uUcO+HLphRKb5XhUjDccjCkykRL9w6J0fv
	 oRxhG9S82hAxko8k/+kpVfPssujRgQYjyWHs/MBxjHN56rj82a2OpTMuzU7Vp4oeJX5ar
	 pPH94tbYQWWk+mkw5lxx8/DQcaeG7pjzF0uf/wbnahav+ngt6BuPCzx2vPPD/Bw+oDu8r
	 TXYFnTeAL4QjKq1Lj+unjM2hlnOKpFYVS9eN9ipjET/4+jkGjEF73V8+DjcyRSS9BQHXS
	 phtliw9mqD0llRfrnIG24qBqfrf4XQ8Rip8EgjMC07U6Y7XYNnDMOhdMsRUOZ+8W0cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sRgI6R5HZQy+V5uuPS1W80C85iTTuGQEneJBIaR713Y=;
	b=GOzNBI3No7zdUY4Co+Apz9dv7vKfYQ3bJPyCTGA37YqNKVG4ghM4dbOhxjJomWuqxuPm
	 EoY3ffSiccuaBUwhX4/I/c/ZrC/V/PXmDXIDz60ap9ec+NpMNRbjgeJE8ds77YX9I670n
	 gtIIpxD0+BGbqrzQG/aRCw0csedv3Qw5zkuMGw1o6DCjPTsyqjJ5eDNtz7uIxfLweF3b0
	 mqUcSSPWDyEJX8Zevm6bDBZLuw8hDnkVupCSghkceJobpOrdDBd2kGOBWk7jFFLtLu9hP
	 icTInQuD+BP4vKXQsFVPCT2sCF0cWmiom7DRUukHSlNgqDgMqFnc3aaCZ5XoOU4dogQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A0LAFoqy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916A5606AE22;
	Wed,  4 Nov 2026 21:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A0LAFoqy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197631F000C1;
	Wed,  4 Nov 2026 21:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827054;
	bh=sRgI6R5HZQy+V5uuPS1W80C85iTTuGQEneJBIaR713Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A0LAFoqy0zQPkY+guo+cTQ3/1H5ltEWLMacC+3Gab2LRTXxZXzgl5fF5qRqIbyENe
	 jd41wqhwF1434gOqSlBp0OyXLp349b7ZEhIX//3pxK8CO5yIGhGuWOya1IaCTeH9Nl
	 3H2nKnURReAWMm53gbVgJhdRjESFUg4vX8qmtLi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.3 166/547] ASoC: audio-graph-card2: Fix use-after-free in audio_graph2_link_c2c()
Date: Wed,  4 Nov 2026 16:05:50 -0500
Message-ID: <20261104211042.867402994@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 5ea495bccfd746b063bc6702064f167467717b41 upstream.

of_graph_get_next_port() consumes the reference of its prev argument.
port0 is only borrowed from the caller's iterator, so the call drops a
reference the function does not own, and port0 is dereferenced again
afterwards. Pass an extra reference, as graph_count_c2c() does, so the
reference the callee consumes is the one taken here.

Fixes: 5f281c3e82b1 ("ASoC: audio-graph-card2: use __free(device_node) for device node")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/20260917165851.2163548-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/generic/audio-graph-card2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/generic/audio-graph-card2.c
+++ b/sound/soc/generic/audio-graph-card2.c
@@ -969,7 +969,8 @@ int audio_graph2_link_c2c(struct simple_
 	struct snd_soc_dai_link *dai_link = simple_priv_to_link(priv, li->link);
 	struct device_node *port0 = lnk;
 	struct device_node *ports __free(device_node) = port_to_ports(port0);
-	struct device_node *port1 __free(device_node) = of_graph_get_next_port(ports, port0);
+	struct device_node *port1 __free(device_node) =
+		of_graph_get_next_port(ports, of_node_get(port0));
 	u32 val = 0;
 	int ret = -EINVAL;
 


