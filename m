Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8011D0DE1;
	Wed,  2 Oct 2024 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880536; cv=none; b=ohVmW5QVW7RVDXXbXmpytnLVe04xwhoYKuXqfBwwFaY4PJENaCGnXZ+xEr0EG7a7+d61ZJqZiap27gFRZyIYEyp6QRv5MqY6lkHtquya4bbnt/Ah8mT21NlwnIxKoHwpPqJW6BvjSaNZrQvRoyjkllFzLa/cYlsQU3DliQsDuOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880536; c=relaxed/simple;
	bh=U6H/gL0VPhoSpZwXuQblQfK8RTQ66LtCFmq5EQBDP5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=th1FLx4sOGK/oORycJZmXHwEFb9R8rBk0X/SsRbkHrbRp+RfAi5zIsOU88C4n5XkocJ+HBLgmSU3khuTGnJOYKCPMWEtSNF0Hkto5oVLoMXBr0/QSSlkzOdSf6OuYz4Dr4XiGYsX9EPMNH9iAzUjalY3UEP7XEHp4kYZz/iSoSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHnPZFFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHnPZFFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A891C4CEC2;
	Wed,  2 Oct 2024 14:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880536;
	bh=U6H/gL0VPhoSpZwXuQblQfK8RTQ66LtCFmq5EQBDP5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHnPZFFXXUfoVMte8HmK5QReTZY5z6qIm00xS01kUO2uu0c7M5BnhS8UGYQfphUcC
	 /+h7NDxfeS5wKKNOTuD88hV2vo9A/8El5OqRRpgtbB73PbG8TIa/4/YYyFmDxqal1R
	 vczzlT5Fhyuck3tn8Xn8f05lZZ2fLbD90lSIEYy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 492/538] serial: dont use uninitialized value in uart_poll_init()
Date: Wed,  2 Oct 2024 15:02:11 +0200
Message-ID: <20241002125811.860534212@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit d0009a32c9e4e083358092f3c97e3c6e803a8930 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 3fb55f46a8914..5d5570bebfeb6 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2694,14 +2694,13 @@ static int uart_poll_init(struct tty_driver *driver, int line, char *options)
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
@@ -2721,10 +2720,10 @@ static int uart_poll_init(struct tty_driver *driver, int line, char *options)
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
 
-- 
2.43.0



