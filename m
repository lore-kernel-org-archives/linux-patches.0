Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621274;
	b=S2jd9e3kQNVxzE8c9mZyG8SXtEsBYVRcyzl7kFaReL3Hs2waMftU09pBJa6X8gZtmRKW
	 CyVr3W0LT6hUzFKuFZtkLfag2g10RN7/jYqPo5bh6ysVrS1Vma5MJ70NCiIB7nFHz8dMC
	 mUUvaczEhzYYmywVoVVGt0yQWTiSsqRr48EdJxv5ck83sbmPdq8zsXD7kMUtd/q4lk+Bj
	 iTB5Bs17qALgYlHUzPcymZYG7HqztwI0Yl1rhQn+Osd326u19GaH75ZLTwc3u6AjbGYMY
	 lQj0JW3txFQmU2fTi3MTyvBPPAby7W64PpW+C20Yn4QVZhakwuoPOv/5KLHDt0ypiuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c5lsJCF67SlkyXUQqcMkGDqkmyDgMyER1Cc0oWkKbdw=;
	b=sCB7Xq9NO1hKWw/P+rP8OQumNAUIAF0LohWRIuRfgp2KR/8FaT+XFg7nlmTgvA/sjnxB
	 4iFjwVkl981yMjR0SbG9ZiIa8YsGvBlPUE4dTo0XvoSdOtzy8k7gvSsgtOShTLfE8Ruqz
	 CvcAPcKD6V7gHUrmLH1UgiIU3muyFcAXZTx+y6l2PDkWwYHdbph6AFmlv4Pz6L9+dviml
	 CMHwRUJrbmQU1afvZnCq5wDoPqx//vYo9qjzGTZykBw2j3cdasNJwYnuR1tVcWcSIH14p
	 VakWZrnckC/+cGluEsRVhkXpA1x/jhKVZztGn9ZSZSDjh/aoryLXGt7wk8Kc04R+S/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cz+Zbeth;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817C8606BF7E;
	Wed, 25 Nov 2026 15:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cz+Zbeth
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2511F00A3E;
	Wed, 25 Nov 2026 15:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621274;
	bh=c5lsJCF67SlkyXUQqcMkGDqkmyDgMyER1Cc0oWkKbdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cz+Zbeth2VFtJhUlahlCqmwKGzhoFa0ycftSxWajGFYT3eNVXPnEYENEmflY730dL
	 ZU5/gzr1vooWm2ltq+ES6jOVC2/347lVBN7hQTeVseDktBGosduCUoSZZ/S3xRGic5
	 NbuoTNv2hQPH93qr67cwK7e9I6NrcFSnq+wroEmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catherine L <catherine.l@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 176/990] Bluetooth: btintel: fix buffer over-read in fw payload
Date: Wed, 25 Nov 2026 15:25:43 +0100
Message-ID: <20261125143826.214201605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f56a4ebd26ed8..86c3b319ae2a7 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -1089,7 +1089,29 @@ static int btintel_download_firmware_payload(struct hci_dev *hdev,
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



