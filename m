Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B011429B
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G49kbs8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DBDC433C9;
	Mon, 23 Oct 2023 11:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059390;
	bh=Ves5z23CSYPnkzOmyzFck6LkDnVfT5AwO9WV5o0BCpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G49kbs8eerKBuAdDBfd0Og4j2KX0fwYYQcIl38AjiXupli0CEBxgXGOCvBQ4re1Ni
	 8BieNmyCvvfxxdj+7hbPqYujmuIz3ou2eQUT8rV+KuEkxVjEHtfW8GIBvbVKVq9QvW
	 tqW2kBTWt3SKYTumvqas9Dpg4s9mOlWSnMYSZhQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 162/241] Bluetooth: hci_event: Fix using memcmp when comparing keys
Date: Mon, 23 Oct 2023 12:55:48 +0200
Message-ID: <20231023104837.824704991@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 9d8aa6ad23dc2..dd70fd5313840 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -26,6 +26,8 @@
 /* Bluetooth HCI event handling. */
 
 #include <asm/unaligned.h>
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -4730,7 +4732,7 @@ static void hci_link_key_notify_evt(struct hci_dev *hdev, void *data,
 		goto unlock;
 
 	/* Ignore NULL link key against CVE-2020-26555 */
-	if (!memcmp(ev->link_key, ZERO_KEY, HCI_LINK_KEY_SIZE)) {
+	if (!crypto_memneq(ev->link_key, ZERO_KEY, HCI_LINK_KEY_SIZE)) {
 		bt_dev_dbg(hdev, "Ignore NULL link key (ZERO KEY) for %pMR",
 			   &ev->bdaddr);
 		hci_disconnect(conn, HCI_ERROR_AUTH_FAILURE);
@@ -5270,8 +5272,8 @@ static u8 bredr_oob_data_present(struct hci_conn *conn)
 		 * available, then do not declare that OOB data is
 		 * present.
 		 */
-		if (!memcmp(data->rand256, ZERO_KEY, 16) ||
-		    !memcmp(data->hash256, ZERO_KEY, 16))
+		if (!crypto_memneq(data->rand256, ZERO_KEY, 16) ||
+		    !crypto_memneq(data->hash256, ZERO_KEY, 16))
 			return 0x00;
 
 		return 0x02;
@@ -5281,8 +5283,8 @@ static u8 bredr_oob_data_present(struct hci_conn *conn)
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



