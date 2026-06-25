Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9647F2571B8;
	Thu, 25 Jun 2026 13:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392840; cv=none; b=SIAysc5tbjNmGc4o8ex2rbC56bCpCetdg+bUMX0dNkcYaxF1pOnL1cgtOTFQzYGd3z9DtKeFhEl028Dbu6/b7T1Li74hCs24RKrTwKbWmKg/g3mKLd+fpcSlN1kJlE+yr8hIBmfcZyUScEBppfNiUsrqZ/orgqTZBy/y4RO63J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392840; c=relaxed/simple;
	bh=VD4IAhww2xrKGfVYVwjLYw2xLrHWBgD3b4MiKyn6uCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0d5gUqNtKJLhx2OF/GlgY8SBPRoTWweI2N2pWl53LWE5wWVyJ6PQE2ocoj7+NLG9IjDSqBWqTrrxcpbccFunzfl0Mp+SovxTI2IhGEq2+cBe/P+IkeTF2qmJN3WoqVmRVPO2LQvgqUyqhjwWThAqFJ6I1fpY5MsRCcY5RTlDJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQSpSozg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQSpSozg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CD51F000E9;
	Thu, 25 Jun 2026 13:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392839;
	bh=M+2rHDchSVZohPeAws6sY9H+u5KR1L1Uct5PcqOj2Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQSpSozgymM3pZU1bK8iThNZERrzQ6IUPM+2EgBu2PNkFEVPmeH2AJm4HXH2p1lSM
	 IC2eLmgNzgnKIDqpqDTFrS51Bc3Mz3Xjz9W2guDHVKcf5xQO/aN9yZH18NNKlo4fDO
	 IXA/SrT41q9XtGKY7DT+iPrzCTmTqYq/bZqrnBfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 25/60] rose: drop CALL_REQUEST in loopback timer when device is not running
Date: Thu, 25 Jun 2026 14:03:10 +0100
Message-ID: <20260625125649.235197933@linuxfoundation.org>
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


