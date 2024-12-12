Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAE8215041;
	Thu, 12 Dec 2024 17:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025471; cv=none; b=KfgOiG80QgZ2wlUa0U02ejfd/OgiEgIAV22GcQdq5ATj/WcgCnNBH5sW4bBB8BrslDtoh6936sBakaW1Ddr7owX5CvaeWEEgM9Qf2zNv+PsQp0C9Ljkoex3I19TxDO6qcvcUymHmMPKWT8M1QSCBKPKCvXyG10N9t0GO7JGHJqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025471; c=relaxed/simple;
	bh=CCwzZ5lyGnP1rLLJ8CnVuCiBkWlmtT+x9pe+iO0LoYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAZupP0C9wbHCElwUGHLthR6ReGsJst1QKP9okE7J8v7vhMpCGqF8+fjNpiF7Db7Y4+P1JNssdAPelWUfp1BB1kl5GP6wXwZT1dxF6DFFdm/X6KoiSP0c+l0s10gdmZOzpmoIkIYYRKiHiSqmCg4rSw1LgUGiM7k9XnlsI+/Q9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iip6SGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iip6SGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D958C4CECE;
	Thu, 12 Dec 2024 17:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025470;
	bh=CCwzZ5lyGnP1rLLJ8CnVuCiBkWlmtT+x9pe+iO0LoYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iip6SGQNIEHQbW9Ym4RD31UlthJPqvPqlZhtRNJYydFWSbPCocWccjKlFRP1MH9m
	 07rLdtwkcfr2TFieFb3a9oFa/SuJ8ObemafRqMYph7SqoQYwlyWN7EJt262OKXYo8P
	 IffjXy0kcscfmivPCSptsgMN+QmT8wpOPFvp3Zss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 139/321] staging: greybus: uart: clean up TIOCGSERIAL
Date: Thu, 12 Dec 2024 16:00:57 +0100
Message-ID: <20241212144235.470358291@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit d38be702452137fa82a56ff7cc577d829add1637 ]

TIOCSSERIAL is a horrid, underspecified, legacy interface which for most
serial devices is only useful for setting the close_delay and
closing_wait parameters.

The xmit_fifo_size parameter could be used to set the hardware transmit
fifo size of a legacy UART when it could not be detected, but the
interface is limited to eight bits and should be left unset when not
used.

Similarly, baud_base could be used to set the UART base clock when it
could not be detected but might as well be left unset when it is not
known.

The type parameter could be used to set the UART type, but is
better left unspecified (type unknown) when it isn't used.

Note that some applications have historically expected TIOCGSERIAL to be
implemented, but judging from the Debian sources, the port type not
being PORT_UNKNOWN is only used to check for the existence of legacy
serial ports (ttySn). Notably USB serial drivers like ftdi_sio have been
using PORT_UNKNOWN for twenty years without any problems.

Drop the bogus values provided by the greybus implementation.

Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-8-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: fe0ebeafc3b7 ("staging: greybus: uart: Fix atomicity violation in get_serial_info()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/uart.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
index 0e6bebc20695d..b8da6dc5d4d4d 100644
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -621,10 +621,7 @@ static int get_serial_info(struct tty_struct *tty,
 {
 	struct gb_tty *gb_tty = tty->driver_data;
 
-	ss->type = PORT_16550A;
 	ss->line = gb_tty->minor;
-	ss->xmit_fifo_size = 16;
-	ss->baud_base = 9600;
 	ss->close_delay = jiffies_to_msecs(gb_tty->port.close_delay) / 10;
 	ss->closing_wait =
 		gb_tty->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
-- 
2.43.0



