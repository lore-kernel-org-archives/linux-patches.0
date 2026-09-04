Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEC83D6664;
	Fri,  4 Sep 2026 05:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499229; cv=none; b=RSlimCuYpK4cQIKnLumDPdoGPFBLoSCY5kOBRFF71OfEOZ6WY7a9Gg1H1OPQbp5iiBC0JOqtUgu2FeziFMrCtnWl+5g3/3iRp1RNT2gCJc/4d81BbaS4bUJOogYVNn9IUAK5hwbgf8dilPIf0osrF0tbFOEFu15agr1Vw3aWKxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499229; c=relaxed/simple;
	bh=r4n9N0IepGrX5+tQfeCqrwTGlKGYnI2ys6IoxyDNMLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QI9ajDW/9Nq6nR0k3u728Ew0BzV8FGTkJDr3DR/b8pXkHFqTadUWRA6GOZGhgnMBp5hAyC4mX8IADeZIjXdBhyTlbAdbb9mI9pTbb+j7KDfiWLLHgGbP6VhIHELSBdg2UzPGSRQ5MhQAIXzaAcYxghOUlDzufLVnvdHiWYom7hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVHaXYdC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVHaXYdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EDB1F00A3D;
	Fri,  4 Sep 2026 05:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499227;
	bh=ySYIMU2e/u2ga8PfDWFvXWAfuPt/dOz/E9ChVwSZNCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVHaXYdCjQFDEoNSPifhIe4z+r3NCas3Qk9j/e5G0Zfu1xBcO5VBfd72Qo1PbWEEe
	 cF18uilcdsnzb5Iv5C6mYBRzeBbY2CEgS9BnwmRS/TpyZxSnWfW1/H+/UU37YHEBvl
	 wXAvLPxSmKLq7JdyrNOZc6evPIVByl87k7lSy+Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Kindschi <valentin.kindschi@fiveco.ch>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 342/713] Bluetooth: hci_conn: re-enable advertising only for peripheral role
Date: Fri,  4 Sep 2026 06:55:10 +0200
Message-ID: <20260904045811.495621078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1381,7 +1381,8 @@ static void hci_le_conn_failed(struct hc
 	/* Enable advertising in case this was a failed connection
 	 * attempt as a peripheral.
 	 */
-	hci_enable_advertising(hdev);
+	if (conn->role == HCI_ROLE_SLAVE)
+		hci_enable_advertising(hdev);
 }
 
 /* This function requires the caller holds hdev->lock */


