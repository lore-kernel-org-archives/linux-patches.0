Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1679F1849;
	Thu, 13 Jun 2024 12:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281813; cv=none; b=KGifBjFSy0q90OoUN5FIsvyNMWH3rGWI1nrc6MGSHCn3CDFdf3y8TKSj2X+VoVGa6n/uVrwpg/2JCSPdIzbvZTpLDCKYoKmmftiQmMlZXaDePq5dDe0iUA4TmVMdft7tWfaAqMPj+FjKdmo8MMaSiMA1XULB8kAEifIArhSf2dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281813; c=relaxed/simple;
	bh=bYoSFR5gEY7QDUZ+BsvvV9KQjAi+2JIGKxysg2EguzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbdLFSM82RyQ8NWM9ciDHhW9PWxy+jzeZVrwooasNzLFzJREqhf6AzTl8ReLuMJMERFe028NXiMQVhwOtCxJ41QqatsZcP7mPguOddZDlgxEQ9bUoDS558i4QblKD5c6ybfzDyr5cVAaJw3vP8aALLTzwl5OK+XsMGfkGb2TJGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFbh9eDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFbh9eDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93056C2BBFC;
	Thu, 13 Jun 2024 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281813;
	bh=bYoSFR5gEY7QDUZ+BsvvV9KQjAi+2JIGKxysg2EguzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFbh9eDFwIbAACf3Nck0K1ahl29kiIrjMz9uxQbhjinrEk8GaF9fTqzUOQBGj8r9P
	 e/PIHLJjoNxQkuTB0NK240OCi+/ucGRa7CNY7bCQ7ILbqAF9V+xweVKYzW61gmYg7P
	 LSAUt2FzVIDfyXLf97VEzegLZ7pMtsvMFYVptrMU=
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
Subject: [PATCH 5.15 065/402] scsi: ufs: core: Perform read back after disabling UIC_COMMAND_COMPL
Date: Thu, 13 Jun 2024 13:30:22 +0200
Message-ID: <20240613113304.673145051@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1b8fdeb053529..b7abf1f6410c8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3960,7 +3960,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
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



