Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9CF15E8E
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jd1ZjRwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3360EC433C7;
	Mon, 23 Oct 2023 11:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060885;
	bh=ReK6ISd9eVjCpB+fR4Gkrcg7hH7Ud4mUZbPuTLNYNLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jd1ZjRwHEays35gwF8LIXUTYKp56NszCUxoOe2vfXRkjGPnLsPdk5HbcnsW2XrBsz
	 b5IzFlQzMgUziiMG3xxpb3BogmdUslme5c8rB/NgIoClWpibCoTq4LN1gPFRBroHVl
	 H6oRPPMVSUtvygL0HT1wbYh++ijM1knc5kK2q+N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/123] Bluetooth: hci_event: Fix using memcmp when comparing keys
Date: Mon, 23 Oct 2023 12:57:39 +0200
Message-ID: <20231023104821.090928013@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0fe01b543b185..f182a7d3e44cf 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -25,6 +25,8 @@
 /* Bluetooth HCI event handling. */
 
 #include <asm/unaligned.h>
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -3946,7 +3948,7 @@ static void hci_link_key_notify_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		goto unlock;
 
 	/* Ignore NULL link key against CVE-2020-26555 */
-	if (!memcmp(ev->link_key, ZERO_KEY, HCI_LINK_KEY_SIZE)) {
+	if (!crypto_memneq(ev->link_key, ZERO_KEY, HCI_LINK_KEY_SIZE)) {
 		bt_dev_dbg(hdev, "Ignore NULL link key (ZERO KEY) for %pMR",
 			   &ev->bdaddr);
 		hci_disconnect(conn, HCI_ERROR_AUTH_FAILURE);
@@ -4445,8 +4447,8 @@ static u8 bredr_oob_data_present(struct hci_conn *conn)
 		 * available, then do not declare that OOB data is
 		 * present.
 		 */
-		if (!memcmp(data->rand256, ZERO_KEY, 16) ||
-		    !memcmp(data->hash256, ZERO_KEY, 16))
+		if (!crypto_memneq(data->rand256, ZERO_KEY, 16) ||
+		    !crypto_memneq(data->hash256, ZERO_KEY, 16))
 			return 0x00;
 
 		return 0x02;
@@ -4456,8 +4458,8 @@ static u8 bredr_oob_data_present(struct hci_conn *conn)
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



