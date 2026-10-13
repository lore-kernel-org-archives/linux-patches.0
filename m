Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C2E4F4D04;
	Tue, 13 Oct 2026 12:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895523; cv=none; b=HM6FIcqaHM2/+kft8sYaMJOF6fIa8CXIf56ZXiJ+ojSrdDF+ymr3jrbsXW7+M5Wsyx2NkpG8c+Gin1jmtj9aoJ16VqCnvHxIiG5b34jxuXxe2tx/Q2cw3sh+QP+kQ8duVMDrIbuIQQG+oRnOOFDrEivX1mV9aIgjCbTmUDM1B1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895523; c=relaxed/simple;
	bh=U+7helNNj+xdhizGA/LxeBEIfh0GNdxOddInnskACuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihScnItabxZCQytm5xriuIgWj9LlI3R32FHUUnSKSEpCE7AGTybuc6BauuP4VrpaPB3FqJpfyFe5USnZZl9kW7yqHUwIrlor1xDCEON+CPDQUeoYMF3qmMH21FSXUZvBB9r2bey1Uc/1Jeg0PXzet79DWCk0gNcJi5Kq4gk7G0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0Wn6ts3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0Wn6ts3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5DB1F000FF;
	Tue, 13 Oct 2026 12:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895522;
	bh=+l8OHT2Qr0qqS4gdc27olrLuydrXiydy1rhujasjF2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0Wn6ts3Ec35hIi2ov/2HwxvMlsKlZfeP//jab9xLhRSvMPrdl51serTXLaleq5Ws
	 XBhYvI8P8ELal2Ha7g8KBGuZZG6S8X3B5sBg41QT8VDrIbxZn9DLbUAm275z8hAZEF
	 bu+A6R5gWEkstP8P09xZMO0DBS+AIMAsYL/CStN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 302/497] tty: tty_port: restore TTY_IO_ERROR on activation failure
Date: Tue, 13 Oct 2026 13:37:49 +0200
Message-ID: <20261013112915.065405173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_port.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 64b2584ff7a18..10d707e3c0344 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -765,8 +765,10 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 		clear_bit(TTY_IO_ERROR, &tty->flags);
 		if (port->ops->activate) {
 			int retval = port->ops->activate(port, tty);
-			if (retval)
+			if (retval) {
+				set_bit(TTY_IO_ERROR, &tty->flags);
 				return retval;
+			}
 		}
 		tty_port_set_initialized(port, true);
 	}
-- 
2.53.0



