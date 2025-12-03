Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237B5358D12;
	Wed,  3 Dec 2025 16:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781005; cv=none; b=CsLHdc1uPEGfmJfF1Y7OPbwCaP6zOtyS6dVsQKaHyM1yFNw1h2DcYJji6KnA8h37V2Q1rTDCjWIJAhqh/XpJfkqAN5Oo3H4WEMF2gNK12iyJTqCFn6kcGN8J2qobe8SKJNPvD9eu7yCuJXNSj9xkaaCfh3VdM23f+e/BNw6rE6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781005; c=relaxed/simple;
	bh=8Rk3bu/rEH8foIaH+1PZuu8xMxgH+CRCeJ+AsHTBedA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqEfGRT38NyiLt0qfgsXidUNtyTdahSw84a4rt3Ubi4DnRtCanhpzhcFuVHIJJO+EXj1CE0BNWRpY7wXSuUjYt95fXX5JOVgf5AZbr5BswKy9F06AuPPYNwOC/y+EZVZrk5TjD7iqgrm5wqkyJx5r1E+363el1S2oxsemH/nbIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Anqc3LGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Anqc3LGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C53C4CEF5;
	Wed,  3 Dec 2025 16:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781005;
	bh=8Rk3bu/rEH8foIaH+1PZuu8xMxgH+CRCeJ+AsHTBedA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Anqc3LGI7VkUsfOZfF6RQ8Aa+6xAm8xSA7b7e0NudptfxMiWymxQpMG9xfiRhjwxz
	 f4XJ445hFt/QvUoQx8YbQXRsRLxYRNYF2MgttDus3Dylgxy3q3peju8H/bAZvV1xCn
	 ZIbKwhV7Y6kRppvwi1XItV4sQl57DZd9TWDp9no8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 06/93] Bluetooth: SMP: Fix not generating mackey and ltk when repairing
Date: Wed,  3 Dec 2025 16:28:59 +0100
Message-ID: <20251203152336.739182386@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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
index 4c00bc50de811..e7ee13fe83a74 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2137,7 +2137,7 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 	struct smp_chan *smp = chan->data;
 	struct hci_conn *hcon = conn->hcon;
 	u8 *pkax, *pkbx, *na, *nb, confirm_hint;
-	u32 passkey;
+	u32 passkey = 0;
 	int err;
 
 	bt_dev_dbg(hcon->hdev, "conn %p", conn);
@@ -2189,24 +2189,6 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
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
@@ -2227,11 +2209,12 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
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



