Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79491F09AC;
	Fri, 21 Nov 2025 13:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731298; cv=none; b=nOmlED3x2qNPcu+WmveYwvvWQjj0n1tYwMJD8ew/eNTJ8yr72ABwwz6LOg8pgfcZe8Pxg4kavsYgMHXe3tn4sffVwO81CSVTDcZClBKf2g4veNBO23+5DEBupnJblXWaNgcRnEFKYlAOpTnoeb+rtmyIPap05X0c2Z1/1qwTdGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731298; c=relaxed/simple;
	bh=1t09YMIO68gnVhxoCS32s3/YRl61a7O526Xswl8tHfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BP/zJR1Z4JEpTFtxAAOTojqzSqgVJAyi8a0gLd2zhJNpS8TesD8Vk2ZLD/c9qC2dOLQaaTWr1JlDmztlvIXiOXEGhS24o0KNh6y0DFT9NPSOowFmrCzsg+0kkyAbKLP1cCYQil4kHZKsYXWSC1gy9tN06flubDDsCoGuBF1mCXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSCgkZlv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSCgkZlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329CBC4CEF1;
	Fri, 21 Nov 2025 13:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731298;
	bh=1t09YMIO68gnVhxoCS32s3/YRl61a7O526Xswl8tHfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSCgkZlvCVeI2h8/voK+GOwX/bCzZkydWeA5e59GM++wkdkuxjXKNw/YupnbkCIn6
	 cCqUJOwuLicx4otGsykHypx1ZJvYgXSVpYt+pK1XrS36adIQum3emOu72Mx/qEsetP
	 vPxoA8hgYPnLAlahynOMvOOPi+HL96TYn2DEvBcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 116/247] ASoC: rsnd: fix OF node reference leak in rsnd_ssiu_probe()
Date: Fri, 21 Nov 2025 14:11:03 +0100
Message-ID: <20251121130158.745914205@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 360b3730f8eab6c4467c6cca4cb0e30902174a63 ]

rsnd_ssiu_probe() leaks an OF node reference obtained by
rsnd_ssiu_of_node(). The node reference is acquired but
never released across all return paths.

Fix it by declaring the device node with the __free(device_node)
cleanup construct to ensure automatic release when the variable goes
out of scope.

Fixes: 4e7788fb8018 ("ASoC: rsnd: add SSIU BUSIF support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/20251112065709.1522-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/renesas/rcar/ssiu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/renesas/rcar/ssiu.c b/sound/soc/renesas/rcar/ssiu.c
index faf351126d574..244fb833292a7 100644
--- a/sound/soc/renesas/rcar/ssiu.c
+++ b/sound/soc/renesas/rcar/ssiu.c
@@ -509,7 +509,7 @@ void rsnd_parse_connect_ssiu(struct rsnd_dai *rdai,
 int rsnd_ssiu_probe(struct rsnd_priv *priv)
 {
 	struct device *dev = rsnd_priv_to_dev(priv);
-	struct device_node *node;
+	struct device_node *node __free(device_node) = rsnd_ssiu_of_node(priv);
 	struct rsnd_ssiu *ssiu;
 	struct rsnd_mod_ops *ops;
 	const int *list = NULL;
@@ -522,7 +522,6 @@ int rsnd_ssiu_probe(struct rsnd_priv *priv)
 	 * see
 	 *	rsnd_ssiu_bufsif_to_id()
 	 */
-	node = rsnd_ssiu_of_node(priv);
 	if (node)
 		nr = rsnd_node_count(priv, node, SSIU_NAME);
 	else
-- 
2.51.0



