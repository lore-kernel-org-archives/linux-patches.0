Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41D22D73A6;
	Sat, 17 Oct 2026 17:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256923; cv=none; b=kFMoFuEU8rBm3T8VoOWve7MbQ9kmvcdFAvh6b//yA95CDL9hfq7HZ54cjyhne5efkntjtGRDkDH5Ah1Nd1h+ixKwKsLS/fYFJxVPTNg19cVmH6M2NT9a0Ch8GVvxwLwWEFFQLuWTbZBWE5Sco7kZ4QxxFnIxjYbO1IylxQUZ+OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256923; c=relaxed/simple;
	bh=yc85IXbihi5d/YrHsITz979syULXq+ArxISeXF4nKHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiKjV+6f27+2/pr6TIMyDguTGLSFESzWkBs6ghrw3Zig6Z9AVaXoSPEB9M+ir7Rc561EiOeTX4uIDDLGX6bIZ1XhWu3Rkry6haRjXzn18UXsy5O70cmyl8QlEg3zwVfyuAZd0IsI+H/xuivzH6tBrq6YiTxKzYKX+uYa+KWO1uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7wR6tIt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7wR6tIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E4E1F000C4;
	Sat, 17 Oct 2026 17:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256922;
	bh=iLXRjSMq4KoUuTlJdRL62PmSeZs0kgklht/5N/Q7amw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7wR6tItM9VROHDoX92PN0FOfw1CNvY5NaMZP6Pk1JpVyVow763PNmoxPVIR7mtnc
	 meTbZS5orjC6QXTZ4yEfUNSMKVBMvuTjA3zlttw27UjqQYx2Yr4RnuY7dLixhPpOYu
	 g7mbExL7Wf7L9R3Yin+c1WmacO1qaojgVK3Gkzjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 0396/1674] tty: tty_port: restore TTY_IO_ERROR on activation failure
Date: Sat, 17 Oct 2026 17:44:28 +0200
Message-ID: <20261017160441.277970320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted to existing explicit mutex unlocking instead of automatic cleanup. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 21430e64b4128..7ee96882e0e48 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -781,6 +781,7 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 			int retval = port->ops->activate(port, tty);
 
 			if (retval) {
+				set_bit(TTY_IO_ERROR, &tty->flags);
 				mutex_unlock(&port->mutex);
 				return retval;
 			}
-- 
2.53.0



