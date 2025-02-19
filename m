Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F0F1CB518;
	Wed, 19 Feb 2025 09:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955661; cv=none; b=CAizTPeJa/p4BauljaPvA1kPZ074U+BjDxuVyqRqtPx62ZbFetjgtiIBsT52FDT+z66EGxpzGnPgVVNKdHo6SoMROcDVeqnnaOQ8YmoklKlqsTOqv03j+BirDYRlZP8n6TzCC+T9N3qV1e8Rh3bpomjFkS6sVzONVbs/T7Nt/A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955661; c=relaxed/simple;
	bh=ZX5qTkj/InfS4A1BKQyusFmXAmwtDYxisOekn/5ShCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOmulMLwUq0TCjbedi+Mc7WdWn2X+bn/3wHYPvEkyKMp0BFlmGT9fo/wK9qJW9Y9Drx8yAIoFg99StqNF4l4LBjjWT32sALlzASNRsV4fUeYaKMxBlEtm301+OoVArMFoPYIBfWHdFaTkC9G+kC6wEcvOeu/Mv6ZX0tN+0Im8vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7lpPqUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7lpPqUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4295C4CEE7;
	Wed, 19 Feb 2025 09:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955661;
	bh=ZX5qTkj/InfS4A1BKQyusFmXAmwtDYxisOekn/5ShCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7lpPqUr2Ze3MWsVVw2BKSUr/JAEev0cDr5b82HP319+DMxlY50EmfbYFfhy0w/4J
	 LyPvPYRd0jf/boV1i1eX0/h7K/izFNRLzRBi4fnG4crKfolpjqbgIzZqrWAcNoCYL7
	 8DFoW1arEvZmFFaueATT/NBjC/iIJHY+NW28I/VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 075/152] can: c_can: fix unbalanced runtime PM disable in error path
Date: Wed, 19 Feb 2025 09:28:08 +0100
Message-ID: <20250219082553.015204602@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -394,15 +394,16 @@ static int c_can_plat_probe(struct platf
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


