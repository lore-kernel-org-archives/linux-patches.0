Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222551E3DC9;
	Wed, 19 Feb 2025 09:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957474; cv=none; b=Qt4dpmyV0yJhyyNPV6W+EK3V7G/8/yozmJyBdcvJkzIuU14uGllnw9bAjRkKjRAUUOp1Q9fGfrZvTw8Zh06w8QdQXgomlNfpaJMJTcyaduingOBIgNBFvZ3c4fUsRSH+r/tqR3yyBhGjuQ1zhFnrtY9ytfhOMi8LTGsRGp+Hh9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957474; c=relaxed/simple;
	bh=x7OjA3aGXXvz+ne7jH1p4EzgFgMzVZ00pwVsP1zpQN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iC8QLUPhAZA+zD0XD1u9/ZcXfKNCtfqLKscHi8gBWmbrz322hLnmSpshRczrPJAa8uxy2dRUd4Bes9ARbhBAK2m5cWEe6SMG4/p1sgwkeH9ACYtgLBpnKPYKzzUn/0wSNHh6eLhYaIJXyYsEG9/NotfCQPGzCgf1YA3JS7K/6p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxI8Q4m6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxI8Q4m6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C42AC4CED1;
	Wed, 19 Feb 2025 09:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957474;
	bh=x7OjA3aGXXvz+ne7jH1p4EzgFgMzVZ00pwVsP1zpQN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxI8Q4m6oNvXOVB/GHVtWaMqaVBx6cvgsyJHXV1OvwH1iK4o5udOW4u32EHf8mmgN
	 STSObjsohH/wfiUMpd+0nW6C3VffedrnC3nu7VPe3sM56K9zDb1nT/+zMtX/j0atMd
	 rbSu59OHZ23Vb5Cj3R0LuFpyPLxvYA3050pngEpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 521/578] can: c_can: fix unbalanced runtime PM disable in error path
Date: Wed, 19 Feb 2025 09:28:45 +0100
Message-ID: <20250219082713.470386125@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 257a2cd3eb578ee63d6bf90475dc4f4b16984139 upstream.

Runtime PM is enabled as one of the last steps of probe(), so all
earlier gotos to "exit_free_device" label were not correct and were
leading to unbalanced runtime PM disable depth.

Fixes: 6e2fe01dd6f9 ("can: c_can: move runtime PM enable/disable to c_can_platform")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250112-syscon-phandle-args-can-v1-1-314d9549906f@linaro.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/c_can/c_can_platform.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -395,15 +395,16 @@ static int c_can_plat_probe(struct platf
 	if (ret) {
 		dev_err(&pdev->dev, "registering %s failed (err=%d)\n",
 			KBUILD_MODNAME, ret);
-		goto exit_free_device;
+		goto exit_pm_runtime;
 	}
 
 	dev_info(&pdev->dev, "%s device registered (regs=%p, irq=%d)\n",
 		 KBUILD_MODNAME, priv->base, dev->irq);
 	return 0;
 
-exit_free_device:
+exit_pm_runtime:
 	pm_runtime_disable(priv->device);
+exit_free_device:
 	free_c_can_dev(dev);
 exit:
 	dev_err(&pdev->dev, "probe failed\n");


