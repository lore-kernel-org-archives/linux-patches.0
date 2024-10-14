Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A401B86CC;
	Mon, 14 Oct 2024 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919154; cv=none; b=HLH+UxMmbngjRIomuf7pqUPO9Pz0fnCci3JEds9+P7zLYSJC2G4cmPnKiRAHceyIJIaLdGL8EQ7d0523nm/URSoh017OT5Hr0Sv2AZzxIIXCA3l/sDHR4JO2oipKjpd4xCOZphwAmxYRTTs2VALoNxImIcgWg5Pv9+hhePsmcNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919154; c=relaxed/simple;
	bh=smRawrV3m9iqcj2t5Glqaee4/O+6Epn3ZTcxoLSaMhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmKb6/+A9UCAUs0Bs2HVd7YMvJaOJuin5uVTsrUStBgNgoyJauqw+U3I0OZHo0W+E++DuoEblxQOfvTe1VT2tQgYhL78cOboP8LZMi2vKDIj7ZgQOw7QYImiI42MQohIURKw6/35L8mCOZMnTSFqdcP/o4vZsGjBwIu7ME/Ysdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHacpb8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHacpb8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CE6C4CEC3;
	Mon, 14 Oct 2024 15:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919154;
	bh=smRawrV3m9iqcj2t5Glqaee4/O+6Epn3ZTcxoLSaMhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHacpb8ZGUEUApNM33X3cZvcDRUS3CBf+pWmUd7Z1w54qep5KmqAyKp1q8iPCTA+o
	 +f52MzAP6N5gTxTe4XS3CTJJbBGasfpilJ1Wy2Nw9Kx+qo4DaeEa9FDzI+oaNUQtRi
	 Zsha9vSsoB1qNdRzQ5mPqSE0iJhLbKVHrbbvGGWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 526/798] i2c: qcom-geni: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Mon, 14 Oct 2024 16:18:00 +0200
Message-ID: <20241014141238.651964698@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit e2c85d85a05f16af2223fcc0195ff50a7938b372 upstream.

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: 37692de5d523 ("i2c: i2c-qcom-geni: Add bus driver for the Qualcomm GENI I2C controller")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: <stable@vger.kernel.org> # v4.19+
Acked-by: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -821,15 +821,13 @@ static int geni_i2c_probe(struct platfor
 	init_completion(&gi2c->done);
 	spin_lock_init(&gi2c->lock);
 	platform_set_drvdata(pdev, gi2c);
-	ret = devm_request_irq(dev, gi2c->irq, geni_i2c_irq, 0,
+	ret = devm_request_irq(dev, gi2c->irq, geni_i2c_irq, IRQF_NO_AUTOEN,
 			       dev_name(dev), gi2c);
 	if (ret) {
 		dev_err(dev, "Request_irq failed:%d: err:%d\n",
 			gi2c->irq, ret);
 		return ret;
 	}
-	/* Disable the interrupt so that the system can enter low-power mode */
-	disable_irq(gi2c->irq);
 	i2c_set_adapdata(&gi2c->adap, gi2c);
 	gi2c->adap.dev.parent = dev;
 	gi2c->adap.dev.of_node = dev->of_node;


