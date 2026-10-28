Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211254;
	b=FVNNGtjm02Ji3VCfFlLNT5sr+JCEuJoYopm0Ix8eURQyLZcvZoDb6nklldAh1T+mo+Oo
	 pdeZi7E0dp4POkBm8twSzZn0g/zEp5aVH9jwZdGKbaqfxLc8vPkLpffN4VCpmioUlCeCx
	 8KiE9tXVm3OJQMTn13KWmQGvGlb+gWVI4WKa3ShMTlJxg8f+L15nvktPYMRxdIQF0llOD
	 6lzWN8WctOlCG/t9VN7OKOmNZqzTrKXxgHpRzRp1kr5eY9Tp2c1vBKsQeGeFKZFqPUM+X
	 b5rPKOf2rWHnElEyIbbfgjWfu8eYfXXI+gon8hS5MD5OMGobS4+FlMyvmpXV5HTGzFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VhmYLdVVDo7x48d+Pt3tJio/+d7sfsxbJCPYTB3tRDo=;
	b=V+6wxQgKTC8zHMwZTMM75ZoJ7Ioo+Wa+Zo2e74hYG8Va5pwST0nxMdrGWF6HnBVx7H/z
	 SExS4ncPPGymnC/BupTDyXfgVTdUsiw6pCJ11rTKnfNUxUr6xM9l9aP7RYpx0uNngCB6c
	 4542+qC/I4K9LwHikAts6G7A0zOiMlNRiEYaNwG46+f2RQFTq5kM1u8UHinAEMbfKjB07
	 JduCJvrtRaC5FAxiK6scw4szZCdvOljJUKT7bTo6i03pvlEqp04KY3s/QZ/qmjKGA4z4C
	 nBF+N4MX0BcEkXjtGF2kyqn5rJH66u0QUJpQdkiWxAOZ1tA3ZbiiwGBfcPAAIWbs5Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHnTS5Rm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1BF606BF4A;
	Wed, 28 Oct 2026 18:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHnTS5Rm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35681F01829;
	Wed, 28 Oct 2026 18:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211254;
	bh=VhmYLdVVDo7x48d+Pt3tJio/+d7sfsxbJCPYTB3tRDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OHnTS5Rm6r5tYiju/J0LE9jmpz6omvIV+mV8bvw+NZQ1Opg5JVuXOVwch/+4vZ9n0
	 vCdbtu8rjCGB62Xr2sVWwVJz3+CdglCDTxz/bq1Gp5x3fVZ1THBYYfH3/OGEm6Loic
	 U6MI2RqOd4h3r/liQgcSshrVH9MsuHdwwoC/Kx4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 311/571] tty: tty_port: restore TTY_IO_ERROR on activation failure
Date: Wed, 28 Oct 2026 17:57:38 +0100
Message-ID: <20261028170015.377905004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted to the existing activation-failure block with explicit mutex unlocking. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 2f1061a9d9263..3afdbe5ea156d 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -694,6 +694,7 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 			int retval = port->ops->activate(port, tty);
 
 			if (retval) {
+				set_bit(TTY_IO_ERROR, &tty->flags);
 				mutex_unlock(&port->mutex);
 				return retval;
 			}
-- 
2.53.0



