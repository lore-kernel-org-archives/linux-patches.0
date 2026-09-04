Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435243D6664;
	Fri,  4 Sep 2026 05:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499503; cv=none; b=KwCG8aUkzU4F797ytlyZThSxkOUaLU28ehhrIIuWkZyjDk8Y2PTFT3roHl6kzqHVJk0QQf75UWilL7F5ztJ3+mT30cyxHC70MSj/+TBC+NgLAdI8sTHS2TjsYcr2L5Qq5NuqWc9fvTXRhN6cORDgBVnCGbEp8fZbCxcNDeDiE7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499503; c=relaxed/simple;
	bh=i5V7o8NPSzE6sIyRFI14mRsK48hiSy7/zFWARJQ08h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uge0I46EBrF9FMZG5qAkfZEPvNMNwSJe/tDuMAZxZc+aDHEBT+HnC6AsxlMRR5+1FP/yy8FDsrkPgoH7hErlXkeIEfTiswq0hIlBUnaIwqamVXRlo3QOGAh2YGuB+GRTR7kdUCwy53che8PtGkM5DHGqNcRLgLm5jW0rUUfhWkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5avQNPK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5avQNPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F241F00A3E;
	Fri,  4 Sep 2026 05:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499502;
	bh=Fmic6I81IzQpeAzw8/9VXxD/tDw1la5MDNPpYrk8GXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K5avQNPKiZoW0dRfGeoJE5M7hV/mV8PCJay2pONLNNZbjdpJtoVSOR+lK8TdImr3G
	 BGbLjEv+LeXrJHzKENr6OOkmmxMQ+z74j06kvxzKwwvDSB76J0JiJRjZD5mheHn4K7
	 3G25o1/Q3EOrA6JcmpHPl8s6qgNqJHAklpe4gJLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erin Lo <erin.lo@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 7.2 439/713] remoteproc: scp: Fix device reference leak on failed lookup
Date: Fri,  4 Sep 2026 06:56:47 +0200
Message-ID: <20260904045813.670195805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 22f9efb3ae07f966a1901d929d16df1388cce65c upstream.

Make sure to drop the reference taken to the SCP device when attempting
to look up its driver data before the driver has been bound.

Note that holding a reference to a device does not prevent its driver
data from going away.

Fixes: 63c13d61eafe ("remoteproc/mediatek: add SCP support for mt8183")
Cc: stable@vger.kernel.org	# 5.6
Cc: Erin Lo <erin.lo@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20260706065614.389412-1-johan@kernel.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/mtk_scp.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -36,6 +36,7 @@ struct mtk_scp *scp_get(struct platform_
 	struct device *dev = &pdev->dev;
 	struct device_node *scp_node;
 	struct platform_device *scp_pdev;
+	struct mtk_scp *scp;
 
 	scp_node = of_parse_phandle(dev->of_node, "mediatek,scp", 0);
 	if (!scp_node) {
@@ -51,7 +52,13 @@ struct mtk_scp *scp_get(struct platform_
 		return NULL;
 	}
 
-	return platform_get_drvdata(scp_pdev);
+	scp = platform_get_drvdata(scp_pdev);
+	if (!scp) {
+		put_device(&scp_pdev->dev);
+		return NULL;
+	}
+
+	return scp;
 }
 EXPORT_SYMBOL_GPL(scp_get);
 


