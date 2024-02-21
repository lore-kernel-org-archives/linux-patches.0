Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90A153816;
	Wed, 21 Feb 2024 13:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521821; cv=none; b=O5JF9Fe3YFI+FbjxSgPmozlAiqnpFg6VC+tXHX5oPtKTZt567rXrkr2bYTm2qukx5Wwdk2DFFgCmsNWN9ommWNgpn1WwCagQdOmo7aiYOlvFMQ4kkFfiLkUDD5Kfk9VYZcTFqgpHYApkXsie6XWbEj/CIPOpc5AfM75LUhnrmpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521821; c=relaxed/simple;
	bh=NP7IP5PnpiR9ehfa0KYMEQOuEzlYiKWs4oVRYFbrjzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2psYToNtc5VF2GGdFDowK0+rbnsrxYYypc7cLvR5lLr/SdiseiwageD3TJcdnTSZOwpkIU5vukBNGgwrBZLa38bEmSMlVQZN4E6MR97XeTGakHU8mzHu1duGc2yPnpUW/o2szKsaBc3CzsiYpgN8wCPxhY7AynLP6dRK3JPTV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5eVuaZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5eVuaZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19271C433F1;
	Wed, 21 Feb 2024 13:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521821;
	bh=NP7IP5PnpiR9ehfa0KYMEQOuEzlYiKWs4oVRYFbrjzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5eVuaZglev0yePRVb5uzgJ8HaVx0YQUBhlAS2tXlPGgH+r1R2q2ypPfekWCiJEhM
	 qQevE7jDjPAgOE8Mca9rEtibSV+wfxao5YLm4wqboyanNaODnCychPIIWZkwtUtoIw
	 72pL9qpvCUmqUk2xE6zCa05kWIxQtkmIEPbu1YWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Mentz <danielmentz@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/476] scsi: ufs: core: Remove the ufshcd_hba_exit() call from ufshcd_async_scan()
Date: Wed, 21 Feb 2024 14:01:02 +0100
Message-ID: <20240221130008.280505319@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit ee36710912b2075c417100a8acc642c9c6496501 ]

Calling ufshcd_hba_exit() from a function that is called asynchronously
from ufshcd_init() is wrong because this triggers multiple race
conditions. Instead of calling ufshcd_hba_exit(), log an error message.

Reported-by: Daniel Mentz <danielmentz@google.com>
Fixes: 1d337ec2f35e ("ufs: improve init sequence")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20231218225229.2542156-3-bvanassche@acm.org
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0354e3bce455..03b33c34f702 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8020,12 +8020,9 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 
 out:
 	pm_runtime_put_sync(hba->dev);
-	/*
-	 * If we failed to initialize the device or the device is not
-	 * present, turn off the power/clocks etc.
-	 */
+
 	if (ret)
-		ufshcd_hba_exit(hba);
+		dev_err(hba->dev, "%s failed: %d\n", __func__, ret);
 }
 
 static const struct attribute_group *ufshcd_driver_groups[] = {
-- 
2.43.0



