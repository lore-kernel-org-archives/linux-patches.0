Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA52219CC11;
	Mon, 23 Jun 2025 21:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714600; cv=none; b=Yw9R+UpIBzCtehsCocrHQkVedar86wSgBJusUYsM7S7hwdn+h79HfPZ4Y3bSI0OONlJ1X7UoG6fbYAJertbO5LfPvDsBpmqmwi/gXe3XZs2OtRKRiZ/7AHLK84CXzCkze+1mNumYY7ZfS0UkM9dCfd4bbBzWOdZrTHPWzg2HK6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714600; c=relaxed/simple;
	bh=wKCcjg7V38yNJSxNvKlPTvzUH9ktGKzjHXNwJFYNyOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FEoWS1eUKHj/MS7nSYDWoc4NpyDUFN0JCdOMNOJrplwpDA+7SHN6lc2dpQ5FY3C0ptOfmrJYTnunDUBQzLIhsBrTW3IU/Mtj94GIP7GNJmxrpUhXD0Y6tXosp127VKWEVCQ4X6unayClv2yE4euscVeNskamwu6LFk07AbY6iTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u46jb9O/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u46jb9O/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428B9C4CEEA;
	Mon, 23 Jun 2025 21:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714600;
	bh=wKCcjg7V38yNJSxNvKlPTvzUH9ktGKzjHXNwJFYNyOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u46jb9O/6wiq8G5sK7ZOOBt5FV2kl0kg+1YvupmddUcypL3EaUJmiYvrkPCRgf2g7
	 3knaxuWNMl8c2qEGsBAKKvY+7jzylxFWyihNaiCsQ5IFtiFrr5SpAoTNtvT0fZIrzP
	 qUUT4ALMZXR1LeydzrU74uQbqRlO78N2dc4cL7zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 404/592] wifi: ath12k: fix failed to set mhi state error during reboot with hardware grouping
Date: Mon, 23 Jun 2025 15:06:02 +0200
Message-ID: <20250623130710.048900721@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>

[ Upstream commit dce7aec6b1f74b0a46b901ab8de1f7bd0515f733 ]

With hardware grouping, during reboot, whenever a device is removed, it
powers down itself and all its partner devices in the same group. Now this
is done by all devices and hence there is multiple power down for devices
and hence the following error messages can be seen:

ath12k_pci 0002:01:00.0: failed to set mhi state POWER_OFF(3) in current mhi state (0x0)
ath12k_pci 0002:01:00.0: failed to set mhi state: POWER_OFF(3)
ath12k_pci 0002:01:00.0: failed to set mhi state DEINIT(1) in current mhi state (0x0)
ath12k_pci 0002:01:00.0: failed to set mhi state: DEINIT(1)
ath12k_pci 0003:01:00.0: failed to set mhi state POWER_OFF(3) in current mhi state (0x0)
ath12k_pci 0003:01:00.0: failed to set mhi state: POWER_OFF(3)
ath12k_pci 0003:01:00.0: failed to set mhi state DEINIT(1) in current mhi state (0x0)
ath12k_pci 0003:01:00.0: failed to set mhi state: DEINIT(1)
ath12k_pci 0004:01:00.0: failed to set mhi state POWER_OFF(3) in current mhi state (0x0)
ath12k_pci 0004:01:00.0: failed to set mhi state: POWER_OFF(3)

To prevent this, check if the ATH12K_PCI_FLAG_INIT_DONE flag is already
set before powering down. If it is set, it indicates that another partner
device has already performed the power down, and this device can skip this
step.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250408-fix_reboot_issues_with_hw_grouping-v4-3-95e7bf048595@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 2e7d302ace679..9289910887217 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -1491,6 +1491,9 @@ void ath12k_pci_power_down(struct ath12k_base *ab, bool is_suspend)
 {
 	struct ath12k_pci *ab_pci = ath12k_pci_priv(ab);
 
+	if (!test_bit(ATH12K_PCI_FLAG_INIT_DONE, &ab_pci->flags))
+		return;
+
 	/* restore aspm in case firmware bootup fails */
 	ath12k_pci_aspm_restore(ab_pci);
 
-- 
2.39.5



