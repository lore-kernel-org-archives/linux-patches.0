Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096F51F76DE;
	Tue,  3 Dec 2024 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238670; cv=none; b=OsxjhKdFSx1TXPwuitMN5Ide6gyVmXB7VrONigmOP9hroLAuOnuLfh43scjrDRcAnSgmZCLQwqSvBjm8Sxj9FAITpZwp3WU8bX5ik+X0RaQefueAGXo0A2UjBhwC8g5jJrnBnuHZZrpSa2UmTr0JO2OYaKzaoDuKJRiFrNpjeoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238670; c=relaxed/simple;
	bh=lzh/11UAeeXHxPjUa05aGO1vI8DXJpRxH/CGXSpLUS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVjT7wlEDj4li+Cv384rCII7m1VtE+CiGCH4wzWUFdWhSY4H6TJczlO6as8fi816Dzuhp25xlkhiEBJ+Hrwje5X4rjqG1c+ZmVNj4L+ydDD4NhTULpgVw7yTXEyXxXPYppEftBGubstClNjfj9Kn05o91uh7t1E5DvME4atG49U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aypDGY89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aypDGY89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830B3C4CECF;
	Tue,  3 Dec 2024 15:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238669;
	bh=lzh/11UAeeXHxPjUa05aGO1vI8DXJpRxH/CGXSpLUS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aypDGY89I7uy9TXEUdityLn1aZMXFUxvlAgpKVjocghzI8o1Z6OkVAaUyRpgplqwp
	 RdvKstjlmuw6AWLbA4MdaZ+owktXvFR9Ln6q35/1ATqXbLQ/QQVZKSsLS8GTLwr9Y/
	 m2QaJ4FgV1xPcSU5MghX8mzCtJAktbElk5Z0GUDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 357/817] Bluetooth: btintel: Do no pass vendor events to stack
Date: Tue,  3 Dec 2024 15:38:49 +0100
Message-ID: <20241203144009.768012306@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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
index 69e4650796f05..deb8729f73a91 100644
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
index aab68e3164d36..d239175718624 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -535,7 +535,8 @@ static int btintel_pcie_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 				if (btintel_pcie_in_op(data)) {
 					btintel_pcie_wr_sleep_cntrl(data, BTINTEL_PCIE_STATE_D0);
 					data->alive_intr_ctxt = BTINTEL_PCIE_INTEL_HCI_RESET2;
-					break;
+					kfree_skb(skb);
+					return 0;
 				}
 
 				if (btintel_pcie_in_iml(data)) {
@@ -552,7 +553,8 @@ static int btintel_pcie_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 						btintel_wake_up_flag(data->hdev,
 								     INTEL_WAIT_FOR_D0);
 				}
-				break;
+				kfree_skb(skb);
+				return 0;
 			case 0x06:
 				/* When the firmware loading completes the
 				 * device sends out a vendor specific event
@@ -560,7 +562,8 @@ static int btintel_pcie_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
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



