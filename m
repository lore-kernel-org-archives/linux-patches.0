Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B49B38839E;
	Tue, 21 Jul 2026 20:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667113; cv=none; b=t1C7VCzR0reRN8qYWDLguHooJBqbxF7vTJbx2roygMJPbLHtyTTTgT5XNxQJCiFyAJpZSBVInECMrTp7L/R+hcpn5d0DwFTSK917teGcxGzbhja3djbTBPQz8wYpw7pRgEzxqdhIFGIVlZRHPY3P9kXWz3ZeR5J6cOMhnNz6JKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667113; c=relaxed/simple;
	bh=CsHNTKl9LdzWVJRzOIM+LWBA5AQXiJNqodD4hX/aZ+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lrme9tzhyBKEMSmW2MUfDtCFyzZPdTa3zw8eKgCQFoAAqFS6UHC1R3xiIKUpnJQIDNV7Jpy7sjcsldG6WEgd55cd5aF4SM6llopdLmqEVCuya3vXZV740FvMsBA0/Ikgy61c6KUNy74XoOZ2oGr7MHegpCRtnj4O2OkU5bFA84A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIFfgC6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIFfgC6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12391F000E9;
	Tue, 21 Jul 2026 20:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667112;
	bh=fJZddyYru+YCFyweMqNU5Vr/B6w2+bjeX4lUxGST9kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIFfgC6lInPBf5qp6Pyq/JZD+Tq7XY5kJQpEJkLDXFixmguQEj8LBo+8u1yTikgk3
	 BtanPb3dY2X6Ql9Yzy+ckpfKJKCoBG+v7eYty6yxl/khXleO8SLW4ApSEW5S6PALQw
	 vHSW70B/hOd6ZpEtAGStTSFmvQOJVtu1MOSqrg+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0921/1266] ASoC: mediatek: mt8183: Release reserved memory on cleanup
Date: Tue, 21 Jul 2026 17:22:38 +0200
Message-ID: <20260721152502.448408169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1085,6 +1085,11 @@ static const dai_register_cb dai_registe
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
@@ -1111,6 +1116,12 @@ static int mt8183_afe_pcm_dev_probe(stru
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


