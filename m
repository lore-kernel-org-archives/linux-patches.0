Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B498358D38;
	Fri,  9 Jan 2026 12:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963195; cv=none; b=gKNXtdGNDjnZX3DBF5QNp4gCZMfO1hReoHPi+H+i8Agu+Mku1cUOiovYZANsatbjEwmle8kG/pC9oIKl7zLQIB8KsPfCkYSyURT1C9/Pl0QErbczQWfi6X/lMZCv3THy1jpIQPUKfMRRrVAPMV0huQ+PCrYnINcgSEvszCtJWVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963195; c=relaxed/simple;
	bh=UIx/PLsbTaStOoRIWqe6Mu0lRdTOe1sR6Y9xihJK3N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uCVfoA/fsVJEAlWj4mfOcVzLoQEVLJ7O8VS/hkZs4/nIzaKNXfVyatN2fXA5djPOJXU3KLNQp5cYfBG2/HGcVV9QxejME6ZE5ZkvJSi47zqQxwAY1zvfLUtcqNmAueMdRIXPYpSSePKu0QDGRjdgdayjcfpnr9Z41leDLWzHRe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDHT5lsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDHT5lsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E807AC4CEF1;
	Fri,  9 Jan 2026 12:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963195;
	bh=UIx/PLsbTaStOoRIWqe6Mu0lRdTOe1sR6Y9xihJK3N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDHT5lsHYv62PpXiOjOoHFoceiXl1FGrLlcg4pWI6cf/LsOafxI49vWxFt2SdNAjK
	 YWyWQ+GfBpc8F5GmtC7Nppgdmjq9lxQ1f+ObrVazxt340X8h/gIJymVoxNatbt07z+
	 qI0p8IccqXEpzqrG0C1Vnj0vkkT3+Au7XOFjM1hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 598/634] xhci: dbgtty: fix device unregister: fixup
Date: Fri,  9 Jan 2026 12:44:36 +0100
Message-ID: <20260109112140.128818291@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -523,7 +523,7 @@ static void xhci_dbc_tty_unregister_devi
 	 * Hang up the TTY. This wakes up any blocked
 	 * writers and causes subsequent writes to fail.
 	 */
-	tty_vhangup(port->port.tty);
+	tty_port_tty_vhangup(&port->port);
 
 	tty_unregister_device(dbc_tty_driver, port->minor);
 	xhci_dbc_tty_exit_port(port);


