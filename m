Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D63230649C;
	Tue,  2 Sep 2025 13:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820185; cv=none; b=F7zoeYQ/rwgpO/6hccdqGcDdJTm30fFgiqm2vhZuPiHrgdmXN3XFtLfW5I+HKgpd4lMoUTKSxCfNtP+XF6ocnkJg+so4bMK9jDebKYpZHRTa3kOcQESzlzZ/W+w/nvOzh85pqZrXO5hyV9qrMS+bx1lMgsyhA7L53lm72QliJrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820185; c=relaxed/simple;
	bh=XSp1b336UpcXl6PFVoFU7npw/CZyXgUf4IRGWtAozrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6ITa3lZUH8mtOtrmMt5MpddT4bnRrv2Vnthwbz06XELjTefPB5Ga3eimHe7JSP12CPQuTfGIT6sZTF0QyfRbiR0DQ+b55wEU2xAphvKyKfl4rgPTOCVCl8jv90gxXhsHRMx6Udc1ZRPnhM9ZuXybzFISFCgxlFucRADvv2U66A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXfhI99A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXfhI99A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7BEC4AF09;
	Tue,  2 Sep 2025 13:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820185;
	bh=XSp1b336UpcXl6PFVoFU7npw/CZyXgUf4IRGWtAozrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXfhI99AMBZGMtiSzuuRlHGtFvWBpyfWBcA0xGtj3ryxDFzXQQxrpZVWqeIXGVbXU
	 6hBM9SlRDm6cTf0bG/Vj//RkdHP6t6guAH9n7+511vE29VNK+44ZBcj6ASbDgojpA6
	 GGiD2ucHSue4t7HaLsgJmVHy/ilHWFsxGF9Dq/Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 24/75] Bluetooth: hci_event: Detect if HCI_EV_NUM_COMP_PKTS is unbalanced
Date: Tue,  2 Sep 2025 15:20:36 +0200
Message-ID: <20250902131936.066436065@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a07ad1c99a4b0..5eed23b8d6c33 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4392,7 +4392,17 @@ static void hci_num_comp_pkts_evt(struct hci_dev *hdev, void *data,
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



