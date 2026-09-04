Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EFF3EE1FC;
	Fri,  4 Sep 2026 06:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502628; cv=none; b=AqjNC0XLMRFtR4sbvCmrLjZm3dD3x0dIe+wKJcP+GteHewrrnotpDQSY4M3quLxN3EQz3lKneC+BHR0wF0OqZgH/XCxs2w/lvKwgeJEqpJGD3xYS0wExWyU3+eicsRSQq4/9nSf/3Uql5cB95ncAAPPSJUXnNAVpOaiae0II0nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502628; c=relaxed/simple;
	bh=yQUBRbkUXvYVAA9vjLK3LFHp8z8JzEZ+LokYJXaaaPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmqXGHWcJH4NFASoejwGGqEvLXmpAJcrFk4nzzPZ3uK1GmjUkUx0IrTD+ujxmAzN1r7K+heAib2WFRQXau9WvT9Uw7zwv4Ly/DdS0FLPwx7m8qLPT4wXFGZamUH+4DDpYhKhAyQ0dCO3ripGc3S4qNUudWMU/wuB/jrF35VyUV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqzIgBnf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqzIgBnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7E51F00A3D;
	Fri,  4 Sep 2026 06:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502627;
	bh=NHdzjbMKskrLbwjWmRgPsyyTnX3IYTvejmPcly0KI0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RqzIgBnfn/cvQ2kp5nPjtRjMdlUgzZRu6bBaImDmgp6/LxbNFczuhBdzyOAVRgwe3
	 eEdHgjfPSE/LXvG9EEVr6zOTk06BIsiSAn2utNxEW9ggJ0DuqNPEpXRlzT5MBK6COy
	 kTm9IURnEsaE4YeutYuouqT7Prf19DfbMDSAGSOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erin Lo <erin.lo@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.12 231/403] remoteproc: scp: Fix device reference leak on failed lookup
Date: Fri,  4 Sep 2026 07:00:34 +0200
Message-ID: <20260904045740.118806286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -35,6 +35,7 @@ struct mtk_scp *scp_get(struct platform_
 	struct device *dev = &pdev->dev;
 	struct device_node *scp_node;
 	struct platform_device *scp_pdev;
+	struct mtk_scp *scp;
 
 	scp_node = of_parse_phandle(dev->of_node, "mediatek,scp", 0);
 	if (!scp_node) {
@@ -50,7 +51,13 @@ struct mtk_scp *scp_get(struct platform_
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
 


