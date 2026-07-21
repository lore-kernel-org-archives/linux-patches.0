Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0662E62A9;
	Tue, 21 Jul 2026 17:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654156; cv=none; b=cgk2s1EXxlA9e2dsm6tZ5NVPYeumVYL6BFcJcJtPNNbiNJx0EOEBeGeOFYMcfQrA96Zy5aIWxfqvyXWHHoZaPl1S08tbnSgTEWJgZjkvThSqenYxu1QqPtY7WKYTA2aLx9xRLvAOwLf6HtHvt0823sbyC7IaqwjJf8NkBKlN80E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654156; c=relaxed/simple;
	bh=VfYrbQYEwxohribixJlcE/akR3R2sBfyRQDkYk//pvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jimaF0K5ht0UEah5qJoaemCAIz0QocjyTQRVRNMUEWl9Zgg6FnfZA8YqS63NMXD97KwJIQm16c2R9NfsX7+TMHRjCm4Xk1TfdXsoTAaSWBCsPdmlz+yp6ErkzITJpjsEuAK7S2YqX+MNofaFzVolaR3maOai/ecwDaz61owIFsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIZyAf3g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIZyAf3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5077D1F000E9;
	Tue, 21 Jul 2026 17:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654155;
	bh=8+5DiTzJy4nUIQSiAtE+rV5zfvRZX4xS9QAHTS/1oa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIZyAf3gi7FnqAC7o6ubCOVUxcNa/rArCa+2TMIkQ4VIQ1OXkFbyaGMRuNFM7DawQ
	 /Eod49+UqGkQF5AHY/52KTLaCOX3CW8lNOO5P0pFAwayzDxzY/Mh+4Vcwjs8W2cBKV
	 RCF/yZ43/rCqJLBVvZl63uB4TE5INgdJgTrnH9As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 1597/2077] ASoC: mediatek: mt8192: Release reserved memory on cleanup
Date: Tue, 21 Jul 2026 17:21:10 +0200
Message-ID: <20260721152630.439368214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 965e17ae6751c5d3302430c8ebd650e72d45a85f upstream.

The MT8192 AFE probe calls of_reserved_mem_device_init() and falls
back to preallocated buffers when no reserved memory region is
available. When the reserved memory assignment succeeds, however, the
driver never releases it.

Register a devm cleanup action after a successful reserved-memory
assignment so the assignment is released on probe failure and driver
unbind.

Fixes: ec4a10ca4a68 ("ASoC: mediatek: use reserved memory or enable buffer pre-allocation")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260527-asoc-mt8192-probe-cleanup-v1-1-1bb834d05b72@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2155,6 +2155,11 @@ static const dai_register_cb dai_registe
 	mt8192_dai_memif_register,
 };
 
+static void mt8192_afe_release_reserved_mem(void *data)
+{
+	of_reserved_mem_device_release(data);
+}
+
 static int mt8192_afe_pcm_dev_probe(struct platform_device *pdev)
 {
 	struct mtk_base_afe *afe;
@@ -2184,6 +2189,10 @@ static int mt8192_afe_pcm_dev_probe(stru
 	if (ret) {
 		dev_info(dev, "no reserved memory found, pre-allocating buffers instead\n");
 		afe->preallocate_buffers = true;
+	} else {
+		ret = devm_add_action_or_reset(dev, mt8192_afe_release_reserved_mem, dev);
+		if (ret)
+			return ret;
 	}
 
 	/* init audio related clock */


