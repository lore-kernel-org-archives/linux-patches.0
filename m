Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9A917332C;
	Tue, 26 Aug 2025 11:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208444; cv=none; b=r7Fs7UWRHlAxSjwA2WNSr1YFx6jsWPs8Cq3DZ6iW59wS90aUul5BUVgTbBMtJlf5zZTVffYrImz+zFahWaOOZYdeakIFkxEPKrcwQOfXousg9lwacciLZ6V/uCUMO1W9iqlS00KC+IziC3cnvnxI2WKQcvK5HWIgDpocbUz75nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208444; c=relaxed/simple;
	bh=GzyPM8yHi1iIuUKm9gIbnFDsWqSTlMge7z93e3pViM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m67OGKnugKbVNM78Bvyzh9VWZvzkrkTHb8RXFwRB0LSvYYwerVKDo88W1ZLj1Cwai+TrNwR+TUr5v6yTwDu5RgTryB3erACVkRg09EIImc8fZv77Ul9pGSCFu5fpYMHjosnVkipdcwV/st5cNVPAdiaLe9cUeDtiEKK3Ms8nUR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABImMEgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABImMEgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B7EC4CEF1;
	Tue, 26 Aug 2025 11:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208443;
	bh=GzyPM8yHi1iIuUKm9gIbnFDsWqSTlMge7z93e3pViM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABImMEgDqirN9iYYztC1mUqWn7f6ApBzba3RO2/KUPQNu2UgabGnGc3+cX1EEkRYX
	 Dhm+SmwBGp0ah1a9fw+TfD01LoRiwbhz6BdBg374ej1++VW2YQHGshRWloGQmbjOAS
	 45kdLGRZp6kekxqNQJ1JcZrjwRqOGpt37SpNv8Rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 114/322] media: venus: hfi: explicitly release IRQ during teardown
Date: Tue, 26 Aug 2025 13:08:49 +0200
Message-ID: <20250826110918.602549417@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

commit 640803003cd903cea73dc6a86bf6963e238e2b3f upstream.

Ensure the IRQ is disabled - and all pending handlers completed - before
dismantling the interrupt routing and clearing related pointers.

This prevents any possibility of the interrupt triggering after the
handler context has been invalidated.

Fixes: d96d3f30c0f2 ("[media] media: venus: hfi: add Venus HFI files")
Cc: stable@vger.kernel.org
Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Dikshita Agarwal <quic_dikshita@quicinc.com> # RB5
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -1693,6 +1693,7 @@ void venus_hfi_destroy(struct venus_core
 	venus_interface_queues_release(hdev);
 	mutex_destroy(&hdev->lock);
 	kfree(hdev);
+	disable_irq(core->irq);
 	core->ops = NULL;
 }
 


