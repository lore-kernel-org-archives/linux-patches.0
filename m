Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA6244CAF5;
	Tue, 16 Jun 2026 16:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628569; cv=none; b=dmS+KCzYw87MbGdZ/TvaJDsNfyJwKCQxDgNitRURj8nWxnhQW0M5LxwPluRkkqamDaUopBK8TVawRRHly30JFmHRnTsNGhiga6oRMIz875kiuEc9eViaIqou/iHIYKIcw4cePXvQMfeIIv8aHiYfgl/rfcAIWwV0k/qTBtqHjKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628569; c=relaxed/simple;
	bh=NA+4el4yLURW28R1bIOGtsZildizeOstb2VZvq8Ssfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTQcf/GDUdBRAaBjKCQk8jgWg/1PfXrxsmWrF14RWDtHWfyycFljkg1cI/eGUBY+PB4Q1c5xPrS6DaHoyUK/4gi638+Rr3u4sG5BgbjslLmUx/HBWbefyR37C0DLgfLLpLCthmEoj7iWlDsT65XhA5d/wG9TKGh/zvZxFl85tNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVq1+7np; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVq1+7np"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B6C1F000E9;
	Tue, 16 Jun 2026 16:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628567;
	bh=aQ4bjqEYubtysbKXwCyPAhFt+AWxVSrUuJA0sxRThi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVq1+7npnxkGmpDe8yZ3mSNSVHgy+lO2f0AVqw0+OjPhoZhRyNiVwzrCGXwC/n2u6
	 4wRa6AC20MlNkGHXltdfQHhjKB35q99zQgPVFpaBUyUu9XsuuND406zbQ9t9cTIo8F
	 HQpYxIWhctV9d5iriM8Y8O8uQ3Sq5wSRJzP9LUXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Peter Chen <peter.chen@cixtech.com>
Subject: [PATCH 6.6 121/452] usb: cdns3: plat: fix unbalanced pm_runtime_forbid() call permanently leaks the runtime PM usage counter across bind/unbind cycles
Date: Tue, 16 Jun 2026 20:25:48 +0530
Message-ID: <20260616145124.069325415@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Peter Chen <peter.chen@cixtech.com>

commit ae6f3b82324e4f39ad8443c9020787e6fc889637 upstream.

Call pm_runtime_allow(dev) conditionally at cdns3_plat_remove.

Fixes: f738957277ba ("usb: cdns3: Split core.c into cdns3-plat and core.c file")
Cc: stable <stable@kernel.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-devicetree/agKaEePSFknhDBg2@nchen-desktop/T/#m21e1d9c1574eb127ce03c0c2a1a49002ce435b52
Signed-off-by: Peter Chen <peter.chen@cixtech.com>
Link: https://patch.msgid.link/20260513085310.2217547-3-peter.chen@cixtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-plat.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/cdns3/cdns3-plat.c
+++ b/drivers/usb/cdns3/cdns3-plat.c
@@ -182,6 +182,9 @@ static void cdns3_plat_remove(struct pla
 	struct device *dev = cdns->dev;
 
 	pm_runtime_get_sync(dev);
+	if (!(cdns->pdata && (cdns->pdata->quirks & CDNS3_DEFAULT_PM_RUNTIME_ALLOW)))
+		pm_runtime_allow(dev);
+
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
 	cdns_remove(cdns);


