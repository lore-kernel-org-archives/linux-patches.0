Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCD2341ACA;
	Tue, 11 Nov 2025 01:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825106; cv=none; b=N3hQvEevYjpoJZtUwCQr7sBXqsIl1vYS5rY6bLWE5V3aWhxruoKwxCZD1av5ajp55su2EJ/lo2D0ep4/2p5VBD6BmzcSTnc2n9rlGQVVEQ56+PEIRd1ncOYh1D+tLetbXQLJi3qClKSupqHmM/4bSYMwHBbB5Pjd0JH+gtmTwVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825106; c=relaxed/simple;
	bh=C2bK3N1IfBiRwB3c6jsPAjNHW0bBCHcg5ohGKIBkq/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmEVIdfSsKiiBJ9h2mBf9uxtoQVxTWgHbnYPSbFtnOOdbQzl9ACDNV0X+/6i57JkohtKCTslsAYCnwRNGGfWu7s7UZjlLcuQoEdoCfwrjLDASnMYzBSrpgF3x7DNcNcoJDQWUCrfXhucBIYMoP18ZZZSiZWSz18wSHQNHXsOF/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2XLDFpxO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2XLDFpxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4399C16AAE;
	Tue, 11 Nov 2025 01:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825106;
	bh=C2bK3N1IfBiRwB3c6jsPAjNHW0bBCHcg5ohGKIBkq/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2XLDFpxOxx7PJCPvsTCOR174jH9ILlpZJzdib0KpmigXBNdaJKaALwmX0oXm09bqZ
	 50AHawQ4EtPfpOwpP7ExNz2YEF6g8nQCdtV6nqaEKtuLsb3UuciuldWezGSu1NlGG8
	 0ucfwMN+179TRvPVvzNfsys895yL/hNkVmvvo6Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 661/849] Bluetooth: btintel_pcie: Define hdev->wakeup() callback
Date: Tue, 11 Nov 2025 09:43:51 +0900
Message-ID: <20251111004552.406553810@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

[ Upstream commit 3e94262921990e2884ff7a49064c12fb6d3a0733 ]

Implement hdev->wakeup() callback to support Wake On BT feature.

Test steps:
1. echo enabled > /sys/bus/pci/devices/0000:00:14.7/power/wakeup
2. connect bluetooth hid device
3. put the system to suspend - rtcwake -m mem -s 300
4. press any key on hid to wake up the system

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index c9fb824fb8e1d..becb471ffd421 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -2342,6 +2342,13 @@ static void btintel_pcie_hw_error(struct hci_dev *hdev, u8 code)
 	btintel_pcie_reset(hdev);
 }
 
+static bool btintel_pcie_wakeup(struct hci_dev *hdev)
+{
+	struct btintel_pcie_data *data = hci_get_drvdata(hdev);
+
+	return device_may_wakeup(&data->pdev->dev);
+}
+
 static int btintel_pcie_setup_hdev(struct btintel_pcie_data *data)
 {
 	int err;
@@ -2367,6 +2374,7 @@ static int btintel_pcie_setup_hdev(struct btintel_pcie_data *data)
 	hdev->set_diag = btintel_set_diag;
 	hdev->set_bdaddr = btintel_set_bdaddr;
 	hdev->reset = btintel_pcie_reset;
+	hdev->wakeup = btintel_pcie_wakeup;
 
 	err = hci_register_dev(hdev);
 	if (err < 0) {
-- 
2.51.0



