Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1544D36B906;
	Tue, 13 Oct 2026 12:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895142; cv=none; b=GEba0gV3xfz2x39zBOC9AWArB+rgtZOnvkHRTFqXzbeOfgKE6k05f+d0qWvHw4YevciKiOjJjPfVegEAOJDvkPQXQXFnCiZJExMWTm/FPBNx9g/bCBFUG1SS7UdUBLflqzF/WxR8fT1lGGxc0bn8Eq/OQgmU1PQSFUPoDQta5xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895142; c=relaxed/simple;
	bh=Y6VTDusYWdelPnDl1YyPo3D14XFO/cWpKuBvYSg/kCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENBkRsNNx1Muajf3jrenXJ1XCQRYk2SrJGZ9EB5DNETmOTok+DHdAwMfFXt7QLrLXT6yrja6hT9H934h9ed86HJftc+OtFwSqGOqGu+l4fXVzdCiAHEGZGqFKpUT2Od0T4DnIFayXDqx2HfTEGKz4KdJU+cAgVMdUYt4R339lJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tcPNzsu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tcPNzsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306F31F000FF;
	Tue, 13 Oct 2026 12:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895140;
	bh=r7tWr6abmwvKP0rkBBB/McnoAt61ZDwbimnaMXOXyYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0tcPNzsu6sQLPhFtfdWNKjS+5i1x/gk8oEeOjywbdqpJknKCBhs/6rI1gb1Je0T8L
	 jhxWALIA0HPyfi2NB6J8rSWjYQA3jMvaBSJNtgNTYuX5j+Jw6JWgneqbSdo939n3Xx
	 FVWSWHfHoZzwyEhALkqsdmt3FFmKchJUiKZhmy84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 173/497] ASoC: codecs: max98363: fix uninitialized stream_config->type
Date: Tue, 13 Oct 2026 13:35:40 +0200
Message-ID: <20261013112911.996082755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -205,7 +205,7 @@ static int max98363_sdw_dai_hw_params(st
 	struct max98363_priv *max98363 =
 		snd_soc_component_get_drvdata(component);
 
-	struct sdw_stream_config stream_config;
+	struct sdw_stream_config stream_config = {0};
 	struct sdw_port_config port_config;
 	enum sdw_data_direction direction;
 	struct sdw_stream_runtime *stream;


