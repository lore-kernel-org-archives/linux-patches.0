Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062638;
	b=YkDYhZ1q8M7doQL6xbGdJByid0UkC+exgiD2l9hjlGHCg2tRV7a+TulId77i5xStzwes
	 lyjhQfMttx++NyaaiQv+G5DtL+pIKVEOFD8lqDTrGbLwc2D+bNnVU/3LjjsxXiRWc6ewI
	 HElX3norRUcSGyn3fuOpvhOib8wTp7X5/abkpoj4679U6OXh/VcrYu6zlh4G5bb6Sqcly
	 mjuDRQPyJQCpUy82hcKB2s+0dPmkI2mwoxxG4Ms+2Hqiwdntr8wPJ6np04sXtNL3iYq10
	 S3qQ/YEJ8hH1kEI6k716dC9NCHGsRZFPF/x9MXJITbAXtO0tHEfiqa0HZt41SDKrYsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vy4dJwN4MqolgXUj/USAuVHaXJ4EUWqX3HE69TxDNBk=;
	b=qFyzHfiRJpj8znCHDt+PWy+USYNNJrC5EK7pIvYjW7BTQX+hu/3e1iTluWE1qZzv7NOB
	 9i7QrlNMQPJBn8B279J862Vk9504iczLVy6tiMsjCjnKLtu/RQIQ68Bc79o4BPEi/7CEU
	 9Fv/mr2Le8LG7q7lpBzvtckjYefSTcBGwFJ+k7T2VS5liQQvIvuZqdEuFq3e8eMQmOTLN
	 YLJznce4NxHfXzvYYyJzj/Rxz8nEYrzDS+hhhU0ZgM9Sju3OMR0KViPNMtIEEQ0b72x+6
	 cy3QpaBHxnY+zX1kC7HelgYcseOA3NlgqWFKMNX5dYefXrYwGaePibUrxbMvc8M+Vuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kTODAxKJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC04606A334;
	Sat,  7 Nov 2026 14:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kTODAxKJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE4A1F0089F;
	Sat,  7 Nov 2026 14:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062638;
	bh=Vy4dJwN4MqolgXUj/USAuVHaXJ4EUWqX3HE69TxDNBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTODAxKJ/9nTzKpAwjw0m/6S1gdFC1u+lGQkMbij3s1zlmfcHCJ3QzZsF5yXm32FK
	 rOlLcPKEBGTqnqbKEYneeIlLRP7oCDObfDIKRbppapg0LwtB0Y5A9Nc1Q7vcKuSnrz
	 PPGrlCx5gGbEwylZ2l5yeZ9VWGMk/rzUNg3ElxgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1506/1536] ASoC: hdac_hda: Keep runtime PM state in sync across codec remove/probe
Date: Sat,  7 Nov 2026 08:58:42 -0500
Message-ID: <20261107135040.162316915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 99203e8d8968def973e82bb712ea959c6a46c16e ]

After the codec has been removed, its runtime PM status is
RPM_SUSPENDED while hdac_hda_codec_probe() powers the codec up via
snd_hda_codec_device_new(). The pm_runtime_put()/snd_hda_power_down()
calls on probe and registration then see an already suspended device,
the codec suspend callback is not called and the codec, its HDA link and
the codec_powered bit stay set, preventing the controller from runtime
suspending.

The remove has a similar problem with the codec link accounting:
hdac_hda_codec_remove() drops the link reference taken in probe without
looking at the runtime PM state of the codec. If the codec was already
runtime suspended, the link reference has been dropped by the codec
suspend callback and the remove drops it a second time.

Resume the codec in hdac_hda_codec_remove() before disabling runtime PM
so that the link reference and the codec_powered bit are always in the
same state as after the probe, and mark the device active on probe once
the codec has been powered up.

Finally mark the codec device suspended at the end of the remove. Its
runtime PM is disabled at this point and if only the ASoC card is
unbound (e.g. by unbinding the machine driver), a following system
suspend would otherwise call the runtime suspend callback on the already
cleaned up codec via pm_runtime_force_suspend().

This is a followup patch to address Sashiko reports.

Link: https://lore.kernel.org/linux-sound/20261027083840.28813-4-peter.ujfalusi@linux.intel.com/
Fixes: c3ec8ac82105 ("ASoC: hdac_hda: fix memleak on module unload")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261027144655.31988-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index 9c4a4b5779293..25a145cb8a510 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -517,6 +517,9 @@ static int hdac_hda_codec_probe(struct snd_soc_component *component)
 		snd_hdac_display_power(hdev->bus,
 				       HDA_CODEC_IDX_CONTROLLER, false);
 
+	/* The codec is in D0, the status is RPM_SUSPENDED after a previous unbind */
+	pm_runtime_set_active(&hdev->dev);
+
 	/* match for forbid call in snd_hda_codec_device_new() */
 	pm_runtime_allow(&hdev->dev);
 
@@ -556,6 +559,12 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 		return;
 	}
 
+	/*
+	 * Resume the codec to have its link reference (dropped below) and
+	 * codec_powered bit in the same state as after the probe.
+	 */
+	pm_runtime_get_sync(&hdev->dev);
+
 	/* prevent runtime PM callbacks while the link and the codec are torn down */
 	pm_runtime_disable(&hdev->dev);
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
@@ -567,6 +576,9 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 
 	/* Balances the disable above, cleanup_for_unbind keeps runtime PM disabled */
 	pm_runtime_enable(&hdev->dev);
+	pm_runtime_put_noidle(&hdev->dev);
+	/* The codec is cleaned up, system suspend must skip it from now on */
+	pm_runtime_set_suspended(&hdev->dev);
 }
 
 static const struct snd_soc_dapm_route hdac_hda_dapm_routes[] = {
-- 
2.53.0



