Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050371;
	b=PriBbSnsDZHxiPk/51fcTnTywnzefoFMNfxXBYNhyNKE73oJGaCFJRdZMl3BsmnSrWcX
	 bLbAbRtOx6SP31IEQs0RV4OBBimgTFJbjPYRyUuTx/bYfV0c05FaGe885gapElDMB1yUe
	 TKqiz81AeyfV+kcw5RxxyshM3ycSFhFzjQNVrHu0Ox/1MP0tjhw1JT4t77MesE9r2yAoL
	 zDSqyWTh8MwDzUuuZmy7D4TPQrEjaykJLY2kpyBxmRAtHKZHTnaKPnepznrBlF80kWmoZ
	 m+RRWBmt4kiRq05mVTVXWMryXji8PxI6Va2+ZS5Oa2MphKs2ot6GuAHXBDjUwlEtiSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Mm+Wlmhha/g3yHHAQXy1PKkPQqpe/xpFc4b32PgOwI=;
	b=Xg03bqkXskSYh6e3euhfbnP1CqzOB4lXG18E4a/T1khkieF/UZim9xodsSY9ujPYnrVz
	 N0ERwFD74I5mAGIXfsGw6gFLbatj1X7a3LA3aWCO6UYxXFxocAhHbt3xYjBwS4OKiVCna
	 4oKiFqeJw8TwSccDaFsOHGxiKwmeVN95RVPtFdQl3zOYn6FezARYk3QOdTKb/31bHfkac
	 +c2/9f19gIwQZQxgIMNqVT8Fb2Qtm5gwhFjGKvUW+azrFO/5GBgznpLBqCx97spURpuRs
	 q63D2acoPaH8Gr/Xs6Gb0GDECJSsmoGW+XNWjHzuiQR5ngIAwNuLBAfgUryMHBeXalg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fbga+057;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4478E606A332;
	Thu, 19 Nov 2026 01:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fbga+057
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE501F000C4;
	Thu, 19 Nov 2026 01:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050371;
	bh=/Mm+Wlmhha/g3yHHAQXy1PKkPQqpe/xpFc4b32PgOwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbga+057D9EzPFLagss2qCTm87qPBWXxbZrXNsS4Wzl6ZuK0PKEJXaTbKOylGQj8b
	 giV5XelED33auYc7LZt85zQuh5hXRwgukKsWqDcWQFft9W6opqsmd4Z4j6mdSPUzTZ
	 GBSEja6zBgZ/UzimJqmfbKna3vZiPf2PIa7GXFlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2685/2857] nvme-fabrics: reset io_queues before computing the queue mapping
Date: Wed, 18 Nov 2026 16:01:59 +0100
Message-ID: <20261118150338.250612828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 9588769af5fc8ac12290d48ce1014a78916681fc ]

nvmf_set_io_queues only sets the io_queues entries of the queue types it
hands out, but the array is reused on every reconnect.  When the
controller grants fewer queues on a reconnect, stale entries survive and
nvmf_map_queues maps CPUs to hardware contexts that don't exist anymore,
which crashes blk_mq_map_swqueue with a NULL pointer dereference.  E.g.
with nr_io_queues=8, nr_write_queues=8 and nr_poll_queues=8, 24 queues
are mapped 8/8/8 (default/read/poll).  If the controller grants only 16
queues on the reconnect, the poll map still starts at hardware context
16.

Clear the array before computing the new mapping.

Fixes: 6486199378a5 ("nvme-tcp: fix queue mapping when queue count is limited")
Fixes: 5651cd3c4336 ("nvme-rdma: fix queue mapping when queue count is limited")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 7d3a34acf80e3..f7dc799b1dbd3 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -962,6 +962,8 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 void nvmf_set_io_queues(struct nvmf_ctrl_options *opts, u32 nr_io_queues,
 			u32 io_queues[HCTX_MAX_TYPES])
 {
+	memset(io_queues, 0, sizeof(*io_queues) * HCTX_MAX_TYPES);
+
 	if (opts->nr_write_queues && opts->nr_io_queues < nr_io_queues) {
 		/*
 		 * separate read/write queues
-- 
2.53.0



