Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021497;
	b=iLWZH41NkB5hMsusEv6xrIzY8RxT0nYDP0LXiZkHfihHvaSAQL54mrs9zD09rlKP10Zu
	 hWLPsvCYcrer8f59SCpt6/2UJVB06qh8cfLIRA6qn2HOyZtNqxUveJiIX+n6KyskXn0T5
	 Bo8EqPdnJOOVncOQE550l4Gt7NYIX89/KDT6V+uF23SLJPg9c5IPtXs89vZ8fKcisOqRX
	 mUdFtCVUDBOiXpTbeA5oNzDGwxzEU3xKdffoAN4w9aLGxIRlpfSVEelrgJzgjzPkxbkv6
	 hmZSQysVCsbftYGQ4UJ1IIyNinjmv2IuxRFme2OhG5A4HObRiBt+D6UQ2nkQhx3jgOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ImhgGux/yvlGJTd+GJUWAmdunVS1PwfCS6P4H86L+og=;
	b=OQKyXtVI+RsfOj1H5fOZLxArX/cO2EIY3WflromKgKIlghiKYPysWXEJqDLQ3SQZ9auv
	 va1e75bbBw1xrIQyCKiHv5Lj3pui3vz35cDj994g8gv0ZPj2OdqzjqiCyjPIRSm2VkJvB
	 VnaAW+BAw0N4H0fuTLye42dVrxuriC6AmV5/2dl7uyOdioyhdFFO3hrQ03ny4u+mUS7LU
	 7CZNOPGeMRk3KhXk+67s1BoyZ4B2KWpuGi+tbP9dB+cef4N/Kvgxx46snC+FrEx2pqx6r
	 Qr7o4eCSb7ycQpSdAb4SJb3hDQen6UbXfpsUVElqb7S8G0v5BNpIkPNt5m+fBvajr4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hh1BULeD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ECC60A260A;
	Wed, 18 Nov 2026 17:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hh1BULeD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7D71F000C4;
	Wed, 18 Nov 2026 17:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021497;
	bh=ImhgGux/yvlGJTd+GJUWAmdunVS1PwfCS6P4H86L+og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hh1BULeDItKyppjDX6KS7KWuoXCCMQBQl80wZsTCSgPF+bsglvh48vGdZh2qR3z/2
	 m99/NO0/Tmo4EMzIk6N7c94ZxP4CdMVTcKpAjjZtoqGkYIBk76X/W3dl/Gmjjs8+rJ
	 sjqIO1iM615OJZqsJrjCTsvPOkCRIWwCYTG+PXac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2329/2651] nvme-fabrics: reset io_queues before computing the queue mapping
Date: Wed, 18 Nov 2026 15:59:29 +0100
Message-ID: <20261118150408.984499689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 59f823dfbbccb..571de549fbafc 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1125,6 +1125,8 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
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



