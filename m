Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3731DEFC2;
	Tue,  8 Oct 2024 12:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390542; cv=none; b=PxFhcwJZJKTCCoiXoJu25wqFqxCzkrW52ySBvhoM/nIZN97GupvuSnSLYnTxHiwmhPYzm3wCAypdrClqXghT/bK4StPScRlVe5SBOl+FhTiikK7nKvxt6C+2bTbVdPScBD4rIb2YyeGy8YADkSMbFcZgFsNK6354Jffzp8B+EGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390542; c=relaxed/simple;
	bh=F5LQAyCpTRBYt8RwAuJgM0Gn2afgpwcCrRzLuqAfQtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEiz6DDbJf4/ILMH4Ll3OTk2HOGOOcXR5dr69O5drIGPDgcYwUhejFCHiFZcGwUvTlC1R81wSPIhs94NR09pmUtSrDzMITT2+eL/3npDhqmGix5qlJhcrZqAhIOBeBo0b6fNb+hOAYsuycgPXQKJEH+cIY/SM7g+d/uGe07fiQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQuvJ821; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQuvJ821"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F81C4CEC7;
	Tue,  8 Oct 2024 12:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390542;
	bh=F5LQAyCpTRBYt8RwAuJgM0Gn2afgpwcCrRzLuqAfQtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQuvJ821KCBPwQMhk761HPHcdA0eehbrecswYNjavtauMtjcNd+F5FCADLTpE+K9X
	 A535F5qGY14tLavsG23TkVjClJHV8mL3Mx0dI+ahidsxeyAnjvA7XeR9HoP7+Rl666
	 6r2FrO/ES5+tOSEY5yrhW7Sa8yRuWdDgtHSS2QYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.10 293/482] i2c: qcom-geni: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue,  8 Oct 2024 14:05:56 +0200
Message-ID: <20241008115659.808863270@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -818,15 +818,13 @@ static int geni_i2c_probe(struct platfor
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


