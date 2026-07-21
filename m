Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8883B1EFC;
	Tue, 21 Jul 2026 20:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667084; cv=none; b=WKa8QTavU9gHPSv+yoWfMSMdK+P5fyaR9uIMxtLsuPR10gaEZKlK2HzttEqDNBvTjnpvj7vd5TdXzdLbPz8gOWYrqopgGTQZEJofWSJmZrC0OVdLK4LLgwAFfqTT7dFCpDa4mCyWMf1LnVwAynItjt7D1iDhbyfZ2l9TPWPf5V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667084; c=relaxed/simple;
	bh=gPQbvZGGCaHJBqaQfQ/5pJJaftwzBtOG7Y+r6EWdgXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qdtHK028bVaUDURGzZHq3+bHQ9XjWHh0CkbOAJ5BY3FvbNB3PyL+VNlM/WxxB3nmpaXfpTFgSzzFWad8vON/OJBCxd88ERBUq2PpcZktmtDfnSLE6NVm4N1Qn0tDOGqFI0ve78f0p+GyKq+pifTVbTtLbB2hwo4ZoBaGlWVgilo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3tNyvXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3tNyvXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106601F000E9;
	Tue, 21 Jul 2026 20:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667083;
	bh=2XtqnjaXMwZ3HJHA35qatVvmktjL7eKYbbNS3Uar2uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3tNyvXjZqTa8+Q76DsEk4SGH9JAqCXEixzGf9yqFZPWzYoWsnNydMDj7iT/Z490g
	 FjWmdKSsGGe2KK1u1x2S94M6bilscBteihpPD4hUZO76E6sBDnp3GcDZEdzJEhjJb3
	 8hEvb0RCVbBXBQvYCQF3CjeOsHDkhlI7EyN9wfuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0920/1266] ASoC: mediatek: mt8192: Release reserved memory on cleanup
Date: Tue, 21 Jul 2026 17:22:37 +0200
Message-ID: <20260721152502.426622752@linuxfoundation.org>
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
@@ -2171,6 +2171,11 @@ static const dai_register_cb dai_registe
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
@@ -2201,6 +2206,10 @@ static int mt8192_afe_pcm_dev_probe(stru
 	if (ret) {
 		dev_info(dev, "no reserved memory found, pre-allocating buffers instead\n");
 		afe->preallocate_buffers = true;
+	} else {
+		ret = devm_add_action_or_reset(dev, mt8192_afe_release_reserved_mem, dev);
+		if (ret)
+			return ret;
 	}
 
 	/* init audio related clock */


