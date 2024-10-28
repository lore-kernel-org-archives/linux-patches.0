Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F5618E35B;
	Mon, 28 Oct 2024 06:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097835; cv=none; b=LBdMagf53tIcx4kTbyojsKlxITg8ux5vUmYMAXAbG+eodY1lwsz2lMDv609STatu8fADA+JZXRTrEfwxUEKj1MtDvENUULRqN9DBbJLqpUj9CCqzyNi++oOCHjIbA+mxmkeqRQlJWld35xZSHbTpnBQ4SVxKJ3Uxfgspbdyj5T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097835; c=relaxed/simple;
	bh=J0ROFXZCUK78Whzho6Mf7ZE48/T2aqRaRTPZEiroN9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWMJn4Yvp1xKjW9WY51HbBvKfEGqXjhkYcUFOF/Ut1axZDWgfbaEY1SqAnmh3/dyq1OjUH2ipGFDdJqzVT1Zv7xzgX9ONTw+iTjpmnI5Mtntsq4J5l+NdofFlrxTXJNTtMCmJjA0+kI9RHHmYRQ4+LMEis8Q8zk97aHlelSyoE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V963h0WJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V963h0WJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B41FC4CEC3;
	Mon, 28 Oct 2024 06:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097835;
	bh=J0ROFXZCUK78Whzho6Mf7ZE48/T2aqRaRTPZEiroN9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V963h0WJ+ZTVuI8gAsJKgyZSayjYVQ0nbm9QDkpEC/3O+D9DY0ZhaQEjAatzpbI4R
	 zv6u40RNN70ARAIMX69O8J+Fwl0B8blkK5VQJH4sTAbUva4YIuu133609U533iZ4QF
	 NLdNiCMaf+PZPOxSp71kdEFuRjyAqFrZH+jhYDBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/208] ASoC: rsnd: Fix probe failure on HiHope boards due to endpoint parsing
Date: Mon, 28 Oct 2024 07:25:48 +0100
Message-ID: <20241028062310.768648730@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 9b064d200aa8fee9d1d7ced05d8a617e45966715 ]

On the HiHope boards, we have a single port with a single endpoint defined
as below:
....
        rsnd_port: port {
                rsnd_endpoint: endpoint {
                        remote-endpoint = <&dw_hdmi0_snd_in>;

                        dai-format = "i2s";
                        bitclock-master = <&rsnd_endpoint>;
                        frame-master = <&rsnd_endpoint>;

                        playback = <&ssi2>;
                };
        };
....

With commit 547b02f74e4a ("ASoC: rsnd: enable multi Component support for
Audio Graph Card/Card2"), support for multiple ports was added. This caused
probe failures on HiHope boards, as the endpoint could not be retrieved due
to incorrect device node pointers being used.

This patch fixes the issue by updating the `rsnd_dai_of_node()` and
`rsnd_dai_probe()` functions to use the correct device node pointers based
on the port names ('port' or 'ports'). It ensures that the endpoint is
properly parsed for both single and multi-port configurations, restoring
compatibility with HiHope boards.

Fixes: 547b02f74e4a ("ASoC: rsnd: enable multi Component support for Audio Graph Card/Card2")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/20241010141432.716868-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sh/rcar/core.c b/sound/soc/sh/rcar/core.c
index 1bd7114c472a8..98c7be340a536 100644
--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -1297,7 +1297,9 @@ static int rsnd_dai_of_node(struct rsnd_priv *priv, int *is_graph)
 		if (!of_node_name_eq(ports, "ports") &&
 		    !of_node_name_eq(ports, "port"))
 			continue;
-		priv->component_dais[i] = of_graph_get_endpoint_count(ports);
+		priv->component_dais[i] =
+			of_graph_get_endpoint_count(of_node_name_eq(ports, "ports") ?
+						    ports : np);
 		nr += priv->component_dais[i];
 		i++;
 		if (i >= RSND_MAX_COMPONENT) {
@@ -1510,7 +1512,8 @@ static int rsnd_dai_probe(struct rsnd_priv *priv)
 			if (!of_node_name_eq(ports, "ports") &&
 			    !of_node_name_eq(ports, "port"))
 				continue;
-			for_each_endpoint_of_node(ports, dai_np) {
+			for_each_endpoint_of_node(of_node_name_eq(ports, "ports") ?
+						  ports : np, dai_np) {
 				__rsnd_dai_probe(priv, dai_np, dai_np, 0, dai_i);
 				if (rsnd_is_gen3(priv) || rsnd_is_gen4(priv)) {
 					rdai = rsnd_rdai_get(priv, dai_i);
-- 
2.43.0



