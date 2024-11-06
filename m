Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF231E1C33;
	Wed,  6 Nov 2024 13:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898346; cv=none; b=kOvkacddVugfCepJ3nBGzYr8IwnVMc/htNx9fkjFnzYgCm1Z+/DONBaE+mfRZkPOkuehHiwULFjN3FcREpyun3Uw9BJQTxuHG566H/yY27QjtdxuWpKTwzK/gDYZy4sR6uMVPGlpwEmDcPnwsEgENh8cwOu+fvR+OyWjW9+uU+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898346; c=relaxed/simple;
	bh=H+YNpyQ0XIM74Eh35YtD+8r7ytQimoN1m916IRG+PoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+t9KXwl1e47Gov7UKn1dICciE6R0CHL6rovdTHE+EPQAT6xPCu9euUqQ/Gxxsi5In/WliFogfQsiPTw8l6QYflGgE8GHwpnZSYENqMnzZ510qa2avMEpTs7LA21TlsX0AfYda5fSMA5FBCV+JX4YUQaS9XW4LpWaHGyL3sx7lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXBxYKhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXBxYKhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194E5C4CECD;
	Wed,  6 Nov 2024 13:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898346;
	bh=H+YNpyQ0XIM74Eh35YtD+8r7ytQimoN1m916IRG+PoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXBxYKhrAiLs+ujEi7+LOGt58VfYypZgNs9vBkJrVAncUxewX7cJM/dF9RERgH+Ml
	 wkjVa4hq9TabYf93Qk156EmpRle+8hMxgM4Bf+vPcE4bfk9z/S17rD/3jK+hf2W8gf
	 1lRjuW2JO7+kJD7n2IsuTe0a3SFdkv2xaS4EEVkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Marcin Wojtas <marcin.s.wojtas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 207/462] net: mvpp2: Increase size of queue_name buffer
Date: Wed,  6 Nov 2024 13:01:40 +0100
Message-ID: <20241106120336.629677017@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index cf45b9210c155..552ec1f96e5d2 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -809,7 +809,7 @@ struct mvpp2 {
 	unsigned int max_port_rxqs;
 
 	/* Workqueue to gather hardware statistics */
-	char queue_name[30];
+	char queue_name[31];
 	struct workqueue_struct *stats_queue;
 
 	/* Debugfs root entry */
-- 
2.43.0



