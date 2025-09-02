Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8848A2DAFCA;
	Tue,  2 Sep 2025 13:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820004; cv=none; b=LS9oyr6/Il52mxaxQaHbPAlhJgbn9VUC0CRl3kTfkecRQmYNuteZp29tticN+87Yz+8GJhmOeve8Y92SkTv9ALwXDezqiPvwwhCfU+EWKyUodsHss4nYG1DEdIE0bH89UCY7GUgbx8YkRjvSNdu+TJa068VI/ih31G5qmrDtUDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820004; c=relaxed/simple;
	bh=RFXJnHqxFWvb7l7Vp29P2OWyHevfXd8xNralUAbyL+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGYpJcck6Mpizr69sqtrcTD1fM3daQicgswYkYkaVgE58RWiKakSCtFt6M1FprmjiJ8HEmnVRIL0noFsR4THn9NZ8dGZJr5k6X5b39LH3s9hF0wYcbcThDy+V+us5hVXtcyTu89gKVGtuScqZghtILjv3THU/hFKZWiSoZHGpq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQHSan+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQHSan+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED18C4CEED;
	Tue,  2 Sep 2025 13:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820004;
	bh=RFXJnHqxFWvb7l7Vp29P2OWyHevfXd8xNralUAbyL+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQHSan+5SZnqgYFZ23eOq5yZDQGwIBUnXl5rii98BSOjix/3pmcwtAwYbVgHmIPQL
	 Y8uRwnDGiugp6bWn8SkQiTU/Wg6gZNqLfKpJwEDkyTaRcCq4ixFTC9H6cIeZFvOqvs
	 BXPU/JgUyce/ePioZay+oIfqrm+dvGKh8KyVCsYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 31/95] Bluetooth: hci_event: Detect if HCI_EV_NUM_COMP_PKTS is unbalanced
Date: Tue,  2 Sep 2025 15:20:07 +0200
Message-ID: <20250902131940.806850779@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b8213bfa0a674..262ff30261d67 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4395,7 +4395,17 @@ static void hci_num_comp_pkts_evt(struct hci_dev *hdev, void *data,
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



