Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B21146D2C3;
	Tue, 21 Jul 2026 18:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658605; cv=none; b=oWAfPdjzP1OqtLJ18ux00Ds1l1YbGTA46UBFudFyqnxxmhKR6n1CvORqi28X1zDk2J392IIyB6ldErn+/IQKYG+ShNH3Nhe3O7Mvrv+gSXMgwRD65sdRSVl+2Rjp/nCOMC4SfJRugwVZE3t+PdWY5C8RfRF/iETAFkgcokzR7m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658605; c=relaxed/simple;
	bh=L51vlY+vo3qQV+Uz6sITvnbn629G7u0NI4ZYKiFZxnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f60hoSjUEMYwm8ZoBr8rLN8V2W8cbx+nXQRe5R5tU6c0V5XE8NZk939pZ9QOBgvYzFEUYbqfLD4GiZv3VNAXHcD7QOssFf47/lNfXkaDmDG9FDCADLt5b1Kn+xqTO//MPX2hFkwEge4y6oSeuBfg7O+oDcHIqLHD0SgrzMtwgKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WMk/gL5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WMk/gL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12441F000E9;
	Tue, 21 Jul 2026 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658604;
	bh=0gpcZTI1xTF+e1F3zwz+kU0Mhoy/k+lCL0ZoGSsdTo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2WMk/gL5M+av2Z2i0ux9Z76vUlD+JQjoU8h7A885QucPLjFKB+xBUjNg25Qju25IX
	 DZuLFrh6KWVItgHqulD9+kV0kl7qjY4w9IuQ4G5hfw222baa4KHVLhzMA4OTcAE1KT
	 Kf/CQ29ix1X+m45G5Fe4CBAO0IMxsVuTz9WDQFOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 1163/1611] ASoC: mediatek: mt8183: Release reserved memory on cleanup
Date: Tue, 21 Jul 2026 17:21:19 +0200
Message-ID: <20260721152541.582724685@linuxfoundation.org>
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
@@ -766,6 +766,11 @@ static const dai_register_cb dai_registe
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
@@ -794,6 +799,12 @@ static int mt8183_afe_pcm_dev_probe(stru
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


