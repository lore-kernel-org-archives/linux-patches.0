Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A521C57B1;
	Tue, 15 Oct 2024 12:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993803; cv=none; b=Y98ZfH/j3Q5fbuLPAD84LeouhUwWg/wv7EutLaDGlquazLnG3XaAiBGMW/G+16ECg/VdAAT7NLk1W4DrHBIJAESqS+SDMuxBfoVVBpmkYOWVBB1ALo3dTGwpelscXnohvVx2xwATxj7jXyziM07cc98VvxGXf8dHhjibjn5MHw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993803; c=relaxed/simple;
	bh=Gz/Xy/QAgs2Pil/hsd8aUimQZGcq4AkaKH7WrHMnk5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pl6OejcytgxDYNxpgVM9kP1vBi1e5bCioZwP1k3FUWqzvWZSJkPdJ/bMjhG11TfPHr3rJX3EihtUbXOSrRKsGTlIDhv9hL9x0d41/pPIWq7kV1OXrqDLIMq7A+OGTgTdodaUyfke24KqHVdVyyopKMzex4584eTVe4oAq+ij15c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OW4S61Z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OW4S61Z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B2AC4CEC6;
	Tue, 15 Oct 2024 12:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993803;
	bh=Gz/Xy/QAgs2Pil/hsd8aUimQZGcq4AkaKH7WrHMnk5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OW4S61Z2ERVqk+ohDNBKtDc55FSw94rRTN0SXVR4cR6JZ3qss2KlTFmsm9edPtzNK
	 /Aor3RVoLRQo6Uplyok78xnVcaUIoQNF974DoaJKZg0WHmSxfRZgn0mRplXgFx1LCj
	 Oht6XFnTTAWVExuO4hBc0HzNCcPTCmFKTkizUDMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 490/691] i2c: qcom-geni: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue, 15 Oct 2024 13:27:18 +0200
Message-ID: <20241015112459.787544740@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -565,15 +565,13 @@ static int geni_i2c_probe(struct platfor
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


