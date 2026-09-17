Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF214DEC08;
	Thu, 17 Sep 2026 18:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670391; cv=none; b=DpMNGpDxjr5kpZT1vd96UcbK3jL+kOm8V9LD5JlB22gc39/WAC7SwZjDIq1qqO/IeGcVogsHZCEwIFRUSc7RzRSLhBurGENOm/LCiqi4LB6WHqRsxRLRARER+cmAkoOUJQHcjJn2kWOPW3ZigtLlgk5xDVXe4ut/sevv3wpAalI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670391; c=relaxed/simple;
	bh=enHtKyCzbvsyZwB6VQpM7MeZMu5MuSCEg4A3EjnR19M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oSXvxgTMzSdV/CaZQafEquGdNU4IWmvU+dBBLhFFo0Q7FqFgbS0fDATkDDJY5r6E82+kKOiSI/IZgS/oaccZmKqYHMqi2GhUlqFkUpK5zJM2skHNzncnFk4XwgkhSGlyjoAo5fPyLxPm5A0j9csyPFLdHHX2PK1Xfzmi8MUmH9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8rnFzhc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8rnFzhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D2A1F00893;
	Thu, 17 Sep 2026 18:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670388;
	bh=pD++5pkM/yJrltmDKOUBGI/KOCGathobXmb36+VScW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8rnFzhcs51S7AZ181RIj5IBBPnMXDhg5cSTH+xDxtoPtoiKnr4D8rMFQbS80MozO
	 ROOo/flrhOSkuCPoIdmgHYdaq5Mu//G2rmacvc9bgvmLcLd7AMUbK3P9v0gCLyHfAo
	 tezSc+8b6Nkv+9RrtF4IzA8XIMsxYR9jhoJRfXno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0649/1102] ASoC: Intel: avs: Clean up streams if their initialization fails
Date: Thu, 17 Sep 2026 16:09:52 +0100
Message-ID: <20260917151556.451520849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cf7adf67e34a1..600e1a0a365da 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -85,16 +85,28 @@ static int avs_hdac_bus_init_streams(struct hdac_bus *bus)
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



