Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D8B168C4;
	Mon, 27 May 2024 19:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837922; cv=none; b=D9zvgjR9G2tjWTGs6yagS+ucgoo3MrPUvvIrmSrbOUQ4PSj5thuCXtFziZaZ7WKnzZgmrVQsuMw4IS2KxLwcnhRN7S/sJU3crmH4QCLHKENnki5m6Hls6QqtvlM3d/GU4Uav6bS8OVGeha0VO/GTpOLNZzS5FqnfqlO9eQ9cZTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837922; c=relaxed/simple;
	bh=Ox25diVOEsonZ+aLqSPqTUmgTcM/YAa5+oXQsGNSaPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYf3kTIrqjQkOClJPWuGaacBkjZL5NlWqpFdFKcwxg3DlDzK47XEYi983CJPMfqnTAvxWGB5tPnh6EKl0JBU02I9ISJoFCN81D7Q5JhFyt692PnU1pSu/RXw8rLUpi6w513liaK5QCRv4F0R85NlDlYK8Wdm4Bm6SJ4++TqlW7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbCegG9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbCegG9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A51C2BBFC;
	Mon, 27 May 2024 19:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837921;
	bh=Ox25diVOEsonZ+aLqSPqTUmgTcM/YAa5+oXQsGNSaPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbCegG9moXElIXSSGB2z/zsvky7w3pEKEsH8Aky8wC+2lhrV/fqyEyGk3YJx4PbcC
	 7eC4FN/PLRCsZWXT0op1xLanIe4W1CWGjPzsaKpTYT1AwR4VyNQD32UEkaxRfiVem1
	 11Z7gu1MMTN+P8fk4EW51OCKPcoGo2O0wPbfGwD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ahalaney@redhat.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 197/493] scsi: ufs: qcom: Perform read back after writing unipro mode
Date: Mon, 27 May 2024 20:53:19 +0200
Message-ID: <20240527185636.794177542@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit 823150ecf04f958213cf3bf162187cd1a91c885c ]

Currently, the QUNIPRO_SEL bit is written to and then an mb() is used to
ensure that completes before continuing.

mb() ensures that the write completes, but completion doesn't mean that it
isn't stored in a buffer somewhere. The recommendation for ensuring this
bit has taken effect on the device is to perform a read back to force it to
make it all the way to the device. This is documented in device-io.rst and
a talk by Will Deacon on this can be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

But, there's really no reason to even ensure completion before
continuing. The only requirement here is that this write is ordered to this
endpoint (which readl()/writel() guarantees already). For that reason the
mb() can be dropped altogether without anything forcing completion.

Fixes: f06fcc7155dc ("scsi: ufs-qcom: add QUniPro hardware support and power optimizations")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20240329-ufs-reset-ensure-effect-before-delay-v5-4-181252004586@redhat.com
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8aa55ed45d8e0..cef410f31f449 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -284,9 +284,6 @@ static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 
 	if (host->hw_ver.major >= 0x05)
 		ufshcd_rmwl(host->hba, QUNIPRO_G4_SEL, 0, REG_UFS_CFG0);
-
-	/* make sure above configuration is applied before we return */
-	mb();
 }
 
 /*
-- 
2.43.0



