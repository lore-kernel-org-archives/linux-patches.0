Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C6D2FE060;
	Tue,  6 Jan 2026 17:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721384; cv=none; b=P2J9omE0KYNYMM8Y5/Oy8IIjW9IZXyvNk6FAd1OXhax4yE4k0rMdlZ54y2tvqnmGHCncgVM5cF/x059j+qkGFYUd+t6zgr1UPucFcUiyK0RFxJJU5j3SLzylOOK7qnIk9qUHqxmAef6uD/CnJR9QQmf2Oudb3MdzCU7t17LJpqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721384; c=relaxed/simple;
	bh=I26dojZirt+Uflss8j45wiHWa77VSGlU1zlMwpWOKPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fb/DkHGs9JcEgVUw/I5SdCMkyNn9xgpuGW9RCXj3FfN0NZ7S9INxxYI8N5OiT/ftKQtZt5EU3wJng3QfWySw7/GY3GASOQCD4GdLM9LSdT4NrWm0DQbiXqc2ZsPvs/CFXT/SL3WfiX1IwgPeOILV3eSve3ZpnaKnwNA9jtiAD5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Raor8bd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Raor8bd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503CFC116C6;
	Tue,  6 Jan 2026 17:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721384;
	bh=I26dojZirt+Uflss8j45wiHWa77VSGlU1zlMwpWOKPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Raor8bd3FNmI2VgF490Zf3BWyoZHz25dXnPrsNdzaw3JjUYuiOU6mp7ZGx8GHKptj
	 cYpkmeASeGRLbAvkBoDnUBM3v7pmkt2zGZhli8TBBhKvdwss+6Fbm/hzUUG+Nv+hSX
	 TeHwIjS26ZHBGnfQ++2b+dS+EwAjLMOi2I3yBPPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 493/567] xhci: dbgtty: fix device unregister: fixup
Date: Tue,  6 Jan 2026 18:04:35 +0100
Message-ID: <20260106170509.599329945@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Łukasz Bartosik <ukaszb@chromium.org>

[ Upstream commit 74098cc06e753d3ffd8398b040a3a1dfb65260c0 ]

This fixup replaces tty_vhangup() call with call to
tty_port_tty_vhangup(). Both calls hangup tty device
synchronously however tty_port_tty_vhangup() increases
reference count during the hangup operation using
scoped_guard(tty_port_tty).

Cc: stable <stable@kernel.org>
Fixes: 1f73b8b56cf3 ("xhci: dbgtty: fix device unregister")
Signed-off-by: Łukasz Bartosik <ukaszb@chromium.org>
Link: https://patch.msgid.link/20251127111644.3161386-1-ukaszb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgtty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -522,7 +522,7 @@ static void xhci_dbc_tty_unregister_devi
 	 * Hang up the TTY. This wakes up any blocked
 	 * writers and causes subsequent writes to fail.
 	 */
-	tty_vhangup(port->port.tty);
+	tty_port_tty_vhangup(&port->port);
 
 	tty_unregister_device(dbc_tty_driver, port->minor);
 	xhci_dbc_tty_exit_port(port);


