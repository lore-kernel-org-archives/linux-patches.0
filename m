Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924CA43F8D3;
	Thu, 30 Jul 2026 14:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422590; cv=none; b=g/DYIaf6gJo41cZA8fvDTLmczHs4GF1jkog3nttGCOnd1IsNCOjo6su0kbHoQ5HYOOjPUoBoj0KuVa48jQX+5MvaGwKwP9KNG2na0rCRmJFwGSsQ+nyzkv+yU5+CW3Uii4BSxsiaT2m6mPpig+PVwdzZYrpkl5IN9brt6E3h2So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422590; c=relaxed/simple;
	bh=naMF9qKrd8xqUNw04TPsZZb8vJznIUy7PH2xBDgFnCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxSwba9tsvJtG7Zy5+uemD7alQCyYvegVbWJa1CngwuieunE6q7i1DMUPeMn4Jyx2mOgsd1ZYBOIv/NUMnsiTrWJirUMMbi5z4uW7WRt2vvmrNkK8J/CIhLBzT0/wm9G8yd4ZKYyGCRYu/mkmIDpyyo34ayQQhLinXr+a+qUpxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQamKZRb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQamKZRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECD81F00A3A;
	Thu, 30 Jul 2026 14:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422585;
	bh=Br64Gi9nEEB/Zqv/ohZsPO1lEhEymJ7iTD/8Lz23nvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQamKZRbajbgVQF9oPBo28KeQMdYjvowNTFnT4QesN/OM/5otq8jVocFOVeq4agpE
	 vY0EwbdGAtK2dT8VJneHg3nPnCCIDzvkbAQphGhVnfPIdPh3DgXCCl7YO+gYVzSe9/
	 5p3pAZJk4ygejvVu0TcWEy1dIObQNI9cVrj2j/4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 7.1 488/744] media: iris: Fix use IRQF_NO_AUTOEN when requesting the IRQ
Date: Thu, 30 Jul 2026 16:12:41 +0200
Message-ID: <20260730141454.667495697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -252,12 +252,12 @@ static int iris_probe(struct platform_de
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


