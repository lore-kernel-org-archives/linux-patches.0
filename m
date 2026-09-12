Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF55C2AEEB;
	Sat, 12 Sep 2026 15:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227102; cv=none; b=okFXJModwLL3jGysw8A4MiIqruC3woIJeV6eFLMTbk6K5jcDJ5hKZ778vz0f17tmuKEQCNhGFw4TB4M2GtGQLVsNvTPPcOUDZ5FGYhUkDGBnnCek+Z9fNmGSmvkcjyqZsxMVpw7qtYw2VhVenA0bMIyHedDQUL/vEsYo5VVyZiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227102; c=relaxed/simple;
	bh=eOLfa8+hIjrBidz5u0/XDFphBMheZ2sK3lyleZf7ni4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6ABEzmbSGCe39c7GW4osEjtIlNXJiUL884R8d7zCueMwiBGpu4YzqiHM3xRKFSp4fWPpCcFo/ORAPee/5G0YvK0pOFHit+Y+tMQsjsxbKQ3GF1q1gFBwDsugmT5Hajzd5tl9zLeeeiglkmpobvi3NVgA5j2F56uF29QQKMGpF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3Zu2hfr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3Zu2hfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DD01F000FF;
	Sat, 12 Sep 2026 15:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227100;
	bh=xARB0U2PRGM5QVYM2YLIr4LfuWsbSfIrDvxokQTNrDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P3Zu2hfrUCSIXY8cyIzBZOo7+w4ck4iMHXiAzCfIwGyin4moIhwSYrq/cy7l1iqzq
	 mVfwL0IMvxXn6XPBghNJ9Ttw01X3okaagsFtl6m0FZZH5CSIvcFP/EJ+vl9TfBXYHb
	 yl9jpihncoJNIuKMUxzLBY21dXfBoN9u9+8Btayc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Kindschi <valentin.kindschi@fiveco.ch>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0113/1191] Bluetooth: hci_conn: re-enable advertising only for peripheral role
Date: Sat, 12 Sep 2026 08:47:21 +0200
Message-ID: <20260912065550.726187074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Valentin Kindschi <valentin.kindschi@fiveco.ch>

commit ed5fb41d3b6b6e665e7f97fd54bd1f9531c7477f upstream.

hci_le_conn_failed() unconditionally calls hci_enable_advertising(),
although its own comment states advertising should be re-enabled only
when the failed attempt was made as a peripheral.

hci_le_conn_failed() is reached from hci_conn_failed() for every failed
LE connection, including outgoing central connections. For a central
attempt this enable is redundant: hci_le_create_conn_sync() already
restores advertising via hci_resume_advertising_sync() in its done:
block. Because hci_enable_advertising() only queues the work on
cmd_sync_work, it runs *after* that resume has already succeeded and
set HCI_LE_ADV.

The resulting HCI sequence, captured on a BCM43455 (no LE Extended
Advertising, so legacy advertising is used):

  LE Create Connection                     Status Success
  ... 13.8 s, peer never answers ...
  LE Set Advertising Parameters (0x2006)   Success   <- done: resume,
  LE Set Advertising Enable     (0x200a)   Success      HCI_LE_ADV set
  LE Create Connection Cancel   (0x200e)   Success
  LE Connection Complete                   Unknown Conn Id
  LE Set Advertising Parameters (0x2006)   Command Disallowed (0x0c)

The last command is the queued enable from hci_le_conn_failed() running
as a second hci_enable_advertising_sync() pass. It clears HCI_LE_ADV
(hci_sync.c, "Clear the HCI_LE_ADV bit temporarily"), then sends
LE Set Advertising Parameters while the controller is still advertising,
which the controller correctly rejects with Command Disallowed.

The disable-first call at the top of hci_enable_advertising_sync()
cannot prevent this: hci_disable_advertising_sync() returns early
without sending anything when HCI_LE_ADV is clear, so it is a no-op
exactly when the flag is wrong.

hci_enable_advertising_sync() then returns without sending LE Set
Advertising Enable, so HCI_LE_ADV is never set again. The legacy
software rotation loop re-arms hci_schedule_adv_instance_sync() every
HCI_DEFAULT_ADV_DURATION (2 s), and its "already advertising" shortcut
tests HCI_LE_ADV, which can no longer become true. The command is
therefore retried every 2 s indefinitely:

  Bluetooth: hci0: Opcode 0x2006 failed: -16

Observed on a gateway as 5326 occurrences over 3 hours, ending only when
bluetoothd was restarted. Connection attempts that succeed do not call
hci_le_conn_failed() and never trigger this.

Add the role test the comment already describes. Both other
hci_enable_advertising() call sites reached from a failed/closed LE
connection (hci_cs_disconnect() and hci_disconn_complete_evt()) already
guard on conn->role == HCI_ROLE_SLAVE; this one was missed.

Reproducing needs legacy advertising (ext_adv_capable() false, so the
software rotation loop is used), simultaneous peripheral advertising and
outgoing central connects, and a central connect that times out rather
than failing fast.

The Fixes tag points at the commit that introduced the advertising
restart into this path for the directed-advertising (peripheral) case;
the role test that the later commit 0b1db38ca26b ("Bluetooth: Fix check
for direct advertising") added to the sibling paths was never applied
here.

Fixes: 3c857757ef6e ("Bluetooth: Add directed advertising support through connect()")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5 btmon
Signed-off-by: Valentin Kindschi <valentin.kindschi@fiveco.ch>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1252,7 +1252,8 @@ static void hci_le_conn_failed(struct hc
 	/* Enable advertising in case this was a failed connection
 	 * attempt as a peripheral.
 	 */
-	hci_enable_advertising(hdev);
+	if (conn->role == HCI_ROLE_SLAVE)
+		hci_enable_advertising(hdev);
 }
 
 /* This function requires the caller holds hdev->lock */


