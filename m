Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209034;
	b=XkzNT701VG/PGHQyF9ecxVXP0U+QNxijp0UYqD/jVkDBXV64Xih3xrGpU5cyaFUvv+n6
	 DCwxLNF/ZbPOjCeX26sekvxSYriIRJGVWj/uqLrkF/fSbfC5vFfZjJsEAiZhXAcguzWzv
	 yWLQl2ig4+hSgRpXoG+ks5JkFRqE0PN6fpdggM8+bobYyPFGzLeB/mtsTVWMVQrQjw7iu
	 c8SorUnRwtEMNpBwbWw4C5JhJ7s3ZhX/pMw1vIynYkv8eeD6YW8tmHn8mQUGNgHu208JR
	 qYuo/D50Tu9z8HAXj4J/95FKTgmeuXtbHy6iJb1hAiyC12GlStEvCdbMXpgbSnghd6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UV+r/NnWEZNbBmCZvlaH1SskDrDMgfURwOJGpLWmv3s=;
	b=OwBc8oHykj2PtemwEK+U4IL/g2CIiLdlRyNTZu0ZIl4bbAIRaPYmhjLtT0bvB92ZoPil
	 JjaicFo5vli6+3Mr5kDY9FjV3giCOLfG6F0SAWDIeLm9MojC8jJo1oVRsi4DmpZHZFUrn
	 hwF9TkyV5u7QsIkYxlgzhp7LP39UHwn6JjFbGSQ2OeYTRosIUGVc01nZZHRA/QoKuh/7n
	 fdxnDy4N5kU+pktOjDiSniP0Iw74frdbdyH01jpp1KxcTHE+f1Tj6eFhw2Miu9/aT8FP8
	 pxSdndccpB63Zad/7LcBoNl5lueT4aMTRqOPhbR0emARneQtY5TntoUHypxetIsxWCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J1C3C0vB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C66A606A31A;
	Wed, 28 Oct 2026 17:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J1C3C0vB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586541F031EF;
	Wed, 28 Oct 2026 17:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209033;
	bh=UV+r/NnWEZNbBmCZvlaH1SskDrDMgfURwOJGpLWmv3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1C3C0vBOZlWvBN1x1c02jLoJRfIMXEMyrTXAdl1UWeq/D17o+GJ4lNxFRPFigwu1
	 mpbW8WYxU+yWFYGY2Jv0wn6oUUuX0yU2M83/WgAQYFZ87/B5SvBnvwQyOErwG/WEwO
	 UP8B407VeANWW6RDSIQjXmk3lCglc028mEb4HRLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 286/516] tty: tty_port: restore TTY_IO_ERROR on activation failure
Date: Wed, 28 Oct 2026 17:57:18 +0100
Message-ID: <20261028170010.267645228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 56964f6a31238fb41d5830bb42520c5b10ff7d8f ]

Make sure to restore the TTY_IO_ERROR flag if activation fails to
prevent I/O attempts on a port that is gone or powered down.

This specifically avoids issues like kernel panic due to unclocked
accesses or NULL-pointer dereferences when accessing powered down or
deregistered ports when a TTY ioctl races with hangup and open.

Note that the flag is set again in tty_port_close() but not restoring it
on activation failure leaves a window where drivers fail to handle the
ioctl-hangup race.

Fixes: a9a37ec33a1b ("tty: tty_port: Move the IO_ERROR clear")
Cc: stable <stable@kernel.org>  # 2.6.33
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260908084000.218528-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: adapted to the existing braced error block containing mutex_unlock() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index cbb56f725bc4a..77e28059ad982 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -689,6 +689,7 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 		if (port->ops->activate) {
 			int retval = port->ops->activate(port, tty);
 			if (retval) {
+				set_bit(TTY_IO_ERROR, &tty->flags);
 				mutex_unlock(&port->mutex);
 				return retval;
 			}
-- 
2.53.0



