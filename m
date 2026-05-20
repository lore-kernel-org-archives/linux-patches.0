Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15A12D7386;
	Wed, 20 May 2026 18:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301344; cv=none; b=SepDFgh0xCfSBmWogrr71tWN7G0a+IWv5K2YfrbJoR3rj627rfpvdUTKna5m/vWZXD5Gq/OfkwukGkbvu+4IbHyjwzGVaCYHD2KWk7t9XQLqWT+pQp1Bs01H3TmQSyNG10uGJAme9GqsMO6U92FpWKQ13bBqLa2KGMhD6J5l1As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301344; c=relaxed/simple;
	bh=/wFX/m5cthY2i8SXboxQ8QN69DFjFMDMRTvLUk6qVvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FshoN5G83SDjWukZkFzOfcw1nQhm4zqrXtZtp6eC8sIwqb7LqbOcK9qSlQo6bFJn80UclHk+2z3rrUJ0BYUR0ALNP3gyVs+E5wtnRneWSHpZF4Pct+u/2pVm9lbnwBzN56fYfMoQ1zKno+293zfH+YfNdS5aaU60K1tLf4QN/u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDLgWVIB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDLgWVIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525A21F00893;
	Wed, 20 May 2026 18:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301343;
	bh=S5c+yeZ4rRWLgTw1rdOwLfSa08M3HSX8Al4UMzMzCiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FDLgWVIBAQIhU8Q6lE49LU9YZjXsQyO3/tcwiEi+ZkfYpLEWI0B8RI36tq96I6Ore
	 Vt4SGGc+jF4JoU88/D5Ac0LhoiZO2J7d6HXJ5s9G5+nkI71M0QcNcJyk9X70ltXqpm
	 sp0d4+/hcuFqdwnpJv0rufVxW6I6Z8Ur7QmI0v+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 517/666] nvme-pci: fix missed admin queue sq doorbell write
Date: Wed, 20 May 2026 18:22:08 +0200
Message-ID: <20260520162122.467375486@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 1cc4cdae2a3b7730d462d69e30f213fd2efe7807 ]

We can batch admin commands submitted through io_uring_cmd passthrough,
which means bd->last may be false and skips the doorbell write to
aggregate multiple commands per write. If a subsequent command can't be
dispatched for whatever reason, we have to provide the blk-mq ops'
commit_rqs callback in order to ensure we properly update the doorbell.

Fixes: 58e5bdeb9c2b ("nvme: enable uring-passthrough for admin commands")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 8eb1e4d48c432..758a187a8ab33 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1816,6 +1816,7 @@ static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool polled)
 static const struct blk_mq_ops nvme_mq_admin_ops = {
 	.queue_rq	= nvme_queue_rq,
 	.complete	= nvme_pci_complete_rq,
+	.commit_rqs	= nvme_commit_rqs,
 	.init_hctx	= nvme_admin_init_hctx,
 	.init_request	= nvme_pci_init_request,
 	.timeout	= nvme_timeout,
-- 
2.53.0



