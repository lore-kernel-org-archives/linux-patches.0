Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590074;
	b=0XMdf7X1vkAeK6gXOfOB5O55pgyRgKHufsJMwyP8C02VBYE8okgTUr0hh4lAmi8CIkyo
	 dIWSKyfggzakI44oXNHlBrMJ0mD6oTr/6glbC8EjLxfWLy0j2um8aQYmc5vpQr7jVUq3h
	 YkGqZxIhCYxiRoEo0gRf0+yRCwedGG6LTPPuXxvGuqKXma/WZkXA4LXlEfUOx1OCa/O3Z
	 b1AZQmmW8R2+DeWlbxOBILRrG+eIxaWwZdIzQlkREHAsiTdSck9CozZc7F4tG0JoZEbnz
	 9RS/rOIyWIqk6sOjLJp7+6bBFb6gLWs5987pYrCMlb1MtjoDW7QLV8fkegTm0tYCrdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pPVXb3v/FGUPNb4J0+tvTvyvb6cottBrYjMMlI4Ubh8=;
	b=Sy5+1HbgKqZCbx90kcElLayvGhoQePUO6USjNJo4uGuqnq+E21UZcIiFalKFOvCevF9L
	 k8n8HHbj7NLg5q7/OvUIK9KeMSuMi2uv2GndvUD//2Z0sjIMYdpjBDypjW/dvSXrH6J7V
	 uBVRFhwWy4ZXMyVnrvi1Wpwb7aFCofRA6AL0T3OYszdCItWNz2Zly5UeqEcMDCrLe3w0+
	 VBki41EGko74LcwgbWL4TsOAUWiWqz7zAFGMcqH1GbJd1TpoTViJt5EGfeuJBeepj+6/A
	 uqMJZwsiy3QxuRqfoUaLU3RW7rJyVO4BkqthMFVbHOKRnSVF95Pnvdg8smmUqcPUcYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZigoIzfW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26A2606C086;
	Fri, 13 Nov 2026 17:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZigoIzfW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276231F000C4;
	Fri, 13 Nov 2026 17:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590074;
	bh=pPVXb3v/FGUPNb4J0+tvTvyvb6cottBrYjMMlI4Ubh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZigoIzfW2QJ2GmvzriSBaMiyDEt+XFMThq8mbGnhVay6YCmuNWlD64wTJ7Y9jxZEB
	 9vv+w2lT8lwSWkNQdxjpyMkUyOzUuB9asf5SEGTxnLnDPQHn+87RZp1RAjktAOzzih
	 WJ6kvVjA1Ul9z0UY4SW2DhRcTKwOOMTZb117G/bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 105/686] mkiss: dont use a tty write error as a byte count
Date: Fri, 13 Nov 2026 10:43:58 -0500
Message-ID: <20261113153824.417130970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

ax_encaps() and mkiss_write_wakeup() take whatever tty->ops->write()
returns as the number of bytes accepted by the tty. Some tty drivers
return a negative errno instead, USB serial adapters for instance when
the device is gone or the URB cannot be submitted.

A negative value moves ax->xhead to before the start of xbuff and
makes ax->xleft larger than the frame, so the next write wakeup sends
memory that does not belong to the transmit buffer down the line. It is
also added to the tx_bytes counter.

Treat a negative return as a transmit error: count it in tx_errors,
drop what is left of the frame and restart the queue, as is already
done for an oversized frame.

This path could not be exercised on the test bench, where neither the
8250 driver nor a pty ever returns an error from write(). The change
was compile tested and checked for regressions only: 46 frames out of
46 are still sent unchanged.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit eb6e59f373ad5fa6646a3e836a887830addd0687)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/mkiss.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 05c7a234de6ca..f11019d155764 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -526,6 +526,14 @@ static void ax_encaps(struct net_device *dev, unsigned char *icp, int len)
 
 	set_bit(TTY_DO_WRITE_WAKEUP, &ax->tty->flags);
 	actual = ax->tty->ops->write(ax->tty, ax->xbuff, count);
+	if (actual < 0) {
+		/* The tty refused the frame: drop it. */
+		clear_bit(TTY_DO_WRITE_WAKEUP, &ax->tty->flags);
+		dev->stats.tx_errors++;
+		ax->xleft = 0;
+		netif_start_queue(dev);
+		return;
+	}
 	dev->stats.tx_packets++;
 	dev->stats.tx_bytes += actual;
 
@@ -939,6 +947,14 @@ static void mkiss_write_wakeup(struct tty_struct *tty)
 	}
 
 	actual = tty->ops->write(tty, ax->xhead, ax->xleft);
+	if (actual < 0) {
+		/* Give up on the rest of this frame. */
+		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+		ax->dev->stats.tx_errors++;
+		ax->xleft = 0;
+		netif_wake_queue(ax->dev);
+		goto out;
+	}
 	ax->xleft -= actual;
 	ax->xhead += actual;
 
-- 
2.53.0



