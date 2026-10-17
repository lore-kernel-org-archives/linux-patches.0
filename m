Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6353AFCF0;
	Sat, 17 Oct 2026 17:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256939; cv=none; b=LWxVIvT8vwu8tsnCsnj8VjV+qFErkPF5/OctgGcpZ30IwGTMWKfDk2pAnqWoVf/MuRTztOtS+eGbK8EQLfHw6AkE5LXXzc7EN1u9srrUrm8leNBFPc/r2t79TxVcajQt2YvotHMfi1PtaEZ7axHQtjcKltNN4klBDAHni1gCFWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256939; c=relaxed/simple;
	bh=2s6TsnuYtcHtPUX6MvXImewMnXbHGeerZIdRVVK93OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WT4+EC1SKlYs0E/F2/wPdrCqHqUgrXxFCcY8qE6cuY58O9JDJC+qICebN9zavWUPMO3l2kYZbPVd62tOAX+suC1YzgPrie5wIFUpsGcrWzef7bR1KuATaHxNZrRw8hMalX3evX4/+IcrMxEWNDRfJ70BR0VgyUbMDhqyosyb7fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7iT+fKt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7iT+fKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C632F1F000C4;
	Sat, 17 Oct 2026 17:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256938;
	bh=de9gCHOrtq+nSBSzHiY9Rbm7yhtsVPdGTvgxeYeTJs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J7iT+fKtkAZ8Cdu50ywutf6aPxhAPMkeibSX1lKn1rWqlxRQO5GH5gxYWWIqU47kf
	 JoAFDYKoXwOeyU4UBVHACPwhWbAAVkpsGwFUJgZ4joFCmOmcJEG+lebKnWwI5ACC72
	 8VrG+cwKWSOLPSkRLAa4p4AzAOy0gbQAkDJaJjBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0401/1674] serial: ma35d1: Fix clock reference leak in ma35d1serial_probe()
Date: Sat, 17 Oct 2026 17:44:33 +0200
Message-ID: <20261017160441.411936136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 98401cf912fe8a081ef8e500c421b6d957b55a99 ]

of_clk_get() returns a clock with a reference that has to be released
with clk_put(). ma35d1serial_probe() never does that, so the reference
is leaked on the probe error paths and also when the port is removed.

Release it on the error paths and in ma35d1serial_remove().

Fixes: 930cbf92db01 ("tty: serial: Add Nuvoton ma35d1 serial driver support")
Cc: stable@kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917155650.2161274-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/ma35d1_serial.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/ma35d1_serial.c b/drivers/tty/serial/ma35d1_serial.c
index f6f832ba7204d..225feb5868e85 100644
--- a/drivers/tty/serial/ma35d1_serial.c
+++ b/drivers/tty/serial/ma35d1_serial.c
@@ -725,7 +725,7 @@ static int ma35d1serial_probe(struct platform_device *pdev)
 
 	ret = clk_prepare_enable(up->clk);
 	if (ret)
-		goto err_iounmap;
+		goto err_put_clk;
 
 	if (up->port.line != 0)
 		up->port.uartclk = clk_get_rate(up->clk);
@@ -752,6 +752,9 @@ static int ma35d1serial_probe(struct platform_device *pdev)
 err_clk_disable:
 	clk_disable_unprepare(up->clk);
 
+err_put_clk:
+	clk_put(up->clk);
+
 err_iounmap:
 	iounmap(up->port.membase);
 	return ret;
@@ -767,6 +770,7 @@ static void ma35d1serial_remove(struct platform_device *dev)
 
 	uart_remove_one_port(&ma35d1serial_reg, port);
 	clk_disable_unprepare(up->clk);
+	clk_put(up->clk);
 }
 
 static int ma35d1serial_suspend(struct platform_device *dev, pm_message_t state)
-- 
2.53.0



