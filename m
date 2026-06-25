Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1CE1E633C;
	Thu, 25 Jun 2026 13:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393052; cv=none; b=CbPrv4ddrNjQ3mSLj1xMMpuHCQFwGAQ7Js82NFNah+EkNDEZG/VcgEm5OL+GhzoBv/AVzm7CfDHbf6qGqC1F08HDHHgsxPafynrRyVJN7iDFbPWrE8HIg1LB3B76QKxA3bPwFIsNBe864ipSTtndbqUV+YItKARt1V5WA1nvTCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393052; c=relaxed/simple;
	bh=U4dxaZTJt8tPIWAUGKHq1/fR7hZ9j4tJ8ta4SSK1T+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XC2vdOYiQX87htvLnfHBoXuIWvHFyRjEBDibdY/Qu28c5hG4nvuV1UfjG7Yo5fh/+GGOeE/GEC4jiI/A40FQWC8KwJRY+neZo46+Nhs6DM7rBnXYU95nBlOfLJzyyKL6aYMcxZeLoupWaTabfuFYlfePITpy6IJXzfh38CvgpRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InTE6FvA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InTE6FvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7267B1F000E9;
	Thu, 25 Jun 2026 13:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393051;
	bh=8dDWmuCvbTYbL5RmboNO/AhMg/HKaHjeyA70t5ct1nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=InTE6FvAckOyfB52tZhTdfFSNlUyIMXMPwbGy3yh2L3EYYYguby0lYt81d6NQ6pis
	 ZOOiCL9wC9u21bQbdc2pyXJICRCyGubp0ViiUBzg+oNNyJUL9YxKxjrxzptOv45vF1
	 p/5G+I8+SzkQBlVaKD1cZnSC6x89Zqz5dDOGPP2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 7.0 27/49] rose: drop CALL_REQUEST in loopback timer when device is not running
Date: Thu, 25 Jun 2026 14:03:39 +0100
Message-ID: <20260625125641.311035715@linuxfoundation.org>
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


