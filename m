Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF2936F90D;
	Sat, 12 Sep 2026 19:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241504; cv=none; b=ndVEz9ylD3w0ddElww3tS5t76UwmYanrBSzzKRy4PuGvyRwzwxZEGPcicg3nYtcuV+CUTpsMf50Dhj0/ApveLwSwPIU9DnRznqLs3oWl2hNbUVQgdxJyzwnS7lgbgUqRXwwkAmaDFaQ2SGsvE8DKwaDVozNkHJz2W0U7GgiHoqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241504; c=relaxed/simple;
	bh=fLsLjfDWwv4AypJ3pKTkDScAP3dWZlnwQygsLs9zl4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOZfcviZ1HGqXhTTx7Ln6d5WVmm9ke2lD2IrhMZhDjNCXxWDc8QKb5iW8yQtZw6saSgg6n4NJZ4uEQDuKdUBoTxzKAHJ6ZSXyA5/fF1mcZSLLYt1KuwRc34QL72cZfFIQznUJbHiJXtEw+zT6f4yAnnKXSz5/iXcrE6O73iN1Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwL146t3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwL146t3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DE91F000FF;
	Sat, 12 Sep 2026 19:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241502;
	bh=Y7A23NFhldPDnICXBZ0aVgcqdlb8HWVlVoj50ZZbkT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EwL146t34V5N5KNC4Yy5T2FMI4uvigDQ+W0cgUoj5hyzIbPtb0C6LkymxprEGakDO
	 5Yq4QFepkNEnwr/xuEZ0Aofq4Zv9kRQC99j7Z0alxrYnzUhvLT7mkVA4lv7iISx8UU
	 y+qn8LD+8FdGHkUNZ2oZsmsScaAA3skd4qPIGtZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erin Lo <erin.lo@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 106/798] remoteproc: scp: Fix device reference leak on failed lookup
Date: Sat, 12 Sep 2026 08:55:34 +0200
Message-ID: <20260912065519.391211755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


