Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9489215959B;
	Mon, 29 Jan 2024 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548106; cv=none; b=aRSifcduJpDSbvBX4+VhB+Q9YiF1Yscdad1pr+5NF4ASVeeXtY4s+xUfXWJQY3HJYrTX7kC4cmntYFdEX66q1MRn4OiDLlCQhyukNpTk4GBILVFhK1s2CpdPnrzQHJXDTrBGGGYcj4O8NQoK+Aco3i/aiWRAtnnrJqaoUNhRJYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548106; c=relaxed/simple;
	bh=wFVlpXk44urZs/fWTGzSMKcaVsK2bS05ntZlvKPvVCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNE06l/6I+d1GvXAlJxD5s4Wo84BeeKuyNFV1d1QazZ7+SNVsVUJdsoguPpX0HEn5xcmMmeGCas+okuLQ5uiXLAuVdZW2eaw2T/ZsJ77qczDMCgqyT5ovfAFyzKwhhJUAMh941kQhDeesv3XUaYuB4DyI60gmnao0zTPk9Wma0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dj5Bi81t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dj5Bi81t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1A6C43399;
	Mon, 29 Jan 2024 17:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548106;
	bh=wFVlpXk44urZs/fWTGzSMKcaVsK2bS05ntZlvKPvVCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dj5Bi81ts3LDLLmISs24w5KyWAewvgHAQo1mp8xrAgQ70VZ6kNNIIQGiKd6y1XaTy
	 y5zV9RE6WawSU4+nF1BAWksnHLXQ/9myVTYa7hXLB+aY0xnX+0bJfqFvgpYvPD/uV8
	 18qNqOV+sxd0hzaEXXc93rF98EBsz0x6PNvVO6qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.7 128/346] serial: sc16is7xx: remove wasteful static buffer in sc16is7xx_regmap_name()
Date: Mon, 29 Jan 2024 09:02:39 -0800
Message-ID: <20240129170020.145795715@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 6bcab3c8acc88e265c570dea969fd04f137c8a4c upstream.

Using a static buffer inside sc16is7xx_regmap_name() was a convenient and
simple way to set the regmap name without having to allocate and free a
buffer each time it is called. The drawback is that the static buffer
wastes memory for nothing once regmap is fully initialized.

Remove static buffer and use constant strings instead.

This also avoids a truncation warning when using "%d" or "%u" in snprintf
which was flagged by kernel test robot.

Fixes: 3837a0379533 ("serial: sc16is7xx: improve regmap debugfs by using one regmap per port")
Cc:  <stable@vger.kernel.org> # 6.1.x: 3837a03 serial: sc16is7xx: improve regmap debugfs by using one regmap per port
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231211171353.2901416-2-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1709,13 +1709,15 @@ static struct regmap_config regcfg = {
 	.max_register = SC16IS7XX_EFCR_REG,
 };
 
-static const char *sc16is7xx_regmap_name(unsigned int port_id)
+static const char *sc16is7xx_regmap_name(u8 port_id)
 {
-	static char buf[6];
-
-	snprintf(buf, sizeof(buf), "port%d", port_id);
-
-	return buf;
+	switch (port_id) {
+	case 0:	return "port0";
+	case 1:	return "port1";
+	default:
+		WARN_ON(true);
+		return NULL;
+	}
 }
 
 static unsigned int sc16is7xx_regmap_port_mask(unsigned int port_id)


