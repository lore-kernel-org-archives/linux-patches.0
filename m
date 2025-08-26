Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8148635C;
	Tue, 26 Aug 2025 11:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207435; cv=none; b=ZAWQzUF64cHi1GV4iyuayqntjM4lCuX/3kyzOut98KrxqKFzmE2rZ1doO1BUpV2dzSAqoMy4zH7OTwcuAKlIdHjfnmkbjawA0E/ZOa8nq8iYU3LE0h64wzyGqb1oU6g9M3Ucnl9LscfxG0CznFlEDCOJOu36a0TIfNx0BPL3IHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207435; c=relaxed/simple;
	bh=EH7yMRKNF/8mCx8iuTRU4iLYMqaM0n/2cvoKtPeOqm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QO6wXNqoXMYv37p83d+MEKNM4v3T2b/7Nz0w3s5hTxjZIfQh3VCoLe6itBMnDundFSD0hQQObrOPRTcWNu2W8wj0b8CcZ0W7eOCNKUu/AfUwjXZgnn7oI/1aJWVFI62No8pTpmE5JMM1URxP2BmCq0wFB7eBjJxn7SSJv8HfsUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wE9w/d09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wE9w/d09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2991DC4CEF1;
	Tue, 26 Aug 2025 11:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207435;
	bh=EH7yMRKNF/8mCx8iuTRU4iLYMqaM0n/2cvoKtPeOqm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wE9w/d09QDw779gAp9tNpWZiXbtN3IlVYxP66SFEd5YJ7ZpM6g1EeoBvEoGlNQ6Dn
	 xE3GxcTWFR7Xe7bmHxGVgZiW1MuRgOKCynMnJJRibUP9Jg2ohMkEg7J3Aui8rrOszR
	 Nyir8wm8lDJ3EqgWPstcNj2NDPYpfezS6w3/0Scs=
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
Subject: [PATCH 6.16 149/457] media: venus: protect against spurious interrupts during probe
Date: Tue, 26 Aug 2025 13:07:13 +0200
Message-ID: <20250826110941.053697944@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -424,13 +424,13 @@ static int venus_probe(struct platform_d
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
 


