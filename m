Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE8133E355;
	Thu,  2 Jul 2026 16:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011140; cv=none; b=K8960cWsUMnsni+MoURNTEc8bjlXAvKtd16RcHMLTOI10d5sNoiEDRZAOqdi3iTu2ithwPEpVYhdOD6Afv6c0QBvXgX0pQ8BKMrRqsWG1HSNq/4n0cZGI4pH5pQuw1nFFRVCTZuvH3hs1LNai9RDG+oERZzS/N5PDFBjDE259b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011140; c=relaxed/simple;
	bh=3Sstm68TAHFrHtEP5DBmmnRcNYHGBD5RkthZqCaPtTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpz7rJgkQatZj82eT4nUnSOc4SklGzcqRslRCGzvtp29HKgI5eyh+BZc+FohwQd5rUjyMNou3SDrqKlKMzwNmC+a87G/MwN27GfwllfcT3+KUbre8S9OtowLlR1m7eVfa9ERcWIzXavdTHs33gupyVwo7/ez2aQ9tzSx8onvGhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjuJeJNC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjuJeJNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E581F000E9;
	Thu,  2 Jul 2026 16:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011139;
	bh=x1+vTKgsHefh9yaBUpnm0GXDv6u73nmDCB9xiqgFAO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjuJeJNCikGg+urj33qagBohgwSLtCCEaEpCaFmnSoZX69TsBvvEAO1cw4rfSXDdF
	 KowFhd4Nja5FTHzIfN/Qt/x4VITxS4Ekcz5tCR84PaXcXBGPF29oiIPvlmjnY3gEc4
	 T+Q9jS0R8pggTpIng1D8DwqI0pWyWmc4htMIOABY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/175] serial: 8250_dw: unregister 8250 port if clk_notifier_register() fails
Date: Thu,  2 Jul 2026 18:21:11 +0200
Message-ID: <20260702155119.365841150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit 10fc708b4de7f86002d2d735a2dbf3b5b7f65692 ]

dw8250_probe() registers the 8250 port via serial8250_register_8250_port()
and then, if the device has a clock, registers a clock notifier. If
clk_notifier_register() fails, probe returns the error but leaves the
8250 port registered. The matching serial8250_unregister_port() lives
in dw8250_remove(), which is not called when probe fails, so the port
slot stays occupied until the device is rebound or the system is
rebooted. The devm-allocated driver data is freed while the port still
references it (via the saved private_data and serial_in/serial_out
callbacks), so any access to that port slot before a rebind is a
use-after-free hazard.

Unregister the port on the clk_notifier_register() error path.

Fixes: cc816969d7b5 ("serial: 8250_dw: Fix common clocks usage race condition")
Cc: stable@vger.kernel.org
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260514143746.23671-2-sozdayvek@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -688,8 +688,10 @@ static int dw8250_probe(struct platform_
 	 */
 	if (data->clk) {
 		err = clk_notifier_register(data->clk, &data->clk_notifier);
-		if (err)
+		if (err) {
+			serial8250_unregister_port(data->data.line);
 			return dev_err_probe(dev, err, "Failed to set the clock notifier\n");
+		}
 		queue_work(system_unbound_wq, &data->clk_work);
 	}
 


