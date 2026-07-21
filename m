Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60AA403E9B;
	Tue, 21 Jul 2026 18:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658556; cv=none; b=IEe8cIgD8kvd/M/tR1v4fw0e9T6Ghia5MehevL0Y8Mnsj6D7+ZecXHnJHAgChIBJUi7yYS2ZvFBDKTtHfR/P7B7/NEa8nXwcpV9PesUrO4Y5wMLiKLn9ZDw46Wk/QnlwTiS+ljghJKQ57sCKytwyvwQIy+GWKtsOGUwupZKGa/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658556; c=relaxed/simple;
	bh=p7MEMVfbpTaXSSRa1MSl/pNiV1Lcr4cAfw6507eSA7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mKXWkTGaJs4/Fp7FLBGA6G8sYe8kOiHVid97hNQQIhgqrodzB+NOAElv+ZyboEj2ZxOA5o6V52+hhT/CWfVvN3h4sR/3oJkfloWcKLsVkQB1iSkB+JZHltdcLnYT/u//0r0HHsssP08Xzg3rzQiiFYp5aJne7a1022+KliDNhnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmJT7CwB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmJT7CwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7016B1F000E9;
	Tue, 21 Jul 2026 18:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658555;
	bh=iNlnlBnqHPtnH+klZQfZpYd4KWBPF4a9a27W0zuJ67k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zmJT7CwBWZdNxkSEfKfGQvDbBNgT7/AXaV9WzbAr8IietluoHp4xOP0/KbwTVZ1zc
	 lBpFXAb2drgymdaNfSja3ieYT+mlIjMm6L+ROixlMeZeqUpXjZPDJXfO8D15ELgl6W
	 TI8MBk4/KJLV6ST2mZEuKY2P/vMMs1jcU1n7kGKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 1161/1611] ASoC: mediatek: mt8192: Release reserved memory on cleanup
Date: Tue, 21 Jul 2026 17:21:17 +0200
Message-ID: <20260721152541.537853109@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


