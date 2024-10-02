Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888311D016E;
	Wed,  2 Oct 2024 13:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876857; cv=none; b=MzhTa9qIdvLQ9JbiHZmdMY+Exj1zLTVwi7LdVvH5iC6s2TvPSRnzT0Wj2qR3Mu6NNK2B1y+2P2U5Ew3Go4wlL+D5ARIf41lyV++33w5WbcJFR0J7t7+J0+tEJKda0eK9tpfoScWcQcbeHwpGhJm3MfoyniJPpsaadyH2AVESdb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876857; c=relaxed/simple;
	bh=Uh8LoahnWVSf/guHNR5hHaoS695RaTp/gjL/FnzxIis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1uC9Cgp6vJ4mQL+ABh6fk+ddZA5IPvk6iHKKAHBUxj8UcVZIIvuAJ9LoxiUb+jW3H0Ciu3pqaT+04fHo2IzbWdinMUP3MGsj+NMnCc6bI9s17sW5Gra4Mz6zGhoQqIRFwQT0HJqTcky0caiKTXu6WN8jf45aihcCi/n4veF21M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13wT6fBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13wT6fBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8BCC4CEC5;
	Wed,  2 Oct 2024 13:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876857;
	bh=Uh8LoahnWVSf/guHNR5hHaoS695RaTp/gjL/FnzxIis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13wT6fBk58nVUbCc4/HYBhOhwLL7sSbLxwnGZzdbAuaH1r+yDHzHfr/tlhWvnlAIU
	 AGH2Y+SrLFZVh5ye9p9QNGh3h2alEJBRnS7NJCBHbeedLfelObM1n1iLDtiwhiGLTl
	 AXkly3rzKvEFikEfg5e0aXb4NVNw4jEo19Rcv4IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.11 583/695] USB: class: CDC-ACM: fix race between get_serial and set_serial
Date: Wed,  2 Oct 2024 14:59:41 +0200
Message-ID: <20241002125845.785464707@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -962,10 +962,12 @@ static int get_serial_info(struct tty_st
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
 


