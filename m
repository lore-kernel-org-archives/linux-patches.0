Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A1F1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CCBC433F0;
	Wed, 28 Dec 2022 15:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240417;
	bh=pY18yMiSby5mIloYDnTnV/WFJam7OwG4aqVoN7NM+KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+0v+DF74rD/OAN9Wv5ZCZB7vsPSk9Px6sH8hPMCg9kYFsNtKRyQkbPgssBIcVNFe
	 AIbwILN0tkJLXWClabUqHUhKmmVUR6edSkD4OrtvKf9D2Mwzzp3wJkiZfOg4Vhp4eA
	 La/svR5mpRx5P6aNTUTt2jrWxfSUAtzg7TAA9CSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang ShaoBo <bobo.shaobowang@huawei.com>,
	Tedd Ho-Jeong An <tedd.an@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 347/731] Bluetooth: btintel: Fix missing free skb in btintel_setup_combined()
Date: Wed, 28 Dec 2022 15:37:34 +0100
Message-Id: <20221228144306.623509479@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit cee50ce899de415baf4da3ed38b7d4f13c3170d1 ]

skb allocated by __hci_cmd_sync would not be used whether in checking
for supported iBT hardware variants or after, we should free it in all
error branches, this patch makes the case read version failed or default
error case free skb before return.

Fixes: c86c7285bb08 ("Bluetooth: btintel: Fix the legacy bootloader returns tlv based version")
Fixes: 019a1caa7fd2 ("Bluetooth: btintel: Refactoring setup routine for bootloader devices")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Reviewed-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index de3d851d85e7..d707aa63e944 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2353,7 +2353,7 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 		 */
 		err = btintel_read_version(hdev, &ver);
 		if (err)
-			return err;
+			break;
 
 		/* Apply the device specific HCI quirks
 		 *
@@ -2394,7 +2394,8 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 	default:
 		bt_dev_err(hdev, "Unsupported Intel hw variant (%u)",
 			   INTEL_HW_VARIANT(ver_tlv.cnvi_bt));
-		return -EINVAL;
+		err = -EINVAL;
+		break;
 	}
 
 exit_error:
-- 
2.35.1



