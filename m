Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA131C5799;
	Sat, 12 Sep 2026 18:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239457; cv=none; b=Sau+PJ1Rf2eyO9iQKa5rnk3o1weUn997+w8eYccmKsHrERvWwPsYi5xY2Udnw5AsFoTMIsEV5jJU+SLEqSOaPuhKZ9Oo6PtbDYHg1QPXRdudKA9Q8pdswdrr3MqDEbNq/TJId2brRO4sYwkc0m9gPMHTlqOCU+bOTK7ct7fVklY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239457; c=relaxed/simple;
	bh=UKqtYz87IzS8yvwDYqqyv2YgGrgS7+/wVaa/LutlTbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/SQ+dECURyciyT14JrC3hSL0bJiPeTgF4Req/DRN8Y+X9Kw5+G7pEiqtAwC4FhCFXswGno6bteCf+7EB1XhPe31iBH1QcE7X3uiTiAkyNWT6lYgG6SAfZ8wV0GV9KPZE6y+oi6Ob0gotw3v9VPYJu3Mfl32PAzmZr4dpCBWfBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oM6Wa7H4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oM6Wa7H4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5368E1F000FF;
	Sat, 12 Sep 2026 18:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239456;
	bh=Med1e/t+fB7OZgZVEUo4eMpEZkAqrAeQ2NaPIRKF0Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oM6Wa7H4zFhPZ13HYPXO34fOTJlewPCPNJZGrJ4TJxFkjxqi6UKsEW2GphK91JXBm
	 zj/B1m7kkBkSEBS1kWT6Fv5+J+wVUUoqtonPUigHNdV0vW9T8A4dE6eWShQGS0Vl7x
	 9oJmiFFfWNV4brst0kdpOXpp8jKy0u7HnbiUeHdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex@shazbot.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 631/935] bus: mhi: host: Flush the posted write after writing to MHI_SOC_RESET_REQ_OFFSET
Date: Sat, 12 Sep 2026 09:01:01 +0200
Message-ID: <20260912065541.312995928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 24f4423cbc89548def2b05ae86de6175086dbf94 ]

mhi_soc_reset() tries to reset the device by writing to the
MHI_SOC_RESET_REQ_OFFSET register. But it doesn't do a read-back to ensure
that the write gets flushed to the device before returning to the caller.

This may lead to the delay (if implemented) on the caller to be
insufficient, if the posted write doesn't reach the device before the
delay.

So add a read-back after writing to the MHI_SOC_RESET_REQ_OFFSET register.

Fixes: b5a8d233a588 ("bus: mhi: core: Add device hardware reset support")
Reported-by: Alex Williamson <alex@shazbot.org>
Closes: https://lore.kernel.org/linux-pci/20260622160822.09350246@shazbot.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260623145134.43976-1-manivannan.sadhasivam@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/bus/mhi/host/main.c b/drivers/bus/mhi/host/main.c
index f96a3620e67da..5e59c3c578d18 100644
--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -167,6 +167,9 @@ EXPORT_SYMBOL_GPL(mhi_get_mhi_state);
 
 void mhi_soc_reset(struct mhi_controller *mhi_cntrl)
 {
+	int __maybe_unused ret;
+	u32 tmp;
+
 	if (mhi_cntrl->reset) {
 		mhi_cntrl->reset(mhi_cntrl);
 		return;
@@ -175,6 +178,9 @@ void mhi_soc_reset(struct mhi_controller *mhi_cntrl)
 	/* Generic MHI SoC reset */
 	mhi_write_reg(mhi_cntrl, mhi_cntrl->regs, MHI_SOC_RESET_REQ_OFFSET,
 		      MHI_SOC_RESET_REQ);
+	/* Flush the posted write to the device (ignore return value) */
+	ret = mhi_read_reg(mhi_cntrl, mhi_cntrl->regs, MHI_SOC_RESET_REQ_OFFSET,
+			   &tmp);
 }
 EXPORT_SYMBOL_GPL(mhi_soc_reset);
 
-- 
2.53.0



