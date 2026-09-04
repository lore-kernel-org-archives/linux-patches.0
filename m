Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282652F9DA1;
	Fri,  4 Sep 2026 05:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501202; cv=none; b=Fdo/+qsDt7VMaZ0xoKarzf0muYEHXFf2lPefdOIEIJPB5m/WHnXjwxiHdIJw4kdyYdZcsgj0hkOgz0HFAbYXA31mZGB7xFO4Jpitp8FN9ygipDF7lbYS0D0KdGbT85t1ySd2KVcbn9HJHyl59i+PcpuVeBRFndPYjBZ5o6+P60g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501202; c=relaxed/simple;
	bh=WHw6FVC2uh5na29jhm5ULJLlztTG2cYKIAml0XAufZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACajFSuIz9cN1t/4MS00eyj6swZegNSaaCXuSQDbn2a94WmvmFGLk9a9wbVa0lDtAW3BNiuVj+nJ+Ah0L77XKafnW6ugubPDr9ShnhPNmw422Rp+X72pLrLRciwp38UZ0rN29q3QfbzdndwtNL4Hkr3MCk/QZd6xrAGcjJh7r0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXUAiaTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXUAiaTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD401F00A3D;
	Fri,  4 Sep 2026 05:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501201;
	bh=AuYKwIUrrOpsgYnlIAt2mR88fQKTcSHfjclJmU2u6Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pXUAiaTV6xebIOgYl9X36zqZFOeKAVYmDZwCJTA5GPm7y5WrCJmmA4vZnNhHxEY7k
	 KgU5rqjWa+edyPFyOIZj2J7pBi+x3Bkw97o6dQvGjp9U95B0tvAQ2eRPChzhfEZYjr
	 hFNYcr2dV15CvTQPsKCMco5LQeMvV1J1Dm7PmUVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 326/552] regulator: as3722_get_regulator_dt_data: fix premature of_node_put leaving dangling of_node pointer
Date: Fri,  4 Sep 2026 06:58:03 +0200
Message-ID: <20260904045757.658518513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: WenTao Liang <vulab@iscas.ac.cn>

commit f9324d670ae0b88cbfb0aa48fcaefa5baeb8da4c upstream.

In as3722_get_regulator_dt_data(), of_get_child_by_name() acquires a
reference on np, which is then assigned to pdev->dev.of_node. The
function immediately calls of_node_put(np), releasing the reference and
leaving pdev->dev.of_node as a dangling pointer.

Remove the of_node_put(np) call to let the device hold the reference.

Cc: stable@vger.kernel.org
Fixes: bc407334e9a6 ("regulator: as3722: add regulator driver for AMS AS3722")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260626160150.54291-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/as3722-regulator.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -600,7 +600,6 @@ static int as3722_get_regulator_dt_data(
 
 	ret = of_regulator_match(&pdev->dev, np, as3722_regulator_matches,
 			ARRAY_SIZE(as3722_regulator_matches));
-	of_node_put(np);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Parsing of regulator node failed: %d\n",
 			ret);


