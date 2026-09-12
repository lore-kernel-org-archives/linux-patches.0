Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DE624CEEA;
	Sat, 12 Sep 2026 13:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220399; cv=none; b=UJyke5H3pdIn1e824wWPjbVCb1zD2vteN94q+rE/Bb+/4mwukpJ3tt2iLdvEnILOL36nRz/K7g2FNqx0nJqT4A9U4lI8plsF/g15oDe5VFW7sCny4XgNmclaB7kKyuZlkyahLhbWtZthU4zvNUYg0MRUxCNoun9BBfcsKjsU/XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220399; c=relaxed/simple;
	bh=szZqKGuvIKN4YJ90OVm13yt7O3o6DkL/amr6f9w8718=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZOrAAB0gyExcXpnVhkXWQbDMQ7qPitxgajIw1PosmYld3R0FuovWz59pmZMrPaJm9MslzELKaznefUCL65pH9VFP4kuIz02UZW+ODsmHn9jNr3/VltZKF2xMHV3I07mL1q4HPixq6IfV1mgQkRlHxxVl4hCK+/KHWwRD6XWJ0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJ35r7tH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJ35r7tH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31881F000FF;
	Sat, 12 Sep 2026 13:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220398;
	bh=qoWE1uks6B7ZPKjVbeRPqFbf4fVGmRZY5cSTE1zqSuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YJ35r7tHyTCIOyPrE14UxNULu/j0zl/PvJhY459o91EYNoAKOM7TrDOPA4zowqiA4
	 kZ0CROaF6YKYanKn+7UhViz0gJQebpt7V0UNOCPhFcv6Be111I3aze8UEZ8lBxERLz
	 h6wO3b80AVudNkijvmjVgqPnzfe6GrTfh98OEDz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erin Lo <erin.lo@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.6 0170/1424] remoteproc: scp: Fix device reference leak on failed lookup
Date: Sat, 12 Sep 2026 08:43:22 +0200
Message-ID: <20260912065611.099653417@linuxfoundation.org>
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
 


