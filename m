Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3009D3815E7;
	Sat, 12 Sep 2026 19:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241201; cv=none; b=DX23EWD6dVgpJJzGPV5vYR1cUqi6Qz5SY9USbmVm1Y5L0ANfMaoNjGIAIth5QYuVOJS3hW6RvvFkXZ8Gl29nOvTQ0V4FbRCzSzaQOdgNz3UZlP3cbm2npGE+BmOHJn8gfqlNjaDDTAyUucFpsWAPZqwPWPACMNVd1PBvjPhPAk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241201; c=relaxed/simple;
	bh=16FJGFehlKl/z0y18mbNlVaKSY9f/NK83A4zLl6eMNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNVYQn2qEdIMRayWaS5l4NlPccUjVX+4BJfRuCjADdR5SvTbE1u7YXcJwb00t47h3r50K9ErhiX46/E7y2lLoMAP6Mm20I+yEE93Jx74wOpEmOV5MFQQK//jDRQGTm+Oygzt8/bWayVXK+FwEL7dfYE4kF/KbnC6BAScceyHAPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKziTnom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKziTnom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508CD1F000FF;
	Sat, 12 Sep 2026 19:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241200;
	bh=Ao0S088bCIzRnhFGI7GstEB0giEuS7j8ROHth9INcTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKziTnom3E5CwKhFcDrfesaEWIVHvmne9tzmjYy4Ojse6jU7g1Xo/0Mo0IXBT15O4
	 i3yVrcQtP2mLRhf1I2kin3X1vrE7j4tDe9ex29hdSzt/Mlx1XBmYdpCGgfNaJac3KB
	 LanSqYKDAGSSna+efjnFhX75010TwLzk5In4OXXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Kindschi <valentin.kindschi@fiveco.ch>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 086/798] Bluetooth: hci_event: clear HCI_LE_ADV only on a created connection
Date: Sat, 12 Sep 2026 08:55:14 +0200
Message-ID: <20260912065518.928495308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Kindschi <valentin.kindschi@fiveco.ch>

commit 941929abe5feaed672b9a52e330e547d333240c6 upstream.

le_conn_complete_evt() clears HCI_LE_ADV before looking at the event
status, on the premise stated in its comment that all controllers stop
advertising when a connection is created.

That premise only holds when a connection was actually created. On a
non-zero status none was, and the controller is still advertising: after
the host issues LE Create Connection Cancel the event arrives with
Unknown Connection Identifier (0x02), and a connection timeout behaves
the same way. Clearing the flag there leaves the host believing
advertising is off while the controller has it on.

It is also wrong for extended advertising, where several sets can be
advertising at once. hci_cc_le_set_ext_adv_enable() is careful about
this - on disabling one set it walks hdev->adv_instances and only clears
HCI_LE_ADV once no instance is still enabled. The unconditional clear
here discards that bookkeeping, so one set connecting drops the flag
while the others keep advertising.

The direction of the error matters. A flag left set is self-correcting:
hci_disable_advertising_sync() sends LE Set Advertising Enable(0) and
the command complete puts the state back. A flag left clear is not,
because that same function returns early without sending anything while
the flag is clear:

  - LE Set Advertising Parameters is then sent to a controller that is
    still advertising, and is correctly rejected with Command Disallowed
    (0x0c);
  - hci_enable_advertising_sync() returns at that point, before the
    LE Set Advertising Enable that would set HCI_LE_ADV again.

On a controller without LE Extended Advertising that is reachable from
here: hci_schedule_adv_instance_sync() re-arms adv_instance_expire every
HCI_DEFAULT_ADV_DURATION (2 s) and its "already advertising" shortcut
tests HCI_LE_ADV, which can no longer become true, so the parameter
write is retried for as long as advertising is configured:

  Bluetooth: hci0: Opcode 0x2006 failed: -16

Only clear the flag when a connection was established.

Note this is not on its own sufficient to stop that retry loop - the
redundant enable queued by hci_le_conn_failed() clears HCI_LE_ADV itself
and recreates the same mismatch, which patch 1 addresses. This patch
fixes the event handler reporting a state the controller is not in.

Verified on the affected device (BCM43455, legacy advertising only) with
this patch and patch 1 applied. A 221 s btmon capture with an out-of-range
peer at -90 dBm contains two outgoing connection attempts that the host
cancelled, each producing exactly the event this patch changes:

  < LE Set Advertising Parameters  0x2006   Success
  < LE Set Advertising Enable      0x200a   Success
  < LE Create Connection Cancel    0x200e   Success
  > LE Connection Complete   Unknown Connection Identifier (0x02), central

Nothing follows either one; the next command is an unrelated scan restart
70 ms later. Over the whole capture: 7 LE Set Advertising Parameters sent,
all Success; 10 LE Set Advertising Enable, all Success; no Command
Disallowed of any opcode, and no 2 s cadence anywhere. Two central
connections to other peers completed normally afterwards, with feature
exchange and a connection parameter update, so advertising was still live
across the cancelled attempts.

The extended advertising case above is a code argument, not a measurement:
this controller has no LE Extended Advertising, so that path is not
exercised by the capture.

Fixes: fbd96c151cdc ("Bluetooth: Fix clearing HCI_LE_ADV for LE connections")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5 btmon
Signed-off-by: Valentin Kindschi <valentin.kindschi@fiveco.ch>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5225,10 +5225,11 @@ static void le_conn_complete_evt(struct
 
 	hci_dev_lock(hdev);
 
-	/* All controllers implicitly stop advertising in the event of a
-	 * connection, so ensure that the state bit is cleared.
+	/* Advertising stops when a connection is created. On a failed
+	 * connection it keeps running, so leave the state bit alone.
 	 */
-	hci_dev_clear_flag(hdev, HCI_LE_ADV);
+	if (!status)
+		hci_dev_clear_flag(hdev, HCI_LE_ADV);
 
 	conn = hci_lookup_le_connect(hdev);
 	if (!conn) {


