Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DC23B14A9;
	Sat, 17 Oct 2026 16:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256248; cv=none; b=ow4HEpcZNtvEXp7YsJ1uvsy2udPz4ZW6pkdWa4/brdFTYFveG7iZ75+ySVDI0y2lcrRBTAIFi2BTMcY30kttYW9YaRyL7Z4csN629J4N1hYtxB7+qRSmqy+ii8AlWn9Hnl9cUVk1Jv1QtkiLhrrs+O5KIJa2RaIbagqp1SLuiKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256248; c=relaxed/simple;
	bh=+tYQ0LZgJFYUjG08tW4gMZKcJ3WjKuD2ABsoX/Q65EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcEw+MsBPwH+Eb6J+xKtvMalJ/SpleBcvjbk0anjONRFzQ3zG4QLaBLfNw+NWNtIdHtKUV1TuEli3eFcCWph4uJPNRoKuj1JBXkWLha9Ab0xRFMbFh1HEoFUPFZiIFHMb8TFxrgxFIqplp+Mb9w/dMnG/YF44aWxv+yzXJquy/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MD5ZqO/u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MD5ZqO/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EF11F000C4;
	Sat, 17 Oct 2026 16:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256247;
	bh=j7JJ2UetgYnpx7Lx7r/1CawfFLWAnSJaC7De8cH7L38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MD5ZqO/uegZ+3oDeKSxR28opQxSmp3TWwE2AdtW81jV9wxGo+483AIwcxIAovSOLX
	 yaF5Y+dtIUNsKtnRIq3LJu/OvxNQWiAAgVCzEbXfuvVxU1lHGkyA4KZZUw49wGCc/A
	 otnIzm4HYm/V2cN9uM2dpOuPjOcqiCdwNGWntLnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 0174/1674] rtc: spear: initialize IRQ state before requesting alarm IRQ
Date: Sat, 17 Oct 2026 17:40:46 +0200
Message-ID: <20261017160435.622230322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 055ef5ce9f67a6a3a1363fa663007f8196cc0fb8 upstream.

devm_request_irq() enables the interrupt before it returns, so the handler
may run while probe is still initializing the device. Initialize the MMIO
address and spinlock before requesting the alarm IRQ.

Fixes: 0942a71e435f ("rtc: add support for spear rtc")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260902080318.3498434-1-runyu.xiao@seu.edu.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-spear.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -363,6 +363,12 @@ static int spear_rtc_probe(struct platfo
 	if (irq < 0)
 		return irq;
 
+	config->ioaddr = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(config->ioaddr))
+		return PTR_ERR(config->ioaddr);
+
+	spin_lock_init(&config->lock);
+
 	status = devm_request_irq(&pdev->dev, irq, spear_rtc_irq, 0, pdev->name,
 			config);
 	if (status) {
@@ -371,10 +377,6 @@ static int spear_rtc_probe(struct platfo
 		return status;
 	}
 
-	config->ioaddr = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(config->ioaddr))
-		return PTR_ERR(config->ioaddr);
-
 	config->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(config->clk))
 		return PTR_ERR(config->clk);
@@ -383,7 +385,6 @@ static int spear_rtc_probe(struct platfo
 	if (status < 0)
 		return status;
 
-	spin_lock_init(&config->lock);
 	platform_set_drvdata(pdev, config);
 
 	config->rtc->ops = &spear_rtc_ops;


