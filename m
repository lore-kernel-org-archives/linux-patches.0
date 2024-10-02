Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7CF17B421;
	Wed,  2 Oct 2024 13:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876992; cv=none; b=QJgM88bxnFEXz53/Qsf930jlblkilZ5SMXawgl8ExKYpG8EUeDgQwcRz4owBVhusMJMSdBKOF5vfv7AdTWi7dP8zkeubucn5fx5JdlATBig97GO3hsH26LL5qJHw4VA3q8sTH1KFFZcSLfr53+LgAwgAv7i+D7wsQd00u54+5yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876992; c=relaxed/simple;
	bh=Fa8AWgeoEqBXEIgpu3M+RqAlxP7a/Zv7+9iFkOW6FmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nSO9A9tZZEe0/UpfVK9um2MzW0vjwS4V71A/1lqo9UDvCPc+w80de9qd7tmMmSJJjKj4Fg5ANanw2N45LuWYGgQf/KEj7gBxTHiGggkU/UiUMalva0y6u+0lzqDlTco6uUDbxSM4eqf1AKHIUpkewpa7JY271TzQw+HE0D+sEzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZDJ36B3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZDJ36B3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A18C4CEC2;
	Wed,  2 Oct 2024 13:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876992;
	bh=Fa8AWgeoEqBXEIgpu3M+RqAlxP7a/Zv7+9iFkOW6FmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZDJ36B3x2UjDpVy5HmmofwJxW7ydm37rS5+pF1A/cGI6MaPDRl9leg09m29x1RjG
	 Ttwov9XrVegaGkVCMRwLNp5U038+gribn/I3AXrdRs4DaTbYwiD7y6FGm1TBUDRIv0
	 +Pc2B9OQj+v5QeB+LgBZrR1ZW4ZAU5HovE0HEyGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.11 596/695] serial: dont use uninitialized value in uart_poll_init()
Date: Wed,  2 Oct 2024 14:59:54 +0200
Message-ID: <20241002125846.302125955@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 


