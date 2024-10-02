Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED411D0BBA;
	Wed,  2 Oct 2024 14:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878467; cv=none; b=o/olEK8M7SyomEr00hOqHmbHdOuqlulHCJjSMBukpufsbNPrrfgVpIxNH+fHFf4Uc9rG3CV5S91TNnpwVhhczHT8O0soimemFeYf/r487GyCqhmOJXFHoXHLcuxAmOeacZIcDkhvVeiXJOTpITrSzW1H1OPi5XPigyYDTwIb7VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878467; c=relaxed/simple;
	bh=yuVRgoCzjScAK+Aa7j8N7qYY4SQBxwaEA7pRAp5/JvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STfQp2C+mjbM9cXtt+LPrG5tNKKe7Rfzst2AIgiP4HqgL0No1BHKUkkZrB6bTc1a+ukJLOugSfo/mxfZMPxAU5GI4s4rokbexx/a7bOsXgIkvZ+nDv1krQKXBHmzxhLwgjLwVIX5DHaszzgK587q+lSIVlY1yRYlH1v2ml/F3dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xutgF8vV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xutgF8vV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4B5C4CECD;
	Wed,  2 Oct 2024 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878467;
	bh=yuVRgoCzjScAK+Aa7j8N7qYY4SQBxwaEA7pRAp5/JvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xutgF8vVUH/2I/nQzZwpZ4s0BGIeAENNxFtXqmi7AzRVl7ETcYiNsl/k60vI/qbiY
	 GjHkqJDpMq9qhJcdNQVxDBozzKqFmzJinypA+JeBxYVkYy0iH2q4kGvVqcWAeCjEUp
	 WwdpCxz+Vh2ipnwxYKFfIbh2UnnbuEzPQsRPaysc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 423/634] serial: 8250: omap: Cleanup on error in request_irq
Date: Wed,  2 Oct 2024 14:58:43 +0200
Message-ID: <20241002125827.800000714@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit 35e648a16018b747897be2ccc3ce95ff23237bb5 ]

If devm_request_irq fails, the code does not cleanup many things that
were setup before. Instead of directly returning ret we should jump to
err.

Fixes: fef4f600319e ("serial: 8250: omap: Fix life cycle issues for interrupt handlers")
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Tested-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20240807141227.1093006-4-msp@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index afef1dd4ddf49..fca5f25d693a7 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1581,7 +1581,7 @@ static int omap8250_probe(struct platform_device *pdev)
 	ret = devm_request_irq(&pdev->dev, up.port.irq, omap8250_irq, 0,
 			       dev_name(&pdev->dev), priv);
 	if (ret < 0)
-		return ret;
+		goto err;
 
 	priv->wakeirq = irq_of_parse_and_map(np, 1);
 
-- 
2.43.0



