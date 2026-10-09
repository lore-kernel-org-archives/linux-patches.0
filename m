Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA8347141D;
	Fri,  9 Oct 2026 14:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556247; cv=none; b=pKv8hyn7KTXlQcDPhlWJc5NsLm/0j2hqC6T+vxNMMUE/iQB47xy8hQci6tgwDRk+SaMLTBMTQTP3961rsyhr6jHWywjOcZmSc9kYTgndauh5kCVLT0PNzH8Wxp0qNwm9eBXCnG+vC3Fl/QHqLMAuDcRFUIUKE9qZn8l/epP6y5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556247; c=relaxed/simple;
	bh=wXbV6mFYRgQqeDu+8l1Cqxh3/sdnTD2RwjQOlQyF2y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrACgmETPGXlPCsMEKpzNshXxJSOLzYfWDbSCXI0NxSdCZVcEqmjPFRGnchAKGlYxfAhzCkuOOhR6vs5eaRJXCbYyt0fB91rh8AHVzA6i2WSZqelzrQ65/RwuN1Rarxr02xwklw9E4fqm2bJmf5iQ3wLt1yF6Fkxu4KuK+FT9/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCSRQD2E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCSRQD2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB561F000FF;
	Fri,  9 Oct 2026 14:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556246;
	bh=zkdntbA5manzHAf7h4lgcB7AfEmBDiJ64pvPtZD29AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QCSRQD2Ea2FWmp3Pxdf7+7tBVt8fEH9nk5DpBUeRcqNRMspc/tFHNxH4gLv5iY8Eu
	 WF8ff8nMM9KhO9QfQOClUDiIAVGcYFHqmG9O0y/l7wOyI4XBjNTsaTt144mYKsXT96
	 5xfq+FX4ytNXBTLAKZisH4Q69TggAzzjyGWHnZlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 6.18 203/403] serial: ma35d1: Fix clock reference leak in ma35d1serial_probe()
Date: Fri,  9 Oct 2026 16:09:24 +0200
Message-ID: <20261009140956.882760871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


