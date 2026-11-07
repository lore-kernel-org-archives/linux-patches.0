Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065466;
	b=DAwf/8z9VU24RckbSzR3mrr/wgX9/kXyzLmIBy5AaCXigXed5iG0I+mtgRNI+/tkLXtr
	 zfyOpPOakNdGE0ttO3/DUjBuDgMy438VGVKUpoMenUwuist/szuBkAfbNkWBgF0fJKtmN
	 oOsvxdIWVBkDVuZ55UY00laMQ56R8hCUAvTWemBCPoCn7HJlReeipTboANpILnwoXrFDO
	 YlnxuJ7h6GKni8wrwPobuH0CUPRXfJSzCzL3cMukJ0GEvaVopaboIJ1P6KBgKsm93Upig
	 IweV277cTfE19SOyuak8JRx6xWmzkqu63b/h3dpjVhs6emFkQG8Y95gGTbUv79aSFsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eZDJZMZfookYkE7cB5myLvTuOMk8Xr9rocmXEVyzbao=;
	b=DRU9wpyDnOWWDZpxl/8wSQeSEm4EFqr76ZaSS2fK0B+UrPO1xXFDyb5Q5sTND66nlPXr
	 UaseIOhzFn+p+tPUreEh+/ayqIhwszkPJVzugiI85lOISQ4NXdPkuY5zF/lDi9ctSkpfS
	 rQvJwO9pruhJGnCD72OfxAmJTn1z501gE8ipTtBP1tGKMeQd5Ioo0yRXyWEBT1syRq7FD
	 43ICh/+wa0opFVhArXOd+csrk8mqC0AZc8itY54JIyqyaqkO3GGWS/LHBe51FHjS7tzTS
	 iX1OZ73uNnHHb4RuXJT5faSIN7hrnbNhQhXLQAOFLo80qjW+KQ+UZ3ntgf+zrnfca4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ypziRvxT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EA8606A32C;
	Sat,  7 Nov 2026 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ypziRvxT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593D11F0089F;
	Sat,  7 Nov 2026 15:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065465;
	bh=eZDJZMZfookYkE7cB5myLvTuOMk8Xr9rocmXEVyzbao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypziRvxTx9lHxuqRc5uFraQUnVlz763lpzyOEbGja3kycp3S+QNuf72yyZXZKglOc
	 1d3muvncZ0aCxYzZ/31xuPga0oj1uZNBJunlR5gThUaV0nTCCpaK1reJMuEiAPJ62k
	 Y4BiCEc84LrqgEkNX+yMBuxSIAogSuxkZd0tth+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1161/1257] ASoC: hdac_hda: Balance the runtime PM disable in codec remove
Date: Sat,  7 Nov 2026 08:57:37 -0500
Message-ID: <20261107135011.260372656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1c06fdbf0e712..cbf17753d3fc1 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -554,6 +554,7 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 		return;
 	}
 
+	/* prevent runtime PM callbacks while the link and the codec are torn down */
 	pm_runtime_disable(&hdev->dev);
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 
@@ -561,6 +562,9 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 		driver->ops->remove(codec);
 
 	snd_hda_codec_cleanup_for_unbind(codec);
+
+	/* Balances the disable above, cleanup_for_unbind keeps runtime PM disabled */
+	pm_runtime_enable(&hdev->dev);
 }
 
 static const struct snd_soc_dapm_route hdac_hda_dapm_routes[] = {
-- 
2.53.0



