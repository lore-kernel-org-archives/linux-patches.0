Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045848;
	b=tAkBbLkcsACXxaLVcHZaV+oMdRVWexlkc775ogAvm39QqEKj98UjptGEGi0WCFOfCiuF
	 gSQ7kfqAYC7Z4ep05HaDU8CpUjurzwByNYsSykFHKOy8d/vIroms5FQLLjNamDXbawRiC
	 nuTyavTo6CEdwnWYzAo5wE5WsWsK5INwotGwFhFwCLKHSEeQG38UaeXcDVR8kTO6IZ4I4
	 49UQs7KrrdXT4mklrQuoHxCFVLghLMVXQBZtHndQ6MPm6WRO6BvUECJI5H8l9680rVJVL
	 6qobSfQmMvo2K7ZBVMkiRIxPXjUzKh9vxRqYcrlZTq/YJ84u9FHfbjWzibxJi0c7WFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QzGvYYD4xW5PWEwgUL7nrCpvc7fHniPhevqyoFMlR4U=;
	b=pIDeaeZ/z7Hugo8k0UU14Gy6jWy30lXqlqM/Hljmon8CLogC8ss/UQuqF7dXGYQ2rUyw
	 fmFZfrBbXi2FnXFalZEc0W7UeCyA9NfgiQL32vZpZ8Ki8+m53xorwNh5kNW5tj4LIOA1u
	 tatPyMNHzLWpAInull1GGGTK4JREqqoYmLpiP+Bgk3quFC3uJsn6ejpqFXY61KiCRfn0r
	 K6c/n9yzWUKPKLHKF8m91k9CKkuaJbE1OMMkTo/9vR2nX9evzmvOck2NYdIJwT8eXVDaa
	 mXgOpLKU0HqUpWmGLDsF4FoFmC26wUBuJsPeSg9nrhGmKs7mbxrB37x+Z2vsHP6GBwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SaV32ITw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A505660A2602;
	Wed, 18 Nov 2026 23:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SaV32ITw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0622C1F000C5;
	Wed, 18 Nov 2026 23:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045848;
	bh=QzGvYYD4xW5PWEwgUL7nrCpvc7fHniPhevqyoFMlR4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SaV32ITw0yWfbBv5y8V2BKvsuhPReaAEpX9BopvPL4fYKWzk59ndR9YHVU16bEVT6
	 nqKMy49BC+wK8zWdATtQ4KOKkMqeyVyREuJbuZIdhJhc+oyGkpNb36skwzgrReJZDu
	 YAOJlNWCHTGN8lY8tNQCHsrWSMI+EjmbqPxje6mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1068/2857] ASoC: hdac_hda: Balance the runtime PM disable in codec remove
Date: Wed, 18 Nov 2026 15:35:02 +0100
Message-ID: <20261118150240.059337239@linuxfoundation.org>
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

[ Upstream commit f26c0d5f91d918bb66cbbc8916f41836adb38346 ]

hdac_hda_codec_remove() disables runtime PM of the codec device before
releasing the HDA link and calling the codec driver's remove callback,
so that no runtime resume can race with the teardown and access the
link or the already freed codec driver data.
snd_hda_codec_cleanup_for_unbind() then disables runtime PM again.

On the next probe snd_hda_codec_register() enables runtime PM only once,
leaving it disabled after the ASoC card or the codec driver has been
unbound and bound again: the codec stays powered and runtime_status
reads 'unsupported'.

Re-enable runtime PM at the end of hdac_hda_codec_remove() to balance
its own disable. The codec remains disabled until it is registered again.

Fixes: c3ec8ac82105 ("ASoC: hdac_hda: fix memleak on module unload")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261027083840.28813-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index 4dcb4eb04ec25..6b9c0ad3600a8 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -525,6 +525,7 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 		return;
 	}
 
+	/* prevent runtime PM callbacks while the link and the codec are torn down */
 	pm_runtime_disable(&hdev->dev);
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 
@@ -532,6 +533,9 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 		codec->patch_ops.free(codec);
 
 	snd_hda_codec_cleanup_for_unbind(codec);
+
+	/* Balances the disable above, cleanup_for_unbind keeps runtime PM disabled */
+	pm_runtime_enable(&hdev->dev);
 }
 
 static const struct snd_soc_dapm_route hdac_hda_dapm_routes[] = {
-- 
2.53.0



