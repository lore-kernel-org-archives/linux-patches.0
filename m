Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42F0125AA;
	Fri,  9 Oct 2026 14:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556283; cv=none; b=chpMi7nyKRlDLqwurqHcVmfIKZ+LTTjdZ83HgY6zDEpUZINBYo3nlb+0TB15JJhmFp/Jkgg/JEclaaMJ31I6gLpDnqDNdsfmFcBiaxgy+bqibzApqB9WtWnmbi052OKEOzrdWNbeflaJnHsl490YVvZv6FT+IWONM0yXV9++Swk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556283; c=relaxed/simple;
	bh=+7BLSQOwqJt1FjHuEyyyvdWACwR6P19fd+Xc7aytj08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVMzASg4Mm1yKhZtQQKGbwQqaX21jKegsGyNNAYNhfd3gfB1CbDQjLoRcQd8iXKtEIXCGjaCRinISLc2JrxcHFBexltZqSBl8/V37LYTo5JA6TNYG5qvYQgKMhsHGc+o8L95T7d0DTQLs2bQW66voXT6xA0q3CT0C2dJQcxeesE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hg/IQK9Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hg/IQK9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1DF1F000FF;
	Fri,  9 Oct 2026 14:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556282;
	bh=u4WVJiA54f4Yd9/lYVIurrRgVbEVqf5PhlAjuceiqaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hg/IQK9Y0MjucpturzzWz1iVV9s4bg/hMTGtGGsP8sgYDgCZBdSJzjnEOX2Ks4ytv
	 9Yvi6/Bo38wmusrdFefF2jIJ/Y5Op0yGSI4D17XY3WcAva+e45Al7Bfpbf0epLUQEi
	 nG7tOUR67NQjVLa5Xk6R7fnhBmKCt7wiOZB1mCq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 209/403] ASoC: codecs: max98363: fix uninitialized stream_config->type
Date: Fri,  9 Oct 2026 16:09:30 +0200
Message-ID: <20261009140957.028999754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit bcd61aa247c28b721ac21dda6e4135f75a2de29f upstream.

stream_config is not initialized before being passed to
sdw_stream_add_slave().  The type field may contain garbage and is
later copied to stream->type by sdw_config_stream().

Zero-initialize stream_config so type defaults to SDW_STREAM_PCM.

Fixes: 18c0af945fa3 ("ASoC: max98363: add soundwire amplifier driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Link: https://patch.msgid.link/20260914104456.376666-1-yijiangshan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/max98363.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/max98363.c
+++ b/sound/soc/codecs/max98363.c
@@ -204,7 +204,7 @@ static int max98363_sdw_dai_hw_params(st
 	struct max98363_priv *max98363 =
 		snd_soc_component_get_drvdata(component);
 
-	struct sdw_stream_config stream_config;
+	struct sdw_stream_config stream_config = {0};
 	struct sdw_port_config port_config;
 	enum sdw_data_direction direction;
 	struct sdw_stream_runtime *stream;


