Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B48F1A4F12;
	Wed, 20 Nov 2024 12:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107498; cv=none; b=oInKEfXGYR1e5EBpHJHAOOHj4Zk+RAo96LxJ2BCD3vJoojhvlIUDNfF7fggDo5gWswfk/aFVwJLMiXgbc5ENtKrUh30dnAkBiYp4Sz0ABpb0R0boc5mQfPTbBBBJkSbeCVz0usGgZt7qvf+vdEY7vUSxW3W0UxouhpCILuu63EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107498; c=relaxed/simple;
	bh=nbmvPW6fFrI5A2ZrqFOUQBZpqF4opBvhh8li251wS00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwI+p5aoeUZR8rlWczRyo07YJ9TT93YNTmBPSmHPRLswwKr3G7BLINggoph38SyFUo2wUUiayvI5MuMg9hUSqfQB209vkLAYLNsQz68gzVWmN2F2vSj3Cr32xpijbahqxKnldjBt4D3fxjU8X5Pf5Vriv2OcCzi5trZRRjmXLT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDQT071P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDQT071P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E65C4CECD;
	Wed, 20 Nov 2024 12:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107498;
	bh=nbmvPW6fFrI5A2ZrqFOUQBZpqF4opBvhh8li251wS00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDQT071PJCjKZyy2bJffag4+DK0HQxTuCX4rYpVe8Sej3wnavjnDY+k7cUTz1mVVS
	 9plVVJ6AUFxeLT2jUXWzCM6QKy3P6nzbTySXEmTktls/GsHA1m2d8XHB4JDYGFrQ2i
	 KdVFmub2S34ib31rVWT0m/z6MmCx0nZWcxz0n7wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 021/107] Bluetooth: btintel: Direct exception event to bluetooth stack
Date: Wed, 20 Nov 2024 13:55:56 +0100
Message-ID: <20241120125630.154689631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 1ccbb51575153..24d2f4f37d0fd 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -3288,13 +3288,12 @@ static int btintel_diagnostics(struct hci_dev *hdev, struct sk_buff *skb)
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



