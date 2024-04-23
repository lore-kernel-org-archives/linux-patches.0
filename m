Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34083143C74;
	Tue, 23 Apr 2024 21:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908576; cv=none; b=WPjiLSZ4WfkzMc/YrZ8Ln60661MfIzZHRb0eMrpQ4ZBst9nIbnl0468jnxkAnfzbYsyk5QWy2UXex7/bzRYDEBd66t8Z8lq+0Sgc0Ps/043FT4J5I0uRuozOOY7ReFRmdir4Rdt7hfBgNSR1axdAhbHSJtyaRgZihABhLtPyHLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908576; c=relaxed/simple;
	bh=LhATFkS6z99XI7xOrW4LuQ50cMMLMoDPLN4J26OVFOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oP32wpUik7S6AtN53BAJ9EzjMhepElXOdIullTJY/JmqKrM7eFiG80YBZPeZd1odAor55DXMHzxqxScTQUsIPDXN4y/yVCPQSsmK7llCaxooddjEMI51mtpGY08bZGSLkRuk94k3xiyQowWB1hD0sGwz+tEnD5jU2a1rhX/kSjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1qtMUdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1qtMUdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09721C116B1;
	Tue, 23 Apr 2024 21:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908576;
	bh=LhATFkS6z99XI7xOrW4LuQ50cMMLMoDPLN4J26OVFOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1qtMUdJ1a5fkwmkGxw86iGmbjXgg3qXsaYiMVwGPmBTZbusg/XinEWctzZCKtwD4
	 a+dKidKEEFSsZ8awAd3dZH9QJDvcGOTDuhP8+Xj+xOqonsgf+GnfWPXK4pYQAr28xy
	 +JQv/7QbVKExctNbp0aODYSZ1C6Cd85CQwzQXSMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Palviainen <jarkko.palviainen@gmail.com>,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 029/158] net: usb: ax88179_178a: avoid writing the mac address before first reading
Date: Tue, 23 Apr 2024 14:37:46 -0700
Message-ID: <20240423213856.685888961@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


