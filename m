Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B381F8905;
	Tue,  3 Dec 2024 15:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241148; cv=none; b=VQSRHnGjEQcb1/kvXOGmMU/bHH7O26Qi01IrE36wM1XGd8KRQYwOVUJdKr3f3TZB/13Iod/UxJQbF19YMdPuIf5mtEUhwpdFRXaoHN7XAct+yV+UNyiVebyS72m9wi7SA5Pwkbk0r8vmdU/OKnQZD+NmVt7/00alSsqkXGSGwsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241148; c=relaxed/simple;
	bh=KHLYNXih0jjZNOLMFby5rPpqJlBEBpbhu71JJNqj1X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImWthH62PeTWL6QIJsaUDkJlbzPf1LlfAnSTqvoHEXRDVqTwsS3DP2fUf7TK9h9xFveMcVXw5pRurBrZJ+azjt3QIY82MVql0yP429Fpw3U4QX5lGvoAGrObCzuGX+9QlBeiEoqha2O+zrGfpxij1tBkjfAQO9szztezDSNq6Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbm0CDae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbm0CDae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8DAC4CECF;
	Tue,  3 Dec 2024 15:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241148;
	bh=KHLYNXih0jjZNOLMFby5rPpqJlBEBpbhu71JJNqj1X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbm0CDaeVT8D2MyT5zsQ9bYh2VyCTiC/2lDDoR8wI6nvoBQxXFOI2QrjGlqsNlgdH
	 IOEAAzHQT7F6RwGWhe4URmnOAniRYRV4/KEvJA+zWWF+KGttp3xkTip4MGkwRUmPUc
	 l61BEzmhia8kNSjBF+6Nfcjnd17vD4DZukv31thQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 338/826] Bluetooth: btintel: Do no pass vendor events to stack
Date: Tue,  3 Dec 2024 15:41:05 +0100
Message-ID: <20241203144756.947407127@linuxfoundation.org>
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

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 510e8380b0382ee3b070748656b00f83c9a5bf80 ]

During firmware download, vendor specific events like boot up and
secure send result are generated. These events can be safely processed at
the driver level. Passing on these events to stack prints unnecessary
log as below.

    Bluetooth: hci0: Malformed MSFT vendor event: 0x02

Fixes: 3368aa357f3b ("Bluetooth: msft: Handle MSFT Monitor Device Event")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c      | 6 ++++--
 drivers/bluetooth/btintel_pcie.c | 9 ++++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 4b17202075b00..645047fb92fd2 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -3368,7 +3368,8 @@ int btintel_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 				 * indicating that the bootup completed.
 				 */
 				btintel_bootup(hdev, ptr, len);
-				break;
+				kfree_skb(skb);
+				return 0;
 			case 0x06:
 				/* When the firmware loading completes the
 				 * device sends out a vendor specific event
@@ -3376,7 +3377,8 @@ int btintel_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 				 * loading.
 				 */
 				btintel_secure_send_result(hdev, ptr, len);
-				break;
+				kfree_skb(skb);
+				return 0;
 			}
 		}
 
diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 16ee962d40861..8bd663f4bac1b 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -536,7 +536,8 @@ static int btintel_pcie_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 				if (btintel_pcie_in_op(data)) {
 					btintel_pcie_wr_sleep_cntrl(data, BTINTEL_PCIE_STATE_D0);
 					data->alive_intr_ctxt = BTINTEL_PCIE_INTEL_HCI_RESET2;
-					break;
+					kfree_skb(skb);
+					return 0;
 				}
 
 				if (btintel_pcie_in_iml(data)) {
@@ -553,7 +554,8 @@ static int btintel_pcie_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 						btintel_wake_up_flag(data->hdev,
 								     INTEL_WAIT_FOR_D0);
 				}
-				break;
+				kfree_skb(skb);
+				return 0;
 			case 0x06:
 				/* When the firmware loading completes the
 				 * device sends out a vendor specific event
@@ -561,7 +563,8 @@ static int btintel_pcie_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 				 * loading.
 				 */
 				btintel_secure_send_result(hdev, ptr, len);
-				break;
+				kfree_skb(skb);
+				return 0;
 			}
 		}
 
-- 
2.43.0



