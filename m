Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C055B22A4E5;
	Mon,  2 Jun 2025 15:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877228; cv=none; b=aqpJMLoJeLMO8ga8nQwXp2f+hKw3eN7xivZGS9aaT3xoNiEPy8McCPQP4Z2ga4yXypgpSJffAK8Sm/3LgryCV/fb14bNiP7vBSPKBHD+ureGhF/d25bo5MMcd66tJIZM5rvNXWZeBA5SQDtbWAS9xRDo8M4eln6iWb5EErfMOdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877228; c=relaxed/simple;
	bh=BJMVxnrfcKeUn/XuxeMtnCnxF+X/vMlUhIuIwen+K6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8GGE7qaCGCX8WM038Mw6nj8ApiUchIXXqi10p4YzgSVaaX9lFk1n0x85CIlQ3D509+TW4BKUtNzMg0c8xD5L54ARgJCTwx/HyT8jSM/O0Lqag//VyiLJoVxG6Sa17RZTixUxKs0kK7gmaYx60zZmLKUkYZmFM75Yld11wdT+so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0mt5fvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0mt5fvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C24C4CEEB;
	Mon,  2 Jun 2025 15:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877228;
	bh=BJMVxnrfcKeUn/XuxeMtnCnxF+X/vMlUhIuIwen+K6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0mt5fvwWxNw4TBqBRNovd1ravm7zsTxqUDyXn/7obIoDaY7u4C6DJ5YAiRcN7UaK
	 RRfIUP+b3VuVnW6N9jLQchxiNdAt/knNV4Nw4HPOZKhSGJgIWB/obNJt+ddnQG125y
	 7Lu2004em96XygI06URZQO0vBeUB6D5lRRQ1sTmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/325] ASoC: soc-dai: check return value at snd_soc_dai_set_tdm_slot()
Date: Mon,  2 Jun 2025 15:47:27 +0200
Message-ID: <20250602134326.765092042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 7f1186a8d738661b941b298fd6d1d5725ed71428 ]

snd_soc_dai_set_tdm_slot() calls .xlate_tdm_slot_mask() or
snd_soc_xlate_tdm_slot_mask(), but didn't check its return value.
Let's check it.

This patch might break existing driver. In such case, let's makes
each func to void instead of int.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87o6z7yk61.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dai.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-dai.c b/sound/soc/soc-dai.c
index 49752af0e205d..ba38b6e6b2649 100644
--- a/sound/soc/soc-dai.c
+++ b/sound/soc/soc-dai.c
@@ -270,10 +270,11 @@ int snd_soc_dai_set_tdm_slot(struct snd_soc_dai *dai,
 
 	if (dai->driver->ops &&
 	    dai->driver->ops->xlate_tdm_slot_mask)
-		dai->driver->ops->xlate_tdm_slot_mask(slots,
-						      &tx_mask, &rx_mask);
+		ret = dai->driver->ops->xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
 	else
-		snd_soc_xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
+		ret = snd_soc_xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
+	if (ret)
+		goto err;
 
 	dai->tx_mask = tx_mask;
 	dai->rx_mask = rx_mask;
@@ -282,6 +283,7 @@ int snd_soc_dai_set_tdm_slot(struct snd_soc_dai *dai,
 	    dai->driver->ops->set_tdm_slot)
 		ret = dai->driver->ops->set_tdm_slot(dai, tx_mask, rx_mask,
 						      slots, slot_width);
+err:
 	return soc_dai_ret(dai, ret);
 }
 EXPORT_SYMBOL_GPL(snd_soc_dai_set_tdm_slot);
-- 
2.39.5



