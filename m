Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E68426AF2;
	Mon, 27 May 2024 19:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836646; cv=none; b=gXXulW1ncq3+fu7DyRWKqluQgyt5QMD5ded+bwF3M4hxvXG8L6/ViYrxpalzMPRQkR4Bj8uV55zD4HLOaLre5itgpN6p/1FSjyIOZdhSem4smhNoQR07x8xCIcS9HhDXxPduU3a7DrGNV5hZd3WagoRNoArtL1E8Zer66e2zP/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836646; c=relaxed/simple;
	bh=AntuAPQa6ITu41YFljoNogPJKwQENmqaBU7VG0haueM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7vbSDV+mCFcHJ/T2R1eMxoTMMM3judIgN5HXy8Zhc1vySlxtnl9OlwKp1L/ggw5MAylBjC5WTMi7mNaQFBE34f3uqqcrOyNz+nKyEtPgq0tdgoRcinPFxGbbi7sTRBK40NoIIsdJ6TqqdLzwC5LSmDMX/jiJOglKIGHo/QTzYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Se1kFLy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Se1kFLy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A1FC2BBFC;
	Mon, 27 May 2024 19:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836645;
	bh=AntuAPQa6ITu41YFljoNogPJKwQENmqaBU7VG0haueM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Se1kFLy6BKLFlUmX0WZTnXbKA800X96NDbwc5TrBeIEbyIOXLJCERqlUj5w/viXdA
	 G18RIy+Nue/7PfqPswo5ob/oclxE3LlEFMfSou0uzutAn6+WYbtRbLNKZflIrBNqfH
	 29SRg2xGQ/Bfgw5O4+anOq2nvrpvhgGbqRiRKo1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 133/427] scsi: ufs: core: Perform read back after disabling UIC_COMMAND_COMPL
Date: Mon, 27 May 2024 20:53:00 +0200
Message-ID: <20240527185614.297294759@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit 4bf3855497b60765ca03b983d064b25e99b97657 ]

Currently, the UIC_COMMAND_COMPL interrupt is disabled and a wmb() is used
to complete the register write before any following writes.

wmb() ensures the writes complete in that order, but completion doesn't
mean that it isn't stored in a buffer somewhere. The recommendation for
ensuring this bit has taken effect on the device is to perform a read back
to force it to make it all the way to the device. This is documented in
device-io.rst and a talk by Will Deacon on this can be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. Because the wmb()'s
purpose wasn't to add extra ordering (on top of the ordering guaranteed by
writel()/readl()), it can safely be removed.

Fixes: d75f7fe495cf ("scsi: ufs: reduce the interrupts for power mode change requests")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20240329-ufs-reset-ensure-effect-before-delay-v5-9-181252004586@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5ade57c5a6f4f..1322a9c318cff 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4289,7 +4289,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		 * Make sure UIC command completion interrupt is disabled before
 		 * issuing UIC command.
 		 */
-		wmb();
+		ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 		reenable_intr = true;
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-- 
2.43.0



