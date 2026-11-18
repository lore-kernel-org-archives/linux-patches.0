Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045987;
	b=UWAXnfXCiIWsSI2Xk5k3t8+L0gbGnwcTyDtJKw1cg2ZV0LkNE3Ktbda/g9HwcnBMZH/7
	 aQu1JoTAvKqVHlUBAOivg6O8y8STwNnzL8v28aqph0FrOyAieP9sNAeSEtQForBkIlHHU
	 /EgUGgxBiCfL2ySf3kFh/CH9o+dgjW7nNIKDq9rsiYWlLfkd0ERKR5nLZmUbEJEqz2Tdy
	 1zkuLOyeza3ia/veERqVeQPaXZ2kXeWiTdBBDDofEkOxKS6nS1broHRAStjIAc0ErD7sQ
	 qEcSAxUvSC1AZU/glqPLc52AviL2LhidaPtIW858NIz9iI1V482gcCy0AXCV7yPHBNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bfFeYBQ3G6JLGWXvgtZ7mnm8qIte9qaIm/PC9Nq5TEY=;
	b=jYNsK731J+IGG+O0TGjXsaVp9IxKaiy2dW2V8HzHLYXEK4wcWmmGHhxAkpK2JOERBdYW
	 u+MOjNvt5Q80l0HRlHrRNUNW5SCfOzd1ipXIAGNaGY8VmkPz5aouXKshNM776Ogmuex4+
	 UNo56D4IyWmDw3t0sGIZ0W5yImXFTGjndnq6XKk/GCl7g+4QnX0Mr04nDyKUSosjwRpc5
	 5abWueMMC30dRG21Ezr2aatgLOjaG3plEdXNZ3zTuSIMFaIT1AGETo9ica6aMmeftict4
	 3DrmwtI2yjuj/88gdA9t5z1ztbveZnrCFlV/eQstjX66kd8qi/oTeuh4emkvWKtu5PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MuHcvn3x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B69F606A31C;
	Wed, 18 Nov 2026 23:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MuHcvn3x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786451F000C5;
	Wed, 18 Nov 2026 23:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045987;
	bh=bfFeYBQ3G6JLGWXvgtZ7mnm8qIte9qaIm/PC9Nq5TEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MuHcvn3x964rEH+A/9FBjlxOScOvTWJpOmJ2rMK2NpX7T8Rv+tGArBBLZK3WgDNuH
	 TG6r3mAdhArk7kIt5cxNb6xnA9H4MKl6rSHxfF4bB8DLviAEqk+Yv49lKCSbYLWKT0
	 7g+e3T+K/4L6z1LIG6mre/TI67nu5Qlf7/uBIrJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1079/2857] ASoC: hdac_hda: Keep runtime PM state in sync across codec remove/probe
Date: Wed, 18 Nov 2026 15:35:13 +0100
Message-ID: <20261118150240.470982788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6b9c0ad3600a8..2ca9104853970 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -486,6 +486,9 @@ static int hdac_hda_codec_probe(struct snd_soc_component *component)
 		snd_hdac_display_power(hdev->bus,
 				       HDA_CODEC_IDX_CONTROLLER, false);
 
+	/* The codec is in D0, the status is RPM_SUSPENDED after a previous unbind */
+	pm_runtime_set_active(&hdev->dev);
+
 	/* match for forbid call in snd_hda_codec_device_new() */
 	pm_runtime_allow(&hdev->dev);
 
@@ -525,6 +528,12 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
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
@@ -536,6 +545,9 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 
 	/* Balances the disable above, cleanup_for_unbind keeps runtime PM disabled */
 	pm_runtime_enable(&hdev->dev);
+	pm_runtime_put_noidle(&hdev->dev);
+	/* The codec is cleaned up, system suspend must skip it from now on */
+	pm_runtime_set_suspended(&hdev->dev);
 }
 
 static const struct snd_soc_dapm_route hdac_hda_dapm_routes[] = {
-- 
2.53.0



