Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1555168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4083DC433D2;
	Mon,  8 May 2023 10:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543244;
	bh=GRAUdwK3g0uB6qbs4mc8HpcNgecEEAsCozKvvrhm46g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uufdom9bfeAhHDYxAWHAjYaAH5VYSdAUTGryx+CJRsjlupFeI3cmTTuu6j3X8a8FN
	 pFnFmCV+bJhrprecC509az4DruL3dgyOXYadOokzBqXVGEuRm7KJByiM738zrftBPs
	 ezCRFoKsVrBosT1nTRJvuvKFcxHVDmMmQoDBrPRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.3 029/694] serial: fix TIOCSRS485 locking
Date: Mon,  8 May 2023 11:37:44 +0200
Message-Id: <20230508094433.591864458@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan@kernel.org>

commit 9e4f2a8004213339e9d837d891a59cc80e082966 upstream.

The RS485 multipoint addressing support for some reason added a new
ADDRB termios cflag which is (only!) updated from one of the RS485
ioctls.

Make sure to take the termios rw semaphore for the right ioctl (i.e.
set, not get).

Fixes: ae50bb275283 ("serial: take termios_rwsem for ->rs485_config() & pass termios as param")
Cc: stable@vger.kernel.org	# 6.0
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20230412124811.11217-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1552,7 +1552,7 @@ uart_ioctl(struct tty_struct *tty, unsig
 		goto out;
 
 	/* rs485_config requires more locking than others */
-	if (cmd == TIOCGRS485)
+	if (cmd == TIOCSRS485)
 		down_write(&tty->termios_rwsem);
 
 	mutex_lock(&port->mutex);
@@ -1595,7 +1595,7 @@ uart_ioctl(struct tty_struct *tty, unsig
 	}
 out_up:
 	mutex_unlock(&port->mutex);
-	if (cmd == TIOCGRS485)
+	if (cmd == TIOCSRS485)
 		up_write(&tty->termios_rwsem);
 out:
 	return ret;


