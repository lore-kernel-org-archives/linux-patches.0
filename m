Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F07143882;
	Tue, 23 Apr 2024 21:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908468; cv=none; b=oVHzMl+hfQ9Y/NtWyK+qc+8mFoVz8AajLwiD+lMT7Lqpey04BQ6YJHBz8dQ2fV+4OUeoUWXcCyCNcDVPfhJYf8Sgb1MJceqmUIPVjTWd7AE4lAfbZ1m9+O6KMl29bktZXxKCbThdTgkH/l447OJd5B+xUC2mqAStfJCW6twYJE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908468; c=relaxed/simple;
	bh=fyUT3hfBtaCKWlCqdPgTGryVzD/rMUA2GpXYmiISMQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZeqtRtzwgz+Ou6WFO/5wHvpOiHRQr5kv7q7TWZYGOdHkAB0Zh/SvH09PKAhDnqMzMN0zzqWd2ctQPFPOd95L2kuAMITh86uoaExUn56HAuBzDIN+W56i5iBUGu0M/if7Dxz5JO30LoMs7H1V2WW0oO27wuLBJYglh9NqCPVFVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NO4vU45c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NO4vU45c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D1DC116B1;
	Tue, 23 Apr 2024 21:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908467;
	bh=fyUT3hfBtaCKWlCqdPgTGryVzD/rMUA2GpXYmiISMQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NO4vU45cFanRwHUF9NyfvChFdTOKBy1Bb9XHdIhKozYMCJNy28g9UGGyuLF4uoNMk
	 Kwu/rxqqwR3xbthpAS0+t5GmeFYl/4CdpRRilEjyexkHq5VXSWsanxyQ5+sXBkE09b
	 HzU2xLq4BJEnKgCiIi1hRd2SJdniUgIh1VXHHOo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Palviainen <jarkko.palviainen@gmail.com>,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 008/158] net: usb: ax88179_178a: avoid writing the mac address before first reading
Date: Tue, 23 Apr 2024 14:37:10 -0700
Message-ID: <20240423213856.112455477@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

commit 56f78615bcb1c3ba58a5d9911bad3d9185cf141b upstream.

After the commit d2689b6a86b9 ("net: usb: ax88179_178a: avoid two
consecutive device resets"), reset operation, in which the default mac
address from the device is read, is not executed from bind operation and
the random address, that is pregenerated just in case, is direclty written
the first time in the device, so the default one from the device is not
even read. This writing is not dangerous because is volatile and the
default mac address is not missed.

In order to avoid this and keep the simplification to have only one
reset and reduce the delays, restore the reset from bind operation and
remove the reset that is commanded from open operation. The behavior is
the same but everything is ready for usbnet_probe.

Tested with ASIX AX88179 USB Gigabit Ethernet devices.
Restore the old behavior for the rest of possible devices because I don't
have the hardware to test.

cc: stable@vger.kernel.org # 6.6+
Fixes: d2689b6a86b9 ("net: usb: ax88179_178a: avoid two consecutive device resets")
Reported-by: Jarkko Palviainen <jarkko.palviainen@gmail.com>
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Link: https://lore.kernel.org/r/20240417085524.219532-1-jtornosm@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1317,6 +1317,8 @@ static int ax88179_bind(struct usbnet *d
 
 	netif_set_tso_max_size(dev->net, 16384);
 
+	ax88179_reset(dev);
+
 	return 0;
 }
 
@@ -1695,7 +1697,6 @@ static const struct driver_info ax88179_
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
-	.reset = ax88179_reset,
 	.stop = ax88179_stop,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
@@ -1708,7 +1709,6 @@ static const struct driver_info ax88178a
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
-	.reset = ax88179_reset,
 	.stop = ax88179_stop,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,


