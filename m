Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0801D0492;
	Tue, 15 Oct 2024 11:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993239; cv=none; b=Jmq+JspOLkVsKcFaKc6z6PQhxpab6Q+UQjN6vgAvvMpVNZ4DbOMYJ0XCej15HFAnFRxJYe3a4IZeNUKB6PnBnObqnltDcuX7uf9FARVBDNkTFxf11h+eAN+Y/b0Gya//fmDBAq/afSyx4S8T4cwNkTqZ/3a0BziUCbBivArXmcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993239; c=relaxed/simple;
	bh=WbunqHXtw60Yg4/+ZP/HiKrIvzC148w+yUqjuc5/x9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nn1V0FnOQJnNvBQJtPK14jnPEXlZpBfG3U3kl3fALwuEhn4jLqUdJdLqHTWI7lqYYrGXuqdiwLbpAQdQKHwcSlwo7lXlgWdLPKjKqdWI8jP3ixmfJckizkqLM99N0BLyEQYL/EElc0ABNytHuq7R6FXNjhkXZt9qYC7VsyN30Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIQXiLuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIQXiLuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EE7C4CEC6;
	Tue, 15 Oct 2024 11:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993239;
	bh=WbunqHXtw60Yg4/+ZP/HiKrIvzC148w+yUqjuc5/x9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIQXiLuz3qkxShp9x5k0C8QTehxJcQV9agsNsqlCkOBvUpw14tzypE1OvE0XtlZP+
	 99BRty+sJEAxyDHF/JosCctISUucbES5wMBd4grZB/MUzds9jMxwb1pp3u92hRYAnp
	 rxJgWkNQBFZ0FaZhz6PTRk/TmCAyToDNQYTZpO+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 321/691] USB: class: CDC-ACM: fix race between get_serial and set_serial
Date: Tue, 15 Oct 2024 13:24:29 +0200
Message-ID: <20241015112453.078184076@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

commit b41c1fa155ba56d125885b0191aabaf3c508d0a3 upstream.

TIOCGSERIAL is an ioctl. Thus it must be atomic. It returns
two values. Racing with set_serial it can return an inconsistent
result. The mutex must be taken.

In terms of logic the bug is as old as the driver. In terms of
code it goes back to the conversion to the get_serial and
set_serial methods.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Fixes: 99f75a1fcd865 ("cdc-acm: switch to ->[sg]et_serial()")
Link: https://lore.kernel.org/r/20240912141916.1044393-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -942,10 +942,12 @@ static int get_serial_info(struct tty_st
 	struct acm *acm = tty->driver_data;
 
 	ss->line = acm->minor;
+	mutex_lock(&acm->port.mutex);
 	ss->close_delay	= jiffies_to_msecs(acm->port.close_delay) / 10;
 	ss->closing_wait = acm->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
 				ASYNC_CLOSING_WAIT_NONE :
 				jiffies_to_msecs(acm->port.closing_wait) / 10;
+	mutex_unlock(&acm->port.mutex);
 	return 0;
 }
 


