Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D140A1F55F8;
	Tue, 26 Aug 2025 13:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216658; cv=none; b=DtGAVULBFDcsenDePXnSegajiqjwXN2Cb+gzF4THnQ0cwKG3RGPqamP/MzupCAPFbvlszRozIAZJXhPkjaob3zWtGQ1whNQH8IJJyOWfZjRgX8OWa5QZEVsF61i1Nym5p1tR56eS1sHAlXta9GG4cSI0izh1fCX4qN/6XXnWzWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216658; c=relaxed/simple;
	bh=2FcuAR/i1qZ8V+jCVl9dl13XVptVCJ1ptIVo3/HgPAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJFBlGwDF00sTPTLQyXju98xuSJ9KcwDRTOX0xjZrmJGB2A/eItZH/vji35ADhG7sY5ZDKGyKk1FIaOyTh8zBJjvNVzKkK5H0UpSFRKSBtUPOECzeQzcVZ0W+2Gcd1Ik+i/NEcsjOdpeXqQAtut/j0mkkRZfcEamOMXRcF7Fs84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEe4usIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEe4usIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660A8C4CEF1;
	Tue, 26 Aug 2025 13:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216658;
	bh=2FcuAR/i1qZ8V+jCVl9dl13XVptVCJ1ptIVo3/HgPAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEe4usIOzM4f6eH/Prm8OqUHFGqq/gxvD+PQtxe2vyGU14wD6OCTYOicGSSK30ipq
	 DZWX/59rNentSlGqa676T+tLJ4MtO8BvipXYlLP1gqOvvhNqj8qVnncjVLujAUiY/J
	 XQXKHMjyFWkPSkIZF/l+2HzLx0ECS1RLg6W7jI08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 494/644] media: venus: hfi: explicitly release IRQ during teardown
Date: Tue, 26 Aug 2025 13:09:45 +0200
Message-ID: <20250826110958.735174833@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1679,6 +1679,7 @@ void venus_hfi_destroy(struct venus_core
 	venus_interface_queues_release(hdev);
 	mutex_destroy(&hdev->lock);
 	kfree(hdev);
+	disable_irq(core->irq);
 	core->ops = NULL;
 }
 


