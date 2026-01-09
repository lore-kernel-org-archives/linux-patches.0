Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C197226ED41;
	Fri,  9 Jan 2026 12:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961199; cv=none; b=Q6Fspn1FKPUsP5rrxAowxPM4UloumGz9oZAiO7RJCkZ0uEN8//1yJi5ubKZQ6FYz9ep+r/E/Hn2cr4C3MMpOixF1mlhAbFJmAhjxmArhJzH8WwgZR71oC3Xbl05v2EPf9o2J60Y1c7Rl1WkRtEw3s/hLgwmHk0UK8KQ7SfmS9NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961199; c=relaxed/simple;
	bh=ajmXznLHH7K9v1tURci6vhdTot1IPQ3MWr9ngvy6fno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iJ4SKdpMuC8MbPi9gVZ0z2UYTPjjrez6oiNNiG82s0+dQ7gDjEKN3wqOv62nbgpxauI8IycKeddsFDa9lGcBE+9+ia4oGrrte69ZJZourziqTjw3xs3oqNnbmzWvC4AN3Yk8+u+n30UbPlfMsj84LYAWEnKEmK14pi3fIaoWdJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7y8m2fr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7y8m2fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FFFC4CEF1;
	Fri,  9 Jan 2026 12:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961199;
	bh=ajmXznLHH7K9v1tURci6vhdTot1IPQ3MWr9ngvy6fno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7y8m2frRavlT704oQVaJqOJFZG+j3T/wfts51slLwoE0uscay5B3ftIG/MWm90bc
	 isl+Ll651qh9LeOfRPrKRfLV7si7tSH+YQHHGuXEibKXHAnrEjm7xD8VhTB6peaQ8K
	 96DQrQSa+8sFjuIi7Mv2tG0IJJi6zdRrtmPm/pFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 668/737] xhci: dbgtty: fix device unregister: fixup
Date: Fri,  9 Jan 2026 12:43:27 +0100
Message-ID: <20260109112159.172694969@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


