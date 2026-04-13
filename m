Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8AE26CE32;
	Mon, 13 Apr 2026 16:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097633; cv=none; b=Fh8dMI+JrdV5VZ6kdGAsJjXdcdLTXSktQ5l9bM27iho941asxYNagFDh6ez99A3635duriQeYaSdkPDEg94NDlMb7Cv0wQGiYidYLhpj9jLV1zwNaaf0p+lR9tIRpdHdI1ahYuP6WGFzAgNir649Q4vaJvIE5Q9/lavTeKeb4nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097633; c=relaxed/simple;
	bh=kOROCHNRdYVllR0b+d+UBfE7vK6CRrUfbG+d/Ty7vfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TF89oYq6WANVRr6lH0qglCQbcSC518Sr8TC0j6kldbJ7sXh2RAbU7Xl4aNRUsTcAp2pJYWLgGz1VHNMhzy0v/5KlgWvVJXGr5XhHCsyrj5TEkv+bq7WTXmwjzaHXyXmd2y5WhzF/LhIsnQ9lEo2mAXApdOOqt/jsSlscianKNrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTQ/iS1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTQ/iS1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC58C2BCAF;
	Mon, 13 Apr 2026 16:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097633;
	bh=kOROCHNRdYVllR0b+d+UBfE7vK6CRrUfbG+d/Ty7vfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTQ/iS1Mlb/Bz+dZV7kwnl9VszIFcuqNaP27ioRNsgdT9jDWRE0p+gTnA5npvVUxa
	 8qNNzVFC6GFCOAApRRmWeUexy6lGrxN9O6aBOm3IWxZST0j6LnN7ygRc8fNkh5bih3
	 vLKxS0j4zi9FtKXwD85JMZiO8M9QrFPTvwVCuC3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Maciej Andrzejewski ICEYE <maciej.andrzejewski@m-works.net>
Subject: [PATCH 5.15 212/570] serial: uartlite: fix PM runtime usage count underflow on probe
Date: Mon, 13 Apr 2026 17:55:43 +0200
Message-ID: <20260413155838.397325814@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -806,6 +806,7 @@ static int ulite_probe(struct platform_d
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, UART_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_get_noresume(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
 	ret = ulite_assign(&pdev->dev, id, res->start, irq, pdata);


