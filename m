Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF05F1DA0E1;
	Mon, 23 Mar 2026 16:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282831; cv=none; b=UTZo0L7gDcOD0aUZ87ggYpdx4ogDC7n8yeQ3OwEJc1lzk0wdD8kdzeu/qkWYPcI8LNOBa0E4qVn24/RmICourzFJ4aMTORxrptxBY2YMbjA7S9Rxz5PHkxIUFjhOq1z8xrn8re3dj50JTodHd7aoqw+o4QZFRPkF5fPgo5QrfeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282831; c=relaxed/simple;
	bh=fPd1vEog3JNCb2uIVgbzF3vg1kdqXjyT6VmXNJO16g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eV3KMei1xRir8Tc2g0Hxvnw9kDD35YjmL0WA8SjRiPGuoKPZ+DSo8o93YqBN+AsmVASIJ3Xz3zwjzxMXGbmATGzPyH0VjneqPEeGLeMhO3/Z8ToFLFkcwf4hRyagKg8zk0FzhrMQuL1s89FAnG30UsmYQG/6m8EQJrOxlc4EZh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TSdhwnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TSdhwnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9C0C2BC9E;
	Mon, 23 Mar 2026 16:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282831;
	bh=fPd1vEog3JNCb2uIVgbzF3vg1kdqXjyT6VmXNJO16g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TSdhwnPaM4hvKK4LlUPZDHOruCESaxjSeG1Q2UcPBFvDRMutZfbA5BwtaE7itrP0
	 N+7lLfclYOqfSdGYdoKp64c4/nvL8SWkUBBK3tEnYOq0rXX7SMseEK5EmZIkc1CT4t
	 g/dymyQhmfBsAUN4wjzgfITi6vw3iRMlgI/xPwAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Maciej Andrzejewski ICEYE <maciej.andrzejewski@m-works.net>
Subject: [PATCH 6.1 302/481] serial: uartlite: fix PM runtime usage count underflow on probe
Date: Mon, 23 Mar 2026 14:44:44 +0100
Message-ID: <20260323134532.472849259@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Andrzejewski ICEYE <maciej.andrzejewski@m-works.net>

commit d54801cd509515f674a5aac1d3ea1401d2a05863 upstream.

ulite_probe() calls pm_runtime_put_autosuspend() at the end of probe
without holding a corresponding PM runtime reference for non-console
ports.

During ulite_assign(), uart_add_one_port() triggers uart_configure_port()
which calls ulite_pm() via uart_change_pm(). For non-console ports, the
UART core performs a balanced get/put cycle:

  uart_change_pm(ON)  -> ulite_pm() -> pm_runtime_get_sync()        +1
  uart_change_pm(OFF) -> ulite_pm() -> pm_runtime_put_autosuspend() -1

This leaves no spare reference for the pm_runtime_put_autosuspend() at
the end of probe. The PM runtime core prevents the count from actually
going below zero, and instead triggers a
"Runtime PM usage count underflow!" warning.

For console ports the bug is masked: the UART core skips the
uart_change_pm(OFF) call, so the UART core's unbalanced get happens to
pair with probe's trailing put.

Add pm_runtime_get_noresume() before pm_runtime_enable() to take an
explicit probe-owned reference that the trailing
pm_runtime_put_autosuspend() can release. This ensures a correct usage
count regardless of whether the port is a console.

Fixes: 5bbe10a6942d ("tty: serial: uartlite: Add runtime pm support")
Cc: stable <stable@kernel.org>
Signed-off-by: Maciej Andrzejewski ICEYE <maciej.andrzejewski@m-works.net>
Link: https://patch.msgid.link/20260305123746.4152800-1-maciej.andrzejewski@m-works.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/uartlite.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -874,6 +874,7 @@ of_err:
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, UART_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_get_noresume(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
 	ret = ulite_assign(&pdev->dev, id, res->start, irq, pdata);


