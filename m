Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A2B248F49;
	Mon, 12 May 2025 17:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072765; cv=none; b=lXUy9qlzUFdR4AXJ/XKde4BhqVOX60rhh0F2wi7vrqM7qut7EOhXrLExYW//z5KHecZlLE2+pNVQtXdsbqsZ/OaZAPLD6xDiFzqPsSIO9byw0s3Vcw368e7Dw3oV+Li0ps18jdmCaTSxuIuhJxgdYV1+2UkdH6wsU/Xd54jSJhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072765; c=relaxed/simple;
	bh=OSyxUm3ZnKdf6YOyNpyQ7erIpWzX9/dcJRJInFkReBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTKG1E4u18Y5iMJR8qmVZ4yKyCNqQgc6044XI9E4BuV1QBz5lyZx/dgtx5JjvMlOZ0KkzroUmSqmnG/l5Y8TsE0cysR7kyRHQlJkhu89V+/dW2gBC4bZtmkYryKk2WGGchnB4YURtHt0i4479ixK/DQNsftmlDCxxDNMayBOgLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yg3dpJ+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yg3dpJ+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58763C4CEE7;
	Mon, 12 May 2025 17:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072764;
	bh=OSyxUm3ZnKdf6YOyNpyQ7erIpWzX9/dcJRJInFkReBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yg3dpJ+51K8qtD4x5oROyi2aZeMuquMifitKhOP+MudH7nzn1fYZYaVF41QZWJCh7
	 wY44UBlLEO+YOu6pipkM2+sVHAjHhyUGBy7iERF4AMn6hgFX4u974JdTEOXhLBRcH9
	 EU7oOI/mMHXK9FXkjIXhHvRTD9s2sZi4gGQ/9iq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/184] fbnic: Improve responsiveness of fbnic_mbx_poll_tx_ready
Date: Mon, 12 May 2025 19:44:10 +0200
Message-ID: <20250512172043.735231193@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit ab064f6005973d456f95ae99cd9ea0d8ab676cce ]

There were a couple different issues found in fbnic_mbx_poll_tx_ready.
Among them were the fact that we were sleeping much longer than we actually
needed to as the actual FW could respond in under 20ms. The other issue was
that we would just keep polling the mailbox even if the device itself had
gone away.

To address the responsiveness issues we can decrease the sleeps to 20ms and
use a jiffies based timeout value rather than just counting the number of
times we slept and then polled.

To address the hardware going away we can move the check for the firmware
BAR being present from where it was and place it inside the loop after the
mailbox descriptor ring is initialized and before we sleep so that we just
abort and return an error if the device went away during initialization.

With these two changes we see a significant improvement in boot times for
the driver.

Fixes: da3cde08209e ("eth: fbnic: Add FW communication mechanism")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/174654721224.499179.2698616208976624755.stgit@ahduyck-xeon-server.home.arpa
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index dd30f0cb02506..8d6af5c3a49c0 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -772,27 +772,30 @@ void fbnic_mbx_poll(struct fbnic_dev *fbd)
 
 int fbnic_mbx_poll_tx_ready(struct fbnic_dev *fbd)
 {
+	unsigned long timeout = jiffies + 10 * HZ + 1;
 	struct fbnic_fw_mbx *tx_mbx;
-	int attempts = 50;
-
-	/* Immediate fail if BAR4 isn't there */
-	if (!fbnic_fw_present(fbd))
-		return -ENODEV;
 
 	tx_mbx = &fbd->mbx[FBNIC_IPC_MBX_TX_IDX];
-	while (!tx_mbx->ready && --attempts) {
+	while (!tx_mbx->ready) {
+		if (!time_is_after_jiffies(timeout))
+			return -ETIMEDOUT;
+
 		/* Force the firmware to trigger an interrupt response to
 		 * avoid the mailbox getting stuck closed if the interrupt
 		 * is reset.
 		 */
 		fbnic_mbx_reset_desc_ring(fbd, FBNIC_IPC_MBX_TX_IDX);
 
-		msleep(200);
+		/* Immediate fail if BAR4 went away */
+		if (!fbnic_fw_present(fbd))
+			return -ENODEV;
+
+		msleep(20);
 
 		fbnic_mbx_poll(fbd);
 	}
 
-	return attempts ? 0 : -ETIMEDOUT;
+	return 0;
 }
 
 void fbnic_mbx_flush_tx(struct fbnic_dev *fbd)
-- 
2.39.5



