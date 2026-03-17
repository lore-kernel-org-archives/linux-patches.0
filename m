Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24CF3EF0CF;
	Tue, 17 Mar 2026 16:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765800; cv=none; b=D/1aOoPUqLdNkCKXHa7eqeYd4ttlhLjFuch/Nz+UZoIM6TQKQPb5vnbDgQrEm8MFOpHvwkgqzSc+va4BWk/7/ogubQllsQAtTgqy+XH+Nim6Xqdc+/Td8N5LvKMhJTlJFZJVUSDyljzVcN9SgkZoYHbtoXmnDHZEtFw6eIQAF1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765800; c=relaxed/simple;
	bh=u38v3lKN7xlDv64XmyTVIOK3kxhgkYNRNBXKyOs9tz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZG66gYZXkXrVmv7F+BCQAktUB9OrKJ4PUoUloQxD3RXyB2irn6LKsSHkR02aijNG0OgZDk8u35hgCjPHtoIQIgTK0et31ictkHLSIWgOL+6lIQiNsM28TBSKQcjcBaqgOvARSJNDWAyMMCFtO6/7uDX2aR/qM9a5DOFBrrE3w/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbBz4v7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbBz4v7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48582C4CEF7;
	Tue, 17 Mar 2026 16:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765800;
	bh=u38v3lKN7xlDv64XmyTVIOK3kxhgkYNRNBXKyOs9tz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbBz4v7/We6C1HHtbQSOCpici55nAOVwS5iMLJDYvn/zds9OQ+ZiS8/2sryIiFwpQ
	 WYjDC34UUN35sIIYDxaSrnRUimFD2TMRxbvCXXnffvgpMjkodEMAcy1AME5gjfx3mq
	 i/84W+L/ztQejm+o/qnBpa7DUonjYAbxyK2qM26M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenyuan Li <2063309626@qq.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 067/378] can: hi311x: hi3110_open(): add check for hi3110_power_enable() return value
Date: Tue, 17 Mar 2026 17:30:24 +0100
Message-ID: <20260317163009.477097380@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenyuan Li <2063309626@qq.com>

[ Upstream commit 47bba09b14fa21712398febf36cb14fd4fc3bded ]

In hi3110_open(), the return value of hi3110_power_enable() is not checked.
If power enable fails, the device may not function correctly, while the
driver still returns success.

Add a check for the return value and propagate the error accordingly.

Signed-off-by: Wenyuan Li <2063309626@qq.com>
Link: https://patch.msgid.link/tencent_B5E2E7528BB28AA8A2A56E16C49BD58B8B07@qq.com
Fixes: 57e83fb9b746 ("can: hi311x: Add Holt HI-311x CAN driver")
[mkl: adjust subject, commit message and jump label]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/hi311x.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index e00d3dbc4cf43..91b1fa970f8fb 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -755,7 +755,9 @@ static int hi3110_open(struct net_device *net)
 		return ret;
 
 	mutex_lock(&priv->hi3110_lock);
-	hi3110_power_enable(priv->transceiver, 1);
+	ret = hi3110_power_enable(priv->transceiver, 1);
+	if (ret)
+		goto out_close_candev;
 
 	priv->force_quit = 0;
 	priv->tx_skb = NULL;
@@ -790,6 +792,7 @@ static int hi3110_open(struct net_device *net)
 	hi3110_hw_sleep(spi);
  out_close:
 	hi3110_power_enable(priv->transceiver, 0);
+ out_close_candev:
 	close_candev(net);
 	mutex_unlock(&priv->hi3110_lock);
 	return ret;
-- 
2.51.0



