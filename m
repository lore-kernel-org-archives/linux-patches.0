Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA1F25178A;
	Mon, 12 May 2025 17:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071844; cv=none; b=VN6xXSjN152BfPca0fu28nlKXO1eh4LP5y/6ARNOUc7lQCE92UCykrC48cdVf/ArGBGlW09beT+iSMGcgRzFPhsJOsZCJALYZ3ThNPbSMrCZxTsSRi08U7zCad3Q+4PA0qC6syOQGxon3A9bsYbpujOvXnqG5QGh/7OcD29lxRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071844; c=relaxed/simple;
	bh=pa4uKi0GJih1qAWSmRcIqomw/FPeURoThjZegedkspw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwcOks3mJBC324xLdXPT1J955rJTn9Ll8CXCx0/wLM40j6KEHyF2b89JwEyQUKkm7jbpjFKoZdVPViyhTVvWJRQ2k2+bOm9WhlieE4fTvosLSXJoLajRg19XDdSUb1rwZatp7xFbJIef1/ptviywAdQdfdMCnROrBHbQU1WkvfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ATuEM70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ATuEM70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E27C4CEF0;
	Mon, 12 May 2025 17:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071844;
	bh=pa4uKi0GJih1qAWSmRcIqomw/FPeURoThjZegedkspw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ATuEM70VD0Uu9Tsvq14jV74bSmLZyDLWJeEcqQ7JP002KMME605EuokGxWvWBF7n
	 1onbuvjmYs0MXwOfD0xE2sBvGfGXSYTGdnTCqow0oAF389+eVrBOVtQvyHq+20vJNr
	 sZA34ZBnnqghBHAqGO5m0OE9A2tRbzGU13qYy0dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 049/197] fbnic: Improve responsiveness of fbnic_mbx_poll_tx_ready
Date: Mon, 12 May 2025 19:38:19 +0200
Message-ID: <20250512172046.386872475@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index e9b63755cdc52..da6e5ba5acaee 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -910,27 +910,30 @@ void fbnic_mbx_poll(struct fbnic_dev *fbd)
 
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
 
 static void __fbnic_fw_evict_cmpl(struct fbnic_fw_completion *cmpl_data)
-- 
2.39.5



