Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068883D45E5;
	Tue, 13 Oct 2026 12:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895124; cv=none; b=aBv2ekWsCPRdbffmtUM1TAj4d8bD41Sf3F3C/p+YyOIsrCIdPeGBEFmbZWYiEMRBn2pvwXOAE8tSqgYBwwRw3gN1WFMPLt2A9qYVrGQNdDeJQG4uObJ9YEIUS5XKyj04JTQfCmih6erQzI72QaKNlB/ZeP4dfeT88tmj3cz4Zto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895124; c=relaxed/simple;
	bh=f7H3JTte1UYCLrvnhFfxfeFTc6XawUGcD503QxgZh/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EO5SevALpjHN6XPwqdvlRx5x5UVE8bKsilxPdOGxSsZ1Q4RDhl90jAFzfdvnyfiaEJs5E/gSw8Kv/w8+xEqDV+kq/C8Y0RIG8/aLoHqWVg90F2RcNYg67H+gQUhA3DDD3zghyUMe+7T2vLFLXqeKZosOwiARaMcAYxs/rDa+dTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXwNRtSX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXwNRtSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2741F000FF;
	Tue, 13 Oct 2026 12:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895122;
	bh=Zq0RpjoGTgL7oCGf7ABZD086RT7rs/iP9SO2r2Adk0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lXwNRtSX9GdTLTVYYBYcFYKY+EmsZ9x4ISQ2Nd1DEX/qq8VZrJncPAcxJDEP6Ydhw
	 fOqmoPQWl+//noPgXtklw+dPa/OKT6JIERspQl3p856tTfL+m/D4RWP1S2ldGM7ONH
	 mSapfjPyPAxCffIU1xrBEUKd/40y9keXcu7IfHYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 6.12 168/497] serial: ma35d1: Fix clock reference leak in ma35d1serial_probe()
Date: Tue, 13 Oct 2026 13:35:35 +0200
Message-ID: <20261013112911.877470364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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


