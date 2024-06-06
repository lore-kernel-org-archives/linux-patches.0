Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5F7197A76;
	Thu,  6 Jun 2024 14:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683228; cv=none; b=Q5nNb7PzJlO/hBsAB8KN/5Fi2hbXaKdyghfOcoRA2eAoxC3hCXkHwF9VrNORtace53bNSS8t1gjR6/29+nHw+0Vk9EydjF7A5ECI32ZNTr0h2j9hnoVVNY/VTYGQHRpAeqkI+Avf2+nD0kzrQJPKdXZngOk34DrnrDhMM+jgoLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683228; c=relaxed/simple;
	bh=33k9D7nJ0XD8TDkFYYTiw9dMwH6raBx1B6zyALhr2vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWOXU/HSRnONZ7Vf22ZuwLceGWYSohvrfHYC0qlOvLuS68U3gE58lmAdgGyuJscqw9b+sBQ9IBwa0RNRKufR5mLgxRtOo3wuhksmVQsv2iddavHes1rK9ivyOLm+YWWs3Da0sk+QBCXIkMG8n9qgMyEuAgvwld3Uro00AEBkiHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JyOiV8RR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JyOiV8RR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8B2C2BD10;
	Thu,  6 Jun 2024 14:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683228;
	bh=33k9D7nJ0XD8TDkFYYTiw9dMwH6raBx1B6zyALhr2vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JyOiV8RR3NxWjDiBKzMKVRgjCOQktKIK0fkSBb5KFGE8SMZVt5IIKXmwSSl30EUMt
	 iOxSPQpKOL195hM6BlLTMsplPoWsyrZsOP7UeVKmTDf7wU90IyDj4ryckciqnLorSm
	 SUmURjVLEk2A1Avd9YA7UDX43OEEf+R3FZRzW3pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Guo <quic_cang@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/473] scsi: ufs: qcom: Perform read back after writing REG_UFS_SYS1CLK_1US
Date: Thu,  6 Jun 2024 16:00:33 +0200
Message-ID: <20240606131703.344264241@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit a862fafa263aea0f427d51aca6ff7fd9eeaaa8bd ]

Currently after writing to REG_UFS_SYS1CLK_1US a mb() is used to ensure
that write has gone through to the device.

mb() ensures that the write completes, but completion doesn't mean that it
isn't stored in a buffer somewhere. The recommendation for ensuring this
bit has taken effect on the device is to perform a read back to force it to
make it all the way to the device. This is documented in device-io.rst and
a talk by Will Deacon on this can be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. Because the mb()'s purpose
wasn't to add extra ordering (on top of the ordering guaranteed by
writel()/readl()), it can safely be removed.

Fixes: f06fcc7155dc ("scsi: ufs-qcom: add QUniPro hardware support and power optimizations")
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20240329-ufs-reset-ensure-effect-before-delay-v5-2-181252004586@redhat.com
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8ad1415e10b63..a5d981d3dd6be 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -432,7 +432,7 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear,
 		 * make sure above write gets applied before we return from
 		 * this function.
 		 */
-		mb();
+		ufshcd_readl(hba, REG_UFS_SYS1CLK_1US);
 	}
 
 	if (ufs_qcom_cap_qunipro(host))
-- 
2.43.0



