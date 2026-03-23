Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D422765C4;
	Mon, 23 Mar 2026 15:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278116; cv=none; b=bUFs8I6vl4cgWyvGWkP3qTG2o2kheqHFqtDk32QZoxgO/SGq8HHrVGXFAqsXRTxXcJkiNY4rJtS9qFm3I0anqQZjSz3PF2/AsSsv7+3cHPTxzD2rnPzQ3nDb+4OyVlAryBFGhcFgv8sh2eeQuGAR20C1eKuoVLGJSbYsFpMxGe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278116; c=relaxed/simple;
	bh=i+m3V8HkE7WEGHeA++11uJIdvT3iGlnxp7Hc5FWXct0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dj8gUCU+NDr8z7HrhKQwnCxW95pMuGrJyrmFtCkeWZrqjQFFbpV9vbR8zgAKJyuJZ56cEe7Q96j3mDvvomrR9NkQKb9///x+Zh7QR0ZwhglvG1/ghWJJP4ONvBV6khIreD3B/lEFj+MNhxqHzeoZfFZni6HCX9o1O4c/ycgFqTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xdM0VbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xdM0VbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78BCC4CEF7;
	Mon, 23 Mar 2026 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278116;
	bh=i+m3V8HkE7WEGHeA++11uJIdvT3iGlnxp7Hc5FWXct0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xdM0VbN6yyOImH2rmyn64G8aff4yBimxmZdy6RXnM25sodIifMWxhkqw2LEhHPpr
	 ZMOFlWUokId9NVDkgaEboqgWfflaG/9yfgpx0YvdPvyhRAw3NuixXKZ+Fi76px2bUo
	 aC5xTvEjeAZv2x/ANpgnLdElUdMUgaYCMJo41s/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 206/567] ASoC: cs42l43: Report insert for exotic peripherals
Date: Mon, 23 Mar 2026 14:42:06 +0100
Message-ID: <20260323134538.937180706@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 6510e1324bcdc8caf21f6d17efe27604c48f0d64 ]

For some exotic peripherals the type detect can return a reserved value
of 0x4. This will currently return an error and not report anything to
user-space, update this to report the insert normally.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260223093616.3800350-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43-jack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs42l43-jack.c b/sound/soc/codecs/cs42l43-jack.c
index f58d55d77693f..ba60acc4b2f09 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -699,6 +699,7 @@ static int cs42l43_run_type_detect(struct cs42l43_codec *priv)
 	switch (type & CS42L43_HSDET_TYPE_STS_MASK) {
 	case 0x0: // CTIA
 	case 0x1: // OMTP
+	case 0x4:
 		return cs42l43_run_load_detect(priv, true);
 	case 0x2: // 3-pole
 		return cs42l43_run_load_detect(priv, false);
-- 
2.51.0



