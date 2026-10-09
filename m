Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5216919F40B;
	Fri,  9 Oct 2026 14:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556872; cv=none; b=KQMpiZ5Q5PCxXp1JqRJjG10oIlrf01pHcZvRArVBlUhmj2CZ74g5t0VM2sLEWGhB6QQNnXg5XYnMCzswgJoYKzq69ApgUkBpJIQua1YzmGTTqLyu8GK6UXg481p3T0VeWuclw6edbQQjdYcd8LwZeTD2qmvAZ62OKlAPSm/jRKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556872; c=relaxed/simple;
	bh=NQIV8OccRLlFnxh7/D4WfRD9QKEM57iE7MvqMh71o9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYzbmHTGVNimRv96euDyNrT4AGvqG30g9Xqs5UqFLrKg09Qtx0oeI1O+QinsTfKdriELHMS1iQi+wGZRBd3PaKytbLA9OKup+4eGJ3MdlmyqSentJupDZE777PAzjXPh1zLlkzOLjl/3KmsP7GP0enrP9SS2fUKTmIlhzm1/WfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIT8Q2w4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIT8Q2w4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84F51F000FF;
	Fri,  9 Oct 2026 14:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556871;
	bh=yiTfHhalS6LmvcT5Q0kIfZi1Gz4YnDbR61oXvzB467w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIT8Q2w44rm8WHidtvNbpbVvWbOem26nwceUmnalK2t8CWRY/BAkbBFnoPS+2KUm7
	 LX5FELoFy4dTUjIhdbfrgkZStyM5/QaDSx+iDtg8+l9v1SJ/+4FCOek588ppEDFWZm
	 KD7MtkvQXQHJXBb3ktddnArRhaPnLvuVjhnBFY7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 7.2 256/428] serial: ma35d1: Fix clock reference leak in ma35d1serial_probe()
Date: Fri,  9 Oct 2026 16:09:53 +0200
Message-ID: <20261009140951.728220199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 98401cf912fe8a081ef8e500c421b6d957b55a99 upstream.

of_clk_get() returns a clock with a reference that has to be released
with clk_put(). ma35d1serial_probe() never does that, so the reference
is leaked on the probe error paths and also when the port is removed.

Release it on the error paths and in ma35d1serial_remove().

Fixes: 930cbf92db01 ("tty: serial: Add Nuvoton ma35d1 serial driver support")
Cc: stable@kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917155650.2161274-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/ma35d1_serial.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/ma35d1_serial.c
+++ b/drivers/tty/serial/ma35d1_serial.c
@@ -728,7 +728,7 @@ static int ma35d1serial_probe(struct pla
 
 	ret = clk_prepare_enable(up->clk);
 	if (ret)
-		goto err_iounmap;
+		goto err_put_clk;
 
 	if (up->port.line != 0)
 		up->port.uartclk = clk_get_rate(up->clk);
@@ -755,6 +755,9 @@ err_free_irq:
 err_clk_disable:
 	clk_disable_unprepare(up->clk);
 
+err_put_clk:
+	clk_put(up->clk);
+
 err_iounmap:
 	iounmap(up->port.membase);
 	return ret;
@@ -770,6 +773,7 @@ static void ma35d1serial_remove(struct p
 
 	uart_remove_one_port(&ma35d1serial_reg, port);
 	clk_disable_unprepare(up->clk);
+	clk_put(up->clk);
 }
 
 static int ma35d1serial_suspend(struct platform_device *dev, pm_message_t state)


