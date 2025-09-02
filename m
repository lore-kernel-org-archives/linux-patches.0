Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23935261593;
	Tue,  2 Sep 2025 13:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820647; cv=none; b=f0U5f/PQ/IpT4HP+Wu8flZvv6Av5tk3DEoaEE1IA9e3SaYbvTrWkSkkufIvZr3dpKVxI94RUjzir4oTtvMI9tzHK9WGKqDibrjKUtEUX3H0yET4G1TWkelLmy2aTvkcMrO+urJc7rVmbWY5TJc7RllcmBe/xSgUzIjYVQGpGMdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820647; c=relaxed/simple;
	bh=3UIQddMcavh455dVvXZCdvzPepsLpJOpcF9PY2IdCA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lum166NuPM0eT5LU1YUOVxKfxnXL6ch4rxk3F8j5Gsw8YIPwME0l+u7iHiirNUba+Q6scNDEKyejPpcULQ1cnC4dCPqzknjyqZuPXln0O2YNsjZgGC/Xsc7zIAEh2QcMJ5HFBLYqkr7pfPDcGz+d2lzLKeo+2Rsq+Wf2lhfQjnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoNv25vo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoNv25vo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A95DC4CEED;
	Tue,  2 Sep 2025 13:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820647;
	bh=3UIQddMcavh455dVvXZCdvzPepsLpJOpcF9PY2IdCA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VoNv25vozkVPy1ovayoW7QVeBKqrf2npH4dLASTLZXbUI+ofZy1p+Wdm7kgZjkncq
	 5C8HryzdCNQ3cgLeWIAZkvl7cdtrrVfmxxPCo6g/AZ0Md1DoTIyeiNMMx2de1MBYgJ
	 766k/xX+7PH6jeiNmZhYrbJrgyF/FM2mfjbzXnFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 10/34] Bluetooth: hci_event: Detect if HCI_EV_NUM_COMP_PKTS is unbalanced
Date: Tue,  2 Sep 2025 15:21:36 +0200
Message-ID: <20250902131927.027437754@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7f26c1aab9a06..c6dbb4aebfbc1 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3811,7 +3811,17 @@ static void hci_num_comp_pkts_evt(struct hci_dev *hdev, struct sk_buff *skb)
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



