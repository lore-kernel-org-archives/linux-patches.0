Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EF2472525;
	Tue, 21 Jul 2026 19:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663524; cv=none; b=j1e0iuY5RovWF4kuUUZtyuYEQ7vLLZSmcT/6LUX8OuZx5GgJeCWl54fc3ZikR5Bwrt1Vk53tfahpsFZZ6oaNZrC2Vhh6fSi6xy8/lf9FkrCM6eb2tR2rfYPWF/4ay3V0j29AfKohT8rEtmWdcWLx9na8/ireWOX2dGKPpaPVc3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663524; c=relaxed/simple;
	bh=qxqicNw5cvYnRRD+VRzSSBmMdvlGkkm/wsS/8VFM8Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LK2kkOLcHmG4fBBS7NgyLzvq6ZZPRmBRmBP3kcvNCE6FESPZJ/5SpBfCyiwHDHzhJVMgVdAmDQhztLcZGP8xXYGE16dMEJajU4XicopafhjaMgS0QFdSdjoocVcjVZhgmMmDdR4bw/5bbb3YoA87XgOgfIPdNZHTxgO8bXc5JNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYJkXt7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYJkXt7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9851F000E9;
	Tue, 21 Jul 2026 19:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663522;
	bh=n0kGN8N8BjfJmjP6A4LncDX27qgIatdnamFb7bZ2ZdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pYJkXt7F9XmCl93x/ZhhLrPbYFV5JWJZxfS40gjvVaHwgzNYvczR3S9Iql7XbuQHt
	 ibCstsAK55zWHGQl/ZId0Pbvq4CMZaZlbi6cT/UmVztVJ6Merri/QgALdBvMT8loVS
	 SuVv2eySOdLIcMX6AHLJ5xwRTNK474HPAUdWknZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 0855/1276] ASoC: mediatek: mt8183: Release reserved memory on cleanup
Date: Tue, 21 Jul 2026 17:21:38 +0200
Message-ID: <20260721152505.184187108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit bee65e00c0924ebecf97718d95dcf4a05ee36471 upstream.

The MT8183 AFE probe can assign reserved memory with
of_reserved_mem_device_init(), but the assignment is never released on
driver removal or later probe failures.

Register a devm cleanup action so the reserved memory assignment is
released consistently, matching newer Mediatek AFE drivers.

Fixes: ec4a10ca4a68 ("ASoC: mediatek: use reserved memory or enable buffer pre-allocation")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260527-asoc-mt8183-probe-cleanup-v1-1-4f4f5593c8d1@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c
+++ b/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c
@@ -1073,6 +1073,11 @@ static const dai_register_cb dai_registe
 	mt8183_dai_memif_register,
 };
 
+static void mt8183_afe_release_reserved_mem(void *data)
+{
+	of_reserved_mem_device_release(data);
+}
+
 static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 {
 	struct mtk_base_afe *afe;
@@ -1099,6 +1104,12 @@ static int mt8183_afe_pcm_dev_probe(stru
 	if (ret) {
 		dev_info(dev, "no reserved memory found, pre-allocating buffers instead\n");
 		afe->preallocate_buffers = true;
+	} else {
+		ret = devm_add_action_or_reset(dev,
+					       mt8183_afe_release_reserved_mem,
+					       dev);
+		if (ret)
+			return ret;
 	}
 
 	/* initial audio related clock */


