Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF153D3CE4;
	Sat, 17 Oct 2026 17:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257313; cv=none; b=GTanzssO22P6roLTim5tiyM5lY/HnCPDVaVMbPrHN0xY5FPfxyOIcMYcnDshmqffgJzHcTMSKwjHvqIeyDy4l4+3RH7W0fl52+/uQfbXd4UwpfsuT0PNPGM2DI1g3+ffK9Hud17P0307ZOtv6trjtfNx6mg1S3I+awl5p078MnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257313; c=relaxed/simple;
	bh=+v4mN3dgz9PZfOZaaMNuZ6mxabJCcnodLjxppsPANpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWANN6XFM3YyrJxDu0d+9n2X2xQe7as1wkK7UxQxeMhXdBmkM12/Ck7SNSE06DZXXl4IIUr2eaykBpo1KymwYZDfQc4sa8RFFIqJQipQbwue7sW+z5gwBGEG3kHouLuRHFlGv40JbO5NXZmYH2Lxm1uHEW/1qcs6KLK9x9ogIX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3fvrHvl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3fvrHvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE101F000C4;
	Sat, 17 Oct 2026 17:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257311;
	bh=8Jqw0DBsacqzOoNKekbnNDHZKrEaRer/vSkrdoCCyOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3fvrHvlj0gyKDxwM1iavVEaNQ/FMBGWpx8DpnR11nj64G1aJbaE+H/wn+qWT0VN/
	 UD4ZOFYNScW5Knioa3m82ZNeBYjPpN/zO8jIHlckx4vYbvQU2nk9isHvD53xkhb3xg
	 I2imOIwtZYptjjROzGetvO3Au/vmXSOCqYLwgm90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iaroslav Voitovych <yaroslav.voytovych@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0517/1674] Bluetooth: MGMT: Fix status of pending commands flushed on power off
Date: Sat, 17 Oct 2026 17:46:29 +0200
Message-ID: <20261017160444.374553273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Iaroslav Voitovych <yaroslav.voytovych@gmail.com>

commit 86ef0f58bdecdedb3a1240971c56d71b7e4ce3fc upstream.

cmd_complete_rsp() receives a struct cmd_lookup and, for a pending
command that has no cmd_complete callback, falls through to
cmd_status_rsp(cmd, data). cmd_status_rsp() reads data as a u8 *, so
the status sent comes from the first byte of match->sk's
representation, not from match->mgmt_status.

commit f53e1c9c726d ("Bluetooth: MGMT: Fix possible crash on
mgmt_index_removed") changed the callers' data from &status to &match
and updated the cmd_complete branch to match->mgmt_status, but left
the fall-through passing data unchanged.

In mgmt_index_removed() match->sk is NULL, so every such command is
answered with status 0x00 (Success) instead of
MGMT_STATUS_INVALID_INDEX. In __mgmt_power_off() it is NULL too,
unless a Set Powered command was pending: then settings_rsp() has
stored that command's socket in match->sk, and the byte sent comes
from the socket pointer. Either way the status the caller set,
MGMT_STATUS_NOT_POWERED (or MGMT_STATUS_INVALID_INDEX when the device
is being unregistered), is lost.

Pass the status the callers set.

This was seen on a QCA9377 laptop: bluetoothd's Start Discovery,
pending when the adapter was powered off, was answered with Command
Status 0x00 and no parameters, and bluetoothd 5.72 crashed on the
zero-length success. BlueZ master has since added the length check
on that path ("adapter: Fix crash on short start discovery reply",
BlueZ a734b06059cb), but userspace should still be told Not Powered,
not Success.

Tested on Ubuntu 7.0.0-31 with a virtual controller (hci_vhci):
power off is held in HCI Write Scan Enable while a Start Discovery is
submitted, and the flush answers it with status 0x00 before this
change and 0x0f (Not Powered) after.

Fixes: f53e1c9c726d ("Bluetooth: MGMT: Fix possible crash on mgmt_index_removed")
Cc: stable@vger.kernel.org
Signed-off-by: Iaroslav Voitovych <yaroslav.voytovych@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1462,7 +1462,7 @@ static void cmd_complete_rsp(struct mgmt
 		return;
 	}
 
-	cmd_status_rsp(cmd, data);
+	cmd_status_rsp(cmd, &match->mgmt_status);
 }
 
 static int generic_cmd_complete(struct mgmt_pending_cmd *cmd, u8 status)


