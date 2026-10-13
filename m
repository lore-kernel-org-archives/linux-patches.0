Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B374EF12E;
	Tue, 13 Oct 2026 12:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895129; cv=none; b=dfZ+7+eEj7vb+RdqbqRjARUD56Oxt2Fr46vuOR4hVhFiveaBx9Bc+Lh1p5Q+6bdrF5oMMHVtTo7kTIwZcr+JYs+yeongWzmN+BlsfaSVwSUoqf6vVCJujXlE9epVYAnU4Vlw7eIYwZ8/KVc356qoPgTPmuzh1N08DwP5Dav61sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895129; c=relaxed/simple;
	bh=mGMAXr0Pd62pAQJU+pHzKWDSQNwGGNh03YMo9YoOVjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gExe8O3GxkdNB0n4Boodrhm4+njZOVxpJX/s6LUZ6caTiD5Ynl3M1jmeJznzkBXC7nmi+rznHEb6FIjBuIezr3X/GNOmDSVh5qCMgZ/HCb5v2fXEZs7EDuI8VE+gNc8cpV8qbQFURKg5xrAvjcvD6vj7h1DyOR5/Xn5Y3d/USB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRO4d1yy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRO4d1yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323F01F000FF;
	Tue, 13 Oct 2026 12:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895128;
	bh=OF3NfGHJyQhhkdBr8+tp136Z4MKXwb9EgZVOWIyFnX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rRO4d1yy7N/gYDbOWrjYTMbXoxjgIsaq9rdKgK+yS7FCrEG2tqTN06hvtGIcLmQPZ
	 Q4eMP1NEB0ScoOBYjj6x70xu0AiHj3iMmpv5pFwi2TXkaWjOiz+VGESm3KO4bsfOwt
	 ry1at2oGMTW/Im0CIpEbxKsIqz/R3fBSvtKZhfYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 6.12 170/497] serial: vt8500: Fix clock reference leak in vt8500_serial_probe()
Date: Tue, 13 Oct 2026 13:35:37 +0200
Message-ID: <20261013112911.925017326@linuxfoundation.org>
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
 


