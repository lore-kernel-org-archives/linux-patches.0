Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C5715EB8
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIWVcDmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C46C433C7;
	Mon, 23 Oct 2023 11:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061814;
	bh=Alw5F36ufth/ukSgpv5yhVd9ocFRWLYuGb3EU8JQQ88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JIWVcDmpiHi/aNccQH3FiSNgNmg9ddxnwGYdadrx3tZkycoXLIC1HJLJIo4/1+/JV
	 85U9aK9rjjwoCDHJrMi5Z4ZMgqlpT2ivk/TySnFctj6dSed63lyEy4xQiINn6qUh3Y
	 fgJBGHntwgoSayivlJmLO77KoGUjTpAk05Sddkt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/202] Bluetooth: hci_event: Fix using memcmp when comparing keys
Date: Mon, 23 Oct 2023 12:58:00 +0200
Message-ID: <20231023104831.536043221@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit b541260615f601ae1b5d6d0cc54e790de706303b ]

memcmp is not consider safe to use with cryptographic secrets:

 'Do  not  use memcmp() to compare security critical data, such as
 cryptographic secrets, because the required CPU time depends on the
 number of equal bytes.'

While usage of memcmp for ZERO_KEY may not be considered a security
critical data, it can lead to more usage of memcmp with pairing keys
which could introduce more security problems.

Fixes: 455c2ff0a558 ("Bluetooth: Fix BR/EDR out-of-band pairing with only initiator data")
Fixes: 33155c4aae52 ("Bluetooth: hci_event: Ignore NULL link key")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index c0a2103241415..ad5294de97594 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -25,6 +25,8 @@
 /* Bluetooth HCI event handling. */
 
 #include <asm/unaligned.h>
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -4076,7 +4078,7 @@ static void hci_link_key_notify_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		goto unlock;
 
 	/* Ignore NULL link key against CVE-2020-26555 */
-	if (!memcmp(ev->link_key, ZERO_KEY, HCI_LINK_KEY_SIZE)) {
+	if (!crypto_memneq(ev->link_key, ZERO_KEY, HCI_LINK_KEY_SIZE)) {
 		bt_dev_dbg(hdev, "Ignore NULL link key (ZERO KEY) for %pMR",
 			   &ev->bdaddr);
 		hci_disconnect(conn, HCI_ERROR_AUTH_FAILURE);
@@ -4588,8 +4590,8 @@ static u8 bredr_oob_data_present(struct hci_conn *conn)
 		 * available, then do not declare that OOB data is
 		 * present.
 		 */
-		if (!memcmp(data->rand256, ZERO_KEY, 16) ||
-		    !memcmp(data->hash256, ZERO_KEY, 16))
+		if (!crypto_memneq(data->rand256, ZERO_KEY, 16) ||
+		    !crypto_memneq(data->hash256, ZERO_KEY, 16))
 			return 0x00;
 
 		return 0x02;
@@ -4599,8 +4601,8 @@ static u8 bredr_oob_data_present(struct hci_conn *conn)
 	 * not supported by the hardware, then check that if
 	 * P-192 data values are present.
 	 */
-	if (!memcmp(data->rand192, ZERO_KEY, 16) ||
-	    !memcmp(data->hash192, ZERO_KEY, 16))
+	if (!crypto_memneq(data->rand192, ZERO_KEY, 16) ||
+	    !crypto_memneq(data->hash192, ZERO_KEY, 16))
 		return 0x00;
 
 	return 0x01;
-- 
2.40.1



