Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D48331EC0;
	Sat, 12 Sep 2026 13:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221586; cv=none; b=lNTyS1epiIbU5WHOKTh4C2V4Rg1dqas2bUINes7t/KvgKyBRQQ9v65EzzoYYZOcztxLlHqIlZUFbA82pe/KDpKNVGJ0zFDKUUKDrFg1Ic306EBokEHYFSV1QGEV6gvkEzlN+PKiG6Z0YMHpgj6vWOEMan2D1Y93EYbxFL5/aBL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221586; c=relaxed/simple;
	bh=E33ZB7ePInenfDtHvTRqgNkUbJeeX+tcTNi0h4ui7nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csgTULt94nDtknFthooYfTVnG+sy08sNgVmJ0U7viReU49XnAE99OIwD1FtBBVKb53jwYC5sWLTN4wDxPtl0IJZq9rLXosDwTwDHVxWDGgAtRZdCTvWCIPni3CZ1luH4LOIeOPP8Ra4w9TqJbRNeKbiYluJU1Vnfywd3H2PmPqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpyaaG3J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpyaaG3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48981F000FF;
	Sat, 12 Sep 2026 13:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221581;
	bh=aux3W4fJd/Q1pm1bw2a4KSAlwFw54+n9u5zoTH966xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RpyaaG3JTH92pkEvLz82LjPjfDd6O7wadlur0zmadAj5MqnvG0yAQKw6a3mc/x/F5
	 ufxcr8y7ds7wxCtuYjqe7AmNiIt1kfV3MHQHcFr1gYMP2zULFTqr64rARrxoaklnIX
	 q15xVHNBYf8wYP3EE/XsN8nTzSebpQz0dUqnn+ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0412/1424] ASoC: samsung: aries_audio_probe: double of_node_put due to direct assignment without of_node_get
Date: Sat, 12 Sep 2026 08:47:24 +0200
Message-ID: <20260912065616.509538102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WenTao Liang <vulab@iscas.ac.cn>

commit fb5d1b1c5f8a920ee697545fa6dee16825085717 upstream.

In aries_audio_probe(), aries_dai[0].platforms->of_node is assigned the
same pointer as aries_dai[0].cpus->of_node (from of_parse_phandle)
without calling of_node_get(). When the sound card is deregistered, the
ASoC framework calls of_node_put() on both cpus->of_node and
platforms->of_node, causing a double put on the same node and a refcount
underflow.

Add of_node_get(aries_dai[0].cpus->of_node) before the assignment.

Cc: stable@vger.kernel.org
Fixes: 7a3a7671fa6c ("ASoC: samsung: Add driver for Aries boards")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260627035251.60172-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/samsung/aries_wm8994.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/samsung/aries_wm8994.c
+++ b/sound/soc/samsung/aries_wm8994.c
@@ -659,6 +659,7 @@ static int aries_audio_probe(struct plat
 		goto out;
 	}
 
+	of_node_get(aries_dai[0].cpus->of_node);
 	aries_dai[0].platforms->of_node = aries_dai[0].cpus->of_node;
 
 	/* Set CPU of_node for BT DAI */


