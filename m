Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58496D518;
	Mon, 27 May 2024 19:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836631; cv=none; b=lPDAZ4Y7j+k1OL2Hyor+yjBI67PfO3W+YvgIW3JdtBQDPmuvbCPFtkiLzTyQuriqpfiEfD9CNqjlo9RvBj7LihYCD9oxdc3vEnbUXTTnv1FiyK0qhZPghFTrLmOoP61dCTPWUt4V1qNMnHIvqC4sEV4eqMUhlhv7Xnbe4Nz+Y5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836631; c=relaxed/simple;
	bh=5txbhwUkYgzIc0Z9GgvWZEqY1BxjIhxhCYg8vglEtk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqHFLERqLMriD0ZQBmgoe/v7s6Q/8gWLY+jptNEn6KNRlIdeG6p6sw7a+jrET5kkkxLniO0zJB7tXy+atGRjf74gsfLHObMj+5TxoNrgcxFYlg7ml5kFlPwlxVytwpgkWuyChKcWa/uyM7EUvSvpjoy3WTmXNfjIepYVe9bZ5J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEYCokQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEYCokQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3DEC2BBFC;
	Mon, 27 May 2024 19:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836630;
	bh=5txbhwUkYgzIc0Z9GgvWZEqY1BxjIhxhCYg8vglEtk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEYCokQ1CiHBlcU0XxcMJrjEHt+huZz8HwT0SlYtP6KmMDbwBiNlW1hc4uBEZqRKT
	 ABJ9AOdnXvXuZjQfjs9ODNY3J8Iu40KIZFAXbpDCve24//ZxaK1yzQXdGtIZJM7IYw
	 hmPYUhKUzT8fq6mjZ8rWUUFr2cyExLyez/kzGzBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ahalaney@redhat.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 128/427] scsi: ufs: qcom: Perform read back after writing unipro mode
Date: Mon, 27 May 2024 20:52:55 +0200
Message-ID: <20240527185613.902934006@linuxfoundation.org>
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
index bb3445e5efa8b..004a0f6b1fffa 100644
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



