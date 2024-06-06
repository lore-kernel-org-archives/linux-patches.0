Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF67199384;
	Thu,  6 Jun 2024 14:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683214; cv=none; b=oXdxThgnm1FqVzfZBg6GtVBV5G2NendpAbkGdOdGtoXjfzsO1gwzpuEX8OeiGraSIMW/X3vVCksmVoCIZc/dP5lh4/AXtw1bK35aR2XgKdjhFQOMxtgVmc2fXkmpeRFeAwN5Midoo499HmqJnmjDNMeMCW2z98knSO5TRJ7WNvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683214; c=relaxed/simple;
	bh=3WtBLbz47Flachn3Ae+6fMBm2nFIsxpHecrOgC1QDaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+OxnsZvNmxfp7yQ+sWqRI4RyP9iMjM5hlQfDfKRSfJlCQE5jFSdYZWT31unPZfkBjrkC0UjnIfkctHE47UEQEeemtJeaCNOuWu9fSvs8r2EeKOeT0LGsxv8nFmWvSDWd1ZYRlUK9oRrv1+lJlvIvZTAaoIcR1f+BgCcZ+9ZQ9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUQF2Nsv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUQF2Nsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674E5C2BD10;
	Thu,  6 Jun 2024 14:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683214;
	bh=3WtBLbz47Flachn3Ae+6fMBm2nFIsxpHecrOgC1QDaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUQF2Nsv7xYe0tQcQ4oizI1CMamQ5xkiLwXI9nDlbmYGPN29vcTQMp4bn6QhRa9g1
	 xBKJ6mTWYURoHHwklH3HtMewnQ+U8wgcPBN1Q4t72SW0+OV88u8Iq9JIZeYPxB5Lrk
	 eJeskzjFOXmRFbV2Qu10rcP2+oofZJYGo+RXRrmk=
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
Subject: [PATCH 6.6 157/744] scsi: ufs: core: Perform read back after disabling UIC_COMMAND_COMPL
Date: Thu,  6 Jun 2024 15:57:09 +0200
Message-ID: <20240606131737.463091283@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2371b00c56be9..589c90f4d4021 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4136,7 +4136,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
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



