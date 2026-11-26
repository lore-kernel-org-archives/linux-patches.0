Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705062;
	b=vB4DpeR2MpzOzOVUyAj6P3dq5IneO9PVK+qUq0YuaJZJBoFyEA0t82TXHhWjpjLv4HLU
	 uFkJz2aJYAGWwYqu5STVs0HQu10eF7dNQa9KsVY50CGfIHGcrrBBu1gZ8ND3pdVHkqAtO
	 Rj/aLzjtM+Rcz+s4hybo71MQJ/Us/bKJWuS075GHjLrHNTsFdeh++2h5tIvoRolY1Brx/
	 ccc+ltL7bCaIWKzT+V9youuUl3mUqAVS8/w3RdMlR58eFsIOVJBchpEsZJc32bRFC62qr
	 jUOqOskawJD7hCNxU9w8O+E1zeHpXZ7rTljfox90MdjFfZuJ7YEebNoqFuMfmh/bGBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GGCLor5WYNrMr2vsAJgsmbfov5YJP45f3gExiIKI7DA=;
	b=uPOj+YshRPk0gvc7luuqp4CY9lVhabmlWFEhPkzm4yfd8vlerF6MIarD6Ty3u+zA6J6N
	 tAXKznz/cOVR8yzK3WG7MLJ00JBsDAzTMHkAo30swroRlbG3KNwyV86yGrYGx0SMuD6n6
	 Rot4diqDp9twW/zRcC2ZY0n1W+l11PEk3le4D3ReW1d7AiKZJK0CIH1sMbvYEivJyfjWz
	 /EXySqfqgcoNqiZlZvalhcMSDQQB40iiYMuYDzA6WFArympQSOE0zs0niX4S27MXCRwHX
	 8XDlZeEAhu8jwMQtb8B5cxBKni/qTjC1rlgA9dtM8ipOoicoXxtR1pLUuZ0q0Bl2b6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wcBhnbOR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57764606A6BD;
	Thu, 26 Nov 2026 14:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wcBhnbOR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00F21F0093E;
	Thu, 26 Nov 2026 14:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705062;
	bh=GGCLor5WYNrMr2vsAJgsmbfov5YJP45f3gExiIKI7DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wcBhnbORgrMvF1qfZYe9+ZyC3sWpKaVFDTgnMUqffkMdq+Gbh+LnJ88RwXSDN8spD
	 z17YUV/5Ub5Srq1FVc0X/2zvoZl8AonVZLdpSANkxsqYGAlQU5uKc3NRjmr5vp2m9A
	 KDjMUImNtVQPZz7+KXqQxgfepygoXRKOTSBeAR9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catherine L <catherine.l@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/319] Bluetooth: btintel: fix buffer over-read in fw payload
Date: Thu, 26 Nov 2026 15:37:16 +0100
Message-ID: <20261126144008.273066949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8b8dad2e1f4a4..2842a3dc20fe1 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -996,7 +996,29 @@ static int btintel_download_firmware_payload(struct hci_dev *hdev,
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



