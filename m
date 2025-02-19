Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143561E0DD0;
	Wed, 19 Feb 2025 08:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955180; cv=none; b=PMBPHCdniVVCgxf6nhXEjwJ+ao3fGbPpmb3qpg6WehMoKs5qSNW1sqGRzAbfECWsTlOQj8r7QYpp3sRB0qnnvCBghM54txKP//nXw00KdVpRYEZO7WaA5YDh17fr6c6rPnj5zlxSv+IKFuFEJA8YWnmLKQKMrJxZ7otN9yLBKyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955180; c=relaxed/simple;
	bh=FCwyM+q1SaYBTTX3gXgB1p5+pZHzHHdPg9YcnIubNI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPUMK/aKMVlnW46XrH9Maf39bW+sl7lnr91uOwhbQXVPmqIlhzql/nvPR07J8RZGPlFCGAc3aherSQQmj/r2StltXYoquFCAWcmEKmiOx/T658LWbdM5chb6DB4L0i58RP0hmE4mzq8XvVVIJwMS+ZsR75s5Ytp6PjzJnps4qH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8kL3Fff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8kL3Fff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C2FC4CED1;
	Wed, 19 Feb 2025 08:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955180;
	bh=FCwyM+q1SaYBTTX3gXgB1p5+pZHzHHdPg9YcnIubNI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8kL3FffLTu36+QsryZpCnNwMNXIasIfzjUsINZ8k29Ab2yXashOt0k1kMI5qbU+o
	 KGGYrhHJsW8K8jCOQMFArVWeqP4+LjJj07O3sfDa0LuAjKfivEmQyOswWX7sdN+zFf
	 45I6xYGaIOrYxWL45DgqWMlpRSqv/gIdF2SmbYhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 130/230] can: c_can: fix unbalanced runtime PM disable in error path
Date: Wed, 19 Feb 2025 09:27:27 +0100
Message-ID: <20250219082606.771771714@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -385,15 +385,16 @@ static int c_can_plat_probe(struct platf
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


