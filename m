Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7276C25DB0A;
	Tue, 26 Aug 2025 14:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218339; cv=none; b=r1j7wY9LGIW4lrbFujdHu3wUc6cOnYZHhw64BkskYK3Karcgh5FwCx+lyo7Ri/fmcADuQtsMlYJZr8y/76WqLKbYkLJlY7sLcafvxjJgZFefjqCmrPo8ywIioNRyyRll7bMK66Cxd3xJ0bFsPbhPd3MNL5bDFKPzf+koVid2ITE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218339; c=relaxed/simple;
	bh=BhLD4rryrNe2cajUSGamNNZLKSxmkL/j5CMZzC9Cf1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXIBDpyg8McheBnUM8cTvZ4XD+QJjTGCuY6UWG52+op7xA8k48LRrImwSuP6iv8U4aJ3ynZzhGBCpm+aX5CNLkIcgZRJhI7XTjhbwYas8Q0q0FMNZjlwIAHn7MpOof35JPUww7HnfjDtQ3Va+yrmSxcNj6j0PJ9HCPeJgAI7yDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmGKqTmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmGKqTmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938E7C4CEF1;
	Tue, 26 Aug 2025 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218335;
	bh=BhLD4rryrNe2cajUSGamNNZLKSxmkL/j5CMZzC9Cf1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmGKqTmJ6YiTagmI5bf9MDsOZ1ck9cFaF8kfAWomkpi9fKwBP6RnCNUmtOIfHfIwi
	 y5DT5b1jwxp9DkEtHPb58rQdiv51sPxX++k8x8iyokHq3L8606oWkyEkDohAQgk3iP
	 G8hoiZhVudpnz3Y0Q1mp5y/i5fX/0JvnNFqm7vm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 484/523] media: venus: dont de-reference NULL pointers at IRQ time
Date: Tue, 26 Aug 2025 13:11:34 +0200
Message-ID: <20250826110936.386593321@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 686ee9b6253f9b6d7f1151e73114698940cc0894 ]

Smatch is warning that:
	drivers/media/platform/qcom/venus/hfi_venus.c:1100 venus_isr() warn: variable dereferenced before check 'hdev' (see line 1097)

The logic basically does:
	hdev = to_hfi_priv(core);

with is translated to:
	hdev = core->priv;

If the IRQ code can receive a NULL pointer for hdev, there's
a bug there, as it will first try to de-reference the pointer,
and then check if it is null.

After looking at the code, it seems that this indeed can happen:
Basically, the venus IRQ thread is started with:
	devm_request_threaded_irq()
So, it will only be freed after the driver unbinds.

In order to prevent the IRQ code to work with freed data,
the logic at venus_hfi_destroy() sets core->priv to NULL,
which would make the IRQ code to ignore any pending IRQs.

There is, however a race condition, as core->priv is set
to NULL only after being freed. So, we need also to move the
core->priv = NULL to happen earlier.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 640803003cd9 ("media: venus: hfi: explicitly release IRQ during teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -1071,12 +1071,15 @@ static irqreturn_t venus_isr(struct venu
 {
 	struct venus_hfi_device *hdev = to_hfi_priv(core);
 	u32 status;
-	void __iomem *cpu_cs_base = hdev->core->cpu_cs_base;
-	void __iomem *wrapper_base = hdev->core->wrapper_base;
+	void __iomem *cpu_cs_base;
+	void __iomem *wrapper_base;
 
 	if (!hdev)
 		return IRQ_NONE;
 
+	cpu_cs_base = hdev->core->cpu_cs_base;
+	wrapper_base = hdev->core->wrapper_base;
+
 	status = readl(wrapper_base + WRAPPER_INTR_STATUS);
 
 	if (status & WRAPPER_INTR_STATUS_A2H_MASK ||
@@ -1613,10 +1616,10 @@ void venus_hfi_destroy(struct venus_core
 {
 	struct venus_hfi_device *hdev = to_hfi_priv(core);
 
+	core->priv = NULL;
 	venus_interface_queues_release(hdev);
 	mutex_destroy(&hdev->lock);
 	kfree(hdev);
-	core->priv = NULL;
 	core->ops = NULL;
 }
 


