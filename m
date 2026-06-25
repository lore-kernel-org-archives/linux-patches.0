Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFBE2571B8;
	Thu, 25 Jun 2026 13:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392857; cv=none; b=RF7EG1R66K8fioq15OtwiP9Xz7decXL1ZLlEQzVNTlCBTWObbT9KnOXsCRw+sbRNzwxrCf0TZ1B/AwiCTfZDLx4JVhFgWjcDBQlmcv5EfuHt65CJRCg/jweEP4/3oh12k/3E+uOoTqxdUZWnBILsfeDJ4QS+2dBIPheMFwo187U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392857; c=relaxed/simple;
	bh=/TFdmZRQznOCWt06dtL6DljQu9hS5KMSfMDV7YUBkRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1/PQLe+OhKiOS6wy6s6GB2P37M4p11CT40eT1LUzPkX/IMSqJT0Y/UkxpAdyjazEOLtVHx9MXc/r07/bln9TFR/UdGLNUOgkRh7ctz22bl2dIGVF3aNBm+Lkn6dRQSDPkwaDSS8MVoNPHF5BCL/Pob7cYiRJ2YgQZ8K+f3vo08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEF08RYQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEF08RYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B711F000E9;
	Thu, 25 Jun 2026 13:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392856;
	bh=kevlA4ojNMPXtdh7mUbAavg+/wDeMSGnxWIDZKV3XU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SEF08RYQOxBTovGI1VxfQT+g0A2XNErBfjSXM2F1k/r/vWOdKg4pYFNihkZfFD8wT
	 qAH78pXjptUUvIleCjNEFJB3MDUlRc5GoGQrn+1vTp46FWODyxojL/xB3HpfOXe6Wo
	 gBmI0YoTLYWMeAvveRYGvIwtnNLPfOnXTU+iD8EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 20/60] rose: fix notifier unregistered too early in rose_exit()
Date: Thu, 25 Jun 2026 14:03:05 +0100
Message-ID: <20260625125648.497898989@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit f71a8a1edc14dba746edde38adddd654ba202b4d upstream.

rose_exit() called unregister_netdevice_notifier() before the loop that
calls unregister_netdev() on each ROSE virtual device.  As a result,
the NETDEV_DOWN event fired by unregister_netdev() was never delivered
to rose_device_event(), so rose_kill_by_device() never ran.

Every socket whose rose->device pointed at a ROSE device therefore kept
its netdev_tracker entry live until free_netdev() destroyed the
ref_tracker_dir, at which point the kernel reported all of them as
leaked references (165 entries in a typical FPAC setup).  Worse, those
sockets retained stale device pointers and live timers that could fire
into freed module text after module unload, causing a silent system
freeze with no kernel panic logged.

Fix by moving unregister_netdevice_notifier() to after the device-
unregistration loop.  unregister_netdev() then delivers NETDEV_DOWN
while the notifier is still registered, rose_kill_by_device() runs for
each device, releases all netdev references held by open sockets, and
calls rose_disconnect() which stops the per-socket timers.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/af_rose.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1669,19 +1669,28 @@ static void __exit rose_exit(void)
 #ifdef CONFIG_SYSCTL
 	rose_unregister_sysctl();
 #endif
-	unregister_netdevice_notifier(&rose_dev_notifier);
-
 	sock_unregister(PF_ROSE);
 
 	for (i = 0; i < rose_ndevs; i++) {
 		struct net_device *dev = dev_rose[i];
 
 		if (dev) {
+			/* unregister_netdev() fires NETDEV_DOWN, which -- while the
+			 * notifier is still registered below -- invokes
+			 * rose_kill_by_device(dev).  That releases every socket's
+			 * netdev reference and disconnects all active circuits.
+			 * Unregistering the notifier before this loop was the
+			 * original bug: NETDEV_DOWN was never delivered, leaving
+			 * 165 netdev_tracker entries leaked and stale timers live.
+			 */
 			unregister_netdev(dev);
 			free_netdev(dev);
 		}
 	}
 
+	/* Now safe to remove the notifier -- all ROSE devices are gone. */
+	unregister_netdevice_notifier(&rose_dev_notifier);
+
 	kfree(dev_rose);
 	proto_unregister(&rose_proto);
 }


