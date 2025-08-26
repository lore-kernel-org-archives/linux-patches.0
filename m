Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6A9345726;
	Tue, 26 Aug 2025 13:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214946; cv=none; b=enQ/uotQEdl6zLw6PY+mtgFxejRmvJcrj7swbkd0Dkfjl0R88Ry60jir9BKufXrhopl61igd+Lu4F6/9AkiUDgK5h/m/o2lv1dhXFxctmTRP1AHG9/Cs+1vh+eaFPPvQ7fLfBB6Bq/m6rcV4mBCEwMW152akBuJepcJ/9WwaepQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214946; c=relaxed/simple;
	bh=b4obmSk4bvzTyaN8FeO2GbUWl+h1YP/VYtEIwPv9/Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vsql6jRvc2/Db55T8way0G2mQZfgu4hxZ3f5CebSy5idPUVNLE1g1aHSWxsM/bmZaxdCXQ3BPCaYt57xaHFKmJ6/Jm2fHKGvuJufAGG8gilyJA867fks3zieCVwJmXrbVQkUAFX6x8quMR9wN4sTg9tlfjKu2dQq40LvuSiaZJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrNvJw41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrNvJw41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FD1C113CF;
	Tue, 26 Aug 2025 13:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214945;
	bh=b4obmSk4bvzTyaN8FeO2GbUWl+h1YP/VYtEIwPv9/Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrNvJw41y5dMf8qCI29S9k0plfLlyKllEnsE/obh52ksk0wW+8bfaCOon5sunJ+fx
	 tixfd+hUi/ZkCsr7FZB9K7qsTY+/SayhLrmV0Z03mIn7cJzIZ5IGaHH/dur/+Oz/Bp
	 0DRIOjT8aa2NxM6DlqO0x/AXqvPbKGETT4GOteYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 330/482] media: venus: protect against spurious interrupts during probe
Date: Tue, 26 Aug 2025 13:09:43 +0200
Message-ID: <20250826110938.968688011@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

commit 3200144a2fa4209dc084a19941b9b203b43580f0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -333,13 +333,13 @@ static int venus_probe(struct platform_d
 	INIT_DELAYED_WORK(&core->work, venus_sys_error_handler);
 	init_waitqueue_head(&core->sys_err_done);
 
-	ret = devm_request_threaded_irq(dev, core->irq, hfi_isr, venus_isr_thread,
-					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
-					"venus", core);
+	ret = hfi_create(core, &venus_core_ops);
 	if (ret)
 		goto err_core_put;
 
-	ret = hfi_create(core, &venus_core_ops);
+	ret = devm_request_threaded_irq(dev, core->irq, hfi_isr, venus_isr_thread,
+					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					"venus", core);
 	if (ret)
 		goto err_core_put;
 


