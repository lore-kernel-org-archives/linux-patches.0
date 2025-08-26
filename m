Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56D734DCFE;
	Tue, 26 Aug 2025 14:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219411; cv=none; b=JOx6o9KNXDl7itdQc57son7OHmRzyvojuEjiB9R0vyRKTeGy3UzaEGmcq8I9H1WdYyLAR9sb+KQdW5NQngA/bUtF6lz7rRiyYse/Jvif81TtbwTgRUF7lL7OQrSAajRf0xVotlAhL0LQHtuoYYEQsoVcULmjXx80r1vMiSATZlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219411; c=relaxed/simple;
	bh=42cBsCnOjz+RWQHo0lz81xFmSQmehTRuLLC1HbphiqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pubwJ/7zvdIWnMa4aPrZxlsO4jApx550bllPg7PY/6NFAQqQiS/xnYjaPZ2iMcFqT85LAVTsaEEEhlmcD3qZmkqjk1K+TNKMX30M4hNAk4QqxLsw8z4m60JUseazOpV2ChmGtZXFIFm2lqpqLBb4QkUPlkagSqbvKT7krWEh9wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KfBrZdH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KfBrZdH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6749BC4CEF1;
	Tue, 26 Aug 2025 14:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219411;
	bh=42cBsCnOjz+RWQHo0lz81xFmSQmehTRuLLC1HbphiqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KfBrZdH7xSTmA4wr3VelD1ckpa76Y2JviKLWon8MrY4WJgpmvxWHff1zUT7dIEzoo
	 RQLl73GBUdUYaWdtFqK0PJRX+pIwi7+IhYWHa1kBVsq3m/eDohc49J6gTGVY6UlXuE
	 XdeUKY0Vz5IfhgF4FU/o7Rxd3IY1KIIrrAzs9NnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 371/403] media: venus: protect against spurious interrupts during probe
Date: Tue, 26 Aug 2025 13:11:37 +0200
Message-ID: <20250826110917.256439537@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

[ Upstream commit 3200144a2fa4209dc084a19941b9b203b43580f0 ]

Make sure the interrupt handler is initialized before the interrupt is
registered.

If the IRQ is registered before hfi_create(), it's possible that an
interrupt fires before the handler setup is complete, leading to a NULL
dereference.

This error condition has been observed during system boot on Rb3Gen2.

Fixes: af2c3834c8ca ("[media] media: venus: adding core part and helper functions")
Cc: stable@vger.kernel.org
Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Reviewed-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Dikshita Agarwal <quic_dikshita@quicinc.com> # RB5
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[ kept hfi_isr_thread instead of venus_isr_thread ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -267,13 +267,13 @@ static int venus_probe(struct platform_d
 	mutex_init(&core->lock);
 	INIT_DELAYED_WORK(&core->work, venus_sys_error_handler);
 
-	ret = devm_request_threaded_irq(dev, core->irq, hfi_isr, hfi_isr_thread,
-					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
-					"venus", core);
+	ret = hfi_create(core, &venus_core_ops);
 	if (ret)
 		return ret;
 
-	ret = hfi_create(core, &venus_core_ops);
+	ret = devm_request_threaded_irq(dev, core->irq, hfi_isr, hfi_isr_thread,
+					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					"venus", core);
 	if (ret)
 		return ret;
 


