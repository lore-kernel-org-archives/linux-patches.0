Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6496D32A81D;
	Tue,  2 Sep 2025 13:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820822; cv=none; b=ZxAaAhoXNuNU7UpZ0TQHgNCAw1Fp5yhnu/3A59S5uF27JpYCQ3a840NnwBO9PiLOJIoWz1f+v/Zoocn6YjsN6dB028fyI83Ql2c4dAMNAEObWY6D7PX1zM7E8EbPOGSA/C29UNwfAjF4RDiBtbCdL+r9NSHFP6tHu2PSvSjQeZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820822; c=relaxed/simple;
	bh=z6vOHKqPgIixlcN637GX3TaKXDXa2jVNJvBVfZ8vWXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XN0dSVHBRs4fITKLGu1CKjcVTMZDGAr20sVqlTTyVSaWyVUkLHkRJpdtQpHf5zKDZaqa7NV22nV4/xgicTbn3DZGhOd7X0MRzNZemikMAjIyGAC49IATL0t03eOsVZO3UQCdXrR0M0M9TlSREY0/L2TwbZYZ+jBGaKXTIFEIT3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIfxUDBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIfxUDBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93037C4CEED;
	Tue,  2 Sep 2025 13:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820822;
	bh=z6vOHKqPgIixlcN637GX3TaKXDXa2jVNJvBVfZ8vWXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIfxUDBQUa2uPiu6a+cCFDReMXrH6666rbMunPyPBLLOhQVw/B/vMeWdHDP6c1b73
	 s2W/3C4WtYLVK1Rh2Ky4amVT6ZMAckVsZhm3gkqlb67QH0Jv0twsmt3W95iXybJsRi
	 ZOBoe9NiSGZjIOl1vjQC/p3Gainp8+5C3qczZb+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/23] Bluetooth: hci_event: Detect if HCI_EV_NUM_COMP_PKTS is unbalanced
Date: Tue,  2 Sep 2025 15:21:53 +0200
Message-ID: <20250902131925.016957354@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 15bf2c6391bafb14a3020d06ec0761bce0803463 ]

This attempts to detect if HCI_EV_NUM_COMP_PKTS contain an unbalanced
(more than currently considered outstanding) number of packets otherwise
it could cause the hcon->sent to underflow and loop around breaking the
tracking of the outstanding packets pending acknowledgment.

Fixes: f42809185896 ("Bluetooth: Simplify num_comp_pkts_evt function")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 33b025a52b83a..4e8911501255d 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3681,7 +3681,17 @@ static void hci_num_comp_pkts_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		if (!conn)
 			continue;
 
-		conn->sent -= count;
+		/* Check if there is really enough packets outstanding before
+		 * attempting to decrease the sent counter otherwise it could
+		 * underflow..
+		 */
+		if (conn->sent >= count) {
+			conn->sent -= count;
+		} else {
+			bt_dev_warn(hdev, "hcon %p sent %u < count %u",
+				    conn, conn->sent, count);
+			conn->sent = 0;
+		}
 
 		switch (conn->type) {
 		case ACL_LINK:
-- 
2.50.1



