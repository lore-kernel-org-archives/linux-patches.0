Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FA52D9494;
	Thu, 15 Jan 2026 17:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498431; cv=none; b=nf19fbBGt5ykBHIhA/NyiL/hjaeInC1qKpzqVvPNbtfSYmBj45sR1LW2/Q/bl8oE0Iwh9/EslD1BAQAqm+t8RsUVR3DSoJ8VPw0HzxdKsmRgu6a4/DLCxXdOPRwO2VqHsZ+9uXqF0HbCOEQfhxw30cQXHXPVHFUM1DZRhF2Db+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498431; c=relaxed/simple;
	bh=WXGOImubF+m4Qfl9EOErqBUKcfE9YbTP6uQw/PQmE+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=STYcMnoTp4VAhi+7evz+uabdq6Svi6JkEgML5yMQKT4BbTwe8ocoa/zZPksE7HT3X91n30b6KDbU7CzyyAfNCOpoK4lq9amiGdpBgntuEwugf1ZM9s1nSKtGjMYL9XuawElg8zvs/AVXcZy50tpzcgjWBuvJIeYWalGCTDWpCs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njqwsosG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njqwsosG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F392FC116D0;
	Thu, 15 Jan 2026 17:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498431;
	bh=WXGOImubF+m4Qfl9EOErqBUKcfE9YbTP6uQw/PQmE+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njqwsosGGm5dKrujAd5zombiux7edsWdyl27rcBUK5FPCJXzpj4UwplsT2+kaLoU/
	 bIgkQ8gTuGxnD9Tf4ON7BGOR8jfjC5EzS4h52kY0ltkZD0IZuYdhAi3Zj0YSjtS2Y2
	 2TmH29u7lOljJ6TKsEdBoz49duHPGgQRsZr8SJvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 430/554] xhci: dbgtty: fix device unregister
Date: Thu, 15 Jan 2026 17:48:16 +0100
Message-ID: <20260115164301.824187086@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Łukasz Bartosik <ukaszb@chromium.org>

[ Upstream commit 1f73b8b56cf35de29a433aee7bfff26cea98be3f ]

When DbC is disconnected then xhci_dbc_tty_unregister_device()
is called. However if there is any user space process blocked
on write to DbC terminal device then it will never be signalled
and thus stay blocked indifinitely.

This fix adds a tty_vhangup() call in xhci_dbc_tty_unregister_device().
The tty_vhangup() wakes up any blocked writers and causes subsequent
write attempts to DbC terminal device to fail.

Cc: stable <stable@kernel.org>
Fixes: dfba2174dc42 ("usb: xhci: Add DbC support in xHCI driver")
Signed-off-by: Łukasz Bartosik <ukaszb@chromium.org>
Link: https://patch.msgid.link/20251119212910.1245694-1-ukaszb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgtty.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -489,6 +489,12 @@ static void xhci_dbc_tty_unregister_devi
 
 	if (!port->registered)
 		return;
+	/*
+	 * Hang up the TTY. This wakes up any blocked
+	 * writers and causes subsequent writes to fail.
+	 */
+	tty_vhangup(port->port.tty);
+
 	tty_unregister_device(dbc_tty_driver, port->minor);
 	xhci_dbc_tty_exit_port(port);
 	port->registered = false;


