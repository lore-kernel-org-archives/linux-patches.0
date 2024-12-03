Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89E923CE;
	Tue,  3 Dec 2024 16:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242001; cv=none; b=oaUYQaNPf3VvrLcyDHqawFAm3BsESQClBmSicscZFsqiZ1+AQ+ox9mmnYNcC5K9Scl1Kj+236B+rTeONHN8JmjP35y5rHPva1PoilQl+znx4WtCS1EMjvNeD/pLDcvuAUnvL5LaevRxqg+yKrew7Ft7s0F7rqSvAUF9YVAuZtho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242001; c=relaxed/simple;
	bh=U9+qp1AWwbSF9xWlJMHVZlanbitOVOzm8Y+oKdgLUnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSuZQu63gWPE7XDKte/no2yEYx9lH8MniLv/NlWcI6RvL72k4Cbi7iA1y4wM8Ww27VDa/LmiC4pmVW1BxXUVfJ9n6zapSQafK2dQdpHp5K2/ECd+uZtb1vJNSfZFjaNoSJAAge5/ILuLELCWOU+mDSKQg5swoH3W1IJ3e85t2js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ijujvw+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ijujvw+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5651DC4CECF;
	Tue,  3 Dec 2024 16:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242000;
	bh=U9+qp1AWwbSF9xWlJMHVZlanbitOVOzm8Y+oKdgLUnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ijujvw+uVXxlFyBpisYI/V84qq/HyB8KYJkxtsSjw+k0x8AM28LFpeFiGuYu6uz7Q
	 JOSe97LIdwE2CRpzZcEtKzG5ErBhXJ7giExChOgaiIzvQV4MuC5MNdbwGQKMn2RAhX
	 moKDe0FmZO0GCP4wR+zRBMXtNatdKUeb3WYuxcxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 577/826] bnxt_en: Reserve rings after PCIe AER recovery if NIC interface is down
Date: Tue,  3 Dec 2024 15:45:04 +0100
Message-ID: <20241203144806.259457992@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravanan Vajravel <saravanan.vajravel@broadcom.com>

[ Upstream commit 5311598f7f3293683cdc761df71ae3469327332c ]

After successful PCIe AER recovery, FW will reset all resource
reservations.  If it is IF_UP, the driver will call bnxt_open() and
all resources will be reserved again.  It it is IF_DOWN, we should
call bnxt_reserve_rings() so that we can reserve resources including
RoCE resources to allow RoCE to resume after AER.  Without this
patch, RoCE fails to resume in this IF_DOWN scenario.

Later, if it becomes IF_UP, bnxt_open() will see that resources have
been reserved and will not reserve again.

Fixes: fb1e6e562b37 ("bnxt_en: Fix AER recovery.")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 99d025b69079a..20a8cb26bc0a6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16232,8 +16232,12 @@ static void bnxt_io_resume(struct pci_dev *pdev)
 	rtnl_lock();
 
 	err = bnxt_hwrm_func_qcaps(bp);
-	if (!err && netif_running(netdev))
-		err = bnxt_open(netdev);
+	if (!err) {
+		if (netif_running(netdev))
+			err = bnxt_open(netdev);
+		else
+			err = bnxt_reserve_rings(bp, true);
+	}
 
 	if (!err)
 		netif_device_attach(netdev);
-- 
2.43.0



