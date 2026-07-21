Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FB9445AED;
	Tue, 21 Jul 2026 21:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668074; cv=none; b=YW9JRX8c4AaEIhGutAISlOdUgtxmCzHQsxfsGx58jjNCJueSGPrXpZ8yF5ko2GCESNMO7nbbB8lXYbxnhpHB8j1TsPdagUBaVr/MFev5bvVMLXOhcAzoXNyfapzx6gO3nFH7ZSHu9BSVEBc1Q+Zf0+t75vx0hFkXeJHe1txzNkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668074; c=relaxed/simple;
	bh=7kaaWWvAzqy3NUtX+J6Uf5qw5u9zMScqJkKGNBAoMc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmiA13K64p8gVd0ufIMhar6VK8nYGQTBu594j+ODiEeQZcwKB6Ab7UkAPzGu16/D0DiGQ055QZvdIfB8FLQ46s3gNZl66O1qLEUwDCFYwecTHormAla/upmZFdb4xFR3ri7K0pZQBITqNtvvflWlcVIv0Ubrnby6DRlNLeITgjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTAmswh+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTAmswh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1661F00A3A;
	Tue, 21 Jul 2026 21:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668071;
	bh=gcQt1jWg2YZHD1S26CoRbpN5xOMvP9jsHxXXWzDn+mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTAmswh+bPSdYTyb6MCO8T6O8yPHolDlXl/Z7kVBrmVBfRd+C/uBLbVSv17J0Xfje
	 Cn8RHw3t6Sprx6+2/WzihfRmi3RLMCUmjWd2Iha8tt9ARbj2wb4vDf2KUe13KXzO66
	 KDqBvXTHSwRAHf3SU9kcf+K1cLzXQoyifCezQIyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudia Draghicescu <claudia.rosu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0036/1067] Bluetooth: ISO: Copy BASE if service data matches EIR_BAA_SERVICE_UUID
Date: Tue, 21 Jul 2026 17:10:37 +0200
Message-ID: <20260721152425.360531571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudia Draghicescu <claudia.rosu@nxp.com>

[ Upstream commit f4da3ee15de9944482382181329bb6d7335ca003 ]

Copy the content of a Periodic Advertisement Report to BASE only if
the service UUID is Basic Audio Announcement Service UUID.

Signed-off-by: Claudia Draghicescu <claudia.rosu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 7ea3e633550eb1..aad4baec9ec163 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -13,6 +13,7 @@
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/iso.h>
+#include "eir.h"
 
 static const struct proto_ops iso_sock_ops;
 
@@ -46,6 +47,7 @@ static void iso_sock_kill(struct sock *sk);
 
 #define EIR_SERVICE_DATA_LENGTH 4
 #define BASE_MAX_LENGTH (HCI_MAX_PER_AD_LENGTH - EIR_SERVICE_DATA_LENGTH)
+#define EIR_BAA_SERVICE_UUID	0x1851
 
 struct iso_pinfo {
 	struct bt_sock		bt;
@@ -1337,6 +1339,8 @@ static int iso_sock_getsockopt(struct socket *sock, int level, int optname,
 		len = min_t(unsigned int, len, base_len);
 		if (copy_to_user(optval, base, len))
 			err = -EFAULT;
+		if (put_user(len, optlen))
+			err = -EFAULT;
 
 		break;
 
@@ -1606,12 +1610,16 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 
 	ev3 = hci_recv_event_data(hdev, HCI_EV_LE_PER_ADV_REPORT);
 	if (ev3) {
+		size_t base_len = ev3->length;
+		u8 *base;
+
 		sk = iso_get_sock_listen(&hdev->bdaddr, bdaddr,
 					 iso_match_sync_handle_pa_report, ev3);
-
-		if (sk) {
-			memcpy(iso_pi(sk)->base, ev3->data, ev3->length);
-			iso_pi(sk)->base_len = ev3->length;
+		base = eir_get_service_data(ev3->data, ev3->length,
+					    EIR_BAA_SERVICE_UUID, &base_len);
+		if (base && sk && base_len <= sizeof(iso_pi(sk)->base)) {
+			memcpy(iso_pi(sk)->base, base, base_len);
+			iso_pi(sk)->base_len = base_len;
 		}
 	} else {
 		sk = iso_get_sock_listen(&hdev->bdaddr, BDADDR_ANY, NULL, NULL);
-- 
2.53.0



