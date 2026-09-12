Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE8D29DB64;
	Sat, 12 Sep 2026 10:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208796; cv=none; b=K9cY0QizuFT2FVsiWeW2X187mrBALjIoclCuGyRPi+/trNMBfEp6gs1k06yquOufS2LV6mWx/j60ipBHi99aCTo9gfAH8Jg2FrCxB8XCJAEaxe18PMvrXW4HIarF6JSM6Zf6lX4jF1r7IwYRNaMgDH6iw9bRO7YBqhMz1qtjDxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208796; c=relaxed/simple;
	bh=KeRm+WQg/HAZO8Oyso2DFyhx/kZUq24Fj/UBjn+8uc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXXUGWb+AQXMp34xQz74xyWjMrejcLPhq8878Ret+PoXuXKjiJ96b11Z6qZhWMyOntNJxb2o1z/ovDqyoGxc0TjgIKtxt+8vqIrH/aoiD1YtBXnTw2sWNuvUqSinlCh7ThXWVf6C56jqGFCS24HFlGJk7by2cxIzt/k734vw6ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08VN8YIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08VN8YIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3681F000FF;
	Sat, 12 Sep 2026 10:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208795;
	bh=ZVr6uXPqbMmc5Q+fLuHNqr3oKBge1i6g5osrTn7Y3L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=08VN8YISb8P5EsefvgHkqzDULOJmSUZvBXzu4RV7F7EXKejjpK9hMLokmKX3idIM7
	 o7DREkafeXycLwmfuSZsl4iOnMEhHzQ91Oan8A0MvzUZ546GH4gMIX+hvaGPXxu0cJ
	 yDsrM67RJCrZVUU51RxEky1f/MJwHQCgyXBAij/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex@shazbot.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0648/1518] bus: mhi: host: Flush the posted write after writing to MHI_SOC_RESET_REQ_OFFSET
Date: Sat, 12 Sep 2026 08:46:57 +0200
Message-ID: <20260912065638.090856711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 8615512743199..eeb277dee7486 100644
--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -170,6 +170,9 @@ EXPORT_SYMBOL_GPL(mhi_get_mhi_state);
 
 void mhi_soc_reset(struct mhi_controller *mhi_cntrl)
 {
+	int __maybe_unused ret;
+	u32 tmp;
+
 	if (mhi_cntrl->reset) {
 		mhi_cntrl->reset(mhi_cntrl);
 		return;
@@ -178,6 +181,9 @@ void mhi_soc_reset(struct mhi_controller *mhi_cntrl)
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



