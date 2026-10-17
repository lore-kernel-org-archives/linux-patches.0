Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA883ADBA4;
	Sat, 17 Oct 2026 16:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256365; cv=none; b=Z6/0KLAOpMCOb2oKuzn39Jk9Bp2zUKMDNpUqAnqg15x2Ll5ZjHbKxuqYtxQx9EeTdpCL0amrjsxd+s7k8D5Vt2YIANWbmz9LoZkUUbr+EiZugTrrnyFMtHtu7oOMT53mUvpr/cExPPO/bUzXdb3sDfHBYoUBv2SI4PIHCAYZkkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256365; c=relaxed/simple;
	bh=bZKzZFWDnw2utrYS60Yxs83eFSN44/P8e4ZZBBgtjZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLk0l4X068vLCR+Q87EpJOq4o28akT33NX5xMtKUoyBFcdnuO9HBROpmWUSAXo7Ls2mKRDc7dMmdG/bEeVhCuMH5XCA16cyurbx9JggkIVlXmW1RBE+xpV1+AOhOymSc6TXH270zQqlBZRjQbMDXecbBVQq/lYRTdBnIyzRLjms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwQIyMbc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwQIyMbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35571F000C4;
	Sat, 17 Oct 2026 16:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256364;
	bh=0dRWs60ht8uNKwYpkIjOuLByMMlMlZkeG6ArgJ2f388=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwQIyMbcWcAszZsrNUzAkUyXQsWlOP1RbpOyQCqNe99v1iqKy+oDgxT4lgPtPSg1R
	 GRqjFNafqNN4Yc3BYpsyzp/rpfKK1rrNR+wKSskPuqqXlU5kyiSX4b4zy3rwuqoLWs
	 gIIc2Vhe7gNkQXraiql8x5qryB/NVtzp9AB683ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0205/1674] Bluetooth: btintel: validate DDC record lengths
Date: Sat, 17 Oct 2026 17:41:17 +0200
Message-ID: <20261017160436.411705438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sai Teja Aluvala <aluvala.sai.teja@intel.com>

[ Upstream commit c9c15d4d8956df8c564f7c210e4dc5b9b820d97a ]

Parse DDC record lengths in unsigned storage so 0xFF does not wrap.
Reject records smaller than the mandatory three-byte header, records
exceeding U8_MAX, and records exceeding remaining firmware bytes before
issuing Intel_Write_DDC.

This issue was reported by Claude Mythos.

Fixes: 145f2368c5fd ("Bluetooth: btintel: Add Device Configuration support")
Signed-off-by: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index d713bbebbc5a5..1c8b9f863275a 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -384,8 +384,16 @@ int btintel_load_ddc_config(struct hci_dev *hdev, const char *ddc_name)
 	/* DDC file contains one or more DDC structure which has
 	 * Length (1 byte), DDC ID (2 bytes), and DDC value (Length - 2).
 	 */
-	while (fw->size > fw_ptr - fw->data) {
-		u8 cmd_plen = fw_ptr[0] + sizeof(u8);
+	while (fw->size > (size_t)(fw_ptr - fw->data)) {
+		size_t remaining = fw->size - (fw_ptr - fw->data);
+		unsigned int cmd_plen = fw_ptr[0] + 1U;
+
+		if (cmd_plen < 3 || cmd_plen > U8_MAX || cmd_plen > remaining) {
+			bt_dev_err(hdev, "Malformed DDC record (plen=%u, remaining=%zu)",
+				   cmd_plen, remaining);
+			release_firmware(fw);
+			return -EINVAL;
+		}
 
 		skb = __hci_cmd_sync(hdev, 0xfc8b, cmd_plen, fw_ptr,
 				     HCI_INIT_TIMEOUT);
-- 
2.53.0



