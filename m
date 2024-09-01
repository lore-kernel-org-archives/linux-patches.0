Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C214018308E;
	Sun,  1 Sep 2024 16:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209117; cv=none; b=TTm9j8llgYP1t6rIayiE2lOgUajt3l7/3pq+FYHO+T0gsLV466w7zGK0+sl+ei2XWlH+fXF5pQy1zRE238LylekyrtOBG9coXGjzeGt8jKwNIsHQ05WTZogun4FCBJOiZG3iwNF/8KaFRkyfNJxmzcOYmTYh5BFh52yNwkVuK+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209117; c=relaxed/simple;
	bh=jh7rL0YE6TbcHGp1RoLNwl1btEQMaIis7FdggqZ0grs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N846as8HII0JsfnqkQtw5TUN7GZMPFQ8HAhdUArKTWKthAVS2GEBTo6Gyh0S2Ub64t3fpGAysXDZCraJYtk9gUlw0Y/x7PZCdx2pbf8xAGd/ZtnMI0wc25IKb39IaeSQ7zpQOZFd0+7d0O1pF2z3oN8d3E0n6VqqFvxHaz3bZlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqCJlznP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqCJlznP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114E8C4CEC3;
	Sun,  1 Sep 2024 16:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209117;
	bh=jh7rL0YE6TbcHGp1RoLNwl1btEQMaIis7FdggqZ0grs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqCJlznP6kx0QgojhKfSC/8gkFl8sQoFgGw5fiZz1Cz+D5gvtNpn98GC+3QQS2bT1
	 45sc31n/svyTxT1Bvh4N2vwr4iIA7VuP1SBpq+4KjsyvrbIzgVhh/BUzIz6S+ejgyJ
	 eEN1hv4V+B/T9MVsJY0eq64SSE1faA0Qohh56m6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 5.4 128/134] usb: dwc3: omap: add missing depopulate in probe error path
Date: Sun,  1 Sep 2024 18:17:54 +0200
Message-ID: <20240901160814.896139632@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 2aa765a43817ec8add990f83c8e54a9a5d87aa9c upstream.

Depopulate device in probe error paths to fix leak of children
resources.

Fixes: ee249b455494 ("usb: dwc3: omap: remove IRQ_NOAUTOEN used with shared irq")
Cc: stable@vger.kernel.org
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/20240816075409.23080-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-omap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -527,11 +527,13 @@ static int dwc3_omap_probe(struct platfo
 	if (ret) {
 		dev_err(dev, "failed to request IRQ #%d --> %d\n",
 			omap->irq, ret);
-		goto err1;
+		goto err2;
 	}
 	dwc3_omap_enable_irqs(omap);
 	return 0;
 
+err2:
+	of_platform_depopulate(dev);
 err1:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);


