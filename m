Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A435C35F5F7;
	Sat, 12 Sep 2026 09:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204984; cv=none; b=IlWiui0n6DVmI80dUmKfjWhd+2jscETctHv4FBJals59Ez76gp2gM/8v/y42pTLeVMgaf1LyrT+MwU5CPo3Fb0autSXbwjTQHzNZKZlblXo6/iynU4KO9dPX9HIlNMxuQvTev2zfU4I7StAJX1U13Pz5lo9mTR+bCyTaudljJ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204984; c=relaxed/simple;
	bh=TAr0/cCYiAznXjv0PfBhkNBTFi5JdCDugz66un0IiV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnZ++CDlofzz009U+OvLaD/fRfVunhv0/dHBf3zTJLTsSjL6CB7xduq0j9tPBhQC4vDPTl11ifxNW+Il3O8IbaS/ZD7/ZBh+GCLV0aeqkUmTU6YKc5yJ4rEEpqTNd8D6NRreBCHdNZb2ZVRrRVhLnL14C07FaoPGMY/jcASVaio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IY9AK1jT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IY9AK1jT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90371F000FF;
	Sat, 12 Sep 2026 09:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204983;
	bh=N35rS804S3ffH7cdnPcBOLO0IA3BoPdxdAJStb9lb8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IY9AK1jTvmgQ6UAxNsUYToer4XpqQJNcWnt9hG8QhiDGssjMWJLdNhPpQTkBvdZqq
	 8zAUR0DFvBGonX63pzagqM6iTPLJoEhPpGAnLUkzaSa/nInXEd2PYX6u8ghVVel4dM
	 JxsMBTKx5I4WoYpUAymLZVZE59pt6HPikteHZpGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1724/1815] Bluetooth: btnxpuart: Validate the FW dump header length
Date: Sat, 12 Sep 2026 08:57:54 +0200
Message-ID: <20260912065729.447806474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

[ Upstream commit 060fa7592bdc043a93b6b7870f5b8551206d315d ]

nxp_process_fw_dump() pulls the ACL header off the frame and then reads
seq_num and buf_len from a struct nxp_fw_dump_hdr placed at skb->data,
without checking that the ACL payload is long enough to contain it.

h4_recv_buf() collects HCI_ACL_HDR_SIZE bytes of header followed by the
number of payload bytes named in that header, so skb->len is 4 + dlen
with dlen supplied by the controller and possibly smaller than the 8
byte dump header, or zero. A short frame with connection handle 0xfff
therefore reads both fields from beyond the received data.

Beyond the read itself, buf_len is what terminates a dump: a value of
zero makes the driver call hci_devcd_complete() and reset the
controller, so a truncated frame can end a dump early.

Use skb_pull_data() to validate and pull the FW dump header before
accessing its fields. Warn and reject the chunk if the header is
truncated.

Fixes: 998e447f443f ("Bluetooth: btnxpuart: Add support for HCI coredump feature")
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btnxpuart.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
index 6a1cffe08d5f7..e6c15bc6a30b9 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -1368,12 +1368,21 @@ static int nxp_process_fw_dump(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct hci_acl_hdr *acl_hdr = (struct hci_acl_hdr *)skb_pull_data(skb,
 									  sizeof(*acl_hdr));
-	struct nxp_fw_dump_hdr *fw_dump_hdr = (struct nxp_fw_dump_hdr *)skb->data;
+	struct nxp_fw_dump_hdr *fw_dump_hdr;
 	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
-	__u16 seq_num = __le16_to_cpu(fw_dump_hdr->seq_num);
-	__u16 buf_len = __le16_to_cpu(fw_dump_hdr->buf_len);
+	__u16 seq_num;
+	__u16 buf_len;
 	int err;
 
+	fw_dump_hdr = skb_pull_data(skb, sizeof(*fw_dump_hdr));
+	if (!fw_dump_hdr) {
+		bt_dev_warn(hdev, "FW dump: invalid or corrupt fw dump chunk");
+		goto free_skb;
+	}
+
+	seq_num = __le16_to_cpu(fw_dump_hdr->seq_num);
+	buf_len = __le16_to_cpu(fw_dump_hdr->buf_len);
+
 	if (seq_num == 0x0001) {
 		if (test_and_set_bit(BTNXPUART_FW_DUMP_IN_PROGRESS, &nxpdev->tx_state)) {
 			bt_dev_err(hdev, "FW dump already in progress");
-- 
2.53.0



