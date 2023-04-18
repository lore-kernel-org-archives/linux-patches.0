Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FF02572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08006C433D2;
	Tue, 18 Apr 2023 12:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822426;
	bh=5uplASErk8oGr242/E0GRk+7ABYv4I3xwKVE8UJ9AMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCpmS/6FPT5e6d23Yj8ivnCNKFcaIgZyV6wTwDarHsZwjL6xj5Woy6NmzKX7ycdJF
	 8LW4MLwyTheRlqaNTtJNiz0NYBpjgU02Os3vl0nwWBM87S3e9xnNmzO90PJHWeeA4S
	 RGKv6aHlguufr+0CQRyIeTMwfIr0uAhm6S2O6/yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juraj Pecigos <kernel@juraj.dev>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 138/139] nvme-pci: mark Lexar NM760 as IGNORE_DEV_SUBNQN
Date: Tue, 18 Apr 2023 14:23:23 +0200
Message-Id: <20230418120319.123041081@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Juraj Pecigos <kernel@juraj.dev>

[ Upstream commit 1231363aec86704a6b0467a12e3ca7bdf890e01d ]

A system with more than one of these SSDs will only have one usable.
The kernel fails to detect more than one nvme device due to duplicate
cntlids.

before:
[    9.395229] nvme 0000:01:00.0: platform quirk: setting simple suspend
[    9.395262] nvme nvme0: pci function 0000:01:00.0
[    9.395282] nvme 0000:03:00.0: platform quirk: setting simple suspend
[    9.395305] nvme nvme1: pci function 0000:03:00.0
[    9.409873] nvme nvme0: Duplicate cntlid 1 with nvme1, subsys nqn.2022-07.com.siliconmotion:nvm-subsystem-sn-                    , rejecting
[    9.409982] nvme nvme0: Removing after probe failure status: -22
[    9.427487] nvme nvme1: allocated 64 MiB host memory buffer.
[    9.445088] nvme nvme1: 16/0/0 default/read/poll queues
[    9.449898] nvme nvme1: Ignoring bogus Namespace Identifiers

after:
[    1.161890] nvme 0000:01:00.0: platform quirk: setting simple suspend
[    1.162660] nvme nvme0: pci function 0000:01:00.0
[    1.162684] nvme 0000:03:00.0: platform quirk: setting simple suspend
[    1.162707] nvme nvme1: pci function 0000:03:00.0
[    1.191354] nvme nvme0: allocated 64 MiB host memory buffer.
[    1.193378] nvme nvme1: allocated 64 MiB host memory buffer.
[    1.211044] nvme nvme1: 16/0/0 default/read/poll queues
[    1.211080] nvme nvme0: 16/0/0 default/read/poll queues
[    1.216145] nvme nvme0: Ignoring bogus Namespace Identifiers
[    1.216261] nvme nvme1: Ignoring bogus Namespace Identifiers

Adding the NVME_QUIRK_IGNORE_DEV_SUBNQN quirk to resolves the issue.

Signed-off-by: Juraj Pecigos <kernel@juraj.dev>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 74391b3e6985 ("nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index ea3f0806783a3..2e3fae6e1fb30 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3494,7 +3494,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x1d97, 0x1d97), /* Lexar NM620 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1d97, 0x2269), /* Lexar NM760 */
-		.driver_data = NVME_QUIRK_BOGUS_NID, },
+		.driver_data = NVME_QUIRK_BOGUS_NID |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.39.2



