Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FFB3F928D;
	Fri, 15 May 2026 16:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861905; cv=none; b=d7EU76f88wHEi0JfBw155Z5vGU1BrDiUJ3OeOSJ+nF27pKEP5sce8/m8YnVyDW7qaciaw9IDZMWsjh7XG56cZcTvMo+jyOOiLLqAxBnI6QUjQezXLENGlMuF/lUkiJUWBYoJekmHyXTc4zfGH+AE1fsikuzTMJ+EdfthZG+KTo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861905; c=relaxed/simple;
	bh=TawfsNod7ftqVzR72Rws2uaNWodDYSH6X9txoy6Vxo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXDap3Fob7aYiJkTGgTIMvRwZAOYLBOcSIcvGNl/KAsEkC5rFGTFr4hKd5qpbp8IlxutG0X5qlzn0I1mDKd755KGAS+x9Rf+OapwTbFWVGf+RYJLAuOXqFBPbIiINuZ2uQRla+SyWZhOzJBvyvGYS49XthDoI+VCx9cbDnEXK9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVe6p/+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVe6p/+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22473C2BCB0;
	Fri, 15 May 2026 16:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861905;
	bh=TawfsNod7ftqVzR72Rws2uaNWodDYSH6X9txoy6Vxo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVe6p/+RXubmv5lltvtDQCgAYEiRP/CqFpvkmmXM5xwWb+7LrqYt+HRcnI4DVqbHB
	 AbSBrmDae993ps+xi99KB9R4v0scrsxx4w+8+6pozffqfYfaLybCDgDPR6JMUt54qn
	 S0ZSISEDb/wmRwgoSAP6tEmutquLMHQoyMcbQwAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenyou Yang <wenyou.yang@atmel.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 034/188] regulator: act8945a: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:31 +0200
Message-ID: <20260515154658.047828174@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

commit 0d15ce31375ccef4162f960b34547a821b7619d2 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: 38c09961048b ("regulator: act8945a: add regulator driver for ACT8945A")
Cc: stable@vger.kernel.org	# 4.6
Cc: Wenyou Yang <wenyou.yang@atmel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-7-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/act8945a-regulator.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/regulator/act8945a-regulator.c
+++ b/drivers/regulator/act8945a-regulator.c
@@ -302,8 +302,9 @@ static int act8945a_pmic_probe(struct pl
 		num_regulators = ARRAY_SIZE(act8945a_regulators);
 	}
 
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
+
 	config.dev = &pdev->dev;
-	config.dev->of_node = pdev->dev.parent->of_node;
 	config.driver_data = act8945a;
 	for (i = 0; i < num_regulators; i++) {
 		rdev = devm_regulator_register(&pdev->dev, &regulators[i],


