Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B378E3081C5;
	Mon, 13 Oct 2025 15:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369879; cv=none; b=l/PLPKkw+tWwGHQa57j1bBSQgwIY3WKteoXaZ7Xs/GNlk4MW2cRV6mfTIJJYK+W85hn2Rvc7EEWPOYJyWKKR3ZkoS7XWWPp9n2EHM6wT7YYAXlGYmAOYeEo3fziYygvchDn8IF9PxaaG8Vj3BhViufw1MXbW7igOch19NRD/4ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369879; c=relaxed/simple;
	bh=qbejtbqHZbakfuWmsVdWW6kvbd0p1sIH7HeV2UT6Mv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQvRHVAjUbf08D4uMY5DWsSiGXrqpj6rFJm91HBsJVZyvGRsQOdwwXcXoQAs5t+Y9g43LH8hdFTqgg+N85x6IRjCWXIdPtJnw/2F6ZgQ2jpPemBz8t/xufptaLExVFmuY53HDzeD0CiuwUIKRHf6knNwpjuZ8MjWkoR8QHK9VTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4C5EDkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4C5EDkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA66CC4CEE7;
	Mon, 13 Oct 2025 15:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369879;
	bh=qbejtbqHZbakfuWmsVdWW6kvbd0p1sIH7HeV2UT6Mv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4C5EDkwrm1bc4WQhbwODmnobbVJvy46HSVL31x+DPGY+n4yNE38zXskezF3H/wxR
	 /e5zk+y+vF85IJ61wKpD+G5V/cHAVWNIR8LgCvjVwex37VD0y11ijiN7MXRGpC+xog
	 Z/kh8SWCSdWy9f6U8zil5pZUQzRWCkQFhQySO8qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 400/563] ASoC: Intel: sof_sdw: Prevent jump to NULL add_sidecar callback
Date: Mon, 13 Oct 2025 16:44:21 +0200
Message-ID: <20251013144425.773265229@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 87cab86925b7fa4c1c977bc191ac549a3b23f0ea ]

In create_sdw_dailink() check that sof_end->codec_info->add_sidecar
is not NULL before calling it.

The original code assumed that if include_sidecar is true, the codec
on that link has an add_sidecar callback. But there could be other
codecs on the same link that do not have an add_sidecar callback.

Fixes: da5244180281 ("ASoC: Intel: sof_sdw: Add callbacks to register sidecar devices")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20250919140235.1071941-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 28f03a5f29f74..c013e31d098e7 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -841,7 +841,7 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 			(*codec_conf)++;
 		}
 
-		if (sof_end->include_sidecar) {
+		if (sof_end->include_sidecar && sof_end->codec_info->add_sidecar) {
 			ret = sof_end->codec_info->add_sidecar(card, dai_links, codec_conf);
 			if (ret)
 				return ret;
-- 
2.51.0



