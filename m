Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F0B1798C;
	Mon, 14 Oct 2024 15:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918845; cv=none; b=Qt4YXdsqlS/T6GyzwAC3GzdP8hvuR4tqG2yDKYWXmqGTbH9eYwplZITwcqX6UpKOFkK0ohxS6EDIHZ4cbTqu0h+5VN4vkXKoa940wWo2HM/6IMh+K2mv6F0nTxKeKX5ggOWTWtSvRpgcXuQVqNkq2ClLalrsvaeeGaQMigJQCuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918845; c=relaxed/simple;
	bh=JLZn02CHVyhrrWhCNntFUsGejYLAKAo/bPBRXxRz7EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qA4cOPjeiLa1pxLdbJYbOqgl4i+xjzKu7nJzRQ00fhgjQwlqKEUhpyUjS0PZ7eiBKv0fDkvkUjsUEUuhpdU5wWNvdVuau/TJ+5NgTlVY2Xj2ZqyV9YKTU1yHFVw9BzTXxrD8vPVZ6lMuKVHbfje3Sd0ee75cWyywbIQ0fskX+fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJowU8lW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJowU8lW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C514C4CEC7;
	Mon, 14 Oct 2024 15:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918845;
	bh=JLZn02CHVyhrrWhCNntFUsGejYLAKAo/bPBRXxRz7EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJowU8lWvnA4iS6JvrZj3LtZcBl8k1SV1FGDg62e+xAFzBhnfT7Jgm7dToaO6OlQm
	 NYXv0RB//peLCwQAm7o+ymaGwk0QQXmCNyQbdK4HZCnE1jBdEFGgrmeBfRh+R7xvIM
	 ZYd0ZD03NX4Tvs2vxkqyQP3Psxp8FoODx4dAs3pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Marcin Wojtas <marcin.s.wojtas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 440/798] net: mvpp2: Increase size of queue_name buffer
Date: Mon, 14 Oct 2024 16:16:34 +0200
Message-ID: <20241014141235.250856979@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit 91d516d4de48532d967a77967834e00c8c53dfe6 ]

Increase size of queue_name buffer from 30 to 31 to accommodate
the largest string written to it. This avoids truncation in
the possibly unlikely case where the string is name is the
maximum size.

Flagged by gcc-14:

  .../mvpp2_main.c: In function 'mvpp2_probe':
  .../mvpp2_main.c:7636:32: warning: 'snprintf' output may be truncated before the last format character [-Wformat-truncation=]
   7636 |                  "stats-wq-%s%s", netdev_name(priv->port_list[0]->dev),
        |                                ^
  .../mvpp2_main.c:7635:9: note: 'snprintf' output between 10 and 31 bytes into a destination of size 30
   7635 |         snprintf(priv->queue_name, sizeof(priv->queue_name),
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   7636 |                  "stats-wq-%s%s", netdev_name(priv->port_list[0]->dev),
        |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   7637 |                  priv->port_count > 1 ? "+" : "");
        |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Introduced by commit 118d6298f6f0 ("net: mvpp2: add ethtool GOP statistics").
I am not flagging this as a bug as I am not aware that it is one.

Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Marcin Wojtas <marcin.s.wojtas@gmail.com>
Link: https://patch.msgid.link/20240806-mvpp2-namelen-v1-1-6dc773653f2f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 11e603686a276..522d65acfc47e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1088,7 +1088,7 @@ struct mvpp2 {
 	unsigned int max_port_rxqs;
 
 	/* Workqueue to gather hardware statistics */
-	char queue_name[30];
+	char queue_name[31];
 	struct workqueue_struct *stats_queue;
 
 	/* Debugfs root entry */
-- 
2.43.0



