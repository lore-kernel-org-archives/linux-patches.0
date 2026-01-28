Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5033074B1;
	Wed, 28 Jan 2026 15:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614955; cv=none; b=blMZV8MU6ZosdcUCOpCunWEz/f4fQnKD59p1iq81dRQVGQgfMfvo0ChbnPZhrPAdbCJ9D6azJa1vyQH1ZZFj4JRGuXw3E3ihwGzZVthayRifyN9z4rpZ4+h7Bshkkm2G6u79GDd387bdMkYVZVo0AEEYGdQ3OzHZ7nqqS3XZLms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614955; c=relaxed/simple;
	bh=WLk5EgqFbSl0KssoOmuxAhZZx6asp9BmPU9aL17wxVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpeGLlZ3hhpX7P9eu3GdiWp5Do0mStE6kkp6peDU8o7slMNgQe7s7JUdGfjtdO7iGGwcv/MyXi4AhCTzAtf+bV4DtyeS/+ZxYuXUoBnCou3j2hC2hQk1hx79X72DWLIAV8OseSsWziGKtu627Cc10OMp2YQaXrGgq4rGz2geAfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyvRRZ1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyvRRZ1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F655C4CEF1;
	Wed, 28 Jan 2026 15:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614954;
	bh=WLk5EgqFbSl0KssoOmuxAhZZx6asp9BmPU9aL17wxVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyvRRZ1MDCfo1VNWjaZ+Ts2OG/WJXrdgF5C21HPUEg88XJ6PIgSbdNUCXxb9UrExY
	 VP6NqDJD1n6B400adrhDLdniaXOI0TtWSMy82mlblhDLQYW+2SQs3AkROddpzSKxys
	 cFB7fYL5KgT3W+JgIINWqKURT0voKicSmwQhcRXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/169] veth: fix data race in veth_get_ethtool_stats
Date: Wed, 28 Jan 2026 16:21:58 +0100
Message-ID: <20260128145335.284145140@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit b47adaab8b3d443868096bac08fdbb3d403194ba ]

In veth_get_ethtool_stats(), some statistics protected by
u64_stats_sync, are read and accumulated in ignorance of possible
u64_stats_fetch_retry() events. These statistics, peer_tq_xdp_xmit and
peer_tq_xdp_xmit_err, are already accumulated by veth_xdp_xmit(). Fix
this by reading them into a temporary buffer first.

Fixes: 5fe6e56776ba ("veth: rely on peer veth_rq for ndo_xdp_xmit accounting")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Link: https://patch.msgid.link/20260114122450.227982-1-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 4ff0d4232914f..77e4b0d1ca557 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -227,16 +227,20 @@ static void veth_get_ethtool_stats(struct net_device *dev,
 		const struct veth_rq_stats *rq_stats = &rcv_priv->rq[i].stats;
 		const void *base = (void *)&rq_stats->vs;
 		unsigned int start, tx_idx = idx;
+		u64 buf[VETH_TQ_STATS_LEN];
 		size_t offset;
 
-		tx_idx += (i % dev->real_num_tx_queues) * VETH_TQ_STATS_LEN;
 		do {
 			start = u64_stats_fetch_begin(&rq_stats->syncp);
 			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
 				offset = veth_tq_stats_desc[j].offset;
-				data[tx_idx + j] += *(u64 *)(base + offset);
+				buf[j] = *(u64 *)(base + offset);
 			}
 		} while (u64_stats_fetch_retry(&rq_stats->syncp, start));
+
+		tx_idx += (i % dev->real_num_tx_queues) * VETH_TQ_STATS_LEN;
+		for (j = 0; j < VETH_TQ_STATS_LEN; j++)
+			data[tx_idx + j] += buf[j];
 	}
 	pp_idx = idx + dev->real_num_tx_queues * VETH_TQ_STATS_LEN;
 
-- 
2.51.0



