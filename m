Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A68B214A9B;
	Thu, 15 Jan 2026 17:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499789; cv=none; b=jYZkRU8Qi16WDg7oAIMVmZD+/fz1vdgN9br239HZ+dJyhetwjbesrbZBjjJVkXXxvS1WclfkFtWWZiHKepKWWvSb79OCnlI6zdYBiuZjU22OQpzsdwfPLZMwURZEydQO6+sUrleDF8D8SP3INNDomI5vpkjPHOhtIkvwUsCRaXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499789; c=relaxed/simple;
	bh=athYsHsmCtEUrbUfZWYgW7cOekBHRtAtWrmbqG9R6ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BAMxSnI66cPZsbpcpsQsIFmWN5l3O1XehHibTtu61i80mOod+vvmq61ccCpVMp2cf3YJxkzT8ye/LWmpzndWWOOPM3qZafdgkdS8OGA7dBtTr4EaVFc+Xyg2qS8+ym20uI0R69OY/Ke7iLw9cvwies6CKS/lv+fhwQzzqlJ9tuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v32d8X0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v32d8X0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896C9C116D0;
	Thu, 15 Jan 2026 17:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499788;
	bh=athYsHsmCtEUrbUfZWYgW7cOekBHRtAtWrmbqG9R6ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v32d8X0gpLKzJiu+XSzKn/9tG5pjV1G7STvRqqow+J7kjd8Pe8d9DHyviJlNt8YOq
	 HQEGiZ2dbCllm9SbTcEh3P9cxLzZ+wqekq9/rZ5x0tf9TBSDutp6jNB0mlqP19uoWF
	 DheBxGK2MbXb5Js1qt5xQNSI9btmgkiU7iKRSR/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 351/451] xhci: dbgtty: fix device unregister
Date: Thu, 15 Jan 2026 17:49:12 +0100
Message-ID: <20260115164243.599453309@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgtty.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -468,6 +468,12 @@ static void xhci_dbc_tty_unregister_devi
 
 	if (!port->registered)
 		return;
+	/*
+	 * Hang up the TTY. This wakes up any blocked
+	 * writers and causes subsequent writes to fail.
+	 */
+	tty_vhangup(port->port.tty);
+
 	tty_unregister_device(dbc_tty_driver, 0);
 	xhci_dbc_tty_exit_port(port);
 	port->registered = false;


