Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3654A264614;
	Tue,  8 Apr 2025 11:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111026; cv=none; b=HI5iT5RBFSixMfb1j7Ovc/OOEf/RnSd/6x3BE4j+zio3MBX1ebXm2b6wrfp5CdnGDkQSqQOOEgDaB9lWwpDie5/1aBTjDUr8HKcN8PNpMf9UM/kptGZreezdf1FzxEH4FYmFzt8wX9ao6TEODh8KxaKh+NBvFq00MuYeNfcJ7s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111026; c=relaxed/simple;
	bh=irrXn9Y36iKYbspbcIVr/RYa/6fU53pXePoAmHa6Lwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCRws05Vh4A9j7oyOQBPUE0wlwfTu0PC8Vj6QUreY7BehLmfOzAPc6MmW2rP63CLUerYSe0zJDmubytnI9SHrsaE+azo1/puWk3B6v3G+Ls6Q355ECvfjCezRn9gQzGGwGHMzsU3syIn7QbfEEIHBuR/YNYkegaled8T6tqhbMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJ5gn0s5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJ5gn0s5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD44C4CEE5;
	Tue,  8 Apr 2025 11:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111026;
	bh=irrXn9Y36iKYbspbcIVr/RYa/6fU53pXePoAmHa6Lwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJ5gn0s5uqaBBuC4niAbsKSURBPVhD09C3KkdOuTDaRhGYyVFzfigoo+oDBoOOBbg
	 k4to9r/SG+fZqR0HmEb48IB5+9olFNczfL8Vtu82N0Ku9fil8X5Z4R3WkENK10XeFq
	 fBSVYW8P5D9tqQzJ6xs39kC4OHFRs/0c2TCoeDNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Nishiyama <nishiyama.pedro@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 255/731] Bluetooth: btusb: Fix regression in the initialization of fake Bluetooth controllers
Date: Tue,  8 Apr 2025 12:42:32 +0200
Message-ID: <20250408104920.215030166@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Nishiyama <nishiyama.pedro@gmail.com>

[ Upstream commit 1f04b0e5e3b90b30f3ae7bee7e3d42a55fa91d5f ]

Set HCI_READ_VOICE_SETTING and HCI_READ_PAGE_SCAN_TYPE as broken.

Once the min/max length of the commands began to be asserted, these fake
controllers can no longer be initialized because they return a smaller
report for these commands.

This affects various fake controllers reusing the 0A12:0001 VID/PID.

Fixes: c8992cffbe74 ("Bluetooth: hci_event: Use of a function table to handle Command Complete")
Signed-off-by: Pedro Nishiyama <nishiyama.pedro@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index a0fc465458b2f..699ff21d97675 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2477,6 +2477,8 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 		set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL, &hdev->quirks);
 		set_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_READ_VOICE_SETTING, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_READ_PAGE_SCAN_TYPE, &hdev->quirks);
 
 		/* Clear the reset quirk since this is not an actual
 		 * early Bluetooth 1.1 device from CSR.
-- 
2.39.5



