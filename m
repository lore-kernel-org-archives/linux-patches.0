Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEA351598C;
	Thu, 17 Sep 2026 17:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665618; cv=none; b=BfbZY2uaGTjnbsKbm5MtYl0n128A1+lJ8VqxlEe0GH8picCTjAZjDe8EoZCg0UyS2of80We+6vx1qYF6JnvD/nIWj8mgGHp++ZWhdKqrVQ9O/c1CIj9sAYNcaQHiB++FkyizLINX+uL2OXz6wxqcKKBhDcmSHJjpGIedOrHOpPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665618; c=relaxed/simple;
	bh=WJZLRnPnxHnhypd9qJCzb4IO+TaZqAPoKGAYQgtWOEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hA+rDHTpYUmdbFzGEHtSqKI9QKpWcOw9gmbKxiGKnfgKqpTgNF+tQgovCC5TmEfzQ56OPFOCv2c3MK9aSViY3sHsSgpeuuEl0krzCZo/X+9987sNfY41/y0HcYA/Dknnn+OpEO8uY9SPLAmBgxnHQ6XKVDY9SCM1W0ogVWbRhno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDSlmBkH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDSlmBkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD3D1F000FF;
	Thu, 17 Sep 2026 17:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665617;
	bh=LYYGvPRLtt6p+AyHDH3LK4/Cm502l8crBpbMkS59u+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDSlmBkHbVu8bTnqWKn9v9g7vd9zeahAq/3I3Ju8RgB9xrL6hFuVtJ1vyOgHzP1Xr
	 E4UdTjhEdrgzi1oR8GAEF0IpGIcqehezZP2ZASKuYkqhI7kF69AKlmRxjtYWP41A2+
	 Nybjp2lWPvqo3WXwkqCrjlM/sML5Gjka7hGOlYic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0763/1250] ASoC: Intel: avs: Clean up streams if their initialization fails
Date: Thu, 17 Sep 2026 16:09:18 +0100
Message-ID: <20260917151612.556755246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit f4ba00bb56a8511bafbd19826501d27157141c6d ]

When streams are being initialized the memory allocation may fail.
Have an error path and return early if that is the case.

Fixes: 1affc44ea5dd ("ASoC: Intel: avs: PCI driver implementation")
Co-developed-by: Amadeusz Sławiński <amade@asmblr.net>
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260902081814.1590883-6-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/core.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index 061d97603abbf..b52809934186b 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -91,16 +91,28 @@ static int avs_hdac_bus_init_streams(struct hdac_bus *bus)
 {
 	unsigned int cp_streams, pb_streams;
 	unsigned int gcap;
+	int ret;
 
 	gcap = snd_hdac_chip_readw(bus, GCAP);
 	cp_streams = (gcap >> 8) & 0x0F;
 	pb_streams = (gcap >> 12) & 0x0F;
 	bus->num_streams = cp_streams + pb_streams;
 
-	snd_hdac_ext_stream_init_all(bus, 0, cp_streams, SNDRV_PCM_STREAM_CAPTURE);
-	snd_hdac_ext_stream_init_all(bus, cp_streams, pb_streams, SNDRV_PCM_STREAM_PLAYBACK);
+	ret = snd_hdac_ext_stream_init_all(bus, 0, cp_streams, SNDRV_PCM_STREAM_CAPTURE);
+	if (ret)
+		return ret;
+	ret = snd_hdac_ext_stream_init_all(bus, cp_streams, pb_streams, SNDRV_PCM_STREAM_PLAYBACK);
+	if (ret)
+		goto err;
+
+	ret = snd_hdac_bus_alloc_stream_pages(bus);
+	if (ret)
+		goto err;
 
-	return snd_hdac_bus_alloc_stream_pages(bus);
+	return 0;
+err:
+	snd_hdac_ext_stream_free_all(bus);
+	return ret;
 }
 
 static bool avs_hdac_bus_init_chip(struct hdac_bus *bus, bool full_reset)
-- 
2.53.0



