Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B4330DEDF;
	Mon, 13 Oct 2025 15:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368461; cv=none; b=eXvIfGJbn5hBw6uhh5+aUIT5aJeiPAA/8stv8vrCQn6tyE25KaA7DfseguXXfRd3QgNI73FvN9AhKQABjUu5e50+ieUP0GwaysatqHzXxmtX9zJMdcIiXONiTX8YwbWBqZtn/YxIgq7sF640aq5PNNErmsWEu/zaWdrj+IItT9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368461; c=relaxed/simple;
	bh=bUNzVXWC4XuwTFFJO7uihZbbjPBzkI0cz15/zwlCP1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLA3P5aRauS5OZlQ+hHTJTdpcEge75tqEEcpEw3wO7/ar+75WoOCEgKYjHHJAa93OZFscSh9OMkaP0BqcXEj7GTuKRj1xfpPFSxZSkxsI55FtLcTGI8JJHWS+WB2m7pEQvkEUtIl3vf8npsNM41kh8ExJiCagqqNoTgxTRCuv3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfFpqlYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfFpqlYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6863C4CEE7;
	Mon, 13 Oct 2025 15:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368461;
	bh=bUNzVXWC4XuwTFFJO7uihZbbjPBzkI0cz15/zwlCP1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zfFpqlYstP96yOtGX9Gw0i9ZP1uIMA9/1hnqOmDFNdkgTWm3y3daP/RkA9/lMkRqk
	 NFHbmQqwNheD8cGc2sOOGvZmUy6c2PkZ5+ydaDuJwscLOE1cxoMqxflR+g+VymZAao
	 kFSBISCNUx92KFLTX0Hw0doKEI4EJkeHw6j9HIMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 169/262] ASoC: Intel: sof_sdw: Prevent jump to NULL add_sidecar callback
Date: Mon, 13 Oct 2025 16:45:11 +0200
Message-ID: <20251013144332.210323415@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index 5911a05586516..00d840d5e585c 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -741,7 +741,7 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 			(*codec_conf)++;
 		}
 
-		if (sof_end->include_sidecar) {
+		if (sof_end->include_sidecar && sof_end->codec_info->add_sidecar) {
 			ret = sof_end->codec_info->add_sidecar(card, dai_links, codec_conf);
 			if (ret)
 				return ret;
-- 
2.51.0



