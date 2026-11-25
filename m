Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624311;
	b=UzlEZq6J7c0v4CQr6KA8HXCFOTkEa7gZlCxQ60ZzLlgn1bMUeM0eq1yji2Vlbysj4TVv
	 ZoJZm7j996NSituveaG2/3vIMRcZVo8k2vgiFALu8SXEA8ZAJJrR0utM5xlqrILQAb3X3
	 5pZ9C87gufwJ9xBL/b+kXxHW2ZFDu+hO6hUAyIZS9PWVszeyzFQ6LU9KkOM63TKeH+eY9
	 YSNDGjpJ1xfTMlVkJdiZEjMVhSJEWttgltOlEOzayCWeeyi5VyuhcAMWsA3dVzzO0W4JF
	 G8Jygr5IOvzjQx+c8Bi9AoIEQsDWp84LeTyCXl/6GN9ksHcnwcU5e2cBg6zG/o8n3fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/NLDfKOgmkINOWeKlA3pBOcdmPUCDQcIgiWoHGS9je8=;
	b=OlwlHR0cYIaKXcXhhE+YztdopSBHghCNB+FM0UkoZz0Lqu++3h3mo192ok3DX7GNvzPV
	 mhql/EwZW1OnA4zc0dqS6jIKv3LjERPR1Ai+CVFlZmqqK8Z6mL3XAKhzfFaPphZ91R+pg
	 Hh8H9gO1P9Cpez+RjYpe5r39VwJIfRXpBCgQM5SSQMN/+6I6jCmjUUvaay5//UEiUwmpf
	 eV3tgJF692RJXdqZ+cv3/pBu/fYaFO6SLApsF6PeqPU5FkUmJzripIPCrHZryRtsqVzkn
	 nJTcG1IDORIFAFXsyflYdzCNoSNQedn04IOToE0domK2Yw9WtUVQDyu3GsouJyic5Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TOloTb/8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E58606A33A;
	Wed, 25 Nov 2026 16:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TOloTb/8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B70E1F000C4;
	Wed, 25 Nov 2026 16:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624310;
	bh=/NLDfKOgmkINOWeKlA3pBOcdmPUCDQcIgiWoHGS9je8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TOloTb/8Go4Uuz2e56bRIa3lEI1RxK/OVZXLLKWcQR9p4Acb1q22GBbtk0OsXMWGI
	 WXaZrKYhH0hP+DvCuyO7yQ9EqwB+9pprh0aAyVLIsP2hAWgShf5vPu6Re5P1+e6548
	 3lt0Gj6a0QMkispQpUNjsy1Z7itgtIKQy+JbXMDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catherine L <catherine.l@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/816] Bluetooth: btintel: fix buffer over-read in fw payload
Date: Wed, 25 Nov 2026 15:28:20 +0100
Message-ID: <20261125143852.714291353@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ceca209be40bf..7cbc9aaf85ce5 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -1081,7 +1081,29 @@ static int btintel_download_firmware_payload(struct hci_dev *hdev,
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



