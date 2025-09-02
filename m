Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3CF26D4E2;
	Tue,  2 Sep 2025 13:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820621; cv=none; b=LzG9UqnH2SQWn7pdo/p9NetjXlhfqzv501AOcju3ne+A+PGYaTD21xkSSOjYC2xUAodrTcA7fnA6Lyo91EI8bDrm2/R6Ow05B21GJDScJ7g9q6+GtG/W7vJKqIHKEGb7iARWjL0qHrG5B19pVOxfQMR3C5x2J0HiCSU47xLw940=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820621; c=relaxed/simple;
	bh=iM23AU18avkXi4ygalccvPrOq6wiuDblrf8LlALFR+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRLdFYBl2Vi/q4EAwnZXH4WrRZKOXtta8PwOru08EBquN5Xt6WFp6KqEMm5wfpHV18p94h0+JyezuYazppHx9jS9PrqNV/PAVFRPk08TmahtuxG5ftbzdgQ0DyYr0XMfx4bb59MzopuymSJIkMkNa1oxU+YER/oZGn2z4NyTFhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DarkE+UU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DarkE+UU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37E3C4CEED;
	Tue,  2 Sep 2025 13:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820621;
	bh=iM23AU18avkXi4ygalccvPrOq6wiuDblrf8LlALFR+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DarkE+UU/K3iNlHTBo9/0RoiFEpR8NdEZe351ShfSlRqLGiLYUxEdllGb9dZuxyxY
	 Bioe53SdJWYcuxOUTza6tzTdvykI3eW78LY6uo65315r0jJhhAnSraqGph4GeERVbZ
	 N6UU3LqlND74BQVPEiHx/6Nc2Myc2hYMcn2V1Hnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/33] Bluetooth: hci_event: Detect if HCI_EV_NUM_COMP_PKTS is unbalanced
Date: Tue,  2 Sep 2025 15:21:29 +0200
Message-ID: <20250902131927.492649287@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 84b07b27b3cf4..cfdaaecf78600 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3919,7 +3919,17 @@ static void hci_num_comp_pkts_evt(struct hci_dev *hdev, struct sk_buff *skb)
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



