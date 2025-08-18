Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3274527B324;
	Mon, 18 Aug 2025 14:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526139; cv=none; b=k213PBtsgbU+e1thF906o2eGYQ8Ubfs+fMeXNOrlnmMi9Shmm2AWgSR/6YFBIbsk6LQ6st6pX5lU9C2zIC7m++HX47ai/QrG/1NnaFXiPnitakakUJMAlh9DCzEcSbEsAvijKumq0Ya8znGepLnTXzhKSv+N7ke2xBcgpFsVgAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526139; c=relaxed/simple;
	bh=KdKolxYyXEsqpDCfe1GMMMu79siWIeWWhPI5Q+R+Jys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7H+DU095aF/Bvv6hmGpqohSSAYRalblJhythcuY0tI/w73t/Z5PcEW1RihzUdKovo8tRNm+2kYRDGYHqUw6bAmXej6/ycEQ8aLnvj7tWYlle219b9B11nJq/vw3gpdjO1rlDKl8mtHeF9US0fPTnvzzMHnCV+64tnaJ+kiBqiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gu9rcSyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gu9rcSyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C6FC4CEEB;
	Mon, 18 Aug 2025 14:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526139;
	bh=KdKolxYyXEsqpDCfe1GMMMu79siWIeWWhPI5Q+R+Jys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gu9rcSyiRNhvf7qsIdhFHqXxJC81Waj5X+HjbGqrJ5ddolr2sFADjgl8eCC5ufMrb
	 XVMfyRVKGLgSzW7nRrnhsth7ijkEYFREDBslbrOzLgx55jpZmdmpwrcOokb16YDWh0
	 TUksL1TTvdODZg6+KBPOg7Mdqivs2pp76bxINudM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palash Kambar <quic_pkambar@quicinc.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.16 469/570] scsi: ufs: core: Fix interrupt handling for MCQ Mode
Date: Mon, 18 Aug 2025 14:47:36 +0200
Message-ID: <20250818124523.945328300@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

From: Nitin Rawat <quic_nitirawa@quicinc.com>

[ Upstream commit 034d319c8899e8c5c0a35c6692c7fc7e8c12c374 ]

Commit 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service
routine to a threaded IRQ handler") introduced a regression where the UFS
interrupt status register (IS) was not cleared in ufshcd_intr() when
operating in MCQ mode. As a result, the IS register remained uncleared.

This led to a persistent issue during UIC interrupts:
ufshcd_is_auto_hibern8_error() consistently returned true because the
UFSHCD_UIC_HIBERN8_MASK bit was set, while the active command was neither
UIC_CMD_DME_HIBER_ENTER nor UIC_CMD_DME_HIBER_EXIT. This caused
continuous auto hibern8 enter errors and device failed to boot.

To fix this, ensure that the interrupt status register is properly
cleared in the ufshcd_intr() function for both MCQ mode with ESI enabled.

[    4.553226] ufshcd-qcom 1d84000.ufs: ufshcd_check_errors: Auto
Hibern8 Enter failed - status: 0x00000040, upmcrs: 0x00000001
[    4.553229] ufshcd-qcom 1d84000.ufs: ufshcd_check_errors: saved_err
0x40 saved_uic_err 0x0
[    4.553311] host_regs: 00000000: d5c7033f 20e0071f 00000400 00000000
[    4.553312] host_regs: 00000010: 01000000 00010217 00000c96 00000000
[    4.553314] host_regs: 00000020: 00000440 00170ef5 00000000 00000000
[    4.553316] host_regs: 00000030: 0000010f 00000001 00000000 00000000
[    4.553317] host_regs: 00000040: 00000000 00000000 00000000 00000000
[    4.553319] host_regs: 00000050: fffdf000 0000000f 00000000 00000000
[    4.553320] host_regs: 00000060: 00000001 80000000 00000000 00000000
[    4.553322] host_regs: 00000070: fffde000 0000000f 00000000 00000000
[    4.553323] host_regs: 00000080: 00000001 00000000 00000000 00000000
[    4.553325] host_regs: 00000090: 00000002 d0020000 00000000 01930200

Fixes: 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service routine to a threaded IRQ handler")
Co-developed-by: Palash Kambar <quic_pkambar@quicinc.com>
Signed-off-by: Palash Kambar <quic_pkambar@quicinc.com>
Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Link: https://lore.kernel.org/r/20250728225711.29273-1-quic_nitirawa@quicinc.com
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f07878c50f14..3cc566e8bd1d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7110,14 +7110,19 @@ static irqreturn_t ufshcd_threaded_intr(int irq, void *__hba)
 static irqreturn_t ufshcd_intr(int irq, void *__hba)
 {
 	struct ufs_hba *hba = __hba;
+	u32 intr_status, enabled_intr_status;
 
 	/* Move interrupt handling to thread when MCQ & ESI are not enabled */
 	if (!hba->mcq_enabled || !hba->mcq_esi_enabled)
 		return IRQ_WAKE_THREAD;
 
+	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
+	enabled_intr_status = intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+
+	ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
+
 	/* Directly handle interrupts since MCQ ESI handlers does the hard job */
-	return ufshcd_sl_intr(hba, ufshcd_readl(hba, REG_INTERRUPT_STATUS) &
-				   ufshcd_readl(hba, REG_INTERRUPT_ENABLE));
+	return ufshcd_sl_intr(hba, enabled_intr_status);
 }
 
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
-- 
2.50.1



