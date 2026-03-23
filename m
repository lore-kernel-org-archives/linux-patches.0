Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5DE23B62C;
	Mon, 23 Mar 2026 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277178; cv=none; b=O0Kl1YQHlFmiFo6v6N7xwUVeKBH/JDCCiZ32K49wk437yL/Mwsl23pmOpICGP6s7pz7603oYK+GZ+u1NIGvLWFhck6WeA9hOJltS0DqHJqy4NGUoa0twPQnLZO+M8iFflm9TIyBdlp2VICgUqg1DSmBixmuJl6uSEo3Ol0DZwp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277178; c=relaxed/simple;
	bh=MDCfz7qGMKe+62ZP4i/CQfsMicI54B1MBm0vxf1CHKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfC25LTeYnfD6sInPz/p4gVrHSw8xOXxW9Ltg1udZFn4G1JobeQ2KqLFppXroXmYnTEcE5YxgPmGDm5GjBhRttCezALJMHQmpfne1wgwzgCt9t3ApmaSI8pzGlFWV/vJreVnbu9uVU5lV4hp97zV2yq6NYXmhEU8ehC4OyAiTw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPNhR3ia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPNhR3ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2232CC4CEF7;
	Mon, 23 Mar 2026 14:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277178;
	bh=MDCfz7qGMKe+62ZP4i/CQfsMicI54B1MBm0vxf1CHKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPNhR3iaM1TZxZUn8oIM52LypV3CIax1e1I7b6B2xXewktFIEdelQg/NFGfZthJTt
	 pB6ObEU5556HrxcEvfZBFQODmtfN4V3X2TM3BPNNeMw1ROaj7Rc1QdOdxopfkCB/XY
	 KCwxwhMsu0lcpgO1b1AVhn8iy4hvjLKlfgHCFzKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Maciej Andrzejewski ICEYE <maciej.andrzejewski@m-works.net>
Subject: [PATCH 6.12 347/460] serial: uartlite: fix PM runtime usage count underflow on probe
Date: Mon, 23 Mar 2026 14:45:43 +0100
Message-ID: <20260323134535.074073277@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -878,6 +878,7 @@ of_err:
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, UART_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_get_noresume(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
 	ret = ulite_assign(&pdev->dev, id, res->start, irq, pdata);


