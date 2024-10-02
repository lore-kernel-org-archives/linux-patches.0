Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512BF1D1E80;
	Wed,  2 Oct 2024 14:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878788; cv=none; b=db0K2PX40qZP2wjBDtR/tT9uc8KM9Sh7a8ytYwg6Ahnoj5pPNshZROdA2zGEg/JlQpwmfoczhtMo3H086Crt2/rexC2I0KheGQZA3+6m59QuY6exTZ2eILDQ6wrPLotcvAUj0sL36pWbRAfrru1yVhOhKscPV081qaOkEpYuyps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878788; c=relaxed/simple;
	bh=3HZBIve7Fiz27oj78pZ+9832C2+PrI5kL4zvm2TJbZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BrW2fNYH0QGNgFZisSE0viIMr/PQf+B6c7W3u9hP49SRlTsWQoiXjuyk4uenGmTAHv0Fr3yhZ5gQpDbrNsP5UhcQhnPYcZ4J2QZmJurQgF4tmGbnK+oLdyXREd6+Rd8EIyXHDJkoW9Zb1aD4+UVhvuhub+yQyXOC+r4SG7w9jMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/JTLv41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/JTLv41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE711C4CEC2;
	Wed,  2 Oct 2024 14:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878788;
	bh=3HZBIve7Fiz27oj78pZ+9832C2+PrI5kL4zvm2TJbZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/JTLv41Y0DhH2wQKceUmEspcr6maLi9OAjIOLkvpPC8paIn9KwiOWC6QC5gnsoa4
	 JIOceeN1eLwui+HY6r3z5ypeoulGgNcqahQC6vNarnKtmgb19T4IMLvqQQfEUFFvuZ
	 4/1i+H5rlhxTANbwPu97AorM68QCw7c2451K/q0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.10 532/634] serial: dont use uninitialized value in uart_poll_init()
Date: Wed,  2 Oct 2024 15:00:32 +0200
Message-ID: <20241002125832.107421617@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit d0009a32c9e4e083358092f3c97e3c6e803a8930 upstream.

Coverity reports (as CID 1536978) that uart_poll_init() passes
uninitialized pm_state to uart_change_pm(). It is in case the first 'if'
takes the true branch (does "goto out;").

Fix this and simplify the function by simple guard(mutex). The code
needs no labels after this at all. And it is pretty clear that the code
has not fiddled with pm_state at that point.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Fixes: 5e227ef2aa38 (serial: uart_poll_init() should power on the UART)
Cc: stable@vger.kernel.org
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240805102046.307511-4-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2696,14 +2696,13 @@ static int uart_poll_init(struct tty_dri
 	int ret = 0;
 
 	tport = &state->port;
-	mutex_lock(&tport->mutex);
+
+	guard(mutex)(&tport->mutex);
 
 	port = uart_port_check(state);
 	if (!port || port->type == PORT_UNKNOWN ||
-	    !(port->ops->poll_get_char && port->ops->poll_put_char)) {
-		ret = -1;
-		goto out;
-	}
+	    !(port->ops->poll_get_char && port->ops->poll_put_char))
+		return -1;
 
 	pm_state = state->pm_state;
 	uart_change_pm(state, UART_PM_STATE_ON);
@@ -2723,10 +2722,10 @@ static int uart_poll_init(struct tty_dri
 		ret = uart_set_options(port, NULL, baud, parity, bits, flow);
 		console_list_unlock();
 	}
-out:
+
 	if (ret)
 		uart_change_pm(state, pm_state);
-	mutex_unlock(&tport->mutex);
+
 	return ret;
 }
 


