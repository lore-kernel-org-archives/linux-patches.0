Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DF636A010;
	Wed,  3 Dec 2025 16:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780347; cv=none; b=AKK6iX1tpgdGcHkTYeX7Kfhcebl9aWo2GdS/xKw2d02v1YcZPI3skgXEMwZmW9stV/fBKBHnspBj+c2o5cJBanc+vUdDhENnZ5wYB9GpnBC/hRyAIt0xh34FquUaj/M7Z8IWTpuoYTMK73NMIMLJQD0LGj9abixUOto2UXA8CL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780347; c=relaxed/simple;
	bh=yRBxsTJB/IW/sMCt8t2STK1FunQP9NQy9UksBd8J+7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UC7q8WalU2K6NnXEQ7BiNxleHxBt3ULvRWfhS3ZbXYVTBnUwiibRNOciPARcPpcNvgW6zlh3TiHfnzHYTcNEcdeYnh7yMrCGmhVFiIrdPs0Ufc4qZFvJhbjcIJp94KzGrLgyjbPNNUr7iZDhkKgeXRSJPM4rlov/oSAvPbmdiGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJOWNxLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJOWNxLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B51C4CEF5;
	Wed,  3 Dec 2025 16:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780346;
	bh=yRBxsTJB/IW/sMCt8t2STK1FunQP9NQy9UksBd8J+7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJOWNxLNBVt5zvaLHeoPdg3esKxRoBGZsk9nBOE9FDBPsO0zhGC2PWXq5a/QIYZAU
	 pULcUxRs2DhzVjFozK+9o49qm6Q/gcC1Wk6ECgJLM2YF1xUOkx7qeUHyNmgBCoNDJF
	 erMGi21cRIZ/+0z3IgFxrpmBDDbti9rzj8G9eKz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 496/568] Bluetooth: SMP: Fix not generating mackey and ltk when repairing
Date: Wed,  3 Dec 2025 16:28:18 +0100
Message-ID: <20251203152458.881284472@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 545d7827b2cd5de5eb85580cebeda6b35b3ff443 ]

The change eed467b517e8 ("Bluetooth: fix passkey uninitialized when used")
introduced a goto that bypasses the creation of temporary mackey and ltk
which are later used by the likes of DHKey Check step.

Later ffee202a78c2 ("Bluetooth: Always request for user confirmation for
Just Works (LE SC)") which means confirm_hint is always set in case
JUST_WORKS so the branch checking for an existing LTK becomes pointless
as confirm_hint will always be set, so this just merge both cases of
malicious or legitimate devices to be confirmed before continuing with the
pairing procedure.

Link: https://github.com/bluez/bluez/issues/1622
Fixes: eed467b517e8 ("Bluetooth: fix passkey uninitialized when used")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/smp.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index a03920fe44d94..d8a77bfe65a62 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2130,7 +2130,7 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 	struct smp_chan *smp = chan->data;
 	struct hci_conn *hcon = conn->hcon;
 	u8 *pkax, *pkbx, *na, *nb, confirm_hint;
-	u32 passkey;
+	u32 passkey = 0;
 	int err;
 
 	bt_dev_dbg(hcon->hdev, "conn %p", conn);
@@ -2182,24 +2182,6 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 		smp_send_cmd(conn, SMP_CMD_PAIRING_RANDOM, sizeof(smp->prnd),
 			     smp->prnd);
 		SMP_ALLOW_CMD(smp, SMP_CMD_DHKEY_CHECK);
-
-		/* Only Just-Works pairing requires extra checks */
-		if (smp->method != JUST_WORKS)
-			goto mackey_and_ltk;
-
-		/* If there already exists long term key in local host, leave
-		 * the decision to user space since the remote device could
-		 * be legitimate or malicious.
-		 */
-		if (hci_find_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
-				 hcon->role)) {
-			/* Set passkey to 0. The value can be any number since
-			 * it'll be ignored anyway.
-			 */
-			passkey = 0;
-			confirm_hint = 1;
-			goto confirm;
-		}
 	}
 
 mackey_and_ltk:
@@ -2220,11 +2202,12 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 	if (err)
 		return SMP_UNSPECIFIED;
 
-	confirm_hint = 0;
-
-confirm:
-	if (smp->method == JUST_WORKS)
-		confirm_hint = 1;
+	/* Always require user confirmation for Just-Works pairing to prevent
+	 * impersonation attacks, or in case of a legitimate device that is
+	 * repairing use the confirmation as acknowledgment to proceed with the
+	 * creation of new keys.
+	 */
+	confirm_hint = smp->method == JUST_WORKS ? 1 : 0;
 
 	err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst, hcon->type,
 					hcon->dst_type, passkey, confirm_hint);
-- 
2.51.0



