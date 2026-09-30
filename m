Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731C651AFF6;
	Wed, 30 Sep 2026 17:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790544; cv=none; b=sLaOEhnoG7Xp7ekupv+mQQTUR/MJ8tXT5bdpbTg8uEag8M4gI3rpIxCWao1uSuJsSP6vIOrIiHz8HLri1EyiILR0SkQxQkc/dfwQkxEjNgS4KDpezOeNgCis3DI8QZN30XOS/NIci7wxNyi5OQCH19B9ZcKrIJsAnHd2dwTaMwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790544; c=relaxed/simple;
	bh=MdvQvI36tQp9z2Zf/pNwJbRieimjEV7yW6w00Amxz6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKhgdAc64kIN31kAISbPkmOX1kgV4Zan4/HMnIwyQTXMdMnxwZt2Xwbx7lh0CtYEPApjfad1w5RPAbZnCIRAE8LyP5jH/2io0ZdGrbaGM6roRpIoNNJQ2aLuMdmbOitv/1KJQf7tPRMKl/p4okf7zrVs/oi+orn7S6qvjlfHCtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2l62X0j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2l62X0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969091F000FF;
	Wed, 30 Sep 2026 17:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790543;
	bh=ShElsB9mK5h/dKo/Ln91WsD69ymFMv1oxLIFbaUC9Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u2l62X0jKvEAtGKX/swvhCMV/k/451UmGN/JSOa6r8a3RxKqIHadqgXmE3stcnHSL
	 0KsCHTFO6QYZEeRE01iDyXVasP227T9lO2cBd43mGx6VSkbp/DZYEo6IORRSRyx1cW
	 zGtJIgREC4eGGChKH8b3brjrAvzoCylPlABuvQ1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.12 865/877] rose: drop CALL_REQUEST in loopback timer when device is not running
Date: Wed, 30 Sep 2026 17:29:36 +0200
Message-ID: <20260930152433.401841094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit cf5567a2652e44866eae8987dff4c1ea507680df upstream.

When ax25stop brings down rose0 while the loopback timer has pending
CALL_REQUEST frames, rose_loopback_timer() calls rose_dev_get() and
finds the device still registered (unregister_netdevice waits for
refs to drop), then calls rose_rx_call_request() which takes a
netdev_hold() for the new socket.

But NETDEV_DOWN fires only once: rose_kill_by_device() already ran
before this timer tick, so the new socket is never cleaned up.  The
stuck reference prevents unregister_netdevice from completing, and the
orphan socket's timers eventually fire on freed memory (KASAN
slab-use-after-free in __run_timers).

The kernel clears IFF_UP via dev_close() before sending NETDEV_DOWN,
so checking netif_running() after rose_dev_get() is sufficient: if the
device is no longer running, the CALL_REQUEST is silently dropped and
no socket is created.  This closes the race without touching the
module-exit path (which already stops the timer via loopback_stopping).

Tested: unregister_netdevice completes immediately after ax25stop with
active loopback connections; no ref_tracker warnings, no KASAN.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_loopback.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -118,6 +118,16 @@ static void rose_loopback_timer(struct t
 				kfree_skb(skb);
 				continue;
 			}
+			/* rose_kill_by_device() runs on NETDEV_DOWN (IFF_UP cleared)
+			 * before the device is unregistered.  If we create a new
+			 * socket here after that cleanup, the ref never gets released
+			 * because NETDEV_DOWN fires only once.  Drop the call instead.
+			 */
+			if (!netif_running(dev)) {
+				dev_put(dev);
+				kfree_skb(skb);
+				continue;
+			}
 
 			if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0)
 				kfree_skb(skb);


