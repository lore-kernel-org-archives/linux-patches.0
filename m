Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4F136404F;
	Tue,  6 Jan 2026 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721878; cv=none; b=DZiizY8bA7JnbK1jzsD/dj8Up/uPo+d7DtZnECLUcs1BhfB9eOq3XhkeaQFSpWxQJ0juqvacPzK5GzvxaUV+LsU0zMCxg8WsmxQKUjS6ncitT26ASIX3+tIFlIw0N4Uh7flAcSjGnYipCjclyZVUk29KlS8msR0U1soMtNv9eQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721878; c=relaxed/simple;
	bh=d8NhDNuvcU7UvQ1ZbrI++JMzxoMGDAwKESubkgWDXS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRpob2Upw2ixlkvVHZ86yab+1NbYmp4ty+VSf3IOhoGvtA+urux3vEF+UQTdSE81A5bP2jByaZDnhUC6p1lvdUEOvVABR6gJcNnXmLQ2ZzRzRyz8zzxy6ZGqjLnD6P8jHW5UbAS0TR53Bycplm/DsiN6A36WMwVna1QJAyY+V98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N32XcBLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N32XcBLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16493C116C6;
	Tue,  6 Jan 2026 17:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721877;
	bh=d8NhDNuvcU7UvQ1ZbrI++JMzxoMGDAwKESubkgWDXS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N32XcBLTN3MZSVfn7TYfBt/j+NyS8Bzr0LD2kukL5qBXyjmZ8KaRcCNmrG0fGt40h
	 TgdvrZQv9JCMmBJMUJXFsZdjHQL2wtvMHZKDDkgb/CuaMhMHTJwsLpfM0jisDYi4+J
	 FxDcFlGuPlVP/uUQZcrcPgZDLWSdOSeBThS9Ivmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 099/312] ASoC: codecs: pm4125: Remove irq_chip on component unbind
Date: Tue,  6 Jan 2026 18:02:53 +0100
Message-ID: <20260106170551.421254757@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit e65b871c9b5af9265aefc5b8cd34993586d93aab upstream.

Component bind uses devm_regmap_add_irq_chip() to add IRQ chip, so it
will be removed only during driver unbind, not component unbind.
A component unbind-bind cycle for the same Linux device lifetime would
result in two chips added.  Fix this by manually removing the IRQ chip
during component unbind.

Fixes: 8ad529484937 ("ASoC: codecs: add new pm4125 audio codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20251023-asoc-regmap-irq-chip-v1-2-17ad32680913@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/pm4125.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/codecs/pm4125.c
+++ b/sound/soc/codecs/pm4125.c
@@ -1658,6 +1658,8 @@ static void pm4125_unbind(struct device
 	struct pm4125_priv *pm4125 = dev_get_drvdata(dev);
 
 	snd_soc_unregister_component(dev);
+	devm_regmap_del_irq_chip(dev, irq_find_mapping(pm4125->virq, 0),
+				 pm4125->irq_chip);
 	device_link_remove(dev, pm4125->txdev);
 	device_link_remove(dev, pm4125->rxdev);
 	device_link_remove(pm4125->rxdev, pm4125->txdev);


