Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086E41AB6EF;
	Wed, 20 Nov 2024 12:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107574; cv=none; b=leAxWZH/MBE3Bmj/57ZckkIxMtsrZeNCWv67hHDTyu61s3UisJhaDV83soPXPQk5Ejk4GSXh1WV60vwYNCn/Jw7xO+ZiMEH00pOUt5wAXuFmPfGRwJcyzHSgUWj/6/S0P0EnmVaG4rcwPrEUd7/X4vKsDyfRM/9JHtZAWNmTkf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107574; c=relaxed/simple;
	bh=O/jUQIlIdxOmEx4XxpABrgG4OoqkKUDrGeBKsMDbt9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G470jxjBXNsZZD0z2wvAQHkEXfNNAWjKwkKo3pc/dOrl8He+SEsyWoZ6eCbxTalUTgvSCa4XZ6/4Wiuohg9hb1sQia1gPoXp5Lh+EnqRYLG4NMKbGgu17J4snQM+yj8Gv7e7uBXbYVI88Xd5mDO3E5MOoqZmX/KIGJOu6SPmI9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3W4EuY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3W4EuY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1092C4CECD;
	Wed, 20 Nov 2024 12:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107573;
	bh=O/jUQIlIdxOmEx4XxpABrgG4OoqkKUDrGeBKsMDbt9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3W4EuY4K93GQ3tekPPCuHR1L/r6vVmAVQqlOkaWorrZiNsBHokNlYikW7n4qKzqU
	 YhR1EFYEsqL4v3Bp02FWo/iirMxedysnUyYh9PoLNfAowJzjYEV+1hczRc9Y52kojB
	 M15cdx5g4qk1NuhKwbdlcc8EB8LeQIviDQ4Jaim4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 14/82] Bluetooth: btintel: Direct exception event to bluetooth stack
Date: Wed, 20 Nov 2024 13:56:24 +0100
Message-ID: <20241120125629.936674239@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit d5359a7f583ab9b7706915213b54deac065bcb81 ]

Have exception event part of HCI traces which helps for debug.

snoop traces:
> HCI Event: Vendor (0xff) plen 79
        Vendor Prefix (0x8780)
      Intel Extended Telemetry (0x03)
        Unknown extended telemetry event type (0xde)
        01 01 de
        Unknown extended subevent 0x07
        01 01 de 07 01 de 06 1c ef be ad de ef be ad de
        ef be ad de ef be ad de ef be ad de ef be ad de
        ef be ad de 05 14 ef be ad de ef be ad de ef be
        ad de ef be ad de ef be ad de 43 10 ef be ad de
        ef be ad de ef be ad de ef be ad de

Fixes: af395330abed ("Bluetooth: btintel: Add Intel devcoredump support")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index a936219aebb81..3773cd9d998d5 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2928,13 +2928,12 @@ static int btintel_diagnostics(struct hci_dev *hdev, struct sk_buff *skb)
 	case INTEL_TLV_TEST_EXCEPTION:
 		/* Generate devcoredump from exception */
 		if (!hci_devcd_init(hdev, skb->len)) {
-			hci_devcd_append(hdev, skb);
+			hci_devcd_append(hdev, skb_clone(skb, GFP_ATOMIC));
 			hci_devcd_complete(hdev);
 		} else {
 			bt_dev_err(hdev, "Failed to generate devcoredump");
-			kfree_skb(skb);
 		}
-		return 0;
+	break;
 	default:
 		bt_dev_err(hdev, "Invalid exception type %02X", tlv->val[0]);
 	}
-- 
2.43.0



