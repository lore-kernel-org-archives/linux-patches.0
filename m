Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA07268C65;
	Tue,  8 Apr 2025 10:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109921; cv=none; b=Z1gDN/ZZnzU2qD6vjtkS7bwSCJv9j6I1oCa2238Iypk8CLFti0jgNydcKFnR08TcMb4z/nnsIVpcag3usKAZEkLemTw48oH59cDsWooSHuKEJnWTOtNcrbL2S6QLKcR5TxN/7M4NYTc4evFUFuhtgfuAj0LcQmD2FhzXW3QtKM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109921; c=relaxed/simple;
	bh=+AoJiFncLAZLwWYk8LqU4zCWWNX2p989PNx6Terqrxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WdF1im++QRRoFl1cTU7keioG1ooUs6jpUByuc2HoRuD5qRQhXRSoCVExMWYq7uds702zVLSTc/XFiBjwqj8Pj7eqtXQbleei4tkOpxYtB9zDxrQuDlnlWEtFvtAeC3B2S1t/NSTbZQ+Y76Rs+ytVH7n7qhxeS/iaX1cTltN5V1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIuwG+kv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIuwG+kv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF927C4CEE5;
	Tue,  8 Apr 2025 10:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109921;
	bh=+AoJiFncLAZLwWYk8LqU4zCWWNX2p989PNx6Terqrxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIuwG+kvUgawuzoHHqHj0+BP1ElpAL91DcFBzMuUgtl5MNhVgr4WKNbPAc3OqVmM5
	 xdH3vaKYeO0sLxaQoYDoaosUl8PJzhd4mcyoKk8u8Lxwd9WnqJb3CcS4alYNizs5w+
	 wxilBvLosQtKCFLwX4qKho48CYw48x/BudE1pSvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 5.10 102/227] counter: microchip-tcb-capture: Fix undefined counter channel state on probe
Date: Tue,  8 Apr 2025 12:48:00 +0200
Message-ID: <20250408104823.422550615@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Breathitt Gray <wbg@kernel.org>

commit c0c9c73434666dc99ee156b25e7e722150bee001 upstream.

Hardware initialize of the timer counter channel does not occur on probe
thus leaving the Count in an undefined state until the first
function_write() callback is executed. Fix this by performing the proper
hardware initialization during probe.

Fixes: 106b104137fd ("counter: Add microchip TCB capture counter")
Reported-by: Csókás Bence <csokas.bence@prolan.hu>
Closes: https://lore.kernel.org/all/bfa70e78-3cc3-4295-820b-3925c26135cb@prolan.hu/
Link: https://lore.kernel.org/r/20250305-preset-capture-mode-microchip-tcb-capture-v1-1-632c95c6421e@kernel.org
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/microchip-tcb-capture.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -377,6 +377,25 @@ static int mchp_tc_probe(struct platform
 			channel);
 	}
 
+	/* Disable Quadrature Decoder and position measure */
+	ret = regmap_update_bits(regmap, ATMEL_TC_BMR, ATMEL_TC_QDEN | ATMEL_TC_POSEN, 0);
+	if (ret)
+		return ret;
+
+	/* Setup the period capture mode */
+	ret = regmap_update_bits(regmap, ATMEL_TC_REG(priv->channel[0], CMR),
+				 ATMEL_TC_WAVE | ATMEL_TC_ABETRG | ATMEL_TC_CMR_MASK |
+				 ATMEL_TC_TCCLKS,
+				 ATMEL_TC_CMR_MASK);
+	if (ret)
+		return ret;
+
+	/* Enable clock and trigger counter */
+	ret = regmap_write(regmap, ATMEL_TC_REG(priv->channel[0], CCR),
+			   ATMEL_TC_CLKEN | ATMEL_TC_SWTRG);
+	if (ret)
+		return ret;
+
 	priv->tc_cfg = tcb_config;
 	priv->regmap = regmap;
 	priv->counter.name = dev_name(&pdev->dev);


