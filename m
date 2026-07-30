Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D74D3769F5;
	Thu, 30 Jul 2026 15:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424630; cv=none; b=ie++47oXJIZNCC15hJUmPUM+1CJbKOd78T3XGsSzAjOFsCJCkWlO5CARqv0z+ibPtVxEp7qM4XihCk8AjJPHzWBHWuMXYME6SgzUdFjNTnvYqCcjQJqk1O8olBcD53OFdXYiJnL7BrT70x+PFtAdjXPot07G7fVOUWwnqVZiDOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424630; c=relaxed/simple;
	bh=5ia4eTKOmCJZ7WsqbCcRhfc4T3Q9L1m0LG1+yP78vhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gb1GitLVIJSaxuehxxesAk34H2Ri3a1AQVMmO2jX0BthLJ2Gnt1wvCLgazwaxCdJL3fJh6xhZFL2YstX9mwdbIBNAg9+vV2U/vLYPXBOnwUb4/R24e0dbZFjc2Z6xFsbFaufpWYWEcc4N97E9lXy3FCY7SAISq5lyPzPOpIkE4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKnITKnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKnITKnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8FF1F00A3F;
	Thu, 30 Jul 2026 15:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424629;
	bh=QPEqxjNMgRC2jnwRoGezONNSUk2pwdJkWjAoLr5955A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKnITKnjlnzHrCzS5OzayLllKguZBq+CrGfOWZN6imTf2hlQ/ptYN2NPx/T15B839
	 QGLSMW5GXeb0bVFaCM09dnkcwf3LcayD4aNKHB6/Kj8eYnqPunX6oBRL1vqRw/nLSf
	 GPdnh/yoLsqjsStD0gnnq1/CyCvakzXxNhW2G3EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 6.18 407/675] media: iris: Fix use IRQF_NO_AUTOEN when requesting the IRQ
Date: Thu, 30 Jul 2026 16:12:17 +0200
Message-ID: <20260730141453.784232044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

commit 45ac2230f929b9f0fae899c4a5c6bf763250fc13 upstream.

Requesting the IRQ and then immediately disabling it is fragile as it
leaves a window when the IRQ is still enabled although the underlying
device might be not completely setup for IRQ handling. Pass
IRQF_NO_AUTOEN instead of calling disable_irq_nosync().

Fixes: fb583a214337 ("media: iris: introduce host firmware interface with necessary hooks")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
[bod: Appended Fix to patch title for -stable clarity]
[bod: Added cc stable for backporting]
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_probe.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/qcom/iris/iris_probe.c
+++ b/drivers/media/platform/qcom/iris/iris_probe.c
@@ -256,12 +256,12 @@ static int iris_probe(struct platform_de
 	core->iris_platform_data = of_device_get_match_data(core->dev);
 
 	ret = devm_request_threaded_irq(core->dev, core->irq, iris_hfi_isr,
-					iris_hfi_isr_handler, IRQF_TRIGGER_HIGH, "iris", core);
+					iris_hfi_isr_handler,
+					IRQF_TRIGGER_HIGH | IRQF_NO_AUTOEN,
+					"iris", core);
 	if (ret)
 		return ret;
 
-	disable_irq_nosync(core->irq);
-
 	iris_init_ops(core);
 	core->iris_platform_data->init_hfi_command_ops(core);
 	core->iris_platform_data->init_hfi_response_ops(core);


