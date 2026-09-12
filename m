Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5DC242D65;
	Sat, 12 Sep 2026 11:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212239; cv=none; b=HPq09WM1aboICcdqcys+BjCRsXvqhDxyu4C7ucZAZPxGvrR1KMUxA5QXU8HtZCc7mFpSyQz7wHT8KEe/3UsgN1Y1s6JChWgOGMKIoO1VKsFU/P2GO5YsFu5qZDs95xbB1vTmBf0AIpXgMVnSQllWNLgkPmZ6tOxN5a942jrm4qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212239; c=relaxed/simple;
	bh=Z4Q5x/bBPvD8IbfsxE5UyFg0nwivlVabPerySM4HPXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqcvJ0zAVZKzGYXc1tYFfeDVCHeV/TauzimzZaTH227B89okrqo2Lhd2QxJbx9O+0BISTDD82KBjcm04kxq9CqHN2i35vYyNS/SDVaRzzeS8vtXGgowwEIGB54uW+jXnmGNiCsglqBSOpJNiE/khFjispLqIlEXlSO/AIC70aCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KF2bRVIz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KF2bRVIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5271F000FF;
	Sat, 12 Sep 2026 11:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212238;
	bh=tY3rcuL3wrgGVXNRcNmyyd19Sr8iazCmVTfeX8NqeNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KF2bRVIzUF8YpwON0TNyJOdbpxhHsWtJxBvrj0p6zrXc27tzUPBTYuuqS7hkViKZn
	 TWyWngquw88sifBJ/4PBqYKaJBkfeb+8jT3/E8M7X+zRWIViVRSVzUE9DYiqFfdbli
	 rSQFgNuJPxmJ+iOTsgdb7dahg78kHIDHT1t7S/TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1396/1518] Bluetooth: btnxpuart: Validate the FW dump header length
Date: Sat, 12 Sep 2026 08:59:25 +0200
Message-ID: <20260912065655.128565810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 970da4f84e60f..509d837e353e6 100644
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



