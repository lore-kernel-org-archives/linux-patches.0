Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083B8470435;
	Tue, 21 Jul 2026 20:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664232; cv=none; b=ShoQ4fyulazRfkRoaHqabSiVTzcI1MsBL8+WHSMxnlz4a7mMAh6rG8s2j+7KKzVzEYJxXv26e23rvXURrRUsbwprJgALCjpXS9XXdqpHf2D7C+SqrIVkSIxkVjpve6rjjAw+T7Z0D470/G46teFKhKUzff1HnLA2JB26+uoS9d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664232; c=relaxed/simple;
	bh=x+38G+rwHdw1pDHcrBcQo1a8bPulCa3e3GNjXhSdIpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgCKUNd6fTebwmMyfwefV1eLNTSJ+uFk4xxnZz/5UkB94398Ky9kffVyJ+hdPdfMzSp7OWb86uVsBQFM/+HoBAe1ghoOFGjPHrncZqAY4q+7ujXxA56GFBIb3IeDdxaWD8a3SO23D/s/Z8Yqcg4zpeQPl/fwUALhnM8MOPU6rDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVKxXaVn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVKxXaVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264E61F00A3A;
	Tue, 21 Jul 2026 20:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664228;
	bh=4f24F+q+AZ3YIqLM3Kgu+p0Jh/Y4TFT2kl6+WVwRnqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVKxXaVnQJWPEIS214uzIfpoZ2gyh8SjjgvNtB9Fo2bMfAZkdIm5TPkBOI2w7XoZE
	 8bHQChNytKajzy/eQDoD7Acl+GdFhppMTAsUJ4LffPjw+8BQoOHjXokdqL2xDrjxX+
	 UZ/mr0LhsfbQzIno7cm4Mwp7uxNnJJ5NbKqK3Hsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Beims <rafael.beims@toradex.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 1122/1276] wifi: mwifiex: fix permanently busy scans after multiple roam iterations
Date: Tue, 21 Jul 2026 17:26:05 +0200
Message-ID: <20260721152511.103641939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael Beims <rafael.beims@toradex.com>

commit d78a407bad6f500884a8606aea1a5a9207be4030 upstream.

In order for the firmware to sleep, the driver has to confirm a
previously received sleep request. The normal sequence of evets goes
like this:
EVENT_SLEEP -> adapter->ps_state = PS_STATE_PRE_SLEEP -> sleep-confirm
-> SLEEP -> EVENT_AWAKE -> AWAKE.
Before sending the sleep-confirm command, the driver must make sure
there are no commands either running or waiting to be completed.

mwifiex_ret_802_11_associate() unconditionally sets
ps_state = PS_STATE_AWAKE when it processes the association command
response, outside of the normal powersave management flow. If
EVENT_SLEEP arrives while the association command is in flight,
ps_state is PRE_SLEEP when the association command response is parsed,
and the forced AWAKE overwrites it. The deferred sleep-confirm is
never sent.

A subsequent scan_start command is correctly acknowledged, but the
firmware doesn't generate scan_result events. The scan request never
finishes, and additional requests from userspace fail with -EBUSY.

After testing on both IW412 and W8997, I could only trigger the bug on
the IW412 and observed the firmwares behave differently. On the IW412
the firmware still sends EVENT_SLEEP while the authentication /
association process is ongoing. A W8997 under the same
conditions seems to suppress power-save for the duration of the
association, so PRE_SLEEP never coincided with the association response
even after extended periods of testing using the loops
described below (>12hours).

On the IW412, the delay between commands that triggers an EVENT_SLEEP
was empirically determined to be ~20ms. This delay can naturally occur
when the driver is outputting debugging information
(debug_mask = 0x00000037), in which situation the busy scans issue is
repeatable while running "test 1)" as described below. If the delay
between commands is less than ~20ms, the firmware stays awake and
the issue was not reproducible running the same test.

The host_mlme=false path also behaves differently. In this case, the
entire authentication / association transaction is executed by one
command (HostCmd_CMD_802_11_ASSOCIATE), and the firmware doesn't emit
EVENT_SLEEP while the command is running.

Remove the assignment so the ps_state is only manipulated in the paths
that are related to powersave event handling and on the main workqueue
for correct sleep confirmation.

The following loop tests were performed (with debugging output enabled):
1) force roaming between two AP's, one 5GHz and one 2.4GHz, same
SSID. Use wpa_cli to trigger the roaming behavior, sleep 2s
between iterations.
2) force a disconnection to AP 1 and a connection to AP 2, test
scan. Use wpa_cli to trigger the connection changes, sleep 2s
between iterations.

Each test ran in each device for at least 3 hours.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Rafael Beims <rafael.beims@toradex.com>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
Link: https://patch.msgid.link/20260612122547.1586872-2-rafael@beims.me
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/join.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -737,7 +737,6 @@ int mwifiex_ret_802_11_associate(struct
 	/* Send a Media Connected event, according to the Spec */
 	priv->media_connected = true;
 
-	priv->adapter->ps_state = PS_STATE_AWAKE;
 	priv->adapter->pps_uapsd_mode = false;
 	priv->adapter->tx_lock_flag = false;
 


