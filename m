Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A486D20A5E5;
	Fri, 17 Oct 2025 14:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713139; cv=none; b=Se1XYhrCrCCZ1qgML7RSC/QXQ6j7jXI9RyS7F0swiEUL5DPF2w5ZoTdfkO1AHWDsL5Gu55k9JxouOHjMR2rG2dNcTRNE9kb2KS329ETwlcRkYyCPDXuLyUwxOkUhMqqAfESUFMRJvB7ztWj7q2kvS1ysFmzwNu8EFkaM5fwwxks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713139; c=relaxed/simple;
	bh=4RrHTIDyr3ZzpHu1qX7EshcC0FrAu1Q5gZ3RciozKH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h50XzXPGZoyn+5pqcFj0rdTGIFQ9+j+Rqcrek61m2Ga4lIjDiR9eDKj1CCJiG9FklFG1eYSKyhR1s/7ryXj86DQrs4xzwpUJ53EBsfLp6rV0xw2u3GlWObrjTwYFU58Wnul6Qx4cYWhPntu5KMKd+K7S6hm8+nL/Yxq/I2xCU1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCibwgLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCibwgLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328AEC4CEE7;
	Fri, 17 Oct 2025 14:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713139;
	bh=4RrHTIDyr3ZzpHu1qX7EshcC0FrAu1Q5gZ3RciozKH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCibwgLSNAEi7fY5bTLsh7rkjW/kqwUeMR9ZvTy/HSiQ/IUoxd7/6oLCqqrO9ey1k
	 ND4X8/gEC1bC5sFpkwZZtj90JtZtmqOHcg7zBpZgAA5vhiERh2J7gI0v+zULJLutYr
	 Kdho+4kYavrpUkZN/Txp7aTIegkYY6ZFO4fQwa0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlo Caione <ccaione@baylibre.com>,
	Johan Hovold <johan@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.1 062/168] firmware: meson_sm: fix device leak at probe
Date: Fri, 17 Oct 2025 16:52:21 +0200
Message-ID: <20251017145131.307995578@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 8ece3173f87df03935906d0c612c2aeda9db92ca upstream.

Make sure to drop the reference to the secure monitor device taken by
of_find_device_by_node() when looking up its driver data on behalf of
other drivers (e.g. during probe).

Note that holding a reference to the platform device does not prevent
its driver data from going away so there is no point in keeping the
reference after the helper returns.

Fixes: 8cde3c2153e8 ("firmware: meson_sm: Rework driver as a proper platform driver")
Cc: stable@vger.kernel.org	# 5.5
Cc: Carlo Caione <ccaione@baylibre.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20250725074019.8765-1-johan@kernel.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/meson/meson_sm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/firmware/meson/meson_sm.c
+++ b/drivers/firmware/meson/meson_sm.c
@@ -225,11 +225,16 @@ EXPORT_SYMBOL(meson_sm_call_write);
 struct meson_sm_firmware *meson_sm_get(struct device_node *sm_node)
 {
 	struct platform_device *pdev = of_find_device_by_node(sm_node);
+	struct meson_sm_firmware *fw;
 
 	if (!pdev)
 		return NULL;
 
-	return platform_get_drvdata(pdev);
+	fw = platform_get_drvdata(pdev);
+
+	put_device(&pdev->dev);
+
+	return fw;
 }
 EXPORT_SYMBOL_GPL(meson_sm_get);
 


