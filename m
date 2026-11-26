Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704247;
	b=MQJqGjsQrWwYLT/6aJ7QnxHRw4D29sgiWamBy6CuNyV0qDM0XCFdRj/tmH+xMU54CgmF
	 nPfWVYa2/QOCmnaMKSKlQZ+NlSEGkqo9FUWKlqko55WMJmRe/CRfoysDmqXRglw8Yr/PZ
	 n+td9h6Fv921TJ5Zli990rfmwY5eM8Mw7upTVR4xaunnApusUpq1mTyz9HDBQTgJPoUVy
	 //pEIUppsBdzfjbnB9nQLORIF5AJrMs+otiTfRcOaK/DMC3jINw8/qyIDSh0nlKYofoMv
	 F0cfEjyLCerRkGOjX9V09uhMlEmZIA3zX4kPcpDznTlVCoHGAF4IMgWZnmiIlSEX3KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IUL9/JRLDOTQFhhg5ZH/blA3tX7CF4AX9X3InkO3Fzk=;
	b=2lpW2+A/uGokpzITlTIEb0fYb761Rqz0hZBlK3jHR+MBZ5HpCT6K6UcNNgKlkOT+LY0h
	 Xd52wM/dgZBvGvQfztk/N4xaVYYZ4BKdTePBA0/o2Vz+pWWFUeURsr2jajY0n+YmOPlLa
	 NojM9uv/ATUt9EwqhSagGo0+y+pK2l+v8tZ11C5Q5tWDNtheIWlkpE34DRVeIVPgyFT0m
	 CaGVfPq54xtBJlxjY3tFvRFngLpVrHzqCu6SUCgHN4a3B6sCmMTFjZ0LsNvtx4cPzcCjm
	 lGfXBmyd6H+Od4Z9r7pA9mTH3KhjxB/PcE5dGoXzb01GxVGlMQpLUwkn3mpGzLqwxQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H3XUmHCT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400BF606A32D;
	Thu, 26 Nov 2026 14:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H3XUmHCT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1541F000C6;
	Thu, 26 Nov 2026 14:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704246;
	bh=IUL9/JRLDOTQFhhg5ZH/blA3tX7CF4AX9X3InkO3Fzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3XUmHCT3pu1g3wDcsmPx/K6+VEdTKH92g3zflD1ZDT454L44rikNMzg2D4B+zIoP
	 LdIhtv/yDLoWS1VPUuKdCUJfCxiOu0RJv9L57KOSmZvH/zBd85ZkJDRE+qBsx4YLCk
	 kwWEOYjbX/Uebg8VPROpeOYJCDZcC24xWCx1/SDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catherine L <catherine.l@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/265] Bluetooth: btintel: fix buffer over-read in fw payload
Date: Thu, 26 Nov 2026 15:36:28 +0100
Message-ID: <20261126143609.136167683@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catherine L <catherine.l@intel.com>

[ Upstream commit f92b7bca985205082c86140d0bd7c86c5be00efc ]

The firmware decoder cast fw_ptr + frag_len to struct
hci_command_hdr and read cmd->plen before confirming the
header and payload still fit in the remaining firmware
buffer.

Add explicit bounds checks before each dereference:
1. Reject if the command header is not fully contained
   in remain.
2. Reject if the full command including payload exceeds
   remain.
3. Log the offending fragment length and remaining size
   before returning -EINVAL.

Fixes: fbbe83c52bc0d ("Bluetooth: btintel: Create common function for firmware download")
Signed-off-by: Catherine L <catherine.l@intel.com>
Tested-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index dbacddbe16aba..d881e989e4be9 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -869,7 +869,29 @@ static int btintel_download_firmware_payload(struct hci_dev *hdev,
 	err = -EINVAL;
 
 	while (fw_ptr - fw->data < fw->size) {
-		struct hci_command_hdr *cmd = (void *)(fw_ptr + frag_len);
+		struct hci_command_hdr *cmd;
+		size_t remain = fw->size - (fw_ptr - fw->data);
+
+		/* Ensure the header fits before dereferencing */
+		if (frag_len + sizeof(*cmd) > remain) {
+			bt_dev_err(hdev,
+				   "Firmware buffer overrun at header (frag_len %u, need %zu, remain %zu)",
+				   frag_len, frag_len + sizeof(*cmd), remain);
+			err = -EINVAL;
+			goto done;
+		}
+
+		cmd = (void *)(fw_ptr + frag_len);
+
+		/* Ensure the full command (header + payload) fits before use */
+		if (frag_len + sizeof(*cmd) + cmd->plen > remain) {
+			bt_dev_err(hdev,
+				   "Firmware buffer overrun at payload (frag_len %u, plen %u, need %zu, remain %zu)",
+				   frag_len, cmd->plen,
+				   frag_len + sizeof(*cmd) + cmd->plen, remain);
+			err = -EINVAL;
+			goto done;
+		}
 
 		frag_len += sizeof(*cmd) + cmd->plen;
 
-- 
2.53.0



