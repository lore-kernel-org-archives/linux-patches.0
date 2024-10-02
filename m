Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA5C1D0B92;
	Wed,  2 Oct 2024 13:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876583; cv=none; b=G24OxrJuNkUjh5r4BAxPoFALYKwfx1wuLapRtxUJNkOwosZ3LpNu2Op9vzSBzLPFfOZ/nrJLMKB3cfL/54sSIjXg3PjJ8Nz6P0dvJ6D9UpIIC3yHFZKqZihUqtMjzcg+nX7Niq7hukRtUMrtsgVd11NFAfTIW5uZaF6U716JnsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876583; c=relaxed/simple;
	bh=RMtIWDtL7P5t5Rhmk/olStFOxeQWSIuagfl2+jCEN5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMjoOwMP8B0XPJ39rsKd8UYOR+dUdIhkIBBoxEqZDCStdHcIpYFN8eEE3jZtI8nHhMoYDzf/dcesOx70G+2iyQ2vc/tHeYVASAZbQpwOgXI21m14Sl4MjwJHr+ez4O8kIi6Tmz+Ev/tGu+cjhePXBZ0FJFFa0y3hwmgL7CFtKRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUNz/c3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUNz/c3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A54C4CEC5;
	Wed,  2 Oct 2024 13:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876583;
	bh=RMtIWDtL7P5t5Rhmk/olStFOxeQWSIuagfl2+jCEN5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUNz/c3KHIuKP4vvcAtsbAF3kIjoNEVUNtiYA9okcPKVvHdGj8deLU9LH8tshEtOv
	 pPXZpmQg1bGFrWR1reOyaux5z/rIMqWz0DqqBycw1mDFgC9ryJR+oA1o4KV8LuuTlW
	 EdhEnR0JtXZmROswhtfmIgSIpADG3mKf9SCEpd68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 462/695] serial: 8250: omap: Cleanup on error in request_irq
Date: Wed,  2 Oct 2024 14:57:40 +0200
Message-ID: <20241002125840.898369452@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



