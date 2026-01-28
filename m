Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93D13093A8;
	Wed, 28 Jan 2026 15:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615772; cv=none; b=ncIedgKp1a6+f7/iwNoRPri7+UWHPCtEv8lD1YiqHvq7VKjlYKTFe0VTV0Dc0Ro6sxVKbi4dFEGrbokTE/XwQPzjqFfN/2gn4kn6OTEeX+4ztOumM8oDWgdQjecrcH1n/w007filNsGkGzLM0abGi2aCidYdeRrdi6caczHjp+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615772; c=relaxed/simple;
	bh=/5uWlqUOiVm+emkeZoVuit4wZR04nlC45VVoPPgC9Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jw1uutKdpIJzPns9nkuW19zJvWrMjKTHD+yjbvQ667pYI31827ykh/eE0KMBp4YupIQXkNThsCjbYupo7Pz/dh8pCCTgp/SwlOKwyHTX1cTu5Oy/dv6EMUBa9mV96u7wCN4oiKV/7uOQNN76JU4kL4YN0k9IhaZMjsSLwTRxWy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ak1iw8uu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ak1iw8uu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12930C4CEF1;
	Wed, 28 Jan 2026 15:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615772;
	bh=/5uWlqUOiVm+emkeZoVuit4wZR04nlC45VVoPPgC9Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ak1iw8uuU6BsJrgWBxMCW7GW+vesE8h0dblOdJMU8dJTrRXFs6LCtsRosQaMP6j/T
	 y+29UkHX+HkxuFUXiQPiWrxByA9ARocrbA0N+DtSTTL5/X8MGMleZc+Y0lHQrT21TB
	 cIHAuZbsz0tBOa5hN126e6PrZwnUmqZMSTGDGBrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/227] idpf: Fix data race in idpf_net_dim
Date: Wed, 28 Jan 2026 16:22:35 +0100
Message-ID: <20260128145348.426910922@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit 5fbe395cd1fdbc883584e7f38369e4ba5ca778d2 ]

In idpf_net_dim(), some statistics protected by u64_stats_sync, are read
and accumulated in ignorance of possible u64_stats_fetch_retry() events.
The correct way to copy statistics is already illustrated by
idpf_add_queue_stats(). Fix this by reading them into temporary variables
first.

Fixes: c2d548cad150 ("idpf: add TX splitq napi poll support")
Fixes: 3a8845af66ed ("idpf: add RX splitq napi poll support")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260119162720.1463859-1-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index f66948f5de78b..a48088eb9b822 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -3941,7 +3941,7 @@ static void idpf_update_dim_sample(struct idpf_q_vector *q_vector,
 static void idpf_net_dim(struct idpf_q_vector *q_vector)
 {
 	struct dim_sample dim_sample = { };
-	u64 packets, bytes;
+	u64 packets, bytes, pkts, bts;
 	u32 i;
 
 	if (!IDPF_ITR_IS_DYNAMIC(q_vector->tx_intr_mode))
@@ -3953,9 +3953,12 @@ static void idpf_net_dim(struct idpf_q_vector *q_vector)
 
 		do {
 			start = u64_stats_fetch_begin(&txq->stats_sync);
-			packets += u64_stats_read(&txq->q_stats.packets);
-			bytes += u64_stats_read(&txq->q_stats.bytes);
+			pkts = u64_stats_read(&txq->q_stats.packets);
+			bts = u64_stats_read(&txq->q_stats.bytes);
 		} while (u64_stats_fetch_retry(&txq->stats_sync, start));
+
+		packets += pkts;
+		bytes += bts;
 	}
 
 	idpf_update_dim_sample(q_vector, &dim_sample, &q_vector->tx_dim,
@@ -3972,9 +3975,12 @@ static void idpf_net_dim(struct idpf_q_vector *q_vector)
 
 		do {
 			start = u64_stats_fetch_begin(&rxq->stats_sync);
-			packets += u64_stats_read(&rxq->q_stats.packets);
-			bytes += u64_stats_read(&rxq->q_stats.bytes);
+			pkts = u64_stats_read(&rxq->q_stats.packets);
+			bts = u64_stats_read(&rxq->q_stats.bytes);
 		} while (u64_stats_fetch_retry(&rxq->stats_sync, start));
+
+		packets += pkts;
+		bytes += bts;
 	}
 
 	idpf_update_dim_sample(q_vector, &dim_sample, &q_vector->rx_dim,
-- 
2.51.0



