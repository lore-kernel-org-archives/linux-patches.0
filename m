Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270EE19DF5F;
	Thu, 15 Aug 2024 14:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730632; cv=none; b=Tfs603JUC+XUih24AwWzU5UWwJY/YN2SmQNqYFG9xovt2IcMMwhCgSSblm8V+1ADsRm4FIz6H8qybjNsxGWN3gckLHD1RhDbofd3d/kLg3Wv9x0/0n6eydaHbEbmCmdL8cdzWl7axBZSPlSVJz9uu+D1r8RrluBqlA8eHFFj5L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730632; c=relaxed/simple;
	bh=T3ZzHXVa+6ABWsbCdFkhCdCwT5AdGrz7wIqmOUJS7is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gg7cHiLLGgXeIKV6Dfh1ruHLB9h6SXiCKGv8ufkkSpgXGdKP8+/gNc0TYijvaw/VoDCOG+omYpUBy9NPZ8AsejOZ0ayi76W5bsM9F26KRcjrgfKdX2+kDbRA4dsVsTuR7fkyZ/NQqbRqQnny3rE6v5IK+8kdMKqlUgy7fcH1Tp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=188ZZFUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="188ZZFUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF32C32786;
	Thu, 15 Aug 2024 14:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730632;
	bh=T3ZzHXVa+6ABWsbCdFkhCdCwT5AdGrz7wIqmOUJS7is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=188ZZFUkt7hLyBAHswCfi3K6cmSfng4o39j8P1OFsUKhzuMKSQ2W/RUphQT+5mIfP
	 gR6eoKIlI+07nxlrRBF5r6tVnP0w93fenRV+2ikqut+PW89P+3pXynNdJTKZxvWGa3
	 fQ0lxJZ2sQRuEu0XfrQYo8DmTgOy+ztIdoq3xeik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	George Kennedy <george.kennedy@oracle.com>
Subject: [PATCH 5.15 438/484] serial: core: check uartclk for zero to avoid divide by zero
Date: Thu, 15 Aug 2024 15:24:56 +0200
Message-ID: <20240815131958.375437770@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Kennedy <george.kennedy@oracle.com>

commit 6eabce6608d6f3440f4c03aa3d3ef50a47a3d193 upstream.

Calling ioctl TIOCSSERIAL with an invalid baud_base can
result in uartclk being zero, which will result in a
divide by zero error in uart_get_divisor(). The check for
uartclk being zero in uart_set_info() needs to be done
before other settings are made as subsequent calls to
ioctl TIOCSSERIAL for the same port would be impacted if
the uartclk check was done where uartclk gets set.

Oops: divide error: 0000  PREEMPT SMP KASAN PTI
RIP: 0010:uart_get_divisor (drivers/tty/serial/serial_core.c:580)
Call Trace:
 <TASK>
serial8250_get_divisor (drivers/tty/serial/8250/8250_port.c:2576
    drivers/tty/serial/8250/8250_port.c:2589)
serial8250_do_set_termios (drivers/tty/serial/8250/8250_port.c:502
    drivers/tty/serial/8250/8250_port.c:2741)
serial8250_set_termios (drivers/tty/serial/8250/8250_port.c:2862)
uart_change_line_settings (./include/linux/spinlock.h:376
    ./include/linux/serial_core.h:608 drivers/tty/serial/serial_core.c:222)
uart_port_startup (drivers/tty/serial/serial_core.c:342)
uart_startup (drivers/tty/serial/serial_core.c:368)
uart_set_info (drivers/tty/serial/serial_core.c:1034)
uart_set_info_user (drivers/tty/serial/serial_core.c:1059)
tty_set_serial (drivers/tty/tty_io.c:2637)
tty_ioctl (drivers/tty/tty_io.c:2647 drivers/tty/tty_io.c:2791)
__x64_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:907
    fs/ioctl.c:893 fs/ioctl.c:893)
do_syscall_64 (arch/x86/entry/common.c:52
    (discriminator 1) arch/x86/entry/common.c:83 (discriminator 1))
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

Reported-by: syzkaller <syzkaller@googlegroups.com>
Cc: stable@vger.kernel.org
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Rule: add
Link: https://lore.kernel.org/stable/1721148848-9784-1-git-send-email-george.kennedy%40oracle.com
Link: https://lore.kernel.org/r/1721219078-3209-1-git-send-email-george.kennedy@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -836,6 +836,14 @@ static int uart_set_info(struct tty_stru
 	new_flags = (__force upf_t)new_info->flags;
 	old_custom_divisor = uport->custom_divisor;
 
+	if (!(uport->flags & UPF_FIXED_PORT)) {
+		unsigned int uartclk = new_info->baud_base * 16;
+		/* check needs to be done here before other settings made */
+		if (uartclk == 0) {
+			retval = -EINVAL;
+			goto exit;
+		}
+	}
 	if (!capable(CAP_SYS_ADMIN)) {
 		retval = -EPERM;
 		if (change_irq || change_port ||


