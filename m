Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063728;
	b=LVaKLlDScAjgCSbahkH2r3IrDtX260GMpU6KFJ2wnmZpoJv53uPdprIQxuW3oLWXBGFQ
	 QFAjNcCspcTfhe3QGvSTowtF9TLwIKN0FL8PeKnjGXQTkoLvub75mSJRoqt5b+qn920zn
	 cxlGQrpYuOm02z9DO3007ssy6I6Vnq4hHTil0+MWqXtNKedjUlcDrQxHBA2RCna8eCjiA
	 dB5GRs1VpnBFiIHJVNmbeLdw+aF43jhjwzLmN6JsFpA1HIZZo0FI71qmcuzXYhPpqiWcV
	 5Y024cMFjrNrvEuWgWBKZ53ZC4rIzJIryI7J3Gs/qjwP8qDRqycTs35Guw52EqBNGVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YU2iecN6VcbIHpX/BKajDy9GLF8IA89nkjK6UxztQV0=;
	b=wIKd2tgoTMcrEtrPd6kw8E23g/pQaYUWig0y7LNNqB5g3XGVrBwO6Evk+vX6jYwSTzEM
	 lNFyemFDxQdWjORzMeinWyiJ3ZkkFzcRgvaxvxNW7hUi4Y+GsVtjJ6uc9HW92MRkP/uLe
	 A66Yx2C+lSTc0DYb+TlJ4ZOciRw+FoD9fI+jspwJwlU5wBslsdeB4IQE0waI9utwoqbds
	 ce5PQjbJePEJS1kXu8KL9x5kO8bZ27UPVHpIrohFqfxSc1nv2KFuFUT3+dzl7qRvPPBwZ
	 MrvRmNaSKLWeSZfp5hahCXh3Lhl8oDS2qiUUj/jRqg27bodamhyiJQ8f5LjyBFXNhPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAqnBQ9H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D91F6082BC8;
	Sat,  7 Nov 2026 15:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAqnBQ9H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5CC1F0089F;
	Sat,  7 Nov 2026 15:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063728;
	bh=YU2iecN6VcbIHpX/BKajDy9GLF8IA89nkjK6UxztQV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAqnBQ9HR7AvGyqL4FuqbPG1wrwOA7BuaYLQed5D88PyNvH53kSLzqc/NnSxZXuIc
	 BiKczL6OYDpa1tL7++kf9MM2FaJVBKpmXNaTJliPf1lOckub+m9HrITuJdcmwLbpht
	 FX4AuG8ogLchofm6mpHyiYvQQcgbCMdSUdjFXJBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 826/869] ASoC: hdac_hda: Keep runtime PM state in sync across codec remove/probe
Date: Sat,  7 Nov 2026 08:58:28 -0500
Message-ID: <20261107134920.960366455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1a89f570fd1f4..ac28b3cadb69f 100644
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
 
@@ -557,6 +560,12 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
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
@@ -568,6 +577,9 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 
 	/* Balances the disable above, cleanup_for_unbind keeps runtime PM disabled */
 	pm_runtime_enable(&hdev->dev);
+	pm_runtime_put_noidle(&hdev->dev);
+	/* The codec is cleaned up, system suspend must skip it from now on */
+	pm_runtime_set_suspended(&hdev->dev);
 }
 
 static const struct snd_soc_dapm_route hdac_hda_dapm_routes[] = {
-- 
2.53.0



