Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590966;
	b=gJepLcj4Rl35Nrm3NJXJ55/aiftp/bNvY7ixsuN8XXzYqPYXqQMGY3PsisDhOD/zWcCd
	 7l3vLKHOe1daC3iTNI6el3hJoCi4w+w7m7rCpvvSyrVMCOaCXfRzz/9j500I522zpJLj1
	 HzIW/WA4YsxmiD1rOF2uSP/R+8AqKTbBiRAYasVP0b78FHjALNtS1z4lJ/cd8gBy/rv8M
	 tfUdg2F22GRQ+PE8SNP+0sZ0g2BkQtjhDX1OwnwFKZ1PkoFaA58x1SZrBd992GNs06KLC
	 vocCJE95qkhilcKlGyu56V0KPylmU+xgAkf4iXYYPL2H4dBxWZQzO8btbtqEYNXIfwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+6kbScr/Y0zu50gwWkIqgt8CmCmj2I92Lr+Q/YAoDIg=;
	b=FhAKqCM6Q3f/sxrdCVTLfjugcraYnrq4brqbZghTMM2Lk2yPQxXRDfu5OwQTVCK9DrG/
	 18f66IPUs7T6HkCKcNsvbO0Ihb8NOlAC9CJt0fBX+D+g5E/6omnQZ4pv2qkbdY5Im57Bj
	 Ll9x1RBpNCmPqWuqT+LnAKSkYjD4Q0EYVaLNdL4CH2iyeCI8dO+QvoiYM2kVu2IgosJLE
	 QKTJAZUwb4sGRBxytb5FPMP8wmsUhNarNQ9ATZm4goBMW8emdN19SHCcZ/yfAHETRSZHR
	 i3SiwbmKe3eXMFXo3Q1pOqs5eYQMqTf3iWOFaSZgru1cH614BEPOukdwblyXZUJC1LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfxGRLe5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C5C606B45C;
	Fri, 13 Nov 2026 17:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfxGRLe5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2065E1F000C4;
	Fri, 13 Nov 2026 17:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590966;
	bh=+6kbScr/Y0zu50gwWkIqgt8CmCmj2I92Lr+Q/YAoDIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfxGRLe5wazwB3bthH4zSOCMf+47uFkvIcEbsziBEiZ+7zeNGSM2x2xeztKPL9I/3
	 7ZM+zgR4GhLNNF3wJLKXcSH5bd6Xdw0BOSe6NM1NylH0owDlwEcIE3HnLxqZSiHCFl
	 JKUfeKyP2D2AKyS1lox+OtGYFca+Lt5uwojGtfzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/670] mkiss: dont use a tty write error as a byte count
Date: Fri, 13 Nov 2026 10:44:26 -0500
Message-ID: <20261113153815.344763859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



