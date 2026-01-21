Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340BC421F17;
	Wed, 21 Jan 2026 18:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020588; cv=none; b=t9U3w4HMnUnHk4dlJjkmHUbKw4/+BmA4KsHoyFeHzq3L2GTUsqASQjA3D/lCnRRZqcX3aTk3lKOUZpT2/hUfHdSHMkgSzu3dZpLTfIEHzW0jfFz8/hAyV4O2PZ9wZMrO5nWWCsYHepMApLH9s9kkMEFstEtP4vGzjZOwW1mGIus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020588; c=relaxed/simple;
	bh=1BwYyTfIaFDfsiHoMaBBy0+iHv6+KImgxHIM4DEQqI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DB3cNOgdeY0wFuQN+FUPIcBWNkSqsJIye5Dlji7VhMVSlJn6XjDerJydze6Ztazr5UyyESdvfLUF1HdpmswqSKEHtUo39elzoiojBKoO/J0mziUmjOCxW2sq37S9vwM0zUZLH/9gYofitxDz0XAet4h93ppFdWE/lVJv8OJPqL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ra2H5yfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ra2H5yfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A25C19422;
	Wed, 21 Jan 2026 18:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020587;
	bh=1BwYyTfIaFDfsiHoMaBBy0+iHv6+KImgxHIM4DEQqI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ra2H5yfo7bjTqxvLvd2yVu6IAxIPAsv+oRUBFdzMK8hHlrkOncUBBY3b8ZOBmUElI
	 6avDAd+zmMbQyCND+/C95UDz2rzIMao529vDwDYXAOkpecu3ZZdhm7+uv7b4aYeNOF
	 f3Ok7WBNwgFUNfb9Qe1TOh+3Y4ma2L2c5YRnffOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 177/198] dmaengine: sh: rz-dmac: fix device leak on probe failure
Date: Wed, 21 Jan 2026 19:16:45 +0100
Message-ID: <20260121181424.920062887@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 9fb490323997dcb6f749cd2660a17a39854600cd upstream.

Make sure to drop the reference taken when looking up the ICU device
during probe also on probe failures (e.g. probe deferral).

Fixes: 7de873201c44 ("dmaengine: sh: rz-dmac: Add RZ/V2H(P) support")
Cc: stable@vger.kernel.org	# 6.16
Cc: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Link: https://patch.msgid.link/20251117161258.10679-10-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/sh/rz-dmac.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/dma/sh/rz-dmac.c
+++ b/drivers/dma/sh/rz-dmac.c
@@ -854,6 +854,13 @@ static int rz_dmac_chan_probe(struct rz_
 	return 0;
 }
 
+static void rz_dmac_put_device(void *_dev)
+{
+	struct device *dev = _dev;
+
+	put_device(dev);
+}
+
 static int rz_dmac_parse_of_icu(struct device *dev, struct rz_dmac *dmac)
 {
 	struct device_node *np = dev->of_node;
@@ -876,6 +883,10 @@ static int rz_dmac_parse_of_icu(struct d
 		return -ENODEV;
 	}
 
+	ret = devm_add_action_or_reset(dev, rz_dmac_put_device, &dmac->icu.pdev->dev);
+	if (ret)
+		return ret;
+
 	dmac_index = args.args[0];
 	if (dmac_index > RZV2H_MAX_DMAC_INDEX) {
 		dev_err(dev, "DMAC index %u invalid.\n", dmac_index);
@@ -1055,8 +1066,6 @@ static void rz_dmac_remove(struct platfo
 	reset_control_assert(dmac->rstc);
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-
-	platform_device_put(dmac->icu.pdev);
 }
 
 static const struct of_device_id of_rz_dmac_match[] = {


