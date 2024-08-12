Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1355C15C127;
	Mon, 12 Aug 2024 16:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480437; cv=none; b=WsRdm8o2qpdfGLGIEpLBItS0OPWRzkAKFc1RjltGhc7j8WjqS2+EfkriBnEDGY0uzNnq2z8gz5/Pu9Qx4vSbSg/5QS3fZXQaotUnMTMjXBHsj6zcMn3IUKky9DN2O6CQOSccuiKYR3FbVF6arAbbH3VUa02iGl3stNNzeUkvuXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480437; c=relaxed/simple;
	bh=timkbyYwEf0Ts9MdIzGYRpQkBqBtopaPalQgbQ1El6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eG9Ih6Bra5rsSekQx1VID7cuhhfI1PR8DoPjUDNJ0C/EtqeoTc+XQ4oSMe1VqQYMID3DFwRN3UxxTE/6huSIMmNRXQZl4t1e3jDtChpujNVlOMWCKH6RfOE4+FozanH1PqFvTO5rZGZ1WDFs8OLE+Eza7DkzPLNq12esEy+d6gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1sFEGwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1sFEGwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DF4C32782;
	Mon, 12 Aug 2024 16:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480436;
	bh=timkbyYwEf0Ts9MdIzGYRpQkBqBtopaPalQgbQ1El6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1sFEGwQFOmQwv7qOeOMSbXJYdI/OW2ETjZKryWZaYck6BPAZ46spHDnpfntxpAA4
	 LXWr2sPMhn049gqLv6GO17ShjtlLM/ka52XYGbmJx8SaoB+kS8QAl4gh6TcoOsR50l
	 BdUxrHAAP4ZwRwsT79DAI6LRrtpFQhjgP5u6XjPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjana Hari <quic_ahari@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.10 196/263] scsi: ufs: core: Do not set link to OFF state while waking up from hibernation
Date: Mon, 12 Aug 2024 18:03:17 +0200
Message-ID: <20240812160154.047971001@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit ac6efb12ca64156f4a94e964acdb96ee7d59630d upstream.

UFS link is just put into hibern8 state during the 'freeze' process of the
hibernation. Afterwards, the system may get powered down. But that doesn't
matter during wakeup. Because during wakeup from hibernation, UFS link is
again put into hibern8 state by the restore kernel and then the control is
handed over to the to image kernel.

So in both the places, UFS link is never turned OFF. But
ufshcd_system_restore() just assumes that the link will be in OFF state and
sets the link state accordingly. And this breaks hibernation wakeup:

[ 2445.371335] phy phy-1d87000.phy.3: phy_power_on was called before phy_init
[ 2445.427883] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2445.427890] ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
[ 2445.427906] ufs_device_wlun 0:0:0:49488: ufshcd_wl_resume failed: -5
[ 2445.427918] ufs_device_wlun 0:0:0:49488: PM: dpm_run_callback(): scsi_bus_restore returns -5
[ 2445.427973] ufs_device_wlun 0:0:0:49488: PM: failed to restore async: error -5

So fix the issue by removing the code that sets the link to OFF state.

Cc: Anjana Hari <quic_ahari@quicinc.com>
Cc: stable@vger.kernel.org # 6.3
Fixes: 88441a8d355d ("scsi: ufs: core: Add hibernation callbacks")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240718170659.201647-1-manivannan.sadhasivam@linaro.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10223,9 +10223,6 @@ int ufshcd_system_restore(struct device
 	 */
 	ufshcd_readl(hba, REG_UTP_TASK_REQ_LIST_BASE_H);
 
-	/* Resuming from hibernate, assume that link was OFF */
-	ufshcd_set_link_off(hba);
-
 	return 0;
 
 }


