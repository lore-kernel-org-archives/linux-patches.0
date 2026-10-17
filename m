Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C975E32E151;
	Sat, 17 Oct 2026 17:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256596; cv=none; b=Ezg7N4QbOUMI6Gi/hoqelo1XTOvwiQ4jL9lFljq/b/eyIqdW1Mam/RGVykDRAGA/nikI/2p/1HdHOFx805RoiddUVDCUapDmaNGvI0I7N/eYbTCOUBeLj/i+RpObIGNC6jUUQ+DKLP+68JANtPC4aM6uOekdrWiVvoeB05a1jho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256596; c=relaxed/simple;
	bh=2oEq0+FrbJWqJuvJHM0notyjml9vW8OAPoy60pDqVGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n180X9wUrZhB9Dbc8Uyz3xS/m+Fj8SxUnKL2z4lrZqjgHcKjrlW+N/Pi49/wxPIfQsQw5rEUml336582taXsuDS0ZCDeYEqny5xkiqKGFDpNjEwfQzcDo2KwaRV2WzlEiDkq25qEJzYZoTvNyCjYeM+Md9aNxMVstHZCRPUJDQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q25m0q2e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q25m0q2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0EC1F000C8;
	Sat, 17 Oct 2026 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256595;
	bh=wajBJ3FE0+xQ2J7Gl1dApx+BGz6csNJGXsNcUU/X/sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q25m0q2eEyRsvjH14DT0l6GXJv6v4tagRPxieMx73RSzFCv8Mmd4g+DnJRl6VWNi5
	 agX/BLC8A/44+Q/eFAmEKh/FfkWfcOmpWzuMacaiwdsVZIyEKRskCLaEq7tYxAfeGn
	 s5VziabKRFkjaCSKWy2JktHfvbl++/uJvIvpbbPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 6.6 0287/1674] serial: vt8500: Fix clock reference leak in vt8500_serial_probe()
Date: Sat, 17 Oct 2026 17:42:39 +0200
Message-ID: <20261017160438.482704231@linuxfoundation.org>
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

commit 9d8955281d9229a899e2041659a59b389027b711 upstream.

of_clk_get() returns a clock with a reference that has to be released
with clk_put(). If clk_prepare_enable() fails the function returns
without doing so, leaking the reference.

Add the missing clk_put() on that error path.

Fixes: 12faa35ae5cb ("serial: vt8500: UART uses gated clock rather than 24Mhz reference")
Cc: stable@kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917155834.2161361-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/vt8500_serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -656,6 +656,7 @@ static int vt8500_serial_probe(struct pl
 	ret = clk_prepare_enable(vt8500_port->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
+		clk_put(vt8500_port->clk);
 		return ret;
 	}
 


