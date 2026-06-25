Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331AA2E091B;
	Thu, 25 Jun 2026 13:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393037; cv=none; b=c7MwnwnAoGaV5eNMYBdK76xEHmprx+D/OsiexvSugJE3KNBxbVH7o20z++Z/vNjdiefRVbfcAS5h64uLuJ8aoyK5IFCZuEbG/nZ1RAHjxLQ3mHYOVrE6Y1fnkTT/aH5oaZlAIQ2lUDLLKpGtiA3MGGfMOu/r1ipe3U+glWTeUXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393037; c=relaxed/simple;
	bh=lYI6xdMhsgFmRzQ365s4VpSaVSeDODxSXCN2FJ/AW7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nv2DbIlrijwLaDws3967OTMn/Aw4nNIdGIgvcSyUpmz5mrdNmzaLuvbUUhuvJmr61PUuMx5BU8etyToJdRn3FTqJlj1/Mnrezhn0TsoNm5UgGltMfx/d2pAZql5wHt3FhEKXdPW2U/NPu6fcv9nIaitsh760CRiLt226ThuCCuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjqhJxtZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjqhJxtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1901F000E9;
	Thu, 25 Jun 2026 13:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393034;
	bh=30O8ptXC+MqyiARXGzNa/zxFT6yt3cBDNp1d7CtBypU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjqhJxtZM1apV2DyTJhkscrVzmjdmJ0coaWXaS3mqfbB0laVjINhnI1zFBqmu1Z28
	 OOIdISGdPNF0zrfvbZ2Qhd99kxYikhrmxL2HiKvdVn2o3P/71cQnQXUbn+H4PS3UlV
	 ON3g08pMdKY6Vh/AL7fAqc897zwHlK5s+fXFWilc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 7.0 22/49] rose: fix notifier unregistered too early in rose_exit()
Date: Thu, 25 Jun 2026 14:03:34 +0100
Message-ID: <20260625125640.607463264@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


